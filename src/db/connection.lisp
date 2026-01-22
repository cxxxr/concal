(defpackage #:concal.db.connection
  (:use #:cl)
  (:export #:connect-db
           #:disconnect-db))

(in-package #:concal.db.connection)

(defun connect-db ()
  "Connect to PostgreSQL database using Mito."
  (mito:connect-toplevel :postgres
                         :database-name concal.config:*db-name*
                         :username concal.config:*db-user*
                         :password concal.config:*db-password*
                         :host concal.config:*db-host*
                         :port concal.config:*db-port*))

(defun disconnect-db ()
  "Disconnect from database."
  (mito:disconnect-toplevel))
