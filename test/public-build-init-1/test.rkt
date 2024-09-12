#lang racket

(require "../../connectivity.rkt")

(define in
  '((node "n0")
    (node "n1")
    (node "n2")
    (node "n3")
    (node "n4")
    (link "n0" "n1")
    (link "n1" "n2")
    (link "n2" "n3")
    (link "n0" "n3")
    (link "n4" "n3")
    (link "n3" "n3")
    (link "n1" "n0")))

(print-db (build-init-graph in))

(with-output-to-file "output"
  (lambda ()
    (print-db (build-init-graph in)))
  #:exists 'replace)
