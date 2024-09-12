#lang racket

(require "../../connectivity.rkt")

(define x (hash "n0" (set "n0")
                "n1" (set "n1" "n0")
                "n2" (set "n2" "n0")))

(print-db x)
(print-db (transitive-closure x))

(with-output-to-file "output"
  (lambda ()
    (print-db x)
    (print-db (transitive-closure x)))
  #:exists 'replace)
