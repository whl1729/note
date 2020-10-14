# Advanced Programming in the Unix Environment

## 2 Unix Standardization and Implementations

### 2.2 Unix Standardization

#### 2.2.1 ISO C

1. In late 1989, ANSI Standard **X3.159-1989** for the C programming language was approved. This standard was also adopted as International Standard **ISO/IEC 9899:1990**.

2. ANSI is the **American National Standards Institute**, the U.S. member in the **International Organization for Standardization** (ISO). IEC stands for the **International Electrotechnical Commission**.

3. The C standard is now maintained and developed by the ISO/IEC international standardization working group for the C programming language, known as ISO/IEC JTC1/SC22/WG14, or WG14 for short.

4. The intent of the ISO C standard is to provide **portability of conforming C programs to a wide variety of operating systems**, not only the UNIX System. This standard defines not only the **syntax and semantics** of the programming language but also a **standard library**.

5. This standard defines not only the **syntax and semantics** of the programming language but also a **standard library**.

6. In 1999, the ISO C standard was updated and approved as **ISO/IEC 9899:1999**, largely to improve support for applications that perform numerical processing.

7. ISO C标准定义了24个必需的头文件，POSIX也定义了若干必需的头文件和可选的头文件。

#### 2.2.2 IEEE POSIX

1. POSIX is a family of standards initially developed by the IEEE (Institute of Electrical and Electronics Engineers). POSIX stands for **Portable Operating System Interface**. It originally referred only to the IEEE Standard 1003.1-1988 — the operating system interface — but was later extended to include **many of the standards and draft standards with the 1003 designation**, including the shell and utilities (1003.2).

2. The goal of the **1003.1** operating system interface standard is to promote the portability of applications among various UNIX System environments. This standard defines the services that an operating system must provide if it is to be "POSIX compliant", and has been adopted by most computer vendors. Although the 1003.1 standard is based on the UNIX operating system, the standard is **not restricted** to UNIX and UNIX-like systems.

3. Because the 1003.1 standard specifies an **interface** and not an implementation, no distinction is made between system calls and library functions. All the routines in the standard are called **functions**.

3. The 1988 version, IEEE Standard 1003.1-1988, was modified and submitted to the International Organization for Standardization. No new interfaces or features were added, but the text was revised. The resulting document was published as IEEE Standard **1003.1-1990**. This is also International Standard **ISO/IEC 9945-1:1990**. This standard was commonly referred to as **POSIX.1**.

4. In 1996, a revised version of the IEEE 1003.1 standard was published. It included the 1003.1-1990 standard, the 1003.1b-1993 **real-time extensions standard, and the interfaces for multithreaded programming, called pthreads for POSIX threads**.

#### 2.2.3 The Single UNIX Specification

1. The Single UNIX Specification, a **superset** of the POSIX.1 standard, specifies additional interfaces that extend the functionality provided by the POSIX.1 specification. POSIX.1 is equivalent to the Base Specifications portion of the Single UNIX Specification.

2. The **X/Open System Interfaces (XSI)** option in POSIX.1 describes optional interfaces and defines which optional portions of POSIX.1 must be supported for an implementation to be deemed **XSI conforming**. These include file synchronization, thread stack address and size attributes, thread process-shared synchronization, and the `_XOPEN_UNIX` symbolic constant. **Only XSI-conforming implementations can be called UNIX systems**.

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

### 2.5 Limits

1. Two types of limits are needed:
    - **Compile-time limits** (e.g., what’s the largest value of a short integer?)
    - **Runtime limits** (e.g., how many bytes in a filename?)

2. Compile-time limits can be defined in headers that any program can include at compile time. But runtime limits require the process to call a function to obtain the limit’s value.

3. Additionally, some limits can be fixed on a given implementation—and could therefore be defined statically in a header—yet vary on another implementation and would require a runtime function call.

4. Three types of limits are provided:
    - Compile-time limits (headers)
    - Runtime limits not associated with a file or directory (the sysconf function)
    - Runtime limits that are associated with a file or a directory (the pathconf and fpathconf functions)

#### 2.5.1 ISO C Limits

1. All of the compile-time limits defined by ISO C are defined in the file `<limits.h>`.

2. Although the ISO C standard specifies minimum acceptable values for integral data types, POSIX.1 makes extensions to the C standard. To conform to POSIX.1, an implementation must support a minimum value of 2,147,483,647 for INT_MAX, −2,147,483,647 for INT_MIN, and 4,294,967,295 for UINT_MAX. Because POSIX.1 requires implementations to support an 8-bit char, CHAR_BIT must be 8, SCHAR_MIN must be −128, SCHAR_MAX must be 127, and UCHAR_MAX must be 255.

3. ISO C defines constants FOPEN_MAX, TMP_MAX and FILENAME_MAX in `<stdio.h>`.

#### 2.5.2 POSIX Limits

1. POSIX.1 defines numerous constants that deal with implementation limits of the operating system.

2. These limits and constants are divided into the following seven categories:
    - Numerical limits: `LONG_BIT, SSIZE_MAX, and WORD_BIT`
    - Minimum values: e.g., `_POSIX_ARG_MAX, _POSIX_CHILD_MAX`
    - Maximum value: `_POSIX_CLOCKRES_MIN`
    - Runtime increasable values: `CHARCLASS_NAME_MAX, COLL_WEIGHTS_MAX, LINE_MAX, NGROUPS_MAX, and RE_DUP_MAX`
    - Runtime invariant values, possibly indeterminate: e.g., `ARG_MAX, ATEXIT_MAX`
    - Other invariant values: `NL_ARGMAX, NL_MSGMAX, NL_SETMAX, and NL_TEXTMAX`
    - variable values: `FILESIZEBITS, LINK_MAX, MAX_CANON, MAX_INPUT, NAME_MAX, PATH_MAX, PIPE_BUF, and SYMLINK_MAX`

#### 2.5.4 sysconf, pathconf, and fpathconf Functions

1. The runtime limits are obtained by calling one of the following three functions.
```
#include <unistd.h>

long sysconf(int name);
long pathconf(const char *pathname, int name);
long fpathconf(int fd, int name);

// All three return: corresponding value if OK, −1 on error (see later)
```

2. Constants beginning with `_SC_` are used as arguments to sysconf to identify the runtime limit. Constants beginning with `_PC_` are used as arguments to pathconf and fpathconf to identify the runtime limit.

### 2.6 Options

1. If we are to write portable applications that depend on any of these optionally supported features, we need a portable way to determine whether an implementation supports a given option.

2. Just as with limits (Section 2.5), POSIX.1 defines three ways to do this.
    - Compile-time options are defined in `<unistd.h>`.
    - Runtime options that are not associated with a file or a directory are identified with the `sysconf` function.
    - Runtime options that are associated with a file or a directory are discovered by calling either the `pathconf` or the `fpathconf` function.

3. Options 用来描述系统是否支持某些功能。

### 2.7 Feature Test Macros

1. Most implementations can add their own definitions to these headers, in addition to the POSIX.1 and XSI definitions. If we want to compile a program so that it depends only on the POSIX definitions and doesn’t conflict with any implementation-defined constants, we need to define the constant `_POSIX_C_SOURCE`. All the POSIX.1 headers use this constant to exclude any implementation-defined definitions when `_POSIX_C_SOURCE` is defined.

2. The constants `_POSIX_C_SOURCE` and `_XOPEN_SOURCE` are called **feature test macros**. All feature test macros begin with an underscore. When used, they are typically defined in the cc command.

3. If we want to use only the POSIX.1 definitions, we can also set the first line of a source file to `#define _POSIX_C_SOURCE 200809L`.

4. To enable the XSI option of Version 4 of the Single UNIX Specification, we need to define the constant `_XOPEN_SOURCE` to be 700.

5. To enable the 1999 ISO C extensions in the gcc C compiler, we use the `-std=c99` option.

### 2.8 Primitive System Data Types

1. The header `<sys/types.h>` defines some implementation-dependent data types, called the primitive system data types. More of these data types are defined in other headers as well. These data types are defined in the headers with the C typedef facility. Most end in `_t`.

### 2.9 Differences Between Standards

1. Conflicts are unintended, but if they should arise, **POSIX.1 defers to the ISO C standard**.

2. ISO C defines the function clock to return the amount of CPU time used by a process. The value returned is a `clock_t` value, but ISO C **doesn’t specify its units**. Thus we must take care when using variables of type `clock_t` so that we don’t mix variables with different units.

3. Another area of potential conflict is when the ISO C standard specifies a function, but doesn’t specify it as strongly as POSIX.1 does. This is the case for functions that require a different implementation in a POSIX environment (with multiple processes) than in an ISO C environment (where very little can be assumed about the host operating system).

### Exercises

1. We mentioned in Section 2.8 that some of the primitive system data types are defined in more than one header. For example, in FreeBSD 8.0, `size_t` is defined in 29 different headers. Because all 29 headers could be included in a program and because ISO C does not allow multiple typedefs for the same name, how must the headers be written?
    - 答案：定义`size_t`时使用宏来避免重复定义。
```
#ifndef _SIZE_T_DECLARED
typedef _size_t size_t;
#define _SIZE_T_DECLARED
#endif
```
