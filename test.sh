#!bash
set -euo pipefail

dub test

echo "== Test example modules ==="
cd example
dub build --single ./dman.d
emacs -batch -l dman_test.el
