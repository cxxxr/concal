(in-package #:concal.tests)

(in-suite api-tests)

;;; Tests for parse-date-string
;;; Parses YYYY-MM-DD format strings into local-time:timestamp

(test parse-valid-date
  "Parse a valid date string"
  (let ((result (concal.handlers.api::parse-date-string "2024-01-15")))
    (is (not (null result)))
    (is (= 2024 (local-time:timestamp-year result)))
    (is (= 1 (local-time:timestamp-month result)))
    (is (= 15 (local-time:timestamp-day result)))))

(test parse-date-first-of-month
  "Parse first day of month"
  (let ((result (concal.handlers.api::parse-date-string "2024-03-01")))
    (is (not (null result)))
    (is (= 2024 (local-time:timestamp-year result)))
    (is (= 3 (local-time:timestamp-month result)))
    (is (= 1 (local-time:timestamp-day result)))))

(test parse-date-end-of-month
  "Parse last day of month"
  (let ((result (concal.handlers.api::parse-date-string "2024-12-31")))
    (is (not (null result)))
    (is (= 2024 (local-time:timestamp-year result)))
    (is (= 12 (local-time:timestamp-month result)))
    (is (= 31 (local-time:timestamp-day result)))))

(test parse-date-leap-year
  "Parse leap year date"
  (let ((result (concal.handlers.api::parse-date-string "2024-02-29")))
    (is (not (null result)))
    (is (= 29 (local-time:timestamp-day result)))))

;;; Invalid format tests

(test parse-invalid-format-slash
  "Reject date with slashes"
  (is (null (concal.handlers.api::parse-date-string "2024/01/15"))))

(test parse-invalid-format-no-separator
  "Reject date without separators"
  (is (null (concal.handlers.api::parse-date-string "20240115"))))

(test parse-invalid-format-short-year
  "Reject date with short year"
  (is (null (concal.handlers.api::parse-date-string "24-01-15"))))

(test parse-invalid-format-single-digit-month
  "Reject date with single digit month"
  (is (null (concal.handlers.api::parse-date-string "2024-1-15"))))

(test parse-invalid-format-single-digit-day
  "Reject date with single digit day"
  (is (null (concal.handlers.api::parse-date-string "2024-01-5"))))

(test parse-invalid-format-empty
  "Reject empty string"
  (is (null (concal.handlers.api::parse-date-string ""))))

(test parse-invalid-format-random
  "Reject random string"
  (is (null (concal.handlers.api::parse-date-string "not-a-date"))))

(test parse-invalid-format-extra-chars
  "Reject date with extra characters"
  (is (null (concal.handlers.api::parse-date-string "2024-01-15T00:00:00"))))
