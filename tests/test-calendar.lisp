(in-package #:concal.tests)

(in-suite calendar-tests)

;;; Tests for get-first-day-of-week
;;; Returns day of week (0=Sunday, 1=Monday, ..., 6=Saturday)

(test first-day-of-week-january-2024
  "January 2024 starts on Monday (1)"
  (is (= 1 (concal.views.calendar::get-first-day-of-week 2024 1))))

(test first-day-of-week-february-2024
  "February 2024 starts on Thursday (4)"
  (is (= 4 (concal.views.calendar::get-first-day-of-week 2024 2))))

(test first-day-of-week-march-2024
  "March 2024 starts on Friday (5)"
  (is (= 5 (concal.views.calendar::get-first-day-of-week 2024 3))))

(test first-day-of-week-september-2024
  "September 2024 starts on Sunday (0)"
  (is (= 0 (concal.views.calendar::get-first-day-of-week 2024 9))))

(test first-day-of-week-december-2025
  "December 2025 starts on Monday (1)"
  (is (= 1 (concal.views.calendar::get-first-day-of-week 2025 12))))

;;; Tests for get-days-in-month

(test days-in-january
  "January has 31 days"
  (is (= 31 (concal.views.calendar::get-days-in-month 2024 1))))

(test days-in-february-normal
  "February 2023 (non-leap year) has 28 days"
  (is (= 28 (concal.views.calendar::get-days-in-month 2023 2))))

(test days-in-february-leap-year
  "February 2024 (leap year) has 29 days"
  (is (= 29 (concal.views.calendar::get-days-in-month 2024 2))))

(test days-in-february-century-non-leap
  "February 2100 (century, not divisible by 400) has 28 days"
  (is (= 28 (concal.views.calendar::get-days-in-month 2100 2))))

(test days-in-february-century-leap
  "February 2000 (century, divisible by 400) has 29 days"
  (is (= 29 (concal.views.calendar::get-days-in-month 2000 2))))

(test days-in-april
  "April has 30 days"
  (is (= 30 (concal.views.calendar::get-days-in-month 2024 4))))

(test days-in-december
  "December has 31 days"
  (is (= 31 (concal.views.calendar::get-days-in-month 2024 12))))
