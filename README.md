# d-emacs-module

[![CI](https://github.com/ShigekiKarita/d-emacs-module/actions/workflows/ci.yml/badge.svg)](https://github.com/ShigekiKarita/d-emacs-module/actions/workflows/ci.yml)

D binding and high-level wrappers (WIP) for Emacs dynamic modules.
See [example](example) dir for its usage.

## Emacs version spec

This library assumes Emacs27 but you can specify version (e.g. Emacs25, Emacs26, Emacs27) in dub.json:

```json
{
  "name": "your-emacs-module"
  "license": "GPLv3",
  "targetType": "dynamicLibrary",
  "versions": ["Emacs26"]
  "dependencies": {
    "d-emacs-module": "*"
  }
}
```

Note that only `emacs_module.deimos` supports Emacs25 and Emacs26.

## References

- Official C API (Emacs 27) [C/emacs-module.h](C/emacs-module.h)
- Third-party rust API https://github.com/ubolonton/emacs-module-rs
