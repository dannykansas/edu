#!/bin/zsh
# standalone script to build qBittorent for macOS (including Apple Silicon based Macs)
#
# only Xcode must be installed (Xcode 12 is required to produce arm64 binaries)
# all required dependencies and tools are automatically downloaded and used only from script's working directory
# (can be specified), nothing is installed into the system
# working directory is removed on completion if it was not specified
#
# by default script produces binaries for the architecture it was launched on, but cross-compilation is also supported
# in both directions, i.e. x86_64 -> arm64 and arm64 -> x86_64
#
# following conventions are used in the script:
# - variables names are in snake-case (special variables are an exception)
# - variables starting with '_' (underscore) should be considered "internal"
# - variables without '_' prefix can be considered "options" or "default values"
#
# script accepts few arguments which can customize its behavior the same way as editing "option" variables,
# see 'command line arguments parsing' section for details and possible options
#
# script is not interactive and doesn't ask anything, it just automates build routine
# it can be launched multiple times with the same or different set of arguments, this may be useful for development
# environment setup for example (just pass some working directory, and it will contain everything required for
# qBittorrent development)
# moreover, passing the same working directory with other arguments allows you to get environment with few different
# Qt and/or libtorrent versions (or libraries for different architectures) that you can switch easily
#
# script is "smart enough" to download and build only required parts (which it considers "missing", but not due to
# dependency change) in case when the same working directory is specified multiple times
# qBittorrent is compiled in any case, result .dmg file is overridden if required
# =====================================================================================================================
# software versions to use
qbittorrent_ver=master                      # qBittorrent   https://github.com/qbittorrent/qBittorrent/releases

openssl_ver=1.1.1m                          # OpenSSL       https://www.openssl.org/source/
boost_ver=1.77.0                            # Boost         https://www.boost.org/
libtorrent_ver=2.0.5                        # libtorrent    https://github.com/arvidn/libtorrent/releases
libtorrent_commit=""                        # libtorrent commit
qt_ver=6.2.2                                # Qt            https://code.qt.io/cgit/qt/qt5.git/refs/tags

cmake_ver=3.22.1                            # CMake         https://cmake.org/download/

# build environment variables
target_arch=$(uname -m)                     # target architecture, host by default
# qBittorrent requires C++17 features available only since macOS 10.14
cxxstd=17                                   # C++ standard
min_macos_ver=10.15                         # minimum version of the target platform
# =====================================================================================================================

work_dir=""                                 # working directory, all files will be placed here
prod_dir="${HOME}/Downloads"                # output directory for result qBittorrent .dmg image

universal_arch_tag="universal"              # value used as arch to build a universal binary

# ---------------------------------------------------------------------------------------------------------------------
# command line arguments parsing
# https://stackoverflow.com/questions/402377/using-getopts-to-process-long-and-short-command-line-options

_die() { echo "$*" >&2; exit 2; }
_needs_arg() { if [ -z "$OPTARG" ]; then _die "No arg for --$OPT option"; fi; }
_no_arg() { if [ -n "$OPTARG" ]; then _die "No arg allowed for --$OPT option"; fi; }

while getopts ha:w:o:-: OPT; do
    if [ "$OPT" = "-" ]; then
        OPT="${OPTARG%%=*}"
        OPTARG="${OPTARG#$OPT}"
        OPTARG="${OPTARG#=}"
    fi
    case "$OPT" in
        h | help )
            echo "no help there! but script accepts few command line agruments, just open it to find them :)"
            exit 0
            ;;

        a | target-arch )       _needs_arg; target_arch="$OPTARG" ;;
        w | workdir )           _needs_arg; work_dir="${OPTARG%/}" ;;
        o | outdir )            _needs_arg; prod_dir="${OPTARG%/}" ;;
        qbittorrent )           _needs_arg; qbittorrent_ver="$OPTARG" ;;
        openssl )               _needs_arg; openssl_ver="$OPTARG" ;;
        boost )                 _needs_arg; boost_ver="$OPTARG" ;;
        libtorrent )            _needs_arg; libtorrent_ver="$OPTARG" ;;
        libtorrent-commit )     _needs_arg; libtorrent_commit="$OPTARG" ;;
        qt )                    _needs_arg; qt_ver="$OPTARG" ;;
        cmake )                 _needs_arg; cmake_ver="$OPTARG" ;;
        cxx )                   _needs_arg; cxxstd="$OPTARG" ;;
        macos )                 _needs_arg; min_macos_ver="$OPTARG" ;;
        ??* )                   _die "Illegal option --$OPT" ;;  # bad long option
        ? )                     exit 2 ;;  # bad short option (error reported via getopts)
    esac
done
shift $((OPTIND-1))

# ---------------------------------------------------------------------------------------------------------------------
set -o errexit      # exit immediately if a command exits with a non-zero status
set -o nounset      # treat unset variables as an error when substituting
set -o xtrace       # print commands and their arguments as they are executed
set -o pipefail     # the return value of a pipeline is the status of the last command to exit with a non-zero status
# ---------------------------------------------------------------------------------------------------------------------
# working directory setup
if [[ -z ${work_dir} ]]
then
    work_dir=$(mktemp -d)
    _remove_work_dir=1
else
    mkdir -p "${work_dir}"
    _remove_work_dir=0
fi

# output directory setup
[[ -d "${prod_dir}" ]] || mkdir -p "${prod_dir}"

# get rid of symlinks in paths, Qt6 build system fails if they are faced... requires zsh!
work_dir=${work_dir:A}
prod_dir=${prod_dir:A}

cd "${work_dir}"

_src_dir="${work_dir}/src"                  # sources will be downloaded here
_tmp_dir="${work_dir}/build-${target_arch}" # build intermediates will placed here
_lib_dir="${work_dir}/lib-${target_arch}"   # compiled libraries and headers go here

_qbt_dmg_path="${prod_dir}/qBittorrent-${qbittorrent_ver}-macOS-${target_arch}.dmg"

[[ "${target_arch}" == "${universal_arch_tag}" ]] && target_arch="x86_64;arm64"

# ---------------------------------------------------------------------------------------------------------------------
# download everything required (only missing parts will be downloaded)
mkdir -p ${_src_dir}
pushd "${_src_dir}" > /dev/null

_qbt_src_dir_name="qBittorrent-${qbittorrent_ver}"
_qbt_src_dir="${_src_dir}/${_qbt_src_dir_name}"
_qbt_tmp_dir="${_tmp_dir}/${_qbt_src_dir_name}"
# anything known to git (i.e. branch names or tags) can be used as 'version'
[[ -d ${_qbt_src_dir} ]] || curl -L https://github.com/qbittorrent/qBittorrent/archive/{$qbittorrent_ver}.tar.gz | tar xz

_ssl_src_dir_name="openssl-${openssl_ver}"
_ssl_src_dir="${_src_dir}/${_ssl_src_dir_name}"
_ssl_tmp_dir="${_tmp_dir}/${_ssl_src_dir_name}"
_ssl_lib_dir="${_lib_dir}/${_ssl_src_dir_name}"
[[ -d ${_ssl_src_dir} ]] || curl -L https://www.openssl.org/source/openssl-${openssl_ver}.tar.gz | tar xz

_boost_ver_u=${boost_ver//./_}
_boost_src_dir_name="boost_${_boost_ver_u}"
_boost_src_dir="${_src_dir}/${_boost_src_dir_name}"
# boost will NOT be compiled, only headers are enough, since 1.69.0 Boost.System is header-only
[[ -d ${_boost_src_dir} ]] || curl -L https://boostorg.jfrog.io/artifactory/main/release/${boost_ver}/source/boost_${_boost_ver_u}.tar.bz2 | tar xj

[[ ${libtorrent_commit} ]] && _lt_src_dir_name="libtorrent" || _lt_src_dir_name="libtorrent-rasterbar-${libtorrent_ver}"
_lt_src_dir="${_src_dir}/${_lt_src_dir_name}"
_lt_tmp_dir="${_tmp_dir}/${_lt_src_dir_name}"
_lt_lib_dir="${_lib_dir}/${_lt_src_dir_name}"
# if libtorrent is going to be cloned and workdir is specified, then some cleanup is necessary
if [[ ${libtorrent_commit} ]]
then
    if [[ -d ${_lt_src_dir} ]]
    then
        rm -rf ${_lt_src_dir}
    fi
    if [[ -d ${_lt_lib_dir} ]]
    then
        rm -rf ${_lt_lib_dir}
    fi
fi
# use libtorrent release archives, because GitHub doesn't include submodules into generated archives,
# but since 2.0 libtorrent has few, and they are required for compilation
if ! [[ -d ${_lt_src_dir} ]]
then
    if ! [[ ${libtorrent_commit} ]]
    then
        curl -L https://github.com/arvidn/libtorrent/releases/download/v${libtorrent_ver}/libtorrent-rasterbar-${libtorrent_ver}.tar.gz | tar xz
    else
        git clone --recurse-submodules https://github.com/arvidn/libtorrent.git
        cd ${_lt_src_dir}
        git checkout --recurse-submodules ${libtorrent_commit}
        cd ..
    fi
fi

# Qt6 requires ninja build system. even this is not strict requirement, but why not to satisfy it?
# download ninja sources and later build them for required architecture, use master branch
_ninja_ver="master"                         # ninja         https://github.com/ninja-build/ninja/releases
_ninja_src_dir_name="ninja-${_ninja_ver}"
_ninja_src_dir="${_src_dir}/${_ninja_src_dir_name}"
_ninja_tmp_dir="${work_dir}/build-$(uname -m)/${_ninja_src_dir_name}"
# anything known to git (i.e. branch names or tags) can be used as 'version'
[[ -d ${_ninja_src_dir} ]] || curl -L https://github.com/ninja-build/ninja/archive/{$_ninja_ver}.tar.gz | tar xz

# unfortunately, Qt repository must be cloned... it is much easier rather to deal with release archive
_qt_src_dir_name="qt-${qt_ver}"
_qt_src_dir="${_src_dir}/${_qt_src_dir_name}"
_qt_tmp_dir="${_tmp_dir}/${_qt_src_dir_name}"
_qt_lib_dir="${_lib_dir}/${_qt_src_dir_name}"
if ! [[ -d ${_qt_src_dir} ]]
then
    git clone https://code.qt.io/qt/qt5.git ${_qt_src_dir_name}
    cd ${_qt_src_dir_name}
    git checkout "v${qt_ver}"               # use only tags, not branches
    perl init-repository --module-subset=qtbase,qtsvg,qttools,qttranslations
    cd ..
fi

popd > /dev/null                            # back to working directory

# download CMake, 3.19.2 and above is required for Apple Silicon support
_cmake_dir_name="cmake-${cmake_ver}-macos-universal"
[[ -d ${_cmake_dir_name} ]] || curl -L https://github.com/Kitware/CMake/releases/download/v${cmake_ver}/cmake-${cmake_ver}-macos-universal.tar.gz | tar xz
cmake="${work_dir}/${_cmake_dir_name}/CMake.app/Contents/bin/cmake"
# Qt6 uses CMake as build system, but also provides convenient configure script
# this script relies on cmake executable in PATH
export PATH="$(dirname ${cmake})":$PATH

# Qt6 requires ninja build system. even this is not strict requirement, but why not to satisfy it?
# even more, ninja can be used to build almost any cmake-based project
# ninja is a build tool, so it must be compiled only for build host architecture, so that's why CMAKE_OSX_ARCHITECTURES is omitted
if ! [[ -d ${_ninja_tmp_dir} ]]
then
    ${cmake} -S ${_ninja_src_dir} -B ${_ninja_tmp_dir} -D CMAKE_VERBOSE_MAKEFILE=ON -D CMAKE_OSX_DEPLOYMENT_TARGET=${min_macos_ver} -D CMAKE_BUILD_TYPE=Release
    ${cmake} --build ${_ninja_tmp_dir} -j$(sysctl -n hw.ncpu)
fi
# to be able to use ninja, it must be available in PATH
export PATH=${_ninja_tmp_dir}:$PATH

# ---------------------------------------------------------------------------------------------------------------------
# everything is prepared now, time to start the build
#
# all dependencies are built as static libraries, the main reason for that was a possibility to use LTO
#
# all options used at configuration step are set only based on only my opinion or preference, there are no strict
# reasons for most of options in most cases

# OpenSSL doesn't provide the way to build an universal binary in one build step, so the only one way to get it -
# is build for each architecture separately and then merge architecture-specific binaries into one universal binary
function build_openssl_arch()
{
    local arch=$1

    local ssl_lib_dir="${work_dir}/lib-${arch}/${_ssl_src_dir_name}"
    local ssl_tmp_dir="${work_dir}/build-${arch}/${_ssl_src_dir_name}"

    if ! [[ -d ${ssl_lib_dir} ]]
    then
        rm -rf ${ssl_tmp_dir} && mkdir -p $_ && cd $_
        "${_ssl_src_dir}/Configure" no-comp no-deprecated no-dynamic-engine no-tests no-shared no-zlib --openssldir=/etc/ssl --prefix=${ssl_lib_dir} -mmacosx-version-min=${min_macos_ver} darwin64-${arch}-cc
        make -j$(sysctl -n hw.ncpu)
        make install_sw
        cd -
    fi
}

# OpenSSL is used by Qt, which is compiled as universal binaries in case of cross-compilation
# so OpenSSL is also must be universal binary when it is used for cross-compilation
[[ "${target_arch}" != "$(uname -m)" ]] && _ssl_lib_dir="${work_dir}/lib-${universal_arch_tag}/${_ssl_src_dir_name}"

if ! [[ -d ${_ssl_lib_dir} ]]
then
    if [[ "${target_arch}" == "$(uname -m)" ]]
    then
        build_openssl_arch ${target_arch}
    else
        build_openssl_arch x86_64
        build_openssl_arch arm64

        mkdir -p "${_ssl_lib_dir}/lib"
        # copy include directory (includes are the same for each arch)
        cp -r "${work_dir}/lib-x86_64/${_ssl_src_dir_name}/include" "${_ssl_lib_dir}/"
        # create universal binaries using lipo
        lipo -create "${work_dir}/lib-x86_64/${_ssl_src_dir_name}/lib/libcrypto.a" "${work_dir}/lib-arm64/${_ssl_src_dir_name}/lib/libcrypto.a" -output "${_ssl_lib_dir}/lib/libcrypto.a"
        lipo -create "${work_dir}/lib-x86_64/${_ssl_src_dir_name}/lib/libssl.a" "${work_dir}/lib-arm64/${_ssl_src_dir_name}/lib/libssl.a" -output "${_ssl_lib_dir}/lib/libssl.a"
    fi
fi

if ! [[ -d ${_lt_lib_dir} ]]
then
    rm -rf ${_lt_tmp_dir}
    ${cmake} -S ${_lt_src_dir} -B ${_lt_tmp_dir} -D CMAKE_VERBOSE_MAKEFILE=ON -D CMAKE_PREFIX_PATH="${_boost_src_dir};${_ssl_lib_dir}" -D CMAKE_CXX_STANDARD=${cxxstd} -D CMAKE_CXX_EXTENSIONS=OFF -D CMAKE_OSX_DEPLOYMENT_TARGET=${min_macos_ver} -D CMAKE_OSX_ARCHITECTURES=${target_arch} -D CMAKE_BUILD_TYPE=Release -D BUILD_SHARED_LIBS=OFF -D deprecated-functions=OFF -D CMAKE_INSTALL_PREFIX=${_lt_lib_dir}
    ${cmake} --build ${_lt_tmp_dir} -j$(sysctl -n hw.ncpu)
    ${cmake} --install ${_lt_tmp_dir}
fi

_qt_arch=${target_arch}
# Qt6 supports universal binaries out of the box, and in case of cross-compilation
# it is easier to build universal binaries rather than only for target architecture
if [[ "${target_arch}" != "$(uname -m)" ]]
then
    _qt_arch="x86_64;arm64"
    _qt_tmp_dir="${work_dir}/build-${universal_arch_tag}/${_qt_src_dir_name}"
    _qt_lib_dir="${work_dir}/lib-${universal_arch_tag}/${_qt_src_dir_name}"
fi

if ! [[ -d ${_qt_lib_dir} ]]
then
    rm -rf ${_qt_tmp_dir} && mkdir -p $_ && cd $_
    "${_qt_src_dir}/configure" -prefix ${_qt_lib_dir} -release -static -appstore-compliant -no-pch -no-dbus -no-icu -qt-pcre -system-zlib -ssl -openssl-linked -no-cups -qt-libpng -qt-libjpeg -no-feature-testlib -no-feature-concurrent -- -D CMAKE_PREFIX_PATH="${_ssl_lib_dir}" -D CMAKE_OSX_ARCHITECTURES=${_qt_arch} -D QT_BUILD_EXAMPLES=OFF
    ${cmake} --build . --parallel
    ${cmake} --install .
    cd -
fi

# build qBittorrent each time script launched
rm -rf ${_qbt_tmp_dir}
${cmake} -S ${_qbt_src_dir} -B ${_qbt_tmp_dir} -D CMAKE_VERBOSE_MAKEFILE=ON -D CMAKE_PREFIX_PATH="${_boost_src_dir};${_ssl_lib_dir};${_lt_lib_dir};${_qt_lib_dir}" -D CMAKE_CXX_STANDARD=${cxxstd} -D CMAKE_CXX_EXTENSIONS=OFF -D CMAKE_CXX_VISIBILITY_PRESET=hidden -D CMAKE_VISIBILITY_INLINES_HIDDEN=ON -D CMAKE_OSX_DEPLOYMENT_TARGET=${min_macos_ver} -D CMAKE_OSX_ARCHITECTURES=${target_arch} -D CMAKE_BUILD_TYPE=Release -D QT6=ON
${cmake} --build ${_qbt_tmp_dir} -j$(sysctl -n hw.ncpu)

# build result .dmg image containing qBittorrent
pushd ${_qbt_tmp_dir} > /dev/null
mv qbittorrent.app qBittorrent.app
codesign --deep --force --verify --verbose --sign "-" qBittorrent.app
hdiutil create -srcfolder qBittorrent.app -nospotlight -layout NONE -fs HFS+ -format ULFO -ov ${_qbt_dmg_path}
popd > /dev/null

# only automatically created directory will be removed
[[ $_remove_work_dir -eq 0 ]] || rm -rf ${work_dir}
