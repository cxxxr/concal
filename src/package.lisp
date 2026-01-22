(defpackage #:concal
  (:use #:cl)
  (:export #:start
           #:stop
           #:restart-server))

(defpackage #:concal.config
  (:use #:cl)
  (:export #:*db-host*
           #:*db-port*
           #:*db-name*
           #:*db-user*
           #:*db-password*
           #:*server-port*
           #:*static-directory*))

(defpackage #:concal.db
  (:use #:cl)
  (:export #:connect-db
           #:disconnect-db
           #:ensure-tables))

(defpackage #:concal.models
  (:use #:cl #:mito)
  (:export #:habit-record
           #:habit-record-date
           #:habit-record-completed
           #:habit-record-completed-at
           #:find-record-by-date
           #:toggle-record
           #:get-records-for-month))

(defpackage #:concal.views
  (:use #:cl)
  (:export #:render-page
           #:render-calendar
           #:render-day-cell
           #:render-calendar-header))

(defpackage #:concal.handlers
  (:use #:cl)
  (:export #:handle-index
           #:handle-calendar
           #:handle-toggle))

(defpackage #:concal.routes
  (:use #:cl)
  (:export #:setup-routes))

(defpackage #:concal.server
  (:use #:cl)
  (:export #:start-server
           #:stop-server))
