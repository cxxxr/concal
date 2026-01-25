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
        hunchentoot:*dispatch-table*)

  ;; Record form API (HTMX) - GET /api/records/:date/form
  (push (hunchentoot:create-regex-dispatcher
         "^/api/records/([^/]+)/form$"
         #'handle-get-record-form-dispatch)
        hunchentoot:*dispatch-table*)

  ;; Record update API (HTMX) - POST /api/records/:date
  (push (hunchentoot:create-regex-dispatcher
         "^/api/records/([^/]+)$"
         #'handle-update-record-dispatch)
        hunchentoot:*dispatch-table*))

(defun handle-toggle-dispatch ()
  "Dispatch handler for toggle API."
  (let* ((uri (hunchentoot:request-uri*))
         (date-str (nth-value 1 (cl-ppcre:scan-to-strings
                                 "^/api/toggle/(.+)$" uri))))
    (when date-str
      (concal.handlers.api:handle-toggle (aref date-str 0)))))

(defun handle-get-record-form-dispatch ()
  "Dispatch handler for record form API."
  (let* ((uri (hunchentoot:request-uri*))
         (date-str (nth-value 1 (cl-ppcre:scan-to-strings
                                 "^/api/records/([^/]+)/form" uri))))
    (when date-str
      (concal.handlers.api:handle-get-record-form (aref date-str 0)))))

(defun handle-update-record-dispatch ()
  "Dispatch handler for record update API."
  (let* ((uri (hunchentoot:request-uri*))
         (date-str (nth-value 1 (cl-ppcre:scan-to-strings
                                 "^/api/records/([^/]+)$" uri))))
    (when date-str
      (concal.handlers.api:handle-update-record (aref date-str 0)))))
