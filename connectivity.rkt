;; Honor Pledge (bottom too) FILL IN NAME:
;;
;; I Fiona Azumah submit this assignment as my own work
#lang racket
(provide (all-defined-out))


(define x
  (hash "main-server" (set "switch" "backup-srv" "db-server")
        "switch" (set "main-server" "db-server" "backup-srv")
        "backup-srv" (set "main-server" "db-server" "switch")
        "db-server" (set "main-server" "switch" "backup-srv")))

;; return a list of nodes pointed to by `from` in `graph`
(define (nodes-to graph from)
  (set->list (hash-ref graph from)))

;;
;; CIS352 (Fall 22) Project 2 -- Network Connectivity
;; 

;; To see the demo, invoke using:
;;     racket connectivity.rkt <input-file>.net
;;     racket connectivity.rkt <input-file>.net "CONNECTED <from> <to>"

;; Lines are pared into an intermediate representation satisfying the
;; line? predicate.
(define (line? l)
  (match l
    [`(node ,(? string? node-name)) #t]
    [`(link ,(? string? from-node) ,(? string? to-node)) #t]
    [_ #f]))

;; The input format is a list of line?s
(define (input-format? lst)
  (and (list? lst)
       (andmap line? lst)))

;; A graph? is a hash table whose keys are strings and whose values
;; are sets of strings.
(define (graph? gr) (and (hash? gr)
                         (immutable? gr)
                         (andmap string? (hash-keys gr))
                         (andmap (lambda (key) (andmap string? (set->list (hash-ref gr key))))
                                 (hash-keys gr))))


;; 
;; BEGIN PROJECT BELOW
;; 

;; TODO
;; Parse a line of text input. Lines will have the following format:
;;     NODE <node-name>
;;     LINK <node-name> <node-name>
;; 
;; Hint: use string-split and match, make sure to produce something
;; that adheres to `line?`.
(define/contract (parse-line l)
  (-> string? line?)
  ;; pieces is a list of strings
  (define pieces (string-split l))
  (match pieces
    [`("NODE" ,n)
     (list 'node n)]
    [`("LINK" ,n1 ,n2)
     (list 'link n1 n2)]
    [_ (error "Invalid Input")]))

;; starter code
;; read a file by mapping over its lines  
(define/contract (read-file f)
  (-> string? input-format?)
  (map parse-line (file->lines f)))

;; TODO 
;; Input is a list of line? commands. Write a recursive function which
;; builds up a hash.
;; 
;; - If it's a `node` command, add a link from a node to itself.
;; - If it's a `link` command, add a directional link as specified.
;;
;; Hint: use (hash), (set n), hash-set, set-add, hash-ref, and similar.
(define/contract (build-init-graph input)
  (-> input-format? graph?)
  (define (read-line input graph)
    (if (empty? input)
        graph
        (let ((line (car input))
              (rest (cdr input)))
          (match line
            [`(node ,n)
             (let ((ex-nodes (hash-ref graph n '())))
               (read-line rest (hash-set graph n (set-add ex-nodes n))))]
            [`(link ,n1 ,n2)
             (let ((ex-nodes (hash-ref graph n1 '()))) 
               (read-line rest (hash-set graph n1 (set-add ex-nodes n2))))]
            [_ (error "Invalid Input")]))))
  (read-line input (hash)))
 
;; TODO
;; Check whether or not there is a forward line from n0 to n1 in
;; graph.
;; 
;; Hint: use set-member? and hash-ref
(define (forward-link? graph n0 n1)
  ;; first, look up the set of nodes which are adjacent to (i.e., neighbors of) n0
  ;; then, check if n1 is a member of that set
  (define set-of-nodes (list->set (hash-ref graph n0)))
  (set-member? set-of-nodes n1))
;; TODO
;; Add a directed link (from,to) to the graph graph, return the new graph with 
;; the additional link.
;;
;; Hint: use hash-set, hash-ref, and set-add.
(define (add-link graph from to)
  (hash-set graph
            from
            (set-add (hash-ref graph from (set))
                     to)))

;; TODO
;; Perform the transitive closure of the graph. This is the most challenging 
;; operation in the project, so we recommend putting it off until the end.
;; 
;; To perform the transitive closure of the graph, iteratively add links
;; whenever you find a matching (x,y) and (y,z). This can be done in one of 
;; two broad ways: (a) chaotic iteration or (b) semi-naive evaluation. 
;; Read the project description for more details and hints at a solution.
;; 
;; My solution uses `foldl`, `hash-keys`, `set->list`, `hash-ref`, and 
;; `add-link`. It is always possible to use a recursive helper function instead
;; of a foldl, but it makes the code much easier to understand in my opinion.
(define (transitive-closure graph)
  (define (one-step-transitive graph)
    (foldl (lambda (n0 graph)
             (foldl (lambda (n1 graph)
                      (foldl (lambda (n2 graph)
                               (if (and (not (equal? n0 n1)) (forward-link? graph n1 n2))
                                   (add-link graph n0 n2)
                                   graph))
                             graph
                             (set->list (hash-ref graph n1))))                                            
                           
                      graph
                      (set->list (hash-ref graph n0))))
             graph
             (hash-keys graph)))
  
  (define (loop graph)
    (if (equal? (one-step-transitive graph) graph)
        graph 
        (loop (one-step-transitive graph))))
  (loop graph))



;;
;; END PROJECT CODE, DO NOT TOUCH BELOW
;;

;; Print a DB
(define (print-db db)
  (for ([key (sort (hash-keys db) string<?)])
    (displayln (format "Key ~a:" key))
    (displayln (string-append "    " (string-join (sort (set->list (hash-ref db key)) string<?) ", ")))))

(define (demo file query)
  (define ir (read-file file))
  (define initial-db (build-init-graph ir))
  (displayln "The input is:")
  (print-db initial-db)
  (displayln "Now running transitive closure...")
  (define final-db (transitive-closure initial-db))
  (displayln "Transitive closure:")
  (print-db final-db)
  (unless (equal? query "")
    (match (string-split query)
      [`("CONNECTED" ,n0 ,n1)
        (if (forward-link? final-db n0 n1)
          (displayln "CONNECTED")
          (displayln "DISCONNECTED"))])))

(match-define (cons file query)
  (command-line
   #:program "connectivity.rkt"
   #:args ([filename ""]  [query ""])
   (cons filename query)))

;; if called with a single argument, this racket program will execute
;; the demo.
(if (not (equal? file "")) (demo file query) (void))
