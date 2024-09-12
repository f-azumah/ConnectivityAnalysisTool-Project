#lang racket

(require "../../connectivity.rkt")

(define in
  '((node "n0")
    (node "n1")
    (link "n0" "n1")))

(print-db (build-init-graph in))

(with-output-to-file "output"
  (lambda ()
    (print-db (build-init-graph in)))
  #:exists 'replace)
