/+ dub.json:
{
  "name": "emacs-dman",
  "targetType": "dynamicLibrary",
  "dependencies": {
    "d-emacs-module": { "path": ".." }
  }
}
+/
// How to test
// $ dub build --single ./dman.d
// $ emacs -batch -l dman_test.el

module dman;

import emacs_module.deimos;

import core.runtime: Runtime;
import std.datetime.systime : Clock;
import std.format : format;
import std.string : fromStringz;

private enum string dman = `
 o       o
 |        \
  \ ___   /
   |,-oo\\
   ||    || < %s
   ||    ||
   ||   //
   ||__//
   '---
    \  \
    /  /
    ^  ^
`;

// Wraps elisp "message" func with dman.
private emacs_value dman_message(T)(emacs_env* env, T arg) {
  emacs_value func = env.intern(env, "message");
  emacs_value[1] args;
  string hello = format!dman(arg);
  args[0] = env.make_string(env, hello.ptr, hello.length);
  return env.funcall(env, func, args.length, args.ptr);
}

// Returns true if type of value is string.
bool stringp(emacs_env* env, emacs_value value) {
  return env.eq(env, env.type_of(env, value), env.intern(env, "string"));
}

// Functions bellow are exported to emacs.
extern (C):

int plugin_is_GPL_compatible;

emacs_value dman_time(
    emacs_env* env, ptrdiff_t nargs, emacs_value* args, void* data) {
  return dman_message(env, Clock.currTime());
}

emacs_value dman_say(
    emacs_env* env, ptrdiff_t nargs, emacs_value* args, void* data) {
  if (nargs == 1 && stringp(env, args[0])) {
    char[128] buf;
    ptrdiff_t size = buf.length;
    // TODO(karita): Use dynamic array and handle errors.
    env.copy_string_contents(env, args[0], buf.ptr, &size);
    return dman_message(env, fromStringz(buf));
  }
  return dman_message(env, "Usage: (dman-say [string])");
}

int emacs_module_init(emacs_runtime* ert) {
  // Validate Emacs runtime and environment.
  if (ert.size < emacs_runtime.sizeof)
    return 1;
  emacs_env* env = ert.get_environment(ert);
  if (env.size < emacs_env.sizeof)
    return 2;

  // Initialize D runtime.
  Runtime.initialize();
  dman_message(env, "Hello Emacs from D!!");

  // Register functions.
  emacs_value[2] fn_sym_pair;
  fn_sym_pair[0] = env.intern(env, "dman-time");
  fn_sym_pair[1] = env.make_function(
      env, /*min_arity=*/0, /*max_arity=*/0,
      /*function=*/&dman_time,
      /*documentation=*/"Dman tells you current time.",
      /*data=*/null);
  env.funcall(env, env.intern(env, "defalias"),
              fn_sym_pair.length, fn_sym_pair.ptr);

  fn_sym_pair[0] = env.intern(env, "dman-say");
  fn_sym_pair[1] = env.make_function(
      env, /*min_arity=*/1, /*max_arity=*/1,
      /*function=*/&dman_say,
      /*documentation=*/"Dman repeats your string.",
      /*data=*/null);
  env.funcall(env, env.intern(env, "defalias"),
              fn_sym_pair.length, fn_sym_pair.ptr);

  return 0;
}
