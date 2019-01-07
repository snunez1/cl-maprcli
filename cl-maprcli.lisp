;;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-lisp; Package: CL-MAPRCLI -*-

(in-package :cl-maprcli)

(defun make-url-param (alist)
  "Make a URL parameter format with alist. ex: (make-url-param '((:a . 1) (:b . 2)))"
  (format nil "~{~a~^&~}" (loop for (a . b) in alist
                                collect (format nil "~a=~a" a b))))

(defun remove-assoc (item alist)
  "Remove ITEM from ALIST"
  (remove-if (lambda (x) (equal (car x) item)) alist))

(defun help (cmd-path)
  "Return a documentation string describing a maprcli command. eg: (help :/alarm/list)"
  (labels ((get-in (items alist)
             (if (endp items) alist
                 (get-in (rest items)
                         (cdr (assoc (car items) alist))))))
    (get-in (list :paths cmd-path :get :description) (decode-json-from-source #p"./mapr.json"))))

;;; http response object
(defclass mapr-response ()
  ((status :accessor status :initarg :status )
   (data :accessor data :initarg :data :initform '())))

(defmethod set-data ((message mapr-response) obj)
  "Setter for MAPR-RESPONSE instance"
  (setf (data message) obj))

(defmethod set-status ((message mapr-response) obj)
  "Setter for status instance"
  (setf (status message) obj))

(defmethod pretty ((message mapr-response))
  "Pretty-print output"
  (format t "~%~A~%" (status message))
  (loop for msg in (data message)
        do (format t "~80,,,'=A~%" "")
           (loop for (a . b) in msg
                 do (format t "~35,A : ~A ~%" a b))))

(defun rest-call (host path basic-authorization alist output)
  "Call http-request with basic authentication and parameters."
  (multiple-value-bind (stream code)
      (http-request (string-downcase  (format nil "~a~a?~a" host path (make-url-param alist))) :basic-authorization basic-authorization :accept "application/json" :content-type "application/json" :want-stream t :method :GET)
    (if (equal code 200) (progn (setf (flexi-streams:flexi-stream-external-format stream) :utf-8)
                                (let ((clj (decode-json stream))
                                      (message (make-instance 'mapr-response)))
                                  (set-status message (cdr (assoc :status clj)))
                                  (set-data message (cdr (assoc :data clj)))
                                  (case output
                                    ((:clos) message)
                                    ((:pretty) (pretty message))
                                    ((:json) (encode-json clj))
                                    (t clj))))
        (format t "~%==> ~a~a?~a~%FAILED - RETURN CODE : ~A ~%" host path (make-url-param alist) code))))
