(defpackage #:concal.server
  (:use #:cl)
  (:export #:start-server
           #:stop-server))
(in-package #:concal.server)

(defvar *handler* nil
  "The Clack handler instance.")

(defun start-server ()
  "Start the web server."
  (when *handler*
    (stop-server))

  ;; Set up routes
  (concal.routes:setup-routes)

  ;; Start server with Clack
  (setf *handler*
        (clack:clackup
         (concal.app:build-app)
         :server :hunchentoot
         :address concal.config:*server-host*
         :port concal.config:*server-port*
         :use-thread t))
  (format t "~&Server started on ~a:~d~%"
          concal.config:*server-host*
          concal.config:*server-port*))

(defun stop-server ()
  "Stop the web server."
  (when *handler*
    (clack:stop *handler*)
    (setf *handler* nil)
    (format t "~&Server stopped~%")))
