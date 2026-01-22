(defpackage #:concal.server
  (:use #:cl)
  (:export #:start-server
           #:stop-server))

(in-package #:concal.server)

(defvar *acceptor* nil
  "The Hunchentoot acceptor instance.")

(defun start-server ()
  "Start the web server."
  (when *acceptor*
    (stop-server))

  ;; Set up static file handling
  (push (hunchentoot:create-folder-dispatcher-and-handler
         "/static/"
         concal.config:*static-directory*)
        hunchentoot:*dispatch-table*)

  ;; Set up routes
  (concal.routes:setup-routes)

  ;; Create and start acceptor
  (setf *acceptor*
        (make-instance 'hunchentoot:easy-acceptor
                       :port concal.config:*server-port*))
  (hunchentoot:start *acceptor*)
  (format t "~&Server started on port ~d~%" concal.config:*server-port*))

(defun stop-server ()
  "Stop the web server."
  (when *acceptor*
    (hunchentoot:stop *acceptor*)
    (setf *acceptor* nil)
    (format t "~&Server stopped~%")))
