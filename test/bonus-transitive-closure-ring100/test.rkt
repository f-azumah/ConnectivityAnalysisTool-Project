#lang racket

(require "../../connectivity.rkt")


(define (ext h x y)
  (hash-set h x (set-add (hash-ref h x (set)) y)))

(define (ring n)
  (define (h graph i)
    (if (> i (- n 1)) graph (h (ext graph (number->string i)
                              (number->string (add1 i)))
                         (+ i 1))))
  (ext (h (hash) 0) (number->string n) "0"))

(define x (ring 100))

(print-db x)
(print-db (transitive-closure x))

(with-output-to-file "output"
  (lambda ()
    (print-db x)
    (print-db (transitive-closure x)))
  #:exists 'replace)
