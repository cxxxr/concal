(defpackage #:concal.views.calendar
  (:use #:cl)
  (:export #:render-calendar))
(in-package #:concal.views.calendar)

(defun get-first-day-of-week (year month)
  "Get the day of week for the first day of the month (0=Sunday)."
  (let ((timestamp (local-time:encode-timestamp 0 0 0 0 1 month year)))
    (local-time:timestamp-day-of-week timestamp)))

(defun get-days-in-month (year month)
  "Get the number of days in a month."
  (let* ((start (local-time:encode-timestamp 0 0 0 0 1 month year))
         (end (local-time:timestamp+ start 1 :month)))
    (local-time:timestamp-day
     (local-time:timestamp- end 1 :day))))

(defun render-calendar (year month)
  "Render the complete calendar grid for a given month.
   Returns HTML string."
  (let* ((records (concal.models.habit-record:get-records-for-month year month))
         (today (local-time:now))
         (today-str (local-time:format-timestring
                     nil today
                     :format '(:year "-" (:month 2) "-" (:day 2))))
         (first-day-of-week (get-first-day-of-week year month))
         (days-in-month (get-days-in-month year month))
         (prev-month (if (= month 1) 12 (1- month)))
         (prev-year (if (= month 1) (1- year) year))
         (days-in-prev-month (get-days-in-month prev-year prev-month)))
    (spinneret:with-html-string
      ;; Header
      (:raw (concal.views.components:render-calendar-header year month))
      ;; Weekday header
      (:raw (concal.views.components:render-weekday-header))
      ;; Calendar grid
      (:div :class "calendar-grid"
            ;; Previous month's trailing days
            (dotimes (i first-day-of-week)
              (let* ((day (- days-in-prev-month (- first-day-of-week i 1)))
                     (date (local-time:encode-timestamp 0 0 0 0 day prev-month prev-year))
                     (date-str (local-time:format-timestring
                                nil date
                                :format '(:year "-" (:month 2) "-" (:day 2))))
                     (completed-p (gethash date-str records)))
                (:raw (concal.views.components:render-day-cell
                       date completed-p (string= date-str today-str) nil))))
            ;; Current month's days
            (dotimes (i days-in-month)
              (let* ((day (1+ i))
                     (date (local-time:encode-timestamp 0 0 0 0 day month year))
                     (date-str (local-time:format-timestring
                                nil date
                                :format '(:year "-" (:month 2) "-" (:day 2))))
                     (completed-p (gethash date-str records)))
                (:raw (concal.views.components:render-day-cell
                       date completed-p (string= date-str today-str) t))))
            ;; Next month's leading days
            (let* ((total-cells (+ first-day-of-week days-in-month))
                   (remaining (mod (- 7 (mod total-cells 7)) 7))
                   (next-month (if (= month 12) 1 (1+ month)))
                   (next-year (if (= month 12) (1+ year) year)))
              (dotimes (i remaining)
                (let* ((day (1+ i))
                       (date (local-time:encode-timestamp 0 0 0 0 day next-month next-year))
                       (date-str (local-time:format-timestring
                                  nil date
                                  :format '(:year "-" (:month 2) "-" (:day 2))))
                       (completed-p (gethash date-str records)))
                  (:raw (concal.views.components:render-day-cell
                         date completed-p (string= date-str today-str) nil)))))))))
