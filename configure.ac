#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([nix-utils], [1.0], [yunxinyi@gmail.com])
AM_INIT_AUTOMAKE([-Wall -Werror])

# Checks for programs.
AC_PROG_AWK
AC_PROG_INSTALL
AC_PROG_LN_S

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.
AM_CONDITIONAL([OSX], [test $(uname -s) = Darwin])

# Checks for library functions.

AC_CONFIG_FILES([Makefile tools/Makefile])
AC_OUTPUT
