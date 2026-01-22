(defpackage #:concal
  (:use #:cl)
  (:export #:start
           #:stop
           #:restart-server))
(in-package #:concal)

(defun start ()
  "Start the ConCal application."
  (format t "~&Starting ConCal...~%")

  ;; Connect to database
  (format t "~&Connecting to database...~%")
  (concal.db.connection:connect-db)

  ;; Ensure tables exist
  (format t "~&Ensuring database tables...~%")
  (concal.db.migrations:ensure-tables)

  ;; Start web server
  (format t "~&Starting web server...~%")
  (concal.server:start-server)

  (format t "~&ConCal is ready!~%")
  (format t "~&Access at http://~a:~d~%"
          concal.config:*server-host*
          concal.config:*server-port*))

(defun stop ()
  "Stop the ConCal application."
  (format t "~&Stopping ConCal...~%")
  (concal.server:stop-server)
  (concal.db.connection:disconnect-db)
  (format t "~&ConCal stopped.~%"))

(defun restart-server ()
  "Restart the web server without reconnecting to database."
  (concal.server:stop-server)
  (concal.server:start-server))
