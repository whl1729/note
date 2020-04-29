# The Python Tutorial

## 7 Input and Output

### 7.1 Fancier Output Formatting

1. To use formatted string literals, begin a string with f or F before the opening quotation mark or triple quotation mark. Inside this string, you can write a Python expression between { and } characters that can refer to variables or literal values. (Notice: Formatted string literal is supported in **v3.6 and later version**.)

2. The `str.format()` method of strings requires more manual effort. You’ll still use { and } to mark where a variable will be substituted and can provide detailed formatting directives, but you’ll also need to provide the information to be formatted.

3. When you don’t need fancy output but just want a quick display of some variables for debugging purposes, you can convert any value to a string with the `repr()` or `str()` functions.
    - The `str()` function is meant to return representations of values which are fairly human-readable, while repr() is meant to generate representations which can be read by the interpreter (or will force a SyntaxError if there is no equivalent syntax).
    - For objects which don’t have a particular representation for human consumption, str() will return the same value as repr().
    - Many values, such as numbers or structures like lists and dictionaries, have the same representation using either function.
    - Strings, in particular, have two distinct representations.

4. The `repr()` of a string adds string quotes and backslashes.
```
>>> hello = 'Hello, world\n'
>>> str(hello)
'Hello, world\n'
>>> repr(hello)
"'Hello, world\\n'"
```

#### 7.1.1 Formatted String Literals

1. Formatted string literals (also called **f-strings** for short) let you include the value of Python expressions inside a string by prefixing the string with f or F and writing expressions as {expression}.

2. An optional format specifier can follow the expression. This allows greater control over how the value is formatted.

3. Passing an integer after the `':'` will cause that field to be a minimum number of characters wide.

4. Other modifiers can be used to convert the value before it is formatted. `'!a'` applies ascii(), `'!s'` applies str(), and `'!r'` applies repr().

#### 7.1.2 The String format() Method

1. The brackets and characters within them (called format fields) are replaced with the objects passed into the str.format() method. **A number in the brackets can be used to refer to the position of the object passed into the str.format() method.**

2. If keyword arguments are used in the str.format() method, their values are referred to by using the name of the argument.

3. Positional and keyword arguments can be arbitrarily combined.

4. `vars()` which returns a dictionary containing all local variables.

#### 7.1.3 Manual String Formatting

1. The `str.rjust()` method of string objects right-justifies a string in a field of a given width by padding it with spaces on the left. There are similar methods `str.ljust()` and `str.center()`. These methods do not write anything, they just return a new string. If the input string is too long, they don’t truncate it, but return it unchanged; this will mess up your column lay-out but that’s usually better than the alternative, which would be lying about a value. (If you really want truncation you can always add a slice operation, as in `x.ljust(n)[:n]`.)

2. There is another method, `str.zfill()`, which pads a numeric string on the left with zeros. It understands about plus and minus signs.

#### 7.1.4. Old string formatting

1. The % operator can also be used for string formatting. It interprets the left argument much like a sprintf()-style format string to be applied to the right argument, and returns the string resulting from this formatting operation.

### 7.2 Reading and Writing Files

1. `open()` returns a file object, and is most commonly used with two arguments: `open(filename, mode)`. The first argument is a string containing the filename. The second argument is another string containing a few characters describing the way in which the file will be used. mode can be 'r' when the file will only be read, 'w' for only writing (an existing file with the same name will be erased), and 'a' opens the file for appending; any data written to the file is automatically added to the end. 'r+' opens the file for both reading and writing. The mode argument is optional; 'r' will be assumed if it’s omitted.

2. Normally, files are opened in **text mode**, that means, you read and write strings from and to the file, which are encoded in a specific encoding. If encoding is not specified, the default is platform dependent. 'b' appended to the mode opens the file in **binary mode**: now the data is read and written in the form of bytes objects. This mode should be used for all files that don’t contain text.

3. In text mode, the default when reading is to convert platform-specific line endings (\n on Unix, \r\n on Windows) to just \n. When writing in text mode, the default is to convert occurrences of \n back to platform-specific line endings. This behind-the-scenes modification to file data is fine for text files, **but will corrupt binary data like that in JPEG or EXE files. Be very careful to use binary mode when reading and writing such files.**

It is good practice to use the with keyword when dealing with file objects. The advantage is that the file is properly closed after its suite finishes, even if an exception is raised at some point. Using with is also much shorter than writing equivalent try-finally blocks:

4. `f.read(size)`
    - To read a file’s contents, call f.read(size), which reads some quantity of data and returns it as a string (in text mode) or bytes object (in binary mode).
    - size is an optional numeric argument. When size is omitted or negative, the entire contents of the file will be read and returned; it’s your problem if the file is twice as large as your machine’s memory. Otherwise, at most size characters (in text mode) or size bytes (in binary mode) are read and returned.
    - If the end of the file has been reached, f.read() will return an empty string ('').

5. `f.readline()` reads a single line from the file; a newline character (\n) is left at the end of the string, and is only omitted on the last line of the file if the file doesn’t end in a newline. This makes the return value unambiguous; if f.readline() returns an empty string, the end of the file has been reached, while a blank line is represented by '\n', a string containing only a single newline.

6. For reading lines from a file, you can loop over the file object: `for line in f`. This is memory efficient, fast, and leads to simple code.

7. If you want to read all the lines of a file in a list you can also use `list(f)` or `f.readlines()`.

8. `f.write(string)` writes the contents of string to the file, returning the number of characters written.

9. `f.tell()` returns an integer giving the file object’s current position in the file represented as number of bytes from the beginning of the file when in binary mode and an opaque number when in text mode.

10. To change the file object’s position, use f.seek(offset, whence). The position is computed from adding offset to a reference point; the reference point is selected by the whence argument. **A whence value of 0 measures from the beginning of the file, 1 uses the current file position, and 2 uses the end of the file as the reference point.** whence can be omitted and defaults to 0, using the beginning of the file as the reference point.

11. In text files (those opened without a b in the mode string), only seeks relative to the beginning of the file are allowed (the exception being seeking to the very file end with seek(0, 2)) and the only valid offset values are those returned from the f.tell(), or zero. Any other offset value produces undefined behaviour.

12. The standard module called json can take Python data hierarchies, and convert them to string representations; this process is called **serializing**. Reconstructing the data from the string representation is called **deserializing**. Between serializing and deserializing, the string representing the object may have been stored in a file or data, or sent over a network connection to some distant machine.

13. If you have an object x, you can view its JSON string representation with `json.dumps`.

14. `dump()` simply serializes the object to a text file.

15. To decode the object again, if f is a text file object which has been opened for reading: `x = json.load(f)`
