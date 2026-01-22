(in-package #:concal.views)

(defun render-page (title body)
  "Render the main page layout with HTMX support."
  (spinneret:with-html-string
    (:doctype)
    (:html :lang "ja"
     (:head
      (:meta :charset "utf-8")
      (:meta :name "viewport" :content "width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no")
      (:meta :name "apple-mobile-web-app-capable" :content "yes")
      (:meta :name "mobile-web-app-capable" :content "yes")
      (:title title)
      (:link :rel "stylesheet" :href "/static/css/style.css")
      (:script :src "https://unpkg.com/htmx.org@2.0.4"))
     (:body
      (:main :class "container"
        (:raw body))))))
