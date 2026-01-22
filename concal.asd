(defsystem "concal"
  :version "0.1.0"
  :author "Claude Code"
  :license "MIT"
  :description "Habit tracking calendar application"
  :depends-on ("hunchentoot"
               "spinneret"
               "mito"
               "sxql"
               "cl-dbi"
               "jonathan"
               "local-time"
               "cl-ppcre"
               "uiop")
  :serial t
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "config")
                 (:module "db"
                  :components
                  ((:file "connection")
                   (:file "migrations")))
                 (:module "models"
                  :components
                  ((:file "habit-record")))
                 (:module "views"
                  :components
                  ((:file "layout")
                   (:file "components")
                   (:file "calendar")))
                 (:module "handlers"
                  :components
                  ((:file "pages")
                   (:file "api")))
                 (:file "routes")
                 (:file "server")
                 (:file "main")))))
