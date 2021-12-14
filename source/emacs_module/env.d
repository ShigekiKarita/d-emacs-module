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

/// Return value of EmacsEnv.nonLocalExit.
struct NonLocalExit {
  emacs_value symbol;
  emacs_value data;
  emacs_funcall_exit kind;
}

/// High-level wrapper type for emacs_env;
struct EmacsEnv {
  /// Checks if payload is compatible.
  @nogc nothrow pure @safe
  bool ok() const {
    return payload_ !is null && payload_.size >= emacs_env.sizeof;
  }

  /// Memory management.
  /// TODO(karita): Test.

  @nogc nothrow
  emacs_value makeGlobalRef(emacs_value reference) {
    return payload_.make_global_ref(payload_, reference);
  }

  @nogc nothrow
  void freeGlobalRef(emacs_value reference) {
    payload_.free_global_ref(payload_, reference);
  }

  /// Non-local exit handling.
  // TODO(karita): Test.

  @nogc nothrow
  emacs_funcall_exit nonLocalExitCheck() {
    return payload_.non_local_exit_check(payload_);
  }

  @nogc nothrow
  void nonLocalExitClear() {
    payload_.non_local_exit_clear(payload_);
  }

  @nogc nothrow
  NonLocalExit nonLocalExit() {
    NonLocalExit ret;
    ret.kind = payload_.non_local_exit_get(payload_, &ret.symbol, &ret.data);
    return ret;
  }

  @nogc nothrow
  void nonLocalExitSignal(emacs_value symbol, emacs_value data) {
    payload_.non_local_exit_signal(payload_, symbol, data);
  }

  @nogc nothrow
  void nonLocalExitThrow(emacs_value tag, emacs_value value) {
    payload_.non_local_exit_throw(payload_, tag, value);
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
  @nogc nothrow
  bool isNotNil(emacs_value value) {
    return payload_.is_not_nil(payload_, value);
  }

  /// Returns true if two emacs_values are equal.
  @nogc nothrow
  bool eq(emacs_value a, emacs_value b) {
    return payload_.eq(payload_, a, b);
  }

  /// Vector functions.
  T vecGet(T)(emacs_value vec, ptrdiff_t i) {
    return fromEmacsValue!T(this, payload_.vec_get(payload_, vec, i));
  }

  void vecSet(T)(emacs_value vec, ptrdiff_t i, T value) {
    payload_.vec_set(payload_, vec, i, toEmacsValue(this, value));
  }

  @nogc nothrow
  ptrdiff_t vecSize(emacs_value vec) {
    return payload_.vec_size(payload_, vec);
  }


 private:
  /// C API payload.
  emacs_env* payload_ = null;
}

/// Type conversion. These shouldn't be methods in EmacsEnv because makeFunction
/// can wrap only `function` NOT `delegate`, which captures `this`.
/// TODO(karita): Support embedded pointer type.

/// Converts emacs_value to emacs_value.
@nogc nothrow pure @safe
inout(emacs_value) toEmacsValue(const(EmacsEnv) env, inout(emacs_value) value) {
  return value;
}

/// ditto
@nogc nothrow pure @safe
inout(emacs_value) fromEmacsValue(T: emacs_value)(
    const(EmacsEnv) env, inout(emacs_value) value) { return value;
}

/// Converts intmax_t to emacs_value.
@nogc nothrow
emacs_value toEmacsValue(EmacsEnv env, intmax_t value) {
  return env.payload_.make_integer(env.payload_, value);
}

/// Converts emacs_value to intmax_t.
intmax_t fromEmacsValue(T: intmax_t)(EmacsEnv env, emacs_value value) {
  return env.payload_.extract_integer(env.payload_, value);
}

/// Converts double to emacs_value.
@nogc nothrow
emacs_value toEmacsValue(EmacsEnv env, double value) {
  return env.payload_.make_float(env.payload_, value);
}

/// Converts emacs_value to double.
double fromEmacsValue(T: double)(EmacsEnv env, emacs_value value) {
  return env.payload_.extract_float(env.payload_, value);
}

/// Converts bool to emacs_value.
@nogc nothrow
emacs_value toEmacsValue(EmacsEnv env, bool value) {
  return env.intern(value ? "t" : "nil");
}

/// Converts emacs_value to bool. Note that all non-nil values are true.
bool fromEmacsValue(T: bool)(EmacsEnv env, emacs_value value) {
  return env.isNotNil(value);
}

/// Converts emacs_value to string.
@nogc nothrow
emacs_value toEmacsValue(EmacsEnv env, string value) {
  return env.payload_.make_string(env.payload_, value.ptr, value.length);
}

/// Converts string to emacs_value.
string fromEmacsValue(T: string)(EmacsEnv env, emacs_value ev) {
  // Ask string size.
  ptrdiff_t size;
  env.payload_.copy_string_contents(env.payload_, ev, null, &size);
  if (size == 0) return "";

  // Copy string to new allocated buffer.
  auto buf = new char[size];
  env.payload_.copy_string_contents(env.payload_, ev, buf.ptr, &size);
  assert(size == buf.length);

  // Omit the last NULL byte.
  return buf.idup[0 .. size - 1];
}

/// Emacs vector type.
struct EmacsVec(T = emacs_value) {
  /// Gets a value at the given index.
  T opIndex(ptrdiff_t i) { return env.vecGet!T(vec, i); }

  /// Sets a value at the given index.
  T opIndexAssign(T value, ptrdiff_t i) {
    env.vecSet(vec, i, value);
    return value;
  }

  /// Returns the length of the vector.
  @nogc nothrow
  ptrdiff_t length() { return env.vecSize(vec); }

  /// ditto
  ptrdiff_t opDollar(size_t dim : 0)() { return length; }

 private:
  emacs_value vec;
  EmacsEnv env;
}

/// Converts EmacsVec!T to emacs_value.
@nogc nothrow
emacs_value toEmacsValue(V : EmacsVec!T, T)(const(EmacsEnv) env, V value) {
  return value.vec;
}

/// Converts emacs_value to EmacsVec!T.
EmacsVec!T fromEmacsValue(V : EmacsVec!T, T)(EmacsEnv env, emacs_value value) {
  return EmacsVec!T(value, env);
}
