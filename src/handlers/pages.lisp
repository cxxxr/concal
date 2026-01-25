(defpackage #:concal.handlers.pages
  (:use #:cl)
  (:export #:handle-index
           #:handle-calendar))
(in-package #:concal.handlers.pages)

(defun handle-index (params)
  "Handle the main index page request."
  (declare (ignore params))
  (let* ((today (local-time:now))
         (year (local-time:timestamp-year today))
         (month (local-time:timestamp-month today))
         (calendar-html (concal.views.calendar:render-calendar year month))
         (body (spinneret:with-html-string
                 (:header
                  (:h1 "ConCal"))
                 (:div :id "calendar-container"
                       (:raw calendar-html))))
         (html (concal.views.layout:render-page "ConCal - 習慣トラッカー" body)))
    `(200 (:content-type "text/html; charset=utf-8") (,html))))

(defun handle-calendar (params)
  "Handle calendar partial request (for HTMX).
   Query parameters: year, month"
  (let* ((year-str (cdr (assoc "year" params :test #'string=)))
         (month-str (cdr (assoc "month" params :test #'string=)))
         (today (local-time:now))
         (year (if year-str
                   (parse-integer year-str :junk-allowed t)
                   (local-time:timestamp-year today)))
         (month (if month-str
                    (parse-integer month-str :junk-allowed t)
                    (local-time:timestamp-month today)))
         (html (concal.views.calendar:render-calendar year month)))
    `(200 (:content-type "text/html; charset=utf-8") (,html))))
