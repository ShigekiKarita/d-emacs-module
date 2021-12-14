module emacs_module.feature;

import emacs_module.deimos : emacs_env;
import std.traits : hasMember;

// Feature versions according to C struct emacs_env that has more functions in
// newer versions.

// From Emacs26
enum bool supportShouldQuit = hasMember!(emacs_env, "should_quit");
// From Emacs27
enum bool supportProcessInput = hasMember!(emacs_env, "process_input");
enum bool supportTime = hasMember!(emacs_env, "extract_time") &&
                        hasMember!(emacs_env, "make_time");
enum bool supportBigInteger = hasMember!(emacs_env, "extract_big_integer") &&
                              hasMember!(emacs_env, "make_big_integer");
