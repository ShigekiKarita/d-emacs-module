module emacs_module.env;

import emacs_module.deimos;

import std.string;
import std.stdio;
import std.traits;

/// Returns the minimum arity among func overloads within its module.
private size_t minArity(alias fn)() {
  size_t count = 0;
  foreach (param; ParameterDefaults!fn) {
    if (is(param == void)) {
      ++count;
    }
  }
  return count;
}

/// Returns the maximum arity among func overloads within its module.
alias maxArity = std.traits.arity;

version (emacs_module_test) unittest {
    void foo(int, double, string s = "");
    static assert(maxArity!foo == 3);
    static assert(minArity!foo == 2);
}

/// High-level wrapper type for emacs_env;
struct EmacsEnv {
  /// Checks if payload is compatible.
  @nogc nothrow pure @safe
  bool ok() const {
    return payload_ !is null && payload_.size >= emacs_env.sizeof;
  }

  /// Returns emacs lisp symbol by the given name.
  @nogc nothrow
  emacs_value intern(string name) {
    return payload_.intern(payload_, name.ptr);
  }

  /// Calls emacs lisp function with the given args.
  emacs_value funcall(Args...)(string funcName, Args args) {
    emacs_value func = intern(funcName);
    emacs_value[Args.length] evArgs;
    static foreach (i; 0 .. Args.length) {
      evArgs[i] = toEmacsValue(this, args[i]);
    }
    return payload_.funcall(payload_, func, evArgs.length, evArgs.ptr);
  }

  /// Wraps emacs_env.make_function with auto-detected arity.
  /// WARNING: func overload is not supported.
  emacs_value makeFunction(alias func)(
      const(char)[] doc = "", void* data = null) {
    // Wrapper function.
    extern (C)
    emacs_value wrapper(
        emacs_env* env, ptrdiff_t nargs, emacs_value* args, void* data) {
      alias Params = Parameters!func;
      static assert(is(Params[0] == EmacsEnv),
                    "First func argument must be EmacsEnv.");

      // Convert emacs_value to typed D value.
      Params params;
      params[0] = EmacsEnv(env);
      static foreach (i; 1 .. params.length) {
        params[i] = fromEmacsValue!(Params[i])(params[0], args[i-1]);
      }
      return toEmacsValue(params[0], func(params));
    }

    return payload_.make_function(
        payload_, minArity!func - 1, maxArity!func - 1, &wrapper,
        doc.ptr, data);
  }

  /// Type-safe emacs lisp "defalias".
  emacs_value defAlias(alias func)(
      string elispName, string doc = "", void* data = null) {
    return funcall("defalias", intern(elispName),
                   makeFunction!func(doc, data));
  }

  /// Returns type of the given value in emacs lisp.
  @nogc nothrow
  emacs_value typeOf(emacs_value value) {
    return payload_.type_of(payload_, value);
  }

  /// Returns true if value is the given type in emacs lisp.
  @nogc nothrow
  bool isTypeOf(emacs_value value, string type) {
    return payload_.eq(payload_, typeOf(value),
                       payload_.intern(payload_, type.ptr));
  }

 private:
  /// C API payload.
  emacs_env* payload_ = null;
}

/// Converts the given D object to emacs_value.
@nogc nothrow pure @safe
emacs_value toEmacsValue(EmacsEnv, emacs_value ev) { return ev; }

/// ditto
@nogc nothrow
emacs_value toEmacsValue(T : string)(EmacsEnv env, T s) {
  return env.payload_.make_string(env.payload_, s.ptr, s.length);
}

/// Converts emacs_value to the D object.
@nogc nothrow pure @safe
inout(emacs_value) fromEmacsValue(T: emacs_value)(
    EmacsEnv, inout(emacs_value) ev) { return ev; }

/// ditto
nothrow
string fromEmacsValue(T: string)(EmacsEnv env, emacs_value ev) {
  assert(env.isTypeOf(ev, "string"));
  char[1024] buf;
  ptrdiff_t size = buf.length;
  // TODO(karita): Use dynamic array and handle errors.
  env.payload_.copy_string_contents(env.payload_, ev, buf.ptr, &size);
  return fromStringz(buf).idup;
}
