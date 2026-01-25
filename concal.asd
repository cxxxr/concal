(defsystem "concal"
  :version "0.1.0"
  :author "Claude Code"
  :license "MIT"
  :description "Habit tracking calendar application"
  :depends-on ("ningle"
               "clack"
               "lack"
               "lack-middleware-static"
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
                ((:file "config")
                 (:module "models"
                  :components
                  ((:file "habit-record")))
                 (:module "db"
                  :components
                  ((:file "connection")
                   (:file "migrations")))
                 (:module "views"
                  :components
                  ((:file "layout")
                   (:file "components")
                   (:file "calendar")))
                 (:module "handlers"
                  :components
                  ((:file "pages")
                   (:file "api")))
                 (:file "app")
                 (:file "routes")
                 (:file "server")
                 (:file "main")))))
