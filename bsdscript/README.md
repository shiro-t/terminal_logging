# script command from FreeBSD.

Obtained from the below.
[https://raw.githubusercontent.com/freebsd/freebsd-src/refs/heads/main/usr.bin/script/script.c](https://raw.githubusercontent.com/freebsd/freebsd-src/refs/heads/main/usr.bin/script/script.c)


## How to build

```
$ cc -o script -lutil
```

## Caution

The ```-f``` option in't working.

## Diff from the original source.


```
*** _orig/script.c	Tue Nov 24 19:08:50 2026
--- ./script.c	Tue Nov 24 18:57:16 2026
***************
*** 38,50 ****
--- 38,56 ----
  #include <sys/queue.h>
  #include <sys/uio.h>
  #include <sys/endian.h>
+ #ifndef __APPLE__
  #include <dev/filemon/filemon.h>
+ #endif
  
  #include <assert.h>
  #include <err.h>
  #include <errno.h>
  #include <fcntl.h>
+ #ifdef __APPLE__
+ #include <util.h>
+ #else
  #include <libutil.h>
+ #endif
  #include <paths.h>
  #include <signal.h>
  #include <stdio.h>
***************
*** 145,153 ****
--- 151,161 ----
  		case 'F':
  			Fflg = 1;
  			break;
+ #ifndef __APPLE__
  		case 'f':
  			fflg = 1;
  			break;
+ #endif
  		case 'k':
  			kflg = 1;
  			break;
***************
*** 190,195 ****
--- 198,204 ----
  	if ((fscript = fopen(fname, pflg ? "r" : aflg ? "a" : "w")) == NULL)
  		err(1, "%s", fname);
  
+ #ifndef __APPLE__
  	if (fflg) {
  		asprintf(&fmfname, "%s.filemon", fname);
  		if (!fmfname)
***************
*** 203,208 ****
--- 212,218 ----
  		if (ioctl(fm_fd, FILEMON_SET_FD, &fm_log) < 0)
  			err(1, "Cannot set filemon log file descriptor");
  	}
+ #endif
  
  	if (pflg)
  		playback(fscript);
***************
*** 244,253 ****
--- 254,265 ----
  			}
  		}
  		fflush(fscript);
+ #ifndef __APPLE__
  		if (fflg) {
  			(void)printf("Filemon started, output file is %s\n",
  			    fmfname);
  		}
+ #endif
  	}
  	if (ttyflg) {
  		rtt = tt;
***************
*** 256,269 ****
  		(void)tcsetattr(STDIN_FILENO, TCSAFLUSH, &rtt);
  	}
  
  	assert(fflg ? fm_fd >= 0 : fm_fd < 0);
! 
  	child = fork();
  	if (child < 0) {
  		warn("fork");
  		done(1);
  	}
  	if (child == 0) {
  		if (fflg) {
  			int pid;
  
--- 268,283 ----
  		(void)tcsetattr(STDIN_FILENO, TCSAFLUSH, &rtt);
  	}
  
+ #ifndef __APPLE__
  	assert(fflg ? fm_fd >= 0 : fm_fd < 0);
! #endif
  	child = fork();
  	if (child < 0) {
  		warn("fork");
  		done(1);
  	}
  	if (child == 0) {
+ #ifndef __APPLE__
  		if (fflg) {
  			int pid;
  
***************
*** 271,277 ****
  			if (ioctl(fm_fd, FILEMON_SET_PID, &pid) < 0)
  				err(1, "Cannot set filemon PID");
  		}
! 
  		doshell(argv);
  	}
  	close(slave);
--- 285,291 ----
  			if (ioctl(fm_fd, FILEMON_SET_PID, &pid) < 0)
  				err(1, "Cannot set filemon PID");
  		}
! #endif
  		doshell(argv);
  	}
  	close(slave);
***************
*** 464,473 ****
--- 478,489 ----
  			    ctime(&tvec));
  		}
  		(void)printf("\nScript done, output file is %s\n", fname);
+ #ifndef __APPLE__
  		if (fflg) {
  			(void)printf("Filemon done, output file is %s\n",
  			    fmfname);
  		}
+ #endif
  	}
  	(void)fclose(fscript);
  	(void)close(master);
```
