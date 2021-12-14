#!bash
set -euo pipefail

echo "== DUB test ==="
dub test

echo "== Run test dir ==="

dub build --single ./test.d
emacs -batch -l test.el -f ert-run-tests-batch-and-exit


echo "== Run example dir ==="
cd example

dub build --single ./dman.d
emacs -batch -l dman_test.el

dub build --single ./dman_v2.d
emacs -batch -l dman_test.el

cd -
