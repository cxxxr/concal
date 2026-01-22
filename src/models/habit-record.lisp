(defpackage #:concal.models.habit-record
  (:use #:cl #:mito)
  (:export #:habit-record
           #:habit-record-date
           #:habit-record-completed
           #:habit-record-completed-at
           #:find-record-by-date
           #:toggle-record
           #:get-records-for-month))
(in-package #:concal.models.habit-record)

(mito:deftable habit-record ()
  ((date :col-type :date
         :accessor habit-record-date
         :initarg :date)
   (completed :col-type :boolean
              :accessor habit-record-completed
              :initarg :completed
              :initform nil)
   (completed-at :col-type (or :timestamptz :null)
                 :accessor habit-record-completed-at
                 :initarg :completed-at
                 :initform nil))
  (:unique-keys date))

(defun find-record-by-date (date)
  "Find a habit record by date. DATE should be a local-time:timestamp."
  (mito:find-dao 'habit-record :date date))

(defun toggle-record (date)
  "Toggle the completion status for a given date.
   Returns the updated or created record."
  (let ((record (find-record-by-date date)))
    (if record
        (progn
          (setf (habit-record-completed record) (not (habit-record-completed record)))
          (setf (habit-record-completed-at record)
                (if (habit-record-completed record)
                    (local-time:now)
                    nil))
          (mito:save-dao record)
          record)
        (mito:create-dao 'habit-record
                         :date date
                         :completed t
                         :completed-at (local-time:now)))))

(defun get-records-for-month (year month)
  "Get all habit records for a given month.
   Returns a hash table mapping date strings to completed status."
  (let* ((start-date (local-time:encode-timestamp 0 0 0 0 1 month year))
         (end-date (local-time:timestamp+ start-date 1 :month))
         (records (mito:select-dao 'habit-record
                    (sxql:where (:and (:>= :date start-date)
                                      (:< :date end-date)))))
         (result (make-hash-table :test 'equal)))
    (dolist (record records)
      (let ((date-str (local-time:format-timestring
                       nil (habit-record-date record)
                       :format '(:year "-" (:month 2) "-" (:day 2)))))
        (setf (gethash date-str result) (habit-record-completed record))))
    result))
