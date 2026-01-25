(defpackage #:concal.routes
  (:use #:cl)
  (:export #:setup-routes))
(in-package #:concal.routes)

(defun setup-routes ()
  "Set up all application routes."
  (let ((app concal.app:*app*))
    ;; Main page - GET /
    (setf (ningle:route app "/")
          (lambda (params)
            (concal.handlers.pages:handle-index params)))

    ;; Calendar partial (HTMX) - GET /calendar
    (setf (ningle:route app "/calendar")
          (lambda (params)
            (concal.handlers.pages:handle-calendar params)))

    ;; Toggle API (HTMX) - POST /api/toggle/:date
    (setf (ningle:route app "/api/toggle/:date" :method :POST)
          (lambda (params)
            (concal.handlers.api:handle-toggle params)))

    ;; Record form API (HTMX) - GET /api/records/:date/form
    (setf (ningle:route app "/api/records/:date/form")
          (lambda (params)
            (concal.handlers.api:handle-get-record-form params)))

    ;; Record update API (HTMX) - POST /api/records/:date
    (setf (ningle:route app "/api/records/:date" :method :POST)
          (lambda (params)
            (concal.handlers.api:handle-update-record params)))))
