(in-package #:concal.tests)

;;; Test database configuration
(defvar *test-db-name* "concal_test")
(defvar *test-db-user* "concal")
(defvar *test-db-password* "concal_password")
(defvar *test-db-host* "localhost")
(defvar *test-db-port* 5432)

(defun setup-test-db ()
  "Connect to the test database."
  (mito:connect-toplevel :postgres
                         :database-name *test-db-name*
                         :username *test-db-user*
                         :password *test-db-password*
                         :host *test-db-host*
                         :port *test-db-port*)
  ;; Ensure tables exist
  (mito:ensure-table-exists 'concal.models.habit-record:habit-record))

(defun teardown-test-db ()
  "Disconnect from the test database."
  (mito:disconnect-toplevel))

(defun clear-test-data ()
  "Clear all test data from tables."
  (mito:execute-sql "DELETE FROM habit_record"))

(defmacro with-test-db (&body body)
  "Execute body with test database connection and cleanup."
  `(progn
     (setup-test-db)
     (unwind-protect
          (progn
            (clear-test-data)
            ,@body)
       (clear-test-data)
       (teardown-test-db))))
