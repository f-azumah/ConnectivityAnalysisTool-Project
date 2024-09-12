#lang racket

(require "../../connectivity.rkt")

(define x (hash "n0" (set)
                "n1" (set "n1")
                "n2" (set "n1")))

;;(demo )

(displayln (forward-link? x "n0" "n2"))
(displayln (forward-link? x "n1" "n2"))
(displayln (forward-link? x "n2" "n1"))

(with-output-to-file "output"
  (lambda ()
    (displayln (forward-link? x "n0" "n2"))
    (displayln (forward-link? x "n1" "n2"))
    (displayln (forward-link? x "n2" "n1")))
  #:exists 'replace)
