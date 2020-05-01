/* Makes some system function calls; POSIX-compliant. */

#include <stdio.h>
#include <unistd.h> /* sysconf(3) */

int main(void)
{
	printf("The page size for this system:   %ld bytes\n",
		sysconf(_SC_PAGESIZE)); /* _SC_PAGE_SIZE is OK too. */

	printf("Max length of a login name:     %ld bytes\n",
		sysconf(_SC_LOGIN_NAME_MAX)); /* _POSIX_LOGIN_NAME_MAX */

	printf("Max streaams per process:       %ld streams\n",
		sysconf(_SC_STREAM_MAX)); 


	return 0;

}
