# Advanced Programming in the Unix Environment

## 1 Unix System Overview

### 1.2 Unix Architecture

1. In a strict sense, an operating system can be defined as the software that controls the hardware resources of the computer and provides an environment under which programs can run. Generally, we call this software the **kernel**, since it is relatively small and resides at the core of the environment.

2. The interface to the kernel is a layer of software called the **system calls**.

3. Libraries of common functions are built on top of the **system call** interface, but applications are free to use both.

4. The **shell** is a special application that provides an interface for running other applications.

5. In a broad sense, an operating system consists of the kernel and all the other software that makes a computer useful and gives the computer its personality. This other software includes **system utilities, applications, shells, libraries of common functions, and so on**.

### 1.3 Logging In

1. When we log in to a UNIX system, we enter our login name, followed by our password. The system then looks up our login name in its password file, usually the file `/etc/passwd`.

### 1.4 Files and Directories

1. The stat and fstat functions return a structure of information containing all the attributes of a file.

2. The only two characters that cannot appear in a filename are the slash character (/) and the null character. The slash separates the filenames that form a pathname (described next) and the null character terminates a pathname.

### 1.6 Programs and Processes

1. All threads within a process share the same address space, file descriptors, stacks, and process-related attributes. Each thread executes on its own stack, although any thread can access the stacks of other threads in the same process. Because they can access the same memory, the threads need to **synchronize access to shared data** among themselves to avoid inconsistencies.

### 1.7 Error Handling

1. When an error occurs in one of the UNIX System functions, a **negative** value is often returned, and the integer **errno** is usually set to a value that tells why.

2. There are two rules to be aware of with respect to errno. First, its value is never cleared by a routine if an error does not occur. Therefore, we should examine its value only when the return value from a function indicates that an error occurred. Second, the value of errno is never set to 0 by any of the functions, and none of the constants defined in `<errno.h>` has a value of 0.

3. Resource-related nonfatal errors include EAGAIN, ENFILE, ENOBUFS, ENOLCK, ENOSPC, EWOULDBLOCK, and sometimes ENOMEM. EBUSY can be treated as nonfatal when it indicates that a shared resource is in use. Sometimes, EINTR can be treated as a nonfatal error when it interrupts a slow system call.

4. The typical recovery action for a resource-related nonfatal error is to delay and retry later. This technique can be applied in other circumstances.

## Question

1. Q: Figure 1.4的程序实现读取stdin并写到stdout，我修改为读取stdout并写到stdin，运行结果却没任何区别，为啥？
    - A: 在[stack overflow][1]找到一个解释：When the input comes from the console, and the output goes to the console, then all three indeed happen to refer to the same file. (But the console device has quite different implementations for reading and writing.)

[1]: https://stackoverflow.com/questions/51532911/are-stdin-and-stdout-actually-the-same-file
