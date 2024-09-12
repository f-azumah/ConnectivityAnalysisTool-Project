#lang racket

(require "../../connectivity.rkt")

(define x (hash "n0" (set)
                "n1" (set "n0")
                "n2" (set "n0")))

;;(demo )


(print-db (add-link x "n0" "n0"))
(print-db (add-link (add-link x "n0" "n0") "n0" "n0"))

(with-output-to-file "output"
  (lambda ()
    (print-db (add-link x "n0" "n0"))
    (print-db (add-link (add-link x "n0" "n0") "n0" "n0")))
  #:exists 'replace)
