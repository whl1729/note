# The Python Tutorial

## 10. Brief Tour of the Standard Library

### 10.1 Operating System Interface

1. Be sure to use the `import os` style instead of `from os import *`. This will keep `os.open()` from shadowing the built-in `open()` function which operates much differently.

2. For daily file and directory management tasks, the `shutil` module provides a higher level interface that is easier to use.

3. Some common functions
```
>>> import os
>>> os.getcwd()      # Return the current working directory
'C:\\Python38'
>>> os.chdir('/server/accesslogs')   # Change current working directory
>>> os.system('mkdir today')   # Run the command mkdir in the system shell
0
>>> dir(os)
<returns a list of all module functions>
>>> help(os)
<returns an extensive manual page created from the module's docstrings>
```

### 10.2 File Wildcards

1. The glob module provides a function for making file lists from directory wildcard searches:
```
>>> import glob
>>> glob.glob('*.py')
['primes.py', 'random.py', 'quote.py']
```

### 10.3. Command Line Arguments

1. `sys.argv` stored command line arguments as a list.

2. The `argparse` module provides a more sophisticated mechanism to process command line arguments.

### 10.4. Error Output Redirection and Program Termination

1. The sys module also has attributes for stdin, stdout, and stderr. The latter is useful for emitting warnings and error messages to make them visible even when stdout has been redirected:

2. The most direct way to terminate a script is to use `sys.exit()`.

### 10.5. String Pattern Matching

1. The re module provides regular expression tools for advanced string processing. For complex matching and manipulation, regular expressions offer succinct, optimized solutions.

2. When only simple capabilities are needed, string methods are preferred because they are easier to read and debug.
### 10.6. Mathematics

1. The math module gives access to the underlying C library functions for floating point math.

2. The random module provides tools for making random selections.

3. The statistics module calculates basic statistical properties (the mean, median, variance, etc.) of numeric data.

### 10.7. Internet Access

1. There are a number of modules for accessing the internet and processing internet protocols. Two of the simplest are urllib.request for retrieving data from URLs and smtplib for sending mail.

### 10.8. Dates and Times

1. The datetime module supplies classes for manipulating dates and times in both simple and complex ways.

### 10.9. Data Compression

1. Common data archiving and compression formats are directly supported by modules including: zlib, gzip, bz2, lzma, zipfile and tarfile.

### 10.10. Performance Measurement

1. Python provides some performance measurement tools: `timeit`, `profile` and `pstats`.

2. In contrast to timeit’s fine level of granularity, the profile and pstats modules provide tools for identifying time critical sections in larger blocks of code.

### 10.11. Quality Control

1. The doctest module provides a tool for scanning a module and validating tests embedded in a program’s docstrings. Test construction is as simple as cutting-and-pasting a typical call along with its results into the docstring. This improves the documentation by providing the user with an example and it allows the doctest module to make sure the code remains true to the documentation.

2. The unittest module is not as effortless as the doctest module, but it allows a more comprehensive set of tests to be maintained in a separate file.

### 10.12. Batteries Included

1. Python has a “batteries included” philosophy. This is best seen through the sophisticated and robust capabilities of its larger packages.

2. The Python source distribution has long maintained the philosophy of "batteries included" -- having a rich and versatile standard library which is immediately available, without making the user download separate packages. This gives the Python language a head start in many projects. ---PEP 206
