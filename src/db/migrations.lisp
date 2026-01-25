(defpackage #:concal.db.migrations
  (:use #:cl)
  (:export #:ensure-tables))
(in-package #:concal.db.migrations)

(defun ensure-tables ()
  "Ensure all database tables exist and are up to date."
  (mito:ensure-table-exists 'concal.models.habit-record:habit-record)
  (mito:migrate-table 'concal.models.habit-record:habit-record))
