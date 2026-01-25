(defpackage #:concal.views.layout
  (:use #:cl)
  (:export #:render-page))
(in-package #:concal.views.layout)

(defun render-modal-script ()
  "Render JavaScript for long-press and right-click modal handling."
  "
(function() {
  // Long press detection (mobile)
  document.addEventListener('pointerdown', function(e) {
    var cell = e.target.closest('.day-cell');
    if (!cell) return;
    // 右クリックの場合はタイマーを設定しない（contextmenuで処理）
    if (e.button === 2) return;

    cell._longPressTimer = setTimeout(function() {
      cell._longPressed = true;
      htmx.ajax('GET', cell.dataset.formUrl, {target: '#modal-container'});
    }, 500);
  });

  document.addEventListener('pointerup', function(e) {
    var cell = e.target.closest('.day-cell');
    if (cell && cell._longPressTimer) {
      clearTimeout(cell._longPressTimer);
      if (cell._longPressed) {
        e.preventDefault();
        cell._longPressed = false;
      }
    }
  });

  document.addEventListener('pointercancel', function(e) {
    var cell = e.target.closest('.day-cell');
    if (cell && cell._longPressTimer) {
      clearTimeout(cell._longPressTimer);
    }
  });

  document.addEventListener('pointermove', function(e) {
    var cell = e.target.closest('.day-cell');
    if (cell && cell._longPressTimer) {
      clearTimeout(cell._longPressTimer);
    }
  });

  // Right click detection (PC)
  document.addEventListener('contextmenu', function(e) {
    var cell = e.target.closest('.day-cell');
    if (cell) {
      e.preventDefault();
      htmx.ajax('GET', cell.dataset.formUrl, {target: '#modal-container'});
    }
  });
})();
")

(defun render-page (title body)
  "Render the main page layout with HTMX support."
  (spinneret:with-html-string
    (:doctype)
    (:html :lang "ja"
     (:head
      (:meta :charset "utf-8")
      (:meta :name "viewport"
             :content "width=device-width, initial-scale=1, user-scalable=no")
      (:meta :name "apple-mobile-web-app-capable" :content "yes")
      (:meta :name "mobile-web-app-capable" :content "yes")
      (:title title)
      (:link :rel "stylesheet" :href "/static/css/style.css")
      (:script :src "https://unpkg.com/htmx.org@2.0.4"))
     (:body
      (:main :class "container"
        (:raw body))
      (:div :id "modal-container")
      (:script (:raw (render-modal-script)))))))
