(lang dune 2.8)
(name logger)

(package
 (name logger)
 (version 0.1.1)
 (license "MIT")
 (maintainers "hellojukay@163.com")
 (authors "hellojukay")
 (homepage "https://github.com/hellojukay/logger.git")
 (source (github hellojukay/logger))
 (documentation "https://github.com/hellojukay/logger")
 (bug_reports "https://github.com/hellojukay/logger/issues")
 (synopsis "A simple log lib for OCaml")
 (depends
  (core (>= "v0.12"))
  (ppx_inline_test :with-test)
  ))