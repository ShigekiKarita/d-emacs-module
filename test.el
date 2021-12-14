:;exec emacs --batch -l "$0" -f ert-run-tests-batch-and-exit
;; https://www.gnu.org/software/emacs/manual/html_node/ert/index.html
(require 'ert)

(add-to-list 'load-path default-directory)
(load "libd-emacs-module-test")

(ert-deftest type-conversion-int ()
  (should (string= (documentation 'tc-int-x2) "Multiply integer by 2."))
  (should (= (tc-int-x2 123) 246))
  (should (= (tc-int-x2 0) 0))
  (should (= (tc-int-x2 -2) -4))
  (should-error (tc-int-x2 0.1) :type 'wrong-type-argument))

(ert-deftest type-conversion-float ()
  (should (= (tc-double-x2 12.3) 24.6))
  (should (= (tc-double-x2 0.0) 0.0))
  (should (= (tc-double-x2 -0.2) -0.4))
  (should-error (tc-double-x2 1) :type 'wrong-type-argument))

(ert-deftest type-conversion-string ()
  (should (string= (tc-string-x2 "abc") "abcabc"))
  (should (string= (tc-string-x2 "🍺") "🍺🍺"))
  (should (string= (tc-string-x2 "") ""))
  (should-error (tc-string-x2 1) :type 'wrong-type-argument))

(ert-deftest type-conversion-bool ()
  (should (string= (tc-not nil) t))
  (should (string= (tc-not '()) t))
  ;; Any non-nil values are regarded as true.
  ;; So there are no wrong-type-argument errors.
  (should (string= (tc-not t) nil))
  (should (string= (tc-not 0) nil))
  (should (string= (tc-not "") nil)))

(ert-deftest type-conversion-vec ()
  (should (equal (tc-int-vec-x2 [0 1 -2]) [0 2 -4]))
  (should (equal (tc-int-vec-x2 []) []))
  (should-error (tc-int-vec-x2 1) :type 'wrong-type-argument))
