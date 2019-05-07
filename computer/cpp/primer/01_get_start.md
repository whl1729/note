# 《C++ Primer》第1章阅读笔记

## 1 Getting Start

1. 查看main函数返回结果
    - Windows：`echo %ERRORLEVEL%`
    - Unix: `echo $?`
    - Ubuntu：我在Ubuntu 18测试了一下，发现系统错误码返回值范围是0~255，猜测内部是用unsigned char来存储的，超出这个范围的数值会强制转换为此范围内。
    - [Appendix E. Exit Codes With Special Meanings](http://www.tldp.org/LDP/abs/html/exitcodes.html)

2. [c/c++中#include \<\>与#include""区别](https://kooyee.iteye.com/blog/340846)
    - Headers from the standard library are enclosed in angle brackets (< >). Those that are not part of the library are enclosed in double quotes (" ").
    - <>先去系统目录中找头文件，如果没有再到当前目录下找。所以像标准的头文件 stdio.h、stdlib.h等用这个方法。
    - ""首先在当前目录下寻找，如果找不到，再到系统目录中寻找。 这个用于include自定义的头文件，让系统优先使用当前目录中定义的。

3. C++标准库定义了4种IO对象
    - cin: standard input
    - cout: standard output
    - cerr: standard error, for warning and error messages
    - clog: for general information about the eecution of the program
    - Generally you use std::cout for normal output, std::cerr for errors, and std::clog for "logging" (which can mean whatever you want it to mean).***The major difference is that std::cerr is not buffered like the other two.***
    - In relation to the old C stdout and stderr, std::cout corresponds to stdout, while std::cerr and std::clog both corresponds to stderr (except that std::clog is buffered).
    - stdout should be used for actual program output, while all information and error messages should be printed to stderr, **so that if the user redirects output to a file, information messages are still printed on the screen and not to the output file.**
    ```
    cout << "Hello world!" << endl;
    cerr << "Nice to meet you!" << endl;
    clog << "Bye~Bye~" << endl;
    // If we run "./a.out > file", then the first sentence outputs to the file and the last two sentences outputs to the screen.
    // If we run "./a.out > file 2>&1", then all of three sentences outputs to the file.
    ```

4. chain multiple output request: 
    - The result of the output operator is its left-hand operand. That is, the result is the ostream on which we wrote the given value.Our output statement uses the << operator twice. 
    - Because the operator returns its left-hand operand, the result of the first operator becomes the left-hand operand of the second. As a result, we can chain together output requests. 
    - Like the output operator, the input operator returns its left-hand operand as its result. 
```
std::cout << "Enter two numbers:" << std::endl;
// is equal to
(std::cout << "Enter two numbers:") << std::endl;
// or
std::cout << "Enter two numbers:";
std::cout << std::endl;
```

5. use endl to flush the buffer:
    - endl is a special value called a manipulator. Writing endl has the effect of ending the current line and flushing the buffer associated with that device. Flushing the buffer ensures that all the output the program has generated so far is actually written to the output stream, rather than sitting in memory waiting to be written.
    - Programmers often add print statements during debugging. Such statements should always flush the stream. Otherwise, if the program crashes, output may be left in the buffer, leading to incorrect inferences about where the program crashed.

6. Comment:
    - Comment Pairs Do Not Nest
    - We often need to comment out a block of code during debugging. Because that code might contain nested comment pairs, the best way to comment a block of code is to insert single-line comments at the beginning of each line in the section we want to ignore.
```
/*
 * comment pairs /* */ cannot nest.
 * "cannot nest" is considered source code,
 * as is the rest of the program
 */
int main()
{
    return 0;
}
```

7. read an unknown number of inputs:
    - When we use an istream as a condition, the effect is to test the state of the stream. ***If the stream is valid—that is, if the stream hasn’t encountered an error—then the test succeeds. An istream becomes invalid when we hit end-of-file or encounter an invalid input, such as reading a value that is not an integer. An istream that is in an invalid state will cause the condition to yield false.***
    - When we enter input to a program from the keyboard, different operating systems use different conventions to allow us to indicate end-of-file. On Windows systems we enter an end-of-file by typing a control-z—hold down the Ctrl key and press z—followed by hitting either the Enter or Return key. On UNIX systems, including on Mac OS X machines, end-of-file is usually control-d.

> 疑问： C/C++使用scanf或cin时，有时不等待用户输入，具体原因是什么？怎么解决？

8. The main difference between the for's and the while's is a matter of pragmatics: ***we usually use for when there is a known number of iterations, and use while constructs when the number of iterations in not known in advance.*** The while vs do ... while issue is also of pragmatics, the second executes the instructions once at start, and afterwards it behaves just like the simple while. [Reference](https://stackoverflow.com/questions/2950931/for-vs-while-in-c-programming)

