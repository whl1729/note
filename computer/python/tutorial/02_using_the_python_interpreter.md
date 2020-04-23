# The Python Tutorial

## 02 Using the Python Interpreter

1. Typing an end-of-file character (Control-D on Unix, Control-Z on Windows) at the primary prompt causes the interpreter to exit with a zero exit status. If that doesn’t work, you can exit the interpreter by typing the following command: quit().

2. The interpreter operates somewhat like the Unix shell: when called with standard input connected to a tty device, it reads and executes commands interactively; when called with a file name argument or with a file as standard input, it reads and executes a script from that file.

3. The interpreter option
    - `-c cmd`: program passed in as string (terminates option list)
    - `-i`: inspect interactively after running script; forces a prompt even if stdin does not appear to be a terminal
    - `-m mod`: run library module as a script (terminates option list)

4. Argument Passing
    - When known to the interpreter, the script name and additional arguments thereafter are turned into a list of strings and assigned to the **argv** variable in the **sys** module. You can access this list by executing **import sys**. 
    - The length of the list is at least one; when no script and no arguments are given, sys.argv[0] is an empty string.
    - When the script name is given as '-' (meaning standard input), sys.argv[0] is set to '-'.
    - When -c command is used, sys.argv[0] is set to '-c'.
    - When -m module is used, sys.argv[0] is set to the full name of the located module.
    - Options found after -c command or -m module are not consumed by the Python interpreter’s option processing but left in sys.argv for the command or module to handle.

5. When commands are read from a tty, the interpreter is said to be in interactive mode. In this mode it prompts for the next command with the primary prompt, usually three greater-than signs (>>>); for continuation lines it prompts with the secondary prompt, by default three dots (...). Continuation lines are needed when entering a multi-line construct.

6. To declare an encoding other than the default one, a special comment line should be added as the first line of the file. The syntax is as follows: `# -*- coding: encoding -*-`. where encoding is one of the valid codecs supported by Python.
