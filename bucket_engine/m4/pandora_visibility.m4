dnl Copyright (C) 2005, 2008 Free Software Foundation, Inc.
dnl Copyright (C) 2009 Monty Taylor
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl From Bruno Haible.

dnl Tests whether the compiler supports the command-line option
dnl -fvisibility=hidden and the function and variable attributes
dnl __attribute__((__visibility__("hidden"))) and
dnl __attribute__((__visibility__("default"))).
dnl Does *not* test for __visibility__("protected") - which has tricky
dnl semantics (see the 'vismain' test in glibc) and does not exist e.g. on
dnl MacOS X.
dnl Does *not* test for __visibility__("internal") - which has processor
dnl dependent semantics.
dnl Does *not* test for #pragma GCC visibility push(hidden) - which is
dnl "really only recommended for legacy code".
dnl Set the variable CFLAG_VISIBILITY.
dnl Defines and sets the variable HAVE_VISIBILITY.

AC_DEFUN([PANDORA_CHECK_VISIBILITY],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([PANDORA_PLATFORM])
  CFLAG_VISIBILITY=
  HAVE_VISIBILITY=0
  AS_IF([test -n "$GCC"],[
    AC_MSG_CHECKING([for simple visibility declarations])
    AC_CACHE_VAL([gl_cv_cc_visibility], [
      gl_save_CFLAGS="$CFLAGS"
      CFLAGS="$CFLAGS -fvisibility=hidden"
      AC_TRY_COMPILE(
        [extern __attribute__((__visibility__("hidden"))) int hiddenvar;
         extern __attribute__((__visibility__("default"))) int exportedvar;
         extern __attribute__((__visibility__("hidden"))) int hiddenfunc (void);
         extern __attribute__((__visibility__("default"))) int exportedfunc (void);],
        [],
        [gl_cv_cc_visibility=yes],
        [gl_cv_cc_visibility=no])
      CFLAGS="$gl_save_CFLAGS"])
    AC_MSG_RESULT([$gl_cv_cc_visibility])
    if test $gl_cv_cc_visibility = yes; then
      CFLAG_VISIBILITY="-fvisibility=hidden"
      NO_VISIBILITY="-fvisibility=default"
      HAVE_VISIBILITY=1
    fi
  ])
  AS_IF([test "x$SUNCC" = "xyes"],[
    CFLAG_VISIBILITY="-xldscope=hidden"
    NO_VISIBILITY="-xldscope=global"
    HAVE_VISIBILITY=1
  ])
  AC_SUBST([CFLAG_VISIBILITY])
  AC_SUBST([NO_VISIBILITY])
  AC_SUBST([HAVE_VISIBILITY])
  AC_DEFINE_UNQUOTED([HAVE_VISIBILITY], [$HAVE_VISIBILITY],
    [Define to 1 or 0, depending whether the compiler supports simple visibility declarations.])
])

AC_DEFUN([PANDORA_ENABLE_VISIBILITY],[
  AC_REQUIRE([PANDORA_CHECK_VISIBILITY])
  AM_CFLAGS="${AM_CFLAGS} ${CFLAG_VISIBILITY}"
  AM_CXXFLAGS="${AM_CXXFLAGS} ${CFLAG_VISIBILITY}"
])
