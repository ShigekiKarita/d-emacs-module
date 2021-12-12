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
// $ dub build --single ./dman_v2.d
// $ emacs -batch -l dman_test.el
module dman;

import emacs_module;

import core.runtime: Runtime;
import std.datetime.systime : Clock;
import std.format : format;

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

private emacs_value dmanMessage(T)(EmacsEnv env, T arg) {
  return env.funcall("message", format!dman(arg));
}
emacs_value dmanTime(EmacsEnv e) { return dmanMessage(e, Clock.currTime()); }
emacs_value dmanSay(EmacsEnv e, string s) { return dmanMessage(e, s); }

// Functions bellow are exported to emacs.
extern (C):

int plugin_is_GPL_compatible;

int emacs_module_init(emacs_runtime* ert) {
  // Validate Emacs runtime and environment.
  EmacsRuntime runtime = {ert};
  if (!runtime.ok) return 1;
  EmacsEnv env = runtime.environment();
  if (!env.ok) return 2;

  // Initialize D runtime.
  Runtime.initialize();
  dmanSay(env, "Hello Emacs from D!!");

  // Register functions.
  env.defAlias!dmanTime("dman-time", "Dman tells you current time.");
  env.defAlias!dmanSay("dman-say", "Dman repeats your string.");
  return 0;
}
