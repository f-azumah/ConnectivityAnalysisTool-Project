#lang racket

(require "../../connectivity.rkt")

;;(demo )

(displayln (parse-line "NODE n0"))
(displayln (parse-line "NODE n1"))
(displayln (parse-line "NODE n2"))
(displayln (parse-line "NODE n3"))
(displayln (parse-line "LINK n0 n1"))
(displayln (parse-line "LINK n2 n3"))
(displayln (parse-line "LINK n3 n1"))

(with-output-to-file "output"
  (lambda ()
    (displayln (parse-line "NODE n0"))
    (displayln (parse-line "NODE n1"))
    (displayln (parse-line "NODE n2"))
    (displayln (parse-line "NODE n3"))
    (displayln (parse-line "LINK n0 n1"))
    (displayln (parse-line "LINK n2 n3"))
    (displayln (parse-line "LINK n3 n1")))
  #:exists 'replace)
