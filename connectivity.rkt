
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

;; read a file by mapping over its lines  
(define/contract (read-file f)
  (-> string? input-format?)
  (map parse-line (file->lines f)))




(define/contract (build-init-graph input)
;; builds up a hash
;; - If it's a `node` command, add a link from a node to itself.
;; - If it's a `link` command, add a directional link as specified.
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
 

(define (forward-link? graph n0 n1)
;; Check whether or not there is a forward line from n0 to n1 in
;; graph.
  ;; first, look up the set of nodes which are adjacent to (i.e., neighbors of) n0
  ;; then, check if n1 is a member of that set
  (define set-of-nodes (list->set (hash-ref graph n0)))
  (set-member? set-of-nodes n1))


(define (add-link graph from to)
;; Add a directed link (from,to) to the graph graph, return the new graph with 
;; the additional link.
  (hash-set graph
            from
            (set-add (hash-ref graph from (set))
                     to)))

(define (transitive-closure graph)
;; Perform the transitive closure of the graph. Iteratively adding links
;; whenever there is a matching (x,y) and (y,z).
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
