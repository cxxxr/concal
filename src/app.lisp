(defpackage #:concal.app
  (:use #:cl)
  (:export #:*app*
           #:build-app))
(in-package #:concal.app)

(defvar *app* (make-instance 'ningle:app)
  "The Ningle application instance.")

(defun build-app ()
  "Build the Lack application with middleware."
  (lack:builder
   (:static :path "/static/"
            :root (namestring concal.config:*static-directory*))
   *app*))
