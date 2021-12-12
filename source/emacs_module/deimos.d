/* emacs-module.h - GNU Emacs module API.

   Copyright (C) 2015-2020 Free Software Foundation, Inc.

   This file is part of GNU Emacs.

   GNU Emacs is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or (at
   your option) any later version.

   GNU Emacs is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.  */

/*
  This file defines the Emacs module API.  Please see the chapter
  `Dynamic Modules' in the GNU Emacs Lisp Reference Manual for
  information how to write modules and use this header file.
*/

module emacs_module.deimos;

import core.stdc.config;
import core.stdc.stdint;
import core.sys.posix.time;

extern(C):

/* Current environment.  */
version (Emacs25) {
  alias emacs_env = emacs_env_25;
} else version (Emacs26) {
  alias emacs_env = emacs_env_26;
} else version (Emacs27) {
  alias emacs_env = emacs_env_27;
} else {
  // Default version.
  alias emacs_env = emacs_env_27;
}

/* Opaque pointer representing an Emacs Lisp value.
   BEWARE: Do not assume NULL is a valid value!  */
alias emacs_value = emacs_value_tag*;
struct emacs_value_tag;

enum emacs_variadic_function = -2;

/* Struct passed to a module init function (emacs_module_init).  */
struct emacs_runtime {
  /* Structure size (for version checking).  */
  c_long size;

  /* Private data; users should not touch this.  */
  emacs_runtime_private* private_members;

  /* Return an environment pointer.  */
  emacs_env* function(emacs_runtime*) get_environment;
}

/* Possible Emacs function call outcomes.  */
enum emacs_funcall_exit {
  /* Function has returned normally.  */
  emacs_funcall_exit_return = 0,

  /* Function has signaled an error using `signal'.  */
  emacs_funcall_exit_signal = 1,

  /* Function has exit using `throw'.  */
  emacs_funcall_exit_throw = 2
}
enum emacs_funcall_exit_return = emacs_funcall_exit.emacs_funcall_exit_return;
enum emacs_funcall_exit_signal = emacs_funcall_exit.emacs_funcall_exit_signal;
enum emacs_funcall_exit_throw = emacs_funcall_exit.emacs_funcall_exit_throw;

/* Possible return values for emacs_env.process_input.  */
enum emacs_process_input_result {
  /* Module code may continue  */
  emacs_process_input_continue = 0,

  /* Module code should return control to Emacs as soon as possible.  */
  emacs_process_input_quit = 1
}
enum emacs_process_input_continue = emacs_process_input_result.emacs_process_input_continue;
enum emacs_process_input_quit = emacs_process_input_result.emacs_process_input_quit;

/* Define emacs_limb_t so that it is likely to match GMP's mp_limb_t.
   This micro-optimization can help modules that use mpz_export and
   mpz_import, which operate more efficiently on mp_limb_t.  It's OK
   (if perhaps a bit slower) if the two types do not match, and
   modules shouldn't rely on the two types matching.  */
alias emacs_limb_t = c_ulong;
enum EMACS_LIMB_MAX = SIZE_MAX;

struct emacs_env_25 {
  /* Structure size (for version checking).  */
  c_long size;

  /* Private data; users should not touch this.  */
  emacs_env_private* private_members;

  /* Memory management.  */

  emacs_value function(emacs_env*, emacs_value) make_global_ref;

  void function(emacs_env*, emacs_value) free_global_ref;

  /* Non-local exit handling.  */

  emacs_funcall_exit function(emacs_env*) non_local_exit_check;

  void function(emacs_env*) non_local_exit_clear;

  emacs_funcall_exit function(emacs_env*, emacs_value*, emacs_value*) non_local_exit_get;

  void function(emacs_env*, emacs_value, emacs_value) non_local_exit_signal;

  void function(emacs_env*, emacs_value, emacs_value) non_local_exit_throw;

  /* Function registration.  */

  emacs_value function(emacs_env*, c_long, c_long, emacs_value function(emacs_env*, c_long, emacs_value*, void*), const(char)*, void*) make_function;

  emacs_value function(emacs_env*, emacs_value, c_long, emacs_value*) funcall;

  emacs_value function(emacs_env*, const(char)*) intern;

  /* Type conversion.  */

  emacs_value function(emacs_env*, emacs_value) type_of;

  bool function(emacs_env*, emacs_value) is_not_nil;

  bool function(emacs_env*, emacs_value, emacs_value) eq;

  c_long function(emacs_env*, emacs_value) extract_integer;

  emacs_value function(emacs_env*, c_long) make_integer;

  double function(emacs_env*, emacs_value) extract_float;

  emacs_value function(emacs_env*, double) make_float;

  /* Copy the content of the Lisp string VALUE to BUFFER as an utf8
     NUL-terminated string.

     SIZE must point to the total size of the buffer.  If BUFFER is
     NULL or if SIZE is not big enough, write the required buffer size
     to SIZE and return true.

     Note that SIZE must include the last NUL byte (e.g. "abc" needs
     a buffer of size 4).

     Return true if the string was successfully copied.  */
  bool function(emacs_env*, emacs_value, char*, c_long*) copy_string_contents;

  /* Create a Lisp string from a utf8 encoded string.  */
  emacs_value function(emacs_env*, const(char)*, c_long) make_string;

  /* Embedded pointer type.  */
  emacs_value function(emacs_env*, void function(void*), void*) make_user_ptr;

  void* function(emacs_env*, emacs_value) get_user_ptr;

  void function(emacs_env*, emacs_value, void*) set_user_ptr;

  void function(void*) function(emacs_env*, emacs_value) get_user_finalizer;

  void function(emacs_env*, emacs_value, void function(void*)) set_user_finalizer;

  /* Vector functions.  */

  emacs_value function(emacs_env*, emacs_value, c_long) vec_get;

  void function(emacs_env*, emacs_value, c_long, emacs_value) vec_set;

  c_long function(emacs_env*, emacs_value) vec_size;
}

struct emacs_env_26 {
  /* Structure size (for version checking).  */
  c_long size;

  /* Private data; users should not touch this.  */
  emacs_env_private* private_members;

  /* Memory management.  */

  emacs_value function(emacs_env*, emacs_value) make_global_ref;

  void function(emacs_env*, emacs_value) free_global_ref;

  /* Non-local exit handling.  */

  emacs_funcall_exit function(emacs_env*) non_local_exit_check;

  void function(emacs_env*) non_local_exit_clear;

  emacs_funcall_exit function(emacs_env*, emacs_value*, emacs_value*) non_local_exit_get;

  void function(emacs_env*, emacs_value, emacs_value) non_local_exit_signal;

  void function(emacs_env*, emacs_value, emacs_value) non_local_exit_throw;

  /* Function registration.  */

  emacs_value function(emacs_env*, c_long, c_long, emacs_value function(emacs_env*, c_long, emacs_value*, void*), const(char)*, void*) make_function;

  emacs_value function(emacs_env*, emacs_value, c_long, emacs_value*) funcall;

  emacs_value function(emacs_env*, const(char)*) intern;

  /* Type conversion.  */

  emacs_value function(emacs_env*, emacs_value) type_of;

  bool function(emacs_env*, emacs_value) is_not_nil;

  bool function(emacs_env*, emacs_value, emacs_value) eq;

  c_long function(emacs_env*, emacs_value) extract_integer;

  emacs_value function(emacs_env*, c_long) make_integer;

  double function(emacs_env*, emacs_value) extract_float;

  emacs_value function(emacs_env*, double) make_float;

  /* Copy the content of the Lisp string VALUE to BUFFER as an utf8
     NUL-terminated string.

     SIZE must point to the total size of the buffer.  If BUFFER is
     NULL or if SIZE is not big enough, write the required buffer size
     to SIZE and return true.

     Note that SIZE must include the last NUL byte (e.g. "abc" needs
     a buffer of size 4).

     Return true if the string was successfully copied.  */
  bool function(emacs_env*, emacs_value, char*, c_long*) copy_string_contents;

  /* Create a Lisp string from a utf8 encoded string.  */
  emacs_value function(emacs_env*, const(char)*, c_long) make_string;

  /* Embedded pointer type.  */
  emacs_value function(emacs_env*, void function(void*), void*) make_user_ptr;

  void* function(emacs_env*, emacs_value) get_user_ptr;

  void function(emacs_env*, emacs_value, void*) set_user_ptr;

  void function(void*) function(emacs_env*, emacs_value) get_user_finalizer;

  void function(emacs_env*, emacs_value, void function(void*)) set_user_finalizer;

  /* Vector functions.  */

  emacs_value function(emacs_env*, emacs_value, c_long) vec_get;

  void function(emacs_env*, emacs_value, c_long, emacs_value) vec_set;

  c_long function(emacs_env*, emacs_value) vec_size;

  /* Returns whether a quit is pending.  */
  bool function(emacs_env*) should_quit;
}

struct emacs_env_27 {
  /* Structure size (for version checking).  */
  c_long size;

  /* Private data; users should not touch this.  */
  emacs_env_private* private_members;

  /* Memory management.  */

  emacs_value function(emacs_env*, emacs_value) make_global_ref;

  void function(emacs_env*, emacs_value) free_global_ref;

  /* Non-local exit handling.  */

  emacs_funcall_exit function(emacs_env*) non_local_exit_check;

  void function(emacs_env*) non_local_exit_clear;

  emacs_funcall_exit function(emacs_env*, emacs_value*, emacs_value*) non_local_exit_get;

  void function(emacs_env*, emacs_value, emacs_value) non_local_exit_signal;

  void function(emacs_env*, emacs_value, emacs_value) non_local_exit_throw;

  /* Function registration.  */

  emacs_value function(emacs_env*, c_long, c_long, emacs_value function(emacs_env*, c_long, emacs_value*, void*), const(char)*, void*) make_function;

  emacs_value function(emacs_env*, emacs_value, c_long, emacs_value*) funcall;

  emacs_value function(emacs_env*, const(char)*) intern;

  /* Type conversion.  */

  emacs_value function(emacs_env*, emacs_value) type_of;

  bool function(emacs_env*, emacs_value) is_not_nil;

  bool function(emacs_env*, emacs_value, emacs_value) eq;

  c_long function(emacs_env*, emacs_value) extract_integer;

  emacs_value function(emacs_env*, c_long) make_integer;

  double function(emacs_env*, emacs_value) extract_float;

  emacs_value function(emacs_env*, double) make_float;

  /* Copy the content of the Lisp string VALUE to BUFFER as an utf8
     NUL-terminated string.

     SIZE must point to the total size of the buffer.  If BUFFER is
     NULL or if SIZE is not big enough, write the required buffer size
     to SIZE and return true.

     Note that SIZE must include the last NUL byte (e.g. "abc" needs
     a buffer of size 4).

     Return true if the string was successfully copied.  */
  bool function(emacs_env*, emacs_value, char*, c_long*) copy_string_contents;

  /* Create a Lisp string from a utf8 encoded string.  */
  emacs_value function(emacs_env*, const(char)*, c_long) make_string;

  /* Embedded pointer type.  */
  emacs_value function(emacs_env*, void function(void*), void*) make_user_ptr;

  void* function(emacs_env*, emacs_value) get_user_ptr;

  void function(emacs_env*, emacs_value, void*) set_user_ptr;

  void function(void*) function(emacs_env*, emacs_value) get_user_finalizer;

  void function(emacs_env*, emacs_value, void function(void*)) set_user_finalizer;

  /* Vector functions.  */

  emacs_value function(emacs_env*, emacs_value, c_long) vec_get;

  void function(emacs_env*, emacs_value, c_long, emacs_value) vec_set;

  c_long function(emacs_env*, emacs_value) vec_size;

  /* Returns whether a quit is pending.  */
  bool function(emacs_env*) should_quit;

  /* Processes pending input events and returns whether the module
     function should quit.  */
  emacs_process_input_result function(emacs_env*) process_input;

  timespec function(emacs_env*, emacs_value) extract_time;

  emacs_value function(emacs_env*, timespec) make_time;

  bool function(emacs_env*, emacs_value, int*, c_long*, c_ulong*) extract_big_integer;

  emacs_value function(emacs_env*, int, c_long, const(c_ulong)*) make_big_integer;
}

/* Every module should define a function as follows.  */
int emacs_module_init(emacs_runtime*) @nogc nothrow;

struct emacs_env_private;
struct emacs_runtime_private;
