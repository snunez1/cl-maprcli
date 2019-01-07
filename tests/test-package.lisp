;;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-lisp; Package: CL-USER -*-

(defpackage "MAPRCLI-TESTS"
  (:use "CL"
        "FIVEAM"
        "CL-MAPRCLI")
  (:export #:run!
           #:test-maprcli
           #:all-tests))
