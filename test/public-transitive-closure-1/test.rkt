#lang racket

(require "../../connectivity.rkt")

(define x
  (hash "n0" (set "n0" "n1" "n3" "n5")
        "n1" (set "n0" "n1" "n2" "n3")
        "n2" (set "n2" "n3" "n4" "n5" "n6")
        "n3" (set "n3" "n0" "n1" "n2")
        "n4" (set "n4" "n6" "n7")
        "n5" (set "n5")
        "n6" (set "n4" "n6" "n7")
        "n7" (set "n0" "n7")))

(print-db x)
(print-db (transitive-closure x))

(with-output-to-file "output"
  (lambda ()
    (print-db x)
    (print-db (transitive-closure x)))
  #:exists 'replace)
