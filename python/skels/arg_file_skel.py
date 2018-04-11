#!/usr/bin/env python

"""
  A generic skeleton template for file I/O operations with arg-driven execution in Python.

  This is a useful base template for a great deal of SRE/DevOps-centered work.
"""

from __future__ import print_function
import os
import sys
import argparse


def main(arguments):

    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('-i', '--infile', help="Input file", 
                        type=argparse.FileType('r'))
    parser.add_argument('-o', '--outfile', help="Output file",
                        default=sys.stdout, type=argparse.FileType('w'))

    args = parser.parse_args(arguments)

    print(args)


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
