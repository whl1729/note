# The Python Tutorial

## 12. Virtual Environments and Packages

### 12.1. Introduction

1. The solution for version conflict problem is to create a virtual environment, a self-contained directory tree that contains a Python installation for a particular version of Python, plus a number of additional packages.

### 12.2. Creating Virtual Environments

1. The module used to create and manage virtual environments is called venv. venv will usually install the most recent version of Python that you have available. If you have multiple versions of Python on your system, you can select a specific Python version by running python3 or whichever version you want.

2. To create a virtual environment, decide upon a directory where you want to place it, and run the venv module as a script with the directory path:
```
python3 -m venv tutorial-env
```

3. A common directory location for a virtual environment is .venv. This name keeps the directory typically hidden in your shell and thus out of the way while giving it a name that explains why the directory exists. It also prevents clashing with .env environment variable definition files that some tooling supports.

4. Once you’ve created a virtual environment, you may activate it.
```
source tutorial-env/bin/activate
```

### 12.3. Managing Packages with pip

1. You can install, upgrade, and remove packages using a program called pip.

2. You can also install a specific version of a package by giving the package name followed by == and the version number.

3. If you re-run this command, pip will notice that the requested version is already installed and do nothing. You can supply a different version number to get that version, or you can run `pip install --upgrade` to upgrade the package to the latest version.

4. pip uninstall followed by one or more package names will remove the packages from the virtual environment.

5. pip show will display information about a particular package.

6. pip list will display all of the packages installed in the virtual environment.

7. pip freeze will produce a similar list of the installed packages, but the output uses the format that pip install expects. A common convention is to put this list in a requirements.txt file.

8. The requirements.txt can then be committed to version control and shipped as part of an application. Users can then install all the necessary packages with `install -r`.
