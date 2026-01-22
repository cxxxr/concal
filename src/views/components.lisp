(defpackage #:concal.views.components
  (:use #:cl)
  (:export #:render-day-cell
           #:render-calendar-header
           #:render-weekday-header))
(in-package #:concal.views.components)

(defun render-day-cell (date completed-p is-today-p is-current-month-p)
  "Render a single day cell for the calendar.
   DATE is a local-time:timestamp.
   Returns HTML string."
  (let* ((date-str (local-time:format-timestring
                    nil date
                    :format '(:year "-" (:month 2) "-" (:day 2))))
         (day-number (local-time:timestamp-day date))
         (class-list (format nil "day-cell~a~a~a"
                             (if completed-p " completed" "")
                             (if is-today-p " today" "")
                             (if is-current-month-p "" " other-month"))))
    (spinneret:with-html-string
      (:div :class class-list
            :id (format nil "day-~a" date-str)
            :hx-post (format nil "/api/toggle/~a" date-str)
            :hx-swap "outerHTML"
            (:span :class "day-number" (format nil "~d" day-number))
            (when completed-p
              (:span :class "check-mark" "●"))))))

(defun render-calendar-header (year month)
  "Render the calendar navigation header.
   Returns HTML string."
  (let* ((prev-month (if (= month 1) 12 (1- month)))
         (prev-year (if (= month 1) (1- year) year))
         (next-month (if (= month 12) 1 (1+ month)))
         (next-year (if (= month 12) (1+ year) year))
         (today (local-time:now))
         (today-year (local-time:timestamp-year today))
         (today-month (local-time:timestamp-month today)))
    (spinneret:with-html-string
      (:div :class "calendar-header"
            (:button :class "nav-btn"
                     :hx-get (format nil "/calendar?year=~d&month=~d" prev-year prev-month)
                     :hx-target "#calendar-container"
                     :hx-swap "innerHTML"
                     "<")
            (:h2 :class "month-title"
                 (format nil "~d年~d月" year month))
            (:button :class "nav-btn"
                     :hx-get (format nil "/calendar?year=~d&month=~d" next-year next-month)
                     :hx-target "#calendar-container"
                     :hx-swap "innerHTML"
                     ">")
            (:button :class "today-btn"
                     :hx-get (format nil "/calendar?year=~d&month=~d" today-year today-month)
                     :hx-target "#calendar-container"
                     :hx-swap "innerHTML"
                     "今日")))))

(defun render-weekday-header ()
  "Render the weekday header row."
  (spinneret:with-html-string
    (:div :class "weekday-header"
          (dolist (day '("日" "月" "火" "水" "木" "金" "土"))
            (:span :class "weekday" day)))))
