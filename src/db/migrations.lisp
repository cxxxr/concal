(in-package #:concal.db)

(defun ensure-tables ()
  "Ensure all database tables exist."
  (mito:ensure-table-exists 'concal.models:habit-record))
