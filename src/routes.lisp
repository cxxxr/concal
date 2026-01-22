(defpackage #:concal.routes
  (:use #:cl)
  (:export #:setup-routes))
(in-package #:concal.routes)

(defun setup-routes ()
  "Set up all application routes."
  ;; Main page
  (hunchentoot:define-easy-handler (index :uri "/") ()
    (concal.handlers.pages:handle-index))

  ;; Calendar partial (HTMX)
  (hunchentoot:define-easy-handler (calendar :uri "/calendar") ()
    (concal.handlers.pages:handle-calendar))

  ;; Toggle API (HTMX)
  ;; Using a dispatcher for dynamic routes
  (push (hunchentoot:create-regex-dispatcher
         "^/api/toggle/(.+)$"
         #'handle-toggle-dispatch)
        hunchentoot:*dispatch-table*))

(defun handle-toggle-dispatch ()
  "Dispatch handler for toggle API."
  (let* ((uri (hunchentoot:request-uri*))
         (date-str (nth-value 1 (cl-ppcre:scan-to-strings
                                 "^/api/toggle/(.+)$" uri))))
    (when date-str
      (concal.handlers.api:handle-toggle (aref date-str 0)))))
