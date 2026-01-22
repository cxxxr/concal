(defpackage #:concal.config
  (:use #:cl)
  (:export #:*db-host*
           #:*db-port*
           #:*db-name*
           #:*db-user*
           #:*db-password*
           #:*server-host*
           #:*server-port*
           #:*static-directory*))
(in-package #:concal.config)

(defvar *db-host* (or (uiop:getenv "CONCAL_DB_HOST") "localhost"))
(defvar *db-port* (parse-integer (or (uiop:getenv "CONCAL_DB_PORT") "5432")))
(defvar *db-name* (or (uiop:getenv "CONCAL_DB_NAME") "concal"))
(defvar *db-user* (or (uiop:getenv "CONCAL_DB_USER") "concal"))
(defvar *db-password* (or (uiop:getenv "CONCAL_DB_PASSWORD") "concal_password"))

(defvar *server-host* (or (uiop:getenv "CONCAL_HOST") "0.0.0.0"))
(defvar *server-port* (parse-integer (or (uiop:getenv "CONCAL_PORT") "8080")))

(defvar *static-directory*
  (merge-pathnames "static/"
                   (asdf:system-source-directory :concal)))
