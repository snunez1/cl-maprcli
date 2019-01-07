;;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-lisp; Package: CL-USER -*-

(asdf:defsystem "cl-maprcli"
  :description "MapR control system API"
  :author "Inchul <ijung remove-the-at mapr dot com>"
  :license "BSD"
  :serial t
  :depends-on ("cl-json"
	       "drakma")
  :in-order-to ((test-op (test-op "cl-maprcli/tests")))
  :components ((:file "package")
               (:file "cl-maprcli")
               (:file "mapr-api")))

(asdf:defsystem "cl-maprcli/tests"
  :description "test cl-maprcli"
  :author "Inchul <ijung remove-the-at mapr dot com>"
  :depends-on ("fiveam"
               "cl-maprcli")
  :components ((:module "tests"
                :serial t
                :components ((:file "test-package")
                             (:file "main"))))
  :perform (asdf:test-op (o s)
                         (uiop:symbol-call :fiveam '#:run!
                                           (uiop:find-symbol* :all-tests :maprcli-tests))))
