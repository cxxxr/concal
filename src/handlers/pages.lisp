(defpackage #:concal.handlers.pages
  (:use #:cl)
  (:export #:handle-index
           #:handle-calendar))

(in-package #:concal.handlers.pages)

(defun handle-index ()
  "Handle the main index page request."
  (let* ((today (local-time:now))
         (year (local-time:timestamp-year today))
         (month (local-time:timestamp-month today))
         (calendar-html (concal.views.calendar:render-calendar year month))
         (body (spinneret:with-html-string
                 (:header
                  (:h1 "ConCal"))
                 (:div :id "calendar-container"
                       (:raw calendar-html)))))
    (setf (hunchentoot:content-type*) "text/html; charset=utf-8")
    (concal.views.layout:render-page "ConCal - 習慣トラッカー" body)))

(defun handle-calendar ()
  "Handle calendar partial request (for HTMX).
   Query parameters: year, month"
  (let* ((year-str (hunchentoot:get-parameter "year"))
         (month-str (hunchentoot:get-parameter "month"))
         (today (local-time:now))
         (year (if year-str
                   (parse-integer year-str :junk-allowed t)
                   (local-time:timestamp-year today)))
         (month (if month-str
                    (parse-integer month-str :junk-allowed t)
                    (local-time:timestamp-month today))))
    (setf (hunchentoot:content-type*) "text/html; charset=utf-8")
    (concal.views.calendar:render-calendar year month)))
