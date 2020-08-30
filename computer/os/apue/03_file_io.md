# Advanced Programming in the Unix Environment

## 3 File I/O

### 3.1 Introduction

1. Most file I/O on a UNIX system can be performed using only five functions: `open, read, write, lseek, and close`.

2. The term **unbuffered** means that each read or write invokes a system call in the kernel. These unbuffered I/O functions are not part of ISO C, but are part of POSIX.1 and the Single UNIX Specification.

### 3.2 File Descriptors

1. To the kernel, all open files are referred to by **file descriptors**. A file descriptor is a **non-negative integer**. When we open an existing file or create a new file, the kernel returns a file descriptor to the process. When we want to read or write a file, we identify the file with the file descriptor that was returned by open or creat as an argument to either read or write.

2. By convention, UNIX System **shells** associate file descriptor 0 with the standard input of a process, file descriptor 1 with the standard output, and file descriptor 2 with the standard error. This convention is used by the shells and many applications; it is not a feature of the UNIX kernel. Nevertheless, many applications would break if these associations weren’t followed.

3. Although their values are standardized by POSIX.1, the magic numbers 0, 1, and 2 should be replaced in POSIX-compliant applications with the symbolic constants `STDIN_FILENO, STDOUT_FILENO, and STDERR_FILENO` to improve readability.  These constants are defined in the `<unistd.h>` header.

4. File descriptors range from 0 through `OPEN_MAX−1`. Note: call the function `sysconf` to get the value of `OPEN_MAX`.
```
#include <unistd.h>

int max_open_num = sysconf(_SC_OPEN_MAX);
```

### 3.3 open and openat Functions

1. A file is opened or created by calling either the `open` function or the `openat` function.
```
#include <fcntl.h>

int open(const char *path, int oflag, ... /* mode_t mode */ );
int openat(int fd, const char *path, int oflag, ... /* mode_t mode */ );

// Both return: file descriptor if OK, −1 on error
```

2. The file descriptor returned by open and openat is guaranteed to be the lowest-numbered unused descriptor. This fact is used by some applications to open a new file on standard input, standard output, or standard error.

3. The openat function is one of a class of functions added to the latest version of POSIX.1 to address two problems.
    - First, it gives threads a way to use relative pathnames to open files in directories other than the current working directory. As we’ll see in Chapter 11, all threads in the same process share the same current working directory, so this makes it difficult for multiple threads in the same process to work in different directories at the same time.
    - Second, it provides a way to avoid **time-of-checkto-time-of-use (TOCTTOU)** errors.

4. The basic idea behind TOCTTOU errors is that a program is vulnerable if it makes two file-based function calls where the second call depends on the results of the first call. Because the two calls are not atomic, the file can change between the two calls, thereby invalidating the results of the first call, leading to a program error.

5. TOCTTOU errors in the file system namespace generally deal with attempts to subvert file system permissions by tricking a privileged program into either reducing permissions on a privileged file or modifying a privileged file to open up a security hole.

6. With POSIX.1, the constant `_POSIX_NO_TRUNC` determines whether long filenames and long components of pathnames are truncated or an error is returned.

7. If `_POSIX_NO_TRUNC` is in effect, errno is set to `ENAMETOOLONG`, and an error status is returned if any filename component of the pathname exceeds `NAME_MAX`.

### 3.4 creat Function

1. A new file can also be created by calling the `creat` function.
```
#include <fcntl.h>

int creat(const char *path, mode_t mode);

// Returns: file descriptor opened for write-only if OK, −1 on error
```

2. Note that this function is equivalent to `open(path, O_WRONLY | O_CREAT | O_TRUNC, mode)`.

### 3.5 close Function

1. An open file is closed by calling the `close` function.
```
#include <unistd.h>

int close(int fd);

// Returns: 0 if OK, −1 on error
```

2. When a process terminates, all of its open files are closed automatically by the kernel. Many programs take advantage of this fact and don’t explicitly close open files.

### 3.6 lseek Function

1. Every open file has an associated "**current file offset**", normally a non-negative integer that measures the number of bytes from the beginning of the file.

2. Read and write operations normally start at the current file offset and cause the offset to be incremented by the number of bytes read or written. By default, this offset is initialized to 0 when a file is opened, unless the `O_APPEND` option is specified.

3. An open file’s offset can be set explicitly by calling lseek. (Note: The character l in the name lseek means "long integer.")
```
#include <unistd.h>

off_t lseek(int fd, off_t offset, int whence);

// Returns: new file offset if OK, −1 on error
```

4. The interpretation of the offset depends on the value of the whence argument.
    - If whence is `SEEK_SET`, the file’s offset is set to offset bytes from the beginning of the file.
    - If whence is `SEEK_CUR`, the file’s offset is set to its current value plus the offset. The offset can be positive or negative.
    - If whence is `SEEK_END`, the file’s offset is set to the size of the file plus the offset. The offset can be positive or negative.

5. Because a successful call to lseek returns the new file offset, we can seek zero bytes from the current position to determine the current offset:
```
off_t currpos = lseek(fd, 0, SEEK_CUR);
```

6. This technique can also be used to determine if a file is capable of seeking. If the file descriptor refers to a pipe, FIFO, or socket, lseek sets errno to **ESPIPE** and returns −1.
