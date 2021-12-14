module emacs_module.runtime;

import emacs_module.deimos;
import emacs_module.env;

/// High-level wrapper type for emacs_runtime;
struct EmacsRuntime {
  /// Checks if payload is compatible.
  @nogc nothrow pure @safe
  bool ok() const {
    return payload_ !is null && payload_.size >= emacs_runtime.sizeof;
  }

  /// Returns a new environment wrapper in this runtime.
  @nogc nothrow
  EmacsEnv environment() {
    return EmacsEnv(payload_.get_environment(payload_));
  }

 private:
  /// C API payload.
  emacs_runtime* payload_;
}
