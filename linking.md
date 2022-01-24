
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