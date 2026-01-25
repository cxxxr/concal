(defpackage #:concal.views.components
  (:use #:cl)
  (:export #:render-day-cell
           #:render-calendar-header
           #:render-weekday-header
           #:render-record-form))
(in-package #:concal.views.components)

(defun render-day-cell (date completed-p is-today-p is-current-month-p &optional has-memo-p)
  "Render a single day cell for the calendar.
   DATE is a local-time:timestamp.
   HAS-MEMO-P indicates whether the date has a memo attached.
   Returns HTML string."
  (let* ((date-str (local-time:format-timestring
                    nil date
                    :format '(:year "-" (:month 2) "-" (:day 2))))
         (day-number (local-time:timestamp-day date))
         (class-list (format nil "day-cell~a~a~a~a"
                             (if completed-p " completed" "")
                             (if is-today-p " today" "")
                             (if is-current-month-p "" " other-month")
                             (if has-memo-p " has-memo" ""))))
    (spinneret:with-html-string
      (:div :class class-list
            :id (format nil "day-~a" date-str)
            :data-form-url (format nil "/api/records/~a/form" date-str)
            :hx-post (format nil "/api/toggle/~a" date-str)
            :hx-swap "outerHTML"
            (:span :class "day-number" (format nil "~d" day-number))
            (when completed-p
              (:span :class "check-mark" "●"))
            (when has-memo-p
              (:span :class "memo-indicator" "・"))))))

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

(defun render-record-form (date-str year month day completed-p memo)
  "Render the record editing form for the modal.
   Returns HTML string."
  (spinneret:with-html-string
    (:div :class "modal-overlay"
          :onclick "if(event.target===this)this.remove()"
          (:div :class "modal-content"
                (:div :class "modal-header"
                      (:span :class "modal-date"
                             (format nil "~d年~d月~d日" year month day))
                      (:button :class "modal-close"
                               :type "button"
                               :onclick "this.closest('.modal-overlay').remove()"
                               "×"))
                (:form :hx-post (format nil "/api/records/~a" date-str)
                       :hx-swap "outerHTML"
                       :hx-target (format nil "#day-~a" date-str)
                       :class "record-form"
                       (:label :class "checkbox-label"
                               (:input :type "checkbox"
                                       :name "completed"
                                       :value "true"
                                       :checked completed-p)
                               (:span "達成した"))
                       (:div :class "memo-field"
                             (:label :for "memo" "メモ（任意）")
                             (:textarea :id "memo"
                                        :name "memo"
                                        :rows "3"
                                        :placeholder "例: 本を30ページ読んだ"
                                        :maxlength "1000"
                                        (or memo "")))
                       (:div :class "form-actions"
                             (:button :type "button"
                                      :class "btn-cancel"
                                      :onclick "this.closest('.modal-overlay').remove()"
                                      "キャンセル")
                             (:button :type "submit"
                                      :class "btn-save"
                                      :onclick "this.closest('.modal-overlay').remove()"
                                      "保存")))))))
