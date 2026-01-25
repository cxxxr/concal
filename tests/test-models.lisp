(in-package #:concal.tests)

(in-suite model-tests)

;;; Tests for toggle-record

(test toggle-record-creates-new
  "toggle-record creates a new record if none exists"
  (with-test-db
    (let* ((date (local-time:encode-timestamp 0 0 0 0 15 1 2024))
           (record (concal.models.habit-record:toggle-record date)))
      (is (not (null record)))
      (is (concal.models.habit-record:habit-record-completed record))
      (is (not (null (concal.models.habit-record:habit-record-completed-at record)))))))

(test toggle-record-toggles-existing
  "toggle-record toggles an existing record"
  (with-test-db
    (let* ((date (local-time:encode-timestamp 0 0 0 0 15 1 2024)))
      ;; First toggle: create and complete
      (let ((record1 (concal.models.habit-record:toggle-record date)))
        (is (concal.models.habit-record:habit-record-completed record1)))
      ;; Second toggle: uncomplete
      (let ((record2 (concal.models.habit-record:toggle-record date)))
        (is (not (concal.models.habit-record:habit-record-completed record2)))
        (is (null (concal.models.habit-record:habit-record-completed-at record2))))
      ;; Third toggle: complete again
      (let ((record3 (concal.models.habit-record:toggle-record date)))
        (is (concal.models.habit-record:habit-record-completed record3))))))

;;; Tests for update-record

(test update-record-creates-new
  "update-record creates a new record if none exists"
  (with-test-db
    (let* ((date (local-time:encode-timestamp 0 0 0 0 20 2 2024))
           (record (concal.models.habit-record:update-record date
                     :completed t
                     :memo "Test memo")))
      (is (not (null record)))
      (is (concal.models.habit-record:habit-record-completed record))
      (is (string= "Test memo" (concal.models.habit-record:habit-record-memo record))))))

(test update-record-updates-memo
  "update-record updates memo on existing record"
  (with-test-db
    (let* ((date (local-time:encode-timestamp 0 0 0 0 20 2 2024)))
      ;; Create initial record
      (concal.models.habit-record:update-record date :completed t :memo "Initial")
      ;; Update memo
      (let ((record (concal.models.habit-record:update-record date
                      :completed t
                      :memo "Updated memo")))
        (is (string= "Updated memo" (concal.models.habit-record:habit-record-memo record)))))))

(test update-record-clears-empty-memo
  "update-record clears memo when given empty string"
  (with-test-db
    (let* ((date (local-time:encode-timestamp 0 0 0 0 20 2 2024)))
      ;; Create record with memo
      (concal.models.habit-record:update-record date :completed t :memo "Has memo")
      ;; Clear memo with empty string
      (let ((record (concal.models.habit-record:update-record date
                      :completed t
                      :memo "")))
        (is (null (concal.models.habit-record:habit-record-memo record)))))))

(test update-record-changes-completed-status
  "update-record can change completed status"
  (with-test-db
    (let* ((date (local-time:encode-timestamp 0 0 0 0 20 2 2024)))
      ;; Create completed record
      (concal.models.habit-record:update-record date :completed t :memo nil)
      ;; Uncomplete it
      (let ((record (concal.models.habit-record:update-record date
                      :completed nil
                      :memo nil)))
        (is (not (concal.models.habit-record:habit-record-completed record)))
        (is (null (concal.models.habit-record:habit-record-completed-at record)))))))

;;; Tests for get-records-for-month

(test get-records-for-month-empty
  "get-records-for-month returns empty hash for month with no records"
  (with-test-db
    (let ((result (concal.models.habit-record:get-records-for-month 2024 6)))
      (is (hash-table-p result))
      (is (= 0 (hash-table-count result))))))

(test get-records-for-month-returns-correct-data
  "get-records-for-month returns correct data for records"
  (with-test-db
    (let ((date1 (local-time:encode-timestamp 0 0 0 0 5 3 2024))
          (date2 (local-time:encode-timestamp 0 0 0 0 15 3 2024))
          (date3 (local-time:encode-timestamp 0 0 0 0 25 3 2024)))
      ;; Create records
      (concal.models.habit-record:update-record date1 :completed t :memo nil)
      (concal.models.habit-record:update-record date2 :completed nil :memo "Note")
      (concal.models.habit-record:update-record date3 :completed t :memo "Done!")
      ;; Get records
      (let ((result (concal.models.habit-record:get-records-for-month 2024 3)))
        (is (= 3 (hash-table-count result)))
        ;; Check date1
        (let ((r1 (gethash "2024-03-05" result)))
          (is (getf r1 :completed))
          (is (not (getf r1 :has-memo-p))))
        ;; Check date2
        (let ((r2 (gethash "2024-03-15" result)))
          (is (not (getf r2 :completed)))
          (is (getf r2 :has-memo-p)))
        ;; Check date3
        (let ((r3 (gethash "2024-03-25" result)))
          (is (getf r3 :completed))
          (is (getf r3 :has-memo-p)))))))

(test get-records-for-month-excludes-other-months
  "get-records-for-month excludes records from other months"
  (with-test-db
    (let ((date-mar (local-time:encode-timestamp 0 0 0 0 15 3 2024))
          (date-apr (local-time:encode-timestamp 0 0 0 0 15 4 2024)))
      ;; Create records in different months
      (concal.models.habit-record:update-record date-mar :completed t :memo nil)
      (concal.models.habit-record:update-record date-apr :completed t :memo nil)
      ;; Get March records
      (let ((result (concal.models.habit-record:get-records-for-month 2024 3)))
        (is (= 1 (hash-table-count result)))
        (is (gethash "2024-03-15" result))
        (is (null (gethash "2024-04-15" result)))))))
