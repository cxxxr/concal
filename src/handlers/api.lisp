(defpackage #:concal.handlers.api
  (:use #:cl)
  (:export #:handle-toggle))

(in-package #:concal.handlers.api)

(defun parse-date-string (date-str)
  "Parse a date string in YYYY-MM-DD format to local-time:timestamp."
  (multiple-value-bind (match groups)
      (cl-ppcre:scan-to-strings "^(\\d{4})-(\\d{2})-(\\d{2})$" date-str)
    (when match
      (let ((year (parse-integer (aref groups 0)))
            (month (parse-integer (aref groups 1)))
            (day (parse-integer (aref groups 2))))
        (local-time:encode-timestamp 0 0 0 0 day month year)))))

(defun handle-toggle (date-str)
  "Handle toggle request for a specific date.
   Returns updated day cell HTML for HTMX swap."
  (let ((date (parse-date-string date-str)))
    (if date
        (let* ((record (concal.models.habit-record:toggle-record date))
               (completed-p (concal.models.habit-record:habit-record-completed record))
               (today (local-time:now))
               (today-str (local-time:format-timestring
                           nil today
                           :format '(:year "-" (:month 2) "-" (:day 2))))
               (is-today-p (string= date-str today-str))
               ;; For simplicity, assume it's current month (could be improved)
               (is-current-month-p t))
          (setf (hunchentoot:content-type*) "text/html; charset=utf-8")
          (concal.views.components:render-day-cell date completed-p is-today-p is-current-month-p))
        (progn
          (setf (hunchentoot:return-code*) hunchentoot:+http-bad-request+)
          "Invalid date format"))))
