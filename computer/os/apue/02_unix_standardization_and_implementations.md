# Advanced Programming in the Unix Environment

## 2 Unix Standardization and Implementations

### 2.2 Unix Standardization

#### 2.2.1 ISO C

1. In late 1989, ANSI Standard **X3.159-1989** for the C programming language was approved. This standard was also adopted as International Standard **ISO/IEC 9899:1990**.

2. ANSI is the **American National Standards Institute**, the U.S. member in the **International Organization for Standardization** (ISO). IEC stands for the **International Electrotechnical Commission**.

3. The C standard is now maintained and developed by the ISO/IEC international standardization working group for the C programming language, known as ISO/IEC JTC1/SC22/WG14, or WG14 for short.

4. The intent of the ISO C standard is to provide portability of conforming C programs to a wide variety of operating systems, not only the UNIX System. This standard defines not only the syntax and semantics of the programming language but also a standard library.

5. In 1999, the ISO C standard was updated and approved as **ISO/IEC 9899:1999**, largely to improve support for applications that perform numerical processing.

#### 2.2.2 IEEE POSIX

1. POSIX is a family of standards initially developed by the IEEE (Institute of Electrical and Electronics Engineers). POSIX stands for **Portable Operating System Interface**.

2. The goal of the **1003.1** operating system interface standard is to promote the portability of applications among various UNIX System environments. This standard defines the services that an operating system must provide if it is to be "POSIX compliant", and has been adopted by most computer vendors.

3. The 1988 version, IEEE Standard 1003.1-1988, was modified and submitted to the International Organization for Standardization. No new interfaces or features were added, but the text was revised. The resulting document was published as IEEE Standard **1003.1-1990**. This is also International Standard **ISO/IEC 9945-1:1990**. This standard was commonly referred to as **POSIX.1**.

4. In 1996, a revised version of the IEEE 1003.1 standard was published. It included the 1003.1-1990 standard, the 1003.1b-1993 **real-time extensions standard, and the interfaces for multithreaded programming, called pthreads for POSIX threads**.

#### 2.2.3 The Single UNIX Specification

1. **The Single UNIX Specification**, a superset of the POSIX.1 standard, specifies additional interfaces that extend the functionality provided by the POSIX.1 specification. POSIX.1 is equivalent to the Base Specifications portion of the Single UNIX Specification.

2. The **X/Open System Interfaces (XSI)** option in POSIX.1 describes optional interfaces and defines which optional portions of POSIX.1 must be supported for an implementation to be deemed **XSI conforming**. These include file synchronization, thread stack address and size attributes, thread process-shared synchronization, and the `_XOPEN_UNIX` symbolic constant. **Only XSIconforming implementations can be called UNIX systems**.

### 2.3 UNIX System Implementations

1. Everything starts from the Sixth Edition (1976) and Seventh Edition (1979) of the UNIX Time-Sharing System on the PDP-11 (usually called Version 6 and Version 7, respectively). These were the first releases widely distributed outside of Bell Laboratories.

2. Three branches of the tree evolved.
    - One at AT&T that led to System III and System V, the so-called commercial versions of the UNIX System.
    - One at the University of California at Berkeley that led to the 4.xBSD implementations.
    - The research version of the UNIX System, developed at the Computing Science Research Center of AT&T Bell Laboratories, that led to the UNIX Time-Sharing System 8th Edition, 9th Edition, and ended with the 10th Edition in 1990.

3. **UNIX System V Release 4 (SVR4)** was a product of AT&T’s UNIX System Laboratories (USL, formerly AT&T’s UNIX Software Operation). SVR4 merged functionality from AT&T UNIX System V Release 3.2 (SVR3.2), the SunOS operating system from Sun Microsystems, the 4.3BSD release from the University of California, and the Xenix system from Microsoft into one coherent operating system.

4. The SVR4 source code was released in late 1989, with the first end-user copies becoming available during 1990. SVR4 conformed to both the POSIX 1003.1 standard and the X/Open Portability Guide, Issue 3 (XPG3).

5. The **Berkeley Software Distribution (BSD)** releases were produced and distributed by the Computer Systems Research Group (CSRG) at the University of California at Berkeley; 4.2BSD was released in 1983 and 4.3BSD in 1986.

6. **FreeBSD** is based on the 4.4BSD-Lite operating system. The FreeBSD project was formed to carry on the BSD line after the Computing Science Research Group at the University of California at Berkeley decided to end its work on the BSD versions of the UNIX operating system,

7. All software produced by the FreeBSD project is freely available in both binary and source forms.

8. Linux is distinguished by often being the first operating system to support new hardware.

9. **Mac OS X** is based on entirely different technology than prior versions. The core operating system is called "Darwin", and is based on a combination of the Mach kernel, the FreeBSD operating system, and an object-oriented framework for drivers and other kernel extensions. As of version 10.5, the Intel port of Mac OS X has been certified to be a UNIX system.

10. **Solaris** is the version of the UNIX System developed by Sun Microsystems (now Oracle). Solaris is based on System V Release 4, but includes more than fifteen years of enhancements from the engineers at Sun Microsystems. It is arguably the only commercially successful SVR4 descendant, and is formally certified to be a UNIX system.
