#lang racket

(require "../../connectivity.rkt")


(define x 
  (foldl (lambda (n hsh)
           (foldl (lambda (k hsh)
                    (add-link
                     (add-link hsh (format "~a" n) (format "~a" (+ k 1)))
                     (format "~a" n)
                     (format "~a" k)))
                  hsh
                  (range n)))
         (hash)
         (range 200)))

;;(demo )


(print-db x)

(with-output-to-file "output"
  (lambda ()
    (print-db x))
  #:exists 'replace)
