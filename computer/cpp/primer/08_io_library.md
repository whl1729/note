# 《C++ Primer》第8章学习笔记

## 8 The IO Library

### The IO Classes

1. IO Library Types and Headers

Header | Type
------ | ----
iostream | (w)istream, (w)ostream, (w)iostream
fstream  | (w)ifstream, (w)ofstream, (w)fstream
sstream  | (w)istringstream, (w)ostringstream, (w)stringstream

2. stream type vs stream object
    - cin, an istream object that reads the standard input
    - cout, an ostream object that writes to the standard output
    - cerr, an ostream object, typically used for program error messages, that writes to the standard error

3. The library lets us ignore the differences among these different kinds of streams by using inheritance. For example, The types ifstream and istringstream inherit from istream. Thus, we can use objects of type ifstream or istringstream as if they were istream objects

4. We cannot copy or assign objects of the IO types.  Functions that do IO typically pass and return the stream through references. Reading or writing an IO object changes its state, so the reference must not be const.

5. Condition States
    - The IO classes define functions and flags that let usaccess and manipulate the condition state of a stream.
    - Once an error has occurred, subsequent IO operations on that stream will fail. We can read from or write to a stream only when it is in a non-error state. Because a stream might be in an error state, code ordinarily should check whether a stream is okay before attempting to use it. The easiest way to determine the state of a stream object is to use that object as a condition: `while (cin >> word)`

6. Interrogating the state of a stream
    - The badbit indicates a system-level failure, such as an unrecoverable read or write error. It is usually not possible to use a stream once badbit has been set. 
    - The failbit is set after a recoverable error, such as reading a character when numeric data was expected. It is often possible to correct such problems and continue using the stream. 
    - Reaching end-of-file sets both eofbit and failbit. 
    - The goodbit, which is guaranteed to have the value 0, indicates no failures on the stream. 
    - If any of badbit, failbit, or eofbit are set, then a condition that evaluates that stream will fail.
    - The right way to determine the overall state of a stream is to use either good or fail. 

7. Managing the Condition state
    - The setstate operation turns on the given condition bit(s) to indicate that a problem occurred.
    - The version of clear that takes no arguments turns off all the failure bits. After clear(), a call to good returns true. 
    - The version of clear that takes an argument expects an iostate value that represents the new state of the stream. To turn off a single condition, we use the rdstate member and the bitwise operators to produce the desired new state.

8. Each output stream manages a buffer, which it uses to hold the data that the program reads and writes. There are several conditions that cause the buffer to be flushed to the actual output device or file:
    - The program completes normally. 
    - The buffer become full.
    - We can flush the buffer explicitly using a manipulator such as endl. 
    - We can use the unitbuf manipulator to set the stream’s internal state to empty the buffer after each output operation. By default, unitbuf is set for cerr, so that writes to cerr are flushed immediately. 
    - An output stream might be tied to another stream. In this case, the buffer of the tied stream is flushed whenever the tied stream is read or written. By default, cin and cerr are both tied to cout. Hence, reading cin or writing to cerr flushes the buffer in cout. 

9. endl, flush and ends
```
cout << "hi!" << endl; // writes hi and a newline, then flushes the buffer
cout << "hi!" << flush; // writes hi, then flushes the buffer; adds no data
cout << "hi!" << ends; // writes hi and a null, then flushes the buffer
```

10. unitbuf and nounitbuf
```
cout << unitbuf; // all writes will be flushed immediately
// any output is flushed immediately, no buffering
cout << nounitbuf; // returns to normal buffering
```

11. Caution: Output buffers are not flushed if the program terminates abnormally. When a program crashes, it is likely that data the program wrote may be sitting in an output buffer waiting to be printed.

12. Note: Interactive systems usually should tie their input stream to their output stream. Doing so means that all output, which might include prompts to the user, will be written before attempting to read the input.

### File Input and Output

1. The fstream header defines three types to support file IO: ifstream to read from a given file, ofstream to write to a given file, and fstream, which reads and writes a given file.

2. Because a call to open might fail, it is usually a good idea to verify that the open succeeded.

3. By default, when we open an ofstream, the contents of the file are discarded. The only way to prevent an ostream from emptying the given file is to specify app  or in mode explicitly.

4. Note: Any time open is called, the file mode is set, either explicitly or implicitly. Whenever a mode is not specified, the default value is used.

### string Streams

1. stringstream-Specific Operations
```
sstream strm;  // strm is an unbound stringstream. sstream is one of the types defined in the sstream header
sstream strm(s);  // strm is an sstream that holds a copy of the string s.
strm.str()     // Returns a copy of the string that strm holds.
strm.str(s)    // Copies the string s into strm. Returns void.
```

2. An istringstream is often used when we have some work to do on an entire line, and other work to do with individual words within a line.

3. An ostringstream is useful when we need to build up our output a little at a time but do not want to print the output until later.
