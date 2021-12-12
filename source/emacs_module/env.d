module emacs_module.env;

import emacs_module.deimos;

import core.stdc.stdint : intmax_t;
import std.string : fromStringz;
import std.traits : arity, ParameterDefaults, Parameters;

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
alias maxArity = arity;

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
        payload_, minArity!func-1, maxArity!func-1, &wrapper, doc.ptr, data);
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
    return eq(typeOf(value), intern(type));
  }

  /// Returns true if the given emacs value is not nil.
  /// TODO(karita): Test.
  @nogc nothrow
  bool isNotNil(emacs_value value) {
    return payload_.is_not_nil(payload_, value);
  }

  /// Returns true if two emacs_values are equal.
  @nogc nothrow
  bool eq(emacs_value a, emacs_value b) {
    return payload_.eq(payload_, a, b);
  }

 private:
  /// C API payload.
  emacs_env* payload_ = null;
}

/// Type conversion. These shouldn't be methods in EmacsEnv because makeFunction
/// can wrap only `function` NOT `delegate`, which captures `this`.

/// Converts the given D object to emacs_value.
@nogc nothrow pure @safe
emacs_value toEmacsValue(EmacsEnv, emacs_value ev) { return ev; }

/// ditto
@nogc nothrow
emacs_value toEmacsValue(T : string)(EmacsEnv env, T s) {
  return env.payload_.make_string(env.payload_, s.ptr, s.length);
}

/// ditto
/// TODO(karita): Test.
@nogc nothrow
emacs_value toEmacsValue(T : intmax_t)(EmacsEnv env, T value) {
  return env.payload_.make_integer(env.payload_, value);
}

/// ditto
/// TODO(karita): Test.
@nogc nothrow
emacs_value toEmacsValue(T : double)(EmacsEnv env, T value) {
  return env.payload_.make_float(env.payload_, value);
}

/// Converts emacs_value to the D object.
@nogc nothrow pure @safe
inout(emacs_value) fromEmacsValue(T: emacs_value)(
    EmacsEnv, inout(emacs_value) ev) { return ev; }

/// ditto
nothrow
string fromEmacsValue(T: string)(EmacsEnv env, emacs_value ev) {
  assert(env.isTypeOf(ev, "string"));
  // Ask string size.
  ptrdiff_t size;
  env.payload_.copy_string_contents(env.payload_, ev, null, &size);

  // Copy string to new allocated buffer.
  auto buf = new char[size];
  env.payload_.copy_string_contents(env.payload_, ev, buf.ptr, &size);
  assert(size == buf.length);

  return buf.idup;
}

/// ditto
/// TODO(karita): Test.
@nogc nothrow pure @safe
intmax_t fromEmacsValue(T: intmax_t)(EmacsEnv env, emacs_value value) {
  return env.payload_.extract_integer(env.payload_, value);
}

/// ditto
/// TODO(karita): Test.
@nogc nothrow pure @safe
double fromEmacsValue(T: double)(EmacsEnv env, emacs_value value) {
  return env.payload_.extract_float(env.payload_, value);
}
