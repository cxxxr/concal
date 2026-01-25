(defpackage #:concal.tests
  (:use #:cl)
  (:import-from #:fiveam
                #:def-suite
                #:in-suite
                #:test
                #:is
                #:run!)
  (:export #:run-all-tests
           #:run-unit-tests
           #:run-integration-tests
           #:calendar-tests
           #:api-tests
           #:model-tests))
(in-package #:concal.tests)

;; Define test suites
(def-suite calendar-tests
  :description "Calendar calculation tests (no DB required)")

(def-suite api-tests
  :description "API utility tests (no DB required)")

(def-suite model-tests
  :description "Model tests (DB required)")

(def-suite all-tests
  :description "All ConCal tests")

(defun run-all-tests ()
  "Run all tests."
  (run! 'calendar-tests)
  (run! 'api-tests)
  (run! 'model-tests))

(defun run-unit-tests ()
  "Run only unit tests (no DB required)."
  (run! 'calendar-tests)
  (run! 'api-tests))

(defun run-integration-tests ()
  "Run only integration tests (DB required)."
  (run! 'model-tests))
