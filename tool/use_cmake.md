# cmake 使用笔记

## 编译方法

```
mkdir build
cd build
cmake ..
cmake --build .
```

## 安装方法

```
cmake --install . --prefix "/home/myuser/installdir"
```

## 语法

### some useful variables

- CMAKE_SOURCE_DIR: The path to the top level of the source tree.
- CMAKE_CURRENT_SOURCE_DIR: The path to the source directory currently being processed.
- PROJECT_BINARY_DIR: Full path to build directory for project. This is the binary directory of the most recent project() command.
- PROJECT_SOURCE_DIR: This is the source directory of the last call to the project() command made in the current directory scope or one of its parents.

### set cmake version requirement
```
cmake_minimum_required(VERSION 3.10)
```

### set the project name and version
```
project(Tutorial VERSION 1.0)
```

### add executable target
```
add_executable(Tutorial tutorial.cxx)
```

注意：
- 声明C++标准的语句要放在本语句前，声明库路径的语句要放在本语句后。否则会有编译错误。

### set include path
```
target_include_directories(Tutorial PUBLIC "${PROJECT_BINARY_DIR}")
```

Notice:
- target_include_directories命令必须放在add_executable后面，否则会有编译错误。

### specify the C++ standard
```
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)
```

Notice:
- If `CMAKE_CXX_STANDARD_REQUIRED` is set to ON, then the value of the CXX_STANDARD target property is treated as a requirement. If this property is OFF or unset, the CXX_STANDARD target property is treated as optional and may "decay" to a previous standard if the requested is not available.

### add a normal library

suppose we want to create a library named math_functions, which is located in the math_functions subdirectory. Add It has two files: math_functions.h and mysqrt.cpp.

```cmake
# in the library directory, create a CMakeLists.txt and put the following lines in it:
add_library(math_functions mysqrt.cpp)
target_include_directories(math_functions INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})

# in the top-level CMakeLists.txt, add the following lines:
option(USE_MYMATH "Use tutorial provided math implementation" ON)

configure_file(demo_config.h.in demo_config.h)

if (USE_MYMATH)
  add_subdirectory(math_functions)
  list(APPEND EXTRA_LIBS math_functions)
endif

add_executable(demo main.cpp)

target_link_libraries(demo PUBLIC ${EXTRA_LIBS})

target_include_directries(demo PUBLIC ${PROJECT_BINARY_DIR} ${EXTRA_INCLUDES})
```

### add an imported libraries

```cmake
# type should be one of STATIC/SHARED/MODULE/UNKNOWN/OBJECT/INTERFACE
add_library(<name> <type> IMPORTED [GLOBAL])
```

### install rules

```cmake
install(TARGETS Tutorial DESTINATION bin)
install(FILES "${PROJECT_BINARY_DIR}/TutorialConfig.h" DESTINATION include)
```

## FAQs

### Q2. 使用target_include_directories配置头文件目录时应该使用`PUBLIC/PRIVATE/INTERFACE`中的哪一个？

使用PRIVATE的话，配置的头文件目录不会添加到其他依赖本库的库的INCLUDE_DIRECTORY中；使用PUBLIC/INTERFACE则会。
参考[CMake: Public VS Private VS Interface][cmake_include]

### Q1. cmake相比make有何优势？

一言以蔽之，开发跨平台的项目时更适合使用cmake。参考[Difference between using Makefile and CMake to compile the code][cmake_make]:

> CMake is a generator of buildsystems. It can produce Makefiles, it can produce Ninja build files, it can produce KDEvelop or Xcode projects, it can produce Visual Studio solutions. From the same starting point, the same CMakeLists.txt file. So if you have a platform-independent project, CMake is a way to make it buildsystem-independent as well.

  [cmake_make]: https:#stackoverflow.com/questions/25789644/difference-between-using-makefile-and-cmake-to-compile-the-code
  [cmake_include]: https:#leimao.github.io/blog/CMake-Public-Private-Interface/

## Reference

1. [cmake tutorial](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)
2. [cmake help documentation](https://cmake.org/cmake/help/latest/index.html)
