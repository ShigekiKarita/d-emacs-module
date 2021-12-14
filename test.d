/+ dub.json:
{
  "name": "d-emacs-module-test",
  "targetType": "dynamicLibrary",
  "dependencies": {
    "d-emacs-module": { "path": "." }
  }
}
+/
module type_conversion;

import emacs_module;

import core.runtime;
import core.stdc.stdint;

extern (C):

int plugin_is_GPL_compatible;

/* Type conversion functions. */

intmax_t intX2(EmacsEnv env, intmax_t value) { return value * 2; }

double doubleX2(EmacsEnv env, double value) { return value * 2; }

string stringX2(EmacsEnv env, string value) { return value ~ value; }

bool not(EmacsEnv env, bool value) { return !value; }

EmacsVec!intmax_t intVecX2(EmacsEnv env, EmacsVec!intmax_t value) {
  foreach (i; 0 .. value.length) {
    value[i] = value[i] * 2;
  }
  return value;
}

int emacs_module_init(emacs_runtime* ert) {
  // Validate Emacs runtime and environment.
  EmacsRuntime runtime = {ert};
  if (!runtime.ok) return 1;
  EmacsEnv env = runtime.environment();
  if (!env.ok) return 2;

  // Initialize D runtime.
  Runtime.initialize();

  // Register functions.
  env.defAlias!intX2("tc-int-x2", "Multiply integer by 2.");
  env.defAlias!doubleX2("tc-double-x2", "Multiply float by 2.");
  env.defAlias!stringX2("tc-string-x2", "Repeat string twice.");
  env.defAlias!not("tc-not", "Returns true if value is false, vice versa.");
  env.defAlias!intVecX2("tc-int-vec-x2", "Multiply integer vector by 2.");
  return 0;
}
