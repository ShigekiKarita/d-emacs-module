# d-emacs-module

[![CI](https://github.com/ShigekiKarita/d-emacs-module/actions/workflows/ci.yml/badge.svg)](https://github.com/ShigekiKarita/d-emacs-module/actions/workflows/ci.yml)

D binding and high-level wrappers (WIP) for Emacs dynamic modules.
See [example](example) and [test.d](test.d)/[test.el](test.el) for its usage.

## Emacs version spec

This library assumes Emacs27 but you can explicitly specify version (e.g. Emacs25, Emacs26, Emacs27) in dub.json:

```json
{
  "name": "your-emacs-module"
  "license": "GPLv3",
  "targetType": "dynamicLibrary",
  "versions": ["Emacs27"]
  "dependencies": {
    "d-emacs-module": "*"
  }
}
```

Note that except `emacs_module.deimos`, this library does NOT support Emacs25 and Emacs26.

## TODOs

Emacs 25 features

- [x] basic type (int, double, string, bool) support
- [x] vector type support
- [x] memory management
- [x] non-local exit support
- [ ] embedded pointer support

Emacs 26 features

- [ ] should_quit support

Emacs 27 features

- [ ] process_input support
- [ ] time type support
- [ ] big int support

## References

- Official [Emacs dynamic modules doc](https://www.gnu.org/software/emacs/manual/html_node/elisp/Dynamic-Modules.html)
- Official C API (Emacs 27) [C/emacs-module.h](C/emacs-module.h)
- Third-party rust API https://github.com/ubolonton/emacs-module-rs
