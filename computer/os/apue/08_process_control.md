# Advanced Programming in the Unix Environment

## 8 Process Control

### 8.2 Process Identifiers

1. Every process has a unique process ID, a non-negative integer.

2. Although unique, process IDs are reused. As processes terminate, their IDs become candidates for reuse. Most UNIX systems implement algorithms to **delay reuse**, however, so that newly created processes are assigned IDs different from those used by processes that terminated recently. This prevents a new process from being mistaken for the previous process to have used the same ID.

3. Process ID 0 is usually the scheduler process and is often known as the swapper. No program on disk corresponds to this process, which is part of the kernel and is known as a system process.

4. Process ID 1 is usually the init process and is invoked by the kernel at the end of the bootstrap procedure.
    - The program file for this process was /etc/init in older versions of the UNIX System and is /sbin/init in newer versions.
    - This process is responsible for bringing up a UNIX system after the kernel has been bootstrapped.
    - init usually reads the system-dependent initialization files — the `/etc/rc*` files or `/etc/inittab` and the files in `/etc/init.d` — and brings the system to a certain state, such as multiuser. The init process never dies. It is a normal user process, not a system process within the kernel, like the swapper, although it does run with superuser privileges.

5. In addition to the process ID, there are other identifiers for every process. The following functions return these identifiers.
```
#include <unistd.h>

pid_t getpid(void);
// Returns: process ID of calling process

pid_t getppid(void);
// Returns: parent process ID of calling process

uid_t getuid(void);
// Returns: real user ID of calling process

uid_t geteuid(void);
// Returns: effective user ID of calling process

gid_t getgid(void);
// Returns: real group ID of calling process

gid_t getegid(void);
// Returns: effective group ID of calling process
```

### 8.3 fork Function

1. An existing process can create a new one by calling the fork function.
```
#include <unistd.h>

pid_t fork(void);

// Returns: 0 in child, process ID of child in parent, −1 on error
```

2. This function is called once but returns twice. The only difference in the returns is that the return value in the child is 0, whereas the return value in the parent is the process ID of the new child.
    - The reason the child’s process ID is returned to the parent is that a process can have more than one child, and there is no function that allows a process to obtain the process IDs of its children.
    - The reason fork returns 0 to the child is that a process can have only a single parent, and the child can always call getppid to obtain the process ID of its parent. (Process ID 0 is reserved for use by the kernel, so it’s not possible for 0 to be the process ID of a child.)

3. Modern implementations don’t perform a complete copy of the parent’s data, stack, and heap, since a fork is often followed by an exec. Instead, a technique called copy-on-write (COW) is used. These regions are shared by the parent and the child and have their protection changed by the kernel to read-only. If either process tries to modify these regions, the kernel then makes a copy of that piece of memory only, typically a "page" in a virtual memory system.

4. The differences between the parent and child are
    - The return values from fork are different.
    - The process IDs are different.
    - The two processes have different parent process IDs: the parent process ID of the child is the parent; the parent process ID of the parent doesn’t change.
    - The child’s tms_utime, tms_stime, tms_cutime, and tms_cstime values are set to 0.
    - File locks set by the parent are not inherited by the child.
    - Pending alarms are cleared for the child.
    - The set of pending signals for the child is set to the empty set.

### 8.4 vfork Function

1. The vfork function was intended to create a new process for the purpose of executing a new program. The vfork function creates the new process, just like fork, without copying the address space of the parent into the child, as the child won’t reference that address space; the child simply calls exec (or exit) right after the vfork. Instead, the child runs in the address space of the parent until it calls either exec or exit.

2. This optimization is more efficient on some implementations of the UNIX System, but leads to undefined results if the child modifies any data (except the variable used to hold the return value from vfork), makes function calls, or returns without calling exec or exit.

3. Another difference between the two functions is that vfork guarantees that the child runs first, until the child calls exec or exit. When the child calls either of these functions, the parent resumes. (This can lead to deadlock if the child depends on further actions of the parent before calling either of these two functions.)

### 8.5 exit Functions

1. A process can terminate normally in five ways:
    - Executing a return from the main function.
    - Calling the exit function. This function is defined by ISO C and includes the calling of all **exit handlers** that have been registered by calling atexit and closing all standard I/O streams. Because ISO C does not deal with file descriptors, multiple processes (parents and children), and job control, the definition of this function is incomplete for a UNIX system.
    - Calling the `_exit` or `_Exit` function. ISO C defines `_Exit` to provide a way for a process to terminate without running exit handlers or signal handlers. Whether standard I/O streams are flushed depends on the implementation. On UNIX systems, `_Exit` and `_exit` are synonymous and do not flush standard I/O streams. The `_exit` function is called by exit and handles the UNIX system-specific details; `_exit` is specified by POSIX.1.
    - Executing a return from the start routine of the last thread in the process. The return value of the thread is not used as the return value of the process, however. When the last thread returns from its start routine, the process exits with a termination status of 0.
    - Calling the pthread_exit function from the last thread in the process. The exit status of the process in this situation is always 0, regardless of the argument passed to pthread_exit.

2. The three forms of abnormal termination are as follows:
    - Calling abort. This is a special case of the next item, as it generates the SIGABRT signal.
    - When the process receives certain signals. The signal can be generated by the process itself (e.g., by calling the abort function), by some other process, or by the kernel. Examples of signals generated by the kernel include the process referencing a memory location not within its address space or trying to divide by 0.
    - The last thread responds to a cancellation request. By default, cancellation occurs in a deferred manner: one thread requests that another be canceled, and sometime later the target thread terminates.

3. Regardless of how a process terminates, the same code in the kernel is eventually executed. This kernel code closes all the open descriptors for the process, releases the memory that it was using, and so on.

4. For any of the preceding cases, we want the terminating process to be able to notify its parent how it terminated.
    - For the three exit functions (exit, `_exit`, and `_Exit`), this is done by passing an exit status as the argument to the function.
    - In the case of an abnormal termination, however, the kernel—not the process — generates a termination status to indicate the reason for the abnormal termination.
    - In any case, the parent of the process can obtain the termination status from either the wait or the waitpid function (described in the next section)

5. Note that we differentiate between the **exit status**, which is the argument to one of the three exit functions or the return value from main, and **the termination status**. The exit status is converted into a termination status by the kernel when `_exit` is finally called. Figure 8.4 describes the various ways the parent can examine the termination status of a child. If the child terminated normally, the parent can obtain the exit status of the child.
    ![macros_to_examine_the_termination_status](images/macros_to_examine_the_termination_status.png)

6. The status stored by waitpid() encodes both the reason that the child process was terminated and the exit code. The reason is stored in the least-significant byte (obtained by status & 0xff), and the exit code is stored in the next byte (masked by status & 0xff00 and extracted by WEXITSTATUS()). When the process terminates normally, the reason is 0 and so WEXITSTATUS is just equivalent to shifting by 8 (or dividing by 256). However, if the process is killed by a signal (such as SIGSEGV), there is no exit code, and you have to use WTERMSIG to extract the signal number from the reason byte. (For more details ,see [exit_status][1]).
    [1]: https://stackoverflow.com/questions/808541/any-benefit-in-using-wexitstatus-macro-in-c-over-division-by-256-on-exit-statu/808995#808995

7. What happens if the parent terminates before the child? The answer is that the init process becomes the parent process of any process whose parent terminates. In such a case, we say that the process has been inherited by init. What normally happens is that whenever a process terminates, the kernel goes through all active processes to see whether the terminating process is the parent of any process that still exists. If so, the parent process ID of the surviving process is changed to be 1 (the process ID of init). This way, we’re guaranteed that every process has a parent. (Wu: Things are different on Ubuntu 18. The `systemd --user`, whose pid isn't 1,  becomes the parent process of any orphan process.)

8. What happens if the child terminates before the parent? In UNIX System terminology, a process that has terminated, but whose parent has not yet waited for it, is called a **zombie**.

9. What happens when a process that has been inherited by init terminates? Does it become a zombie? The answer is "no", because init is written so that whenever one of its children terminates, init calls one of the wait functions to fetch the termination status. By doing this, init prevents the system from being clogged by zombies.

### 8.6 wait and waitpid Functions

1. SIGCHLD signal
    - When a process terminates, either normally or abnormally, the kernel notifies the parent by sending the **SIGCHLD** signal to the parent.
    - Because the termination of a child is an **asynchronous** event—it can happen at any time while the parent is running — this signal is the asynchronous notification from the kernel to the parent.
    - The parent can choose to ignore this signal, or it can provide a function that is called when the signal occurs: a signal handler.
    - The default action for this signal is to be ignored.

2. Functions that wait for process to change state
```
#include <sys/wait.h>

pid_t wait(int *statloc);
pid_t waitpid(pid_t pid, int *statloc, int options);

// Both return: process ID if OK, 0 (see later), or −1 on error
```

3. The differences between these two functions are as follows:
    - The wait function can block the caller until a child process terminates, whereas waitpid has an option that prevents it from blocking.
    - The waitpid function doesn’t wait for the child that terminates first; it has a number of options that control which process it waits for.

4.  The value of pid in the waitpid function can be:
    - `< -1` meaning wait for any child process whose process group ID is equal to the absolute value of pid.
    - `-1`   meaning wait for any child process.
    - `0`    meaning wait for any child process whose process group ID is equal to that of the calling process.
    - `> 0`  meaning wait for the child whose process ID is equal to the value of pid.

5. The value of options is an OR of zero or more of the following constants:
    - `WNOHANG` return immediately if no child has exited.
    - `WUNTRACED` also return if a child has stopped.
    - `WCONTINUED` also return if a stopped child has been resumed by delivery of SIGCONT.

6. If we want to write a process so that it forks a child but we don’t want to wait for the child to complete and we don’t want the child to become a zombie until we terminate, the trick is to call **fork twice**.

### 8.7 waitid Function

1. The waitid function is similar to waitpid, but provides extra flexibility.
```
#include <sys/wait.h>

int waitid(idtype_t idtype, id_t id, siginfo_t *infop, int options);

// Returns: 0 if OK, −1 on error
```

2. Instead of encoding this information in a single argument combined with the process ID or process group ID, **two separate arguments** are used. The id parameter is interpreted based on the value of idtype.

3. idtype
    - `idtype == P_PID` Wait for the child whose process ID matches id.
    - `idtype == P_PGID` Wait for any child whose process group ID matches id.
    - `idtype == P_ALL` Wait for any child; id is ignored.

4. options
    - `WCONTINUED` Wait for a process that has previously stopped and has been continued, and whose status has not yet been reported.
    - `WEXITED` Wait for processes that have exited.
    - `WNOHANG` Return immediately instead of blocking if there is no child exit status available.
    - `WNOWAIT` Don’t destroy the child exit status. The child’s exit status can be retrieved by a subsequent call to wait, waitid, or waitpid.
    - `WSTOPPED` Wait for a process that has stopped and whose status has not yet been reported.

5. **At least one of WCONTINUED, WEXITED, or WSTOPPED must be specified in the options argument.**

### 8.8 wait3 and wait4 Funcitons

1. Most UNIX system implementations provide two additional functions: wait3 and wait4. The only feature provided by these two functions that isn’t provided by the wait, waitid, and waitpid functions is an additional argument that allows the kernel to return **a summary of the resources** used by the terminated process and all its child processes.
```
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/resource.h>

pid_t wait3(int *statloc, int options, struct rusage *rusage);
pid_t wait4(pid_t pid, int *statloc, int options, struct rusage *rusage);

// Both return: process ID if OK, 0, or −1 on error
```

2. The resource information includes such statistics as the amount of user CPU time, amount of system CPU time, number of page faults, number of signals received, and the like. Refer to the **getrusage(2)** manual page for additional details.

### 8.9 Race Conditions

1. For our purposes, a **race condition** occurs when multiple processes are trying to do something with shared data and the final outcome **depends on the order** in which the processes run.

2. The fork function is a lively breeding ground for race conditions, if any of the logic after the fork either explicitly or implicitly depends on whether the parent or child runs first after the fork.

3. To avoid race conditions and to avoid polling, some form of **signaling** is required between multiple processes. **Signals** can be used for this purpose. Various forms of **interprocess communication (IPC)** can also be used.

4. For a parent and child relationship, we often have the following scenario to avoid race conditions.
```
#include "apue.h"

TELL_WAIT(); /* set things up for TELL_xxx & WAIT_xxx */

if ((pid = fork()) < 0) {
    err_sys("fork error");
} else if (pid == 0) { /* child */
    /* child does whatever is necessary ... */

    TELL_PARENT(getppid()); /* tell parent we’re done */
    WAIT_PARENT(); /* and wait for parent */

    /* and the child continues on its way ... */

    exit(0);
}

/* parent does whatever is necessary ... */

TELL_CHILD(pid); /* tell child we’re done */
WAIT_CHILD(); /* and wait for child */

/* and the parent continues on its way ... */

exit(0);
```

### 8.10 exec Functions

1. The process ID does not change across an exec, because a new process is not created; exec merely replaces the current process — its text, data, heap, and stack segments — with a brand-new program from disk.

> Question: How does exec work?

2. exec Functions
```
#include <unistd.h>

int execl(const char *pathname, const char *arg0, ... /* (char *)0 */ );
int execv(const char *pathname, char *const argv[]);
int execle(const char *pathname, const char *arg0, ... /* (char *)0, char *const envp[] */ );
int execve(const char *pathname, char *const argv[], char *const envp[]);
int execlp(const char *filename, const char *arg0, ... /* (char *)0 */ );
int execvp(const char *filename, char *const argv[]);
int fexecve(int fd, char *const argv[], char *const envp[]);

// All seven return: −1 on error, no return on success
```

3. How to remember these exec functions?
    - The letter p means that the function takes a filename argument and uses the PATH environment variable to find the executable file. (Note: If the specified filename includes a slash character, then PATH is ignored, and the file at the specified pathname is executed.)
    - The letter l means that the function takes a list of arguments and is mutually exclusive with the letter v, which means that it takes an argv[] vector.
    - The letter e means that the function takes an envp[] array instead of using the current environment.

4. If either execlp or execvp finds an executable file using one of the path prefixes, but the file isn’t a machine executable that was generated by the link editor, the function assumes that the file is a shell script and tries to invoke /bin/sh with the filename as input to the shell.

5. Normally, a process allows its environment to be propagated to its children, but in some cases, a process wants to specify a certain environment for a child. One example of the latter is the login program when a new login shell is initiated.  Normally, login creates a specific environment with only a few variables defined and lets us, through the shell start-up file, add variables to the environment when we log in.

6. The process ID does not change after an exec, but the new program inherits additional properties from the calling process:
    - Process ID and parent process ID
    - Real user ID and real group ID
    - Supplementary group IDs
    - Process group ID
    - Session ID
    - Controlling terminal
    - Time left until alarm clock
    - Current working directory
    - Root directory
    - File mode creation mask
    - File locks
    - Process signal mask
    - Pending signals
    - Resource limits
    - Nice value
    - Values for tms_utime, tms_stime, tms_cutime, and tms_cstime

7. The handling of open files depends on the value of the close-on-exec flag for each descriptor.
    - Every open descriptor in a process has a close-on-exec flag. If this flag is set, the descriptor is closed across an exec. Otherwise, the descriptor is left open across the exec.
    - The default is to leave the descriptor open across the exec unless we specifically set the close-on-exec flag using fcntl.

### 8.11 Changing User IDs and Group IDs

1. In general, we try to use the **least-privilege** model when we design our applications.  According to this model, our programs should use the least privilege necessary to accomplish any given task. This reduces the risk that security might be compromised by a malicious user trying to trick our programs into using their privileges in unintended ways.

2. We can set the real user ID and effective user ID with the setuid function. Similarly, we can set the real group ID and the effective group ID with the setgid function.
```
#include <unistd.h>

int setuid(uid_t uid);
int setgid(gid_t gid);

// Both return: 0 if OK, −1 on error
```

3. There are rules for who can change the IDs. (Everything we describe for the user ID also applies to the group ID.)
    - If the process has superuser privileges, the setuid function sets the real user ID, effective user ID, and saved set-user-ID to uid.
    - If the process does not have superuser privileges, but uid equals either the real user ID or the saved set-user-ID, setuid sets only the effective user ID to uid. The real user ID and the saved set-user-ID are not changed.
    - If neither of these two conditions is true, errno is set to EPERM and -1 is returned.

4. We can make a few statements about the three user IDs that the kernel maintains.
    - Only a superuser process can change the real user ID. Normally, the real user ID is set by the login(1) program when we log in and never changes. Because login is a superuser process, it sets all three user IDs when it calls setuid.
    - The effective user ID is set by the exec functions only if the set-user-ID bit is set for the program file. If the set-user-ID bit is not set, the exec functions leave the effective user ID as its current value. We can call setuid at any time to set the effective user ID to either the real user ID or the saved set-user-ID. Naturally, we can’t set the effective user ID to any random value.
    - The saved set-user-ID is copied from the effective user ID by exec. If the file’s set-user-ID bit is set, this copy is saved after exec stores the effective user ID from the file’s user ID.

5. Historically, BSD supported the swapping of the real user ID and the effective user ID with the setreuid function.
```
#include <unistd.h>

int setreuid(uid_t ruid, uid_t euid);
int setregid(gid_t rgid, gid_t egid);

// Both return: 0 if OK, −1 on error
```

6. POSIX.1 includes the two functions seteuid and setegid. These functions are similar to setuid and setgid, but only the effective user ID or effective group ID is changed.
```
#include <unistd.h>

int seteuid(uid_t uid);
int setegid(gid_t gid);

// Both return: 0 if OK, −1 on error
```

### 8.12 Interpreter Files

1. All contemporary UNIX systems support interpreter files. These files are text files that begin with a line of the form
```
#! pathname [ optional-argument ]
```

2. The space between the exclamation point and the pathname is optional.

3. The pathname is normally an absolute pathname, since no special operations are performed on it (i.e., PATH is not used).

4. The recognition of these files is done within the kernel as part of processing the exec system call. The actual file that gets executed by the kernel is not the interpreter file, but rather the file specified by the pathname on the first line of the interpreter file. (Note: Be sure to differentiate between the interpreter file—a text file that begins with #!—and the interpreter, which is specified by the pathname on the first line of the interpreter file.)

5. A common use for the optional argument following the interpreter pathname is to specify the `-f` option for programs that support this option.

6. Interpreter files are useful for the following reasons:
    - They hide that certain programs are scripts in some other language.
    - Interpreter scripts provide an efficiency gain.
    - Interpreter scripts let us write shell scripts using shells other than /bin/sh.

### 8.13 system Function

1. It is convenient to execute a command string from within a program.

2. ISO C defines the system function, but its operation is strongly system dependent.  POSIX.1 includes the system interface, expanding on the ISO C definition to describe its behavior in a POSIX environment.
```
#include <stdlib.h>
int system(const char *cmdstring);
```

3. Because system is implemented by calling fork, exec, and waitpid, there are three types of return values.
    - If either the fork fails or waitpid returns an error other than EINTR, system returns -1 with errno set to indicate the error.
    - If the exec fails, implying that the shell can’t be executed, the return value is as if the shell had executed exit(127).
    - Otherwise, all three functions—fork, exec, and waitpid—succeed, and the return value from system is the termination status of the shell, in the format specified for waitpid.

### 8.14 Process Accounting

1. Most UNIX systems provide an option to do process accounting. When enabled, the kernel writes an accounting record each time a process terminates. These accounting records typically contain a small amount of binary data with the name of the command, the amount of CPU time used, the user ID and group ID, the starting time, and so on.

### 8.16 Process Scheduling

1. Historically, the UNIX System provided processes with only coarse control over their scheduling priority. The scheduling policy and priority were determined by the kernel. A process could choose to run with lower priority by adjusting its nice value (thus a process could be "nice" and reduce its share of the CPU by adjusting its nice value). Only a privileged process was allowed to increase its scheduling priority. (Question: it seems that we can increase out process's priority by decreasing its nice value?)

2. In the Single UNIX Specification, nice values range from 0 to (2\*NZERO)−1, although some implementations support a range from 0 to 2\*NZERO. Lower nice values have higher scheduling priority. Although this might seem backward, it actually makes sense: the more nice you are, the lower your scheduling priority is. NZERO is the default nice value of the system.

3. A process can retrieve and change its nice value with the nice function. With this function, a process can affect only its own nice value; it can’t affect the nice value of any other process.
```
#include <unistd.h>

int nice(int incr);

// Returns: new nice value − NZERO if OK, −1 on error
```

4. The incr argument is added to the nice value of the calling process.
    - If incr is too large, the system silently reduces it to the maximum legal value.
    - If incr is too small, the system silently increases it to the minimum legal value.
    - Because -1 is a legal successful return value, we need to clear errno before calling nice and check its value if nice returns -1. If the call to nice succeeds and the return value is -1, then errno will still be zero. If errno is nonzero, it means that the call to nice failed.

5. The getpriority function can be used to get the nice value for a process, just like the nice function. However, getpriority can also get the nice value for a group of related processes.
```
#include <sys/resource.h>

int getpriority(int which, id_t who);

// Returns: nice value between −NZERO and NZERO−1 if OK, −1 on error
```

6. The which argument can take on one of three values: PRIO_PROCESS to indicate a process, PRIO_PGRP to indicate a process group, and PRIO_USER to indicate a user ID.  The which argument controls how the who argument is interpreted and the who argument selects the process or processes of interest. If the who argument is 0, then it indicates the calling process, process group, or user (depending on the value of the which argument). When which is set to PRIO_USER and who is 0, the real user ID of the calling process is used. When the which argument applies to more than one process, the highest priority (lowest value) of all the applicable processes is returned.

7. The setpriority function can be used to set the priority of a process, a process group, or all the processes belonging to a particular user ID.
```
#include <sys/resource.h>

int setpriority(int which, id_t who, int value);

// Returns: 0 if OK, −1 on error
```

8. The which and who arguments are the same as in the getpriority function. The value is added to NZERO and this becomes the new nice value.

### 8.17 Process Times

1. Any process can call the times function to obtain time values for itself and any terminated children.
```
#include <sys/times.h>

clock_t times(struct tms *buf );

// Returns: elapsed wall clock time in clock ticks if OK, −1 on error
```

2. This function fills in the tms structure pointed to by buf :
```
struct tms {
    clock_t tms_utime; /* user CPU time */
    clock_t tms_stime; /* system CPU time */
    clock_t tms_cutime; /* user CPU time, terminated children */
    clock_t tms_cstime; /* system CPU time, terminated children */
};
```

3. Note that the structure does not contain any measurement for the wall clock time.  Instead, the function returns the wall clock time as the value of the function, each time it’s called. This value is measured from some arbitrary point in the past, so we can’t use its absolute value; instead, we use its relative value. For example, we call times and save the return value. At some later time, we call times again and subtract the earlier return value from the new return value. The difference is the wall clock time.

4. All the clock_t values returned by this function are converted to seconds using the number of clock ticks per second—the _SC_CLK_TCK value returned by sysconf.
