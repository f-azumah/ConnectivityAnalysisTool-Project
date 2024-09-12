#lang racket

(require "../../connectivity.rkt")

(define x (hash "n0" (set)
                "n1" (set "n0")
                "n2" (set "n0")))

;;(demo )


(print-db (add-link x "n0" "n1"))
(print-db (add-link (add-link x "n0" "n1") "n1" "n2"))
(print-db (add-link (add-link (add-link x "n0" "n1") "n1" "n2") "n2" "n1"))
(print-db (add-link (add-link (add-link (add-link x "n0" "n1") "n1" "n2") "n2" "n1") "n2" "n2"))

(with-output-to-file "output"
  (lambda ()
    (print-db (add-link x "n0" "n1"))
    (print-db (add-link (add-link x "n0" "n1") "n1" "n2"))
    (print-db (add-link (add-link (add-link x "n0" "n1") "n1" "n2") "n2" "n1"))
    (print-db (add-link (add-link (add-link (add-link x "n0" "n1") "n1" "n2") "n2" "n1") "n2" "n2")))
  #:exists 'replace)
