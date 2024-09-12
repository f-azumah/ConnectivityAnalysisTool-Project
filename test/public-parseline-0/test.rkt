#lang racket

(require "../../connectivity.rkt")

;;(demo )

(displayln (parse-line "NODE n0"))
(displayln (parse-line "NODE n1"))

(with-output-to-file "output"
  (lambda ()
    (displayln (parse-line "NODE n0"))
    (displayln (parse-line "NODE n1")))
  #:exists 'replace)
