#lang racket

(require "../../connectivity.rkt")

(define x (hash "n0" (set "n1" "n0" "n2")
                "n1" (set "n0" "n2")
                "n2" (set "n0")
                "n3" (set "n0" "n1" "n2")))

;;(demo )

(displayln (forward-link? x "n0" "n2"))
(displayln (forward-link? x "n1" "n1"))
(displayln (forward-link? x "n3" "n0"))
(displayln (forward-link? x "n3" "n1"))
(displayln (forward-link? x "n3" "n3"))
(displayln (forward-link? x "n2" "n3"))
(displayln (forward-link? x "n2" "n1"))
(displayln (forward-link? x "n2" "n0"))

(with-output-to-file "output"
  (lambda ()
    (displayln (forward-link? x "n0" "n2"))
    (displayln (forward-link? x "n1" "n1"))
    (displayln (forward-link? x "n3" "n0"))
    (displayln (forward-link? x "n3" "n1"))
    (displayln (forward-link? x "n3" "n3"))
    (displayln (forward-link? x "n2" "n3"))
    (displayln (forward-link? x "n2" "n1"))
    (displayln (forward-link? x "n2" "n0")))
  #:exists 'replace)
