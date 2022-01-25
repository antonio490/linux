
# Compilation Process

Compilation is the translation of source code into object code by a compiler.

- Preprocessing
- Compiling
- Assembling
- Linking

## Preprocessing

- It gets rid of all comments
- It includes the code of the header(s) which contains C function declarations and macro definitions.
- It replaces all of the macros by their values.

The output will be stored in a file with .i extension.

    gcc -E main.c

## Compiler

The compiler will take the preprocessed file and generate a .s file.

    gcc -S main.c

## Assembler

The assembler takes the Intermediate code and transforms it into object code, that is code in machine language. It will produce a .o file.

    gcc -c main

## Linker

The linker creates the final executable, in binary and it plays two roles:

- Linking all the source files together, that is all the other object codes in the project.

- Linking functions calls with ther definitions. The linker knows where to look for the function definitions in the static libraries or dynamic libraries. Static libraries are the result of the linker making copies of all used libraries functions to the executable file. Note that by default gcc uses dinamic libraries.

    gcc main.c -o app

## Makefile

Makefiles are widely used to build a lot of languages and projects, with C/C++ projects being the majority. In most linux systems make is a symlink to gmake. The version can be check by running:

    $ make -version

### Variables

- Lazy set: Normal setting of a variable. Values are recursively expanded when the variable is used, not when it's declared.

    VAR = value

- Inmediate Set: Setting of a variable with simple expansion of the values inside. Values are expanded at declaration time.

    VAR := value

- Set if absent: Setting of a variable only if it does not have a value.

    VAR ?= value

### Compiler

    CC ?= gcc
    LD ?= gcc

While it is usually safe to assume that sensible values have been set for CC and DD, it does not harm to set them if and only they are not set in the environment, suing the operator ?=.

- A cross-compile environment has set CC to a link of the actual target architecture compiler, like for example arm-pc-linux-cc, but gcc of the host will be used.

If the user has acknowledged these problems, he can append CC=clang to the make call:

    $ make CC=clang

### Compiler flags 

make utility also use variables that are defined by implicit rules5 and between these variables, some define extra build flags:

- CFLAGS: flags for the C compiler
- CXXFLAGS: flags for the C++ compiler
- CPPFLAGS6: for preprocessor flags for C/C++ and Fortran compilers

Note: there is a variable named CCFLAGS that some projects are using; it defines extra flags for both the C/C++ compilers. This variable is not defined by the implicit rules, please avoid it if you can.

Usually, we add to the compiler options specific for the application we are writing, such as language revision (do we want to use c89 or c99?). Then the user add his own CFLAGS/CXXFLAGS to include debug option and add optimizations; it is important to add these user defined flags.

    CFLAGS = -ansi -std=99

But this would discard the environment CFLAGS, which might contain user defined value. You should instead do:

    CFLAGS := ${CFLAGS} -ansi -std=99

Or, if you have a long CFLAGS:

    CFLAGS += -ansi -std=99

We can optimize a little by converting CFLAGS from a recursive variable to a simple one.

    CFLAGS := ${CFLAGS}
    CFLAGS += -ansi -std=99

### Libraries

In order to include the libraries in the program, gcc flags are needed for both compile and link time.

You can add default values when including libraries, like for example default headers location /usr/include/; use this value inside a variable that can be overriden from the environment (?= set) if you follow this approach.

Suppose we want to include and link our program against OpenSSL, a broadly used library for cryptography and TLS/SSL protocols; we would intuitively add -I/usr/include/openssl to our CFLAGS/CXXFLAGS. It might be good for the most of the linux system, but a MacOS user could have OpenSSL headers in /usr/local/include/openssl, breaking compilation, same thing goes for cross compilation.

What it should be done instead is:

    OPENSSL_INCLUDE ?= -I/usr/include/openssl
    OPENSSL_LIBS ?= -lssl -lcrypto

    CFLAGS ?= -O2 -pipe
    CFLAGS += $(OPENSSL_INCLUDE)
    LIBS := $(OPENSSL_LIBS)

While this approach result in successful compilation, by overriding values when needed, it is really cumbersome and error-prone. A better way to include external libraries is to use pkg-config.

## pkg-config

The main use of pkg-config is to provide the necessary details for compiling and linking a program to a library. This metadata is stored in pkg-config files. These files have to suffix .pc and reside in specific locations known to the pkg-config tool.

    prefix=/usr/local
    exec_prefix=${prefix}
    includedir=${prefix}/include
    libdir=${exec_prefix}/lib

    Name: foo
    Description: The foo library
    Version: 1.0.0
    Cflags: -I${includedir}/foo
    Libs: -L${libdir} -lfoo

### Bibliography

[Compiling C files with gcc](https://medium.com/@laura.derohan/compiling-c-files-with-gcc-step-by-step-8e78318052)

[Static vs Dynamic](https://2142.medium.com/static-and-dynamic-static-or-dynamic-c810dc2443fa)

[pkg-config](https://people.freedesktop.org/~dbn/pkg-config-guide.html)

[Makefile best practices](https://danyspin97.org/blog/makefiles-best-practices/)