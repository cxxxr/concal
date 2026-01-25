(defpackage #:concal.handlers.api
  (:use #:cl)
  (:export #:handle-toggle
           #:handle-get-record-form
           #:handle-update-record))
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

(defun handle-toggle (params)
  "Handle toggle request for a specific date.
   Returns updated day cell HTML for HTMX swap."
  (let* ((date-str (cdr (assoc :date params)))
         (date (parse-date-string date-str)))
    (if date
        (let* ((record (concal.models.habit-record:toggle-record date))
               (completed-p (concal.models.habit-record:habit-record-completed record))
               (has-memo-p (not (null (concal.models.habit-record:habit-record-memo record))))
               (today (local-time:now))
               (today-str (local-time:format-timestring
                           nil today
                           :format '(:year "-" (:month 2) "-" (:day 2))))
               (is-today-p (string= date-str today-str))
               (is-current-month-p t)
               (html (concal.views.components:render-day-cell
                      date completed-p is-today-p is-current-month-p has-memo-p)))
          `(200 (:content-type "text/html; charset=utf-8") (,html)))
        `(400 (:content-type "text/plain; charset=utf-8") ("Invalid date format")))))

(defun handle-get-record-form (params)
  "Handle GET request for record edit form.
   Returns modal form HTML for HTMX."
  (let* ((date-str (cdr (assoc :date params)))
         (date (parse-date-string date-str)))
    (if date
        (let* ((record (concal.models.habit-record:find-record-by-date date))
               (completed-p (and record (concal.models.habit-record:habit-record-completed record)))
               (memo (and record (concal.models.habit-record:habit-record-memo record)))
               (year (local-time:timestamp-year date))
               (month (local-time:timestamp-month date))
               (day (local-time:timestamp-day date))
               (html (concal.views.components:render-record-form
                      date-str year month day completed-p memo)))
          `(200 (:content-type "text/html; charset=utf-8") (,html)))
        `(400 (:content-type "text/plain; charset=utf-8") ("Invalid date format")))))

(defun handle-update-record (params)
  "Handle POST request for record update (completed + memo).
   Returns updated day cell HTML for HTMX swap."
  (let* ((date-str (cdr (assoc :date params)))
         (date (parse-date-string date-str)))
    (if date
        (let* ((completed-param (cdr (assoc "completed" params :test #'string=)))
               (memo-param (cdr (assoc "memo" params :test #'string=)))
               (completed-p (string= completed-param "true"))
               (record (concal.models.habit-record:update-record
                        date
                        :completed completed-p
                        :memo memo-param))
               (has-memo-p (not (null (concal.models.habit-record:habit-record-memo record))))
               (today (local-time:now))
               (today-str (local-time:format-timestring
                           nil today
                           :format '(:year "-" (:month 2) "-" (:day 2))))
               (is-today-p (string= date-str today-str))
               (is-current-month-p t)
               (html (concal.views.components:render-day-cell
                      date completed-p is-today-p is-current-month-p has-memo-p)))
          `(200 (:content-type "text/html; charset=utf-8") (,html)))
        `(400 (:content-type "text/plain; charset=utf-8") ("Invalid date format")))))
