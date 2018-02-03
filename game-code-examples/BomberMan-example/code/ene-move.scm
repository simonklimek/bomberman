; contains the AI of our game
; determining the movement of enemies taking into account the direction of motion of bomber-man 
;relative positions of bomber-man and enemies

(define (get-ene-dir bdir bpos ene-pos)
  (define(helper)   
    ; takes the bomby directionas input and generates a list of four lists corresponding to
    ;the 4 quadrants of enemy  
    (define list-for-all-quads       
      (cond [(eq? 'right bdir) (list '(d l r u)
                                     '(r d u l)
                                     '(r u l d)
                                     '(u l r d))]
            [(eq? 'left bdir) (list '(l d r u)
                                    '(d r u l)
                                    '(u r l d)
                                    '(l u r d))]
            [(eq? bdir 'down) (list '(d l u r) 
                                    '(d r u l)
                                    '(r u l d)
                                    '(l u r d))]
            [(eq? bdir 'up) (list '(l d u r)
                                  '(r d u l)
                                  '(u r l d)
                                  '(u l r d))]
            [else (list '(d l r u)
                        '(r d u l)
                        '(r u l d)
                        '(u l r d))]))
    
    (define (quadrant-of-ene)   ; decides the quadrant of enemy 
      (let([bx (cdr bpos)]
           [by (car bpos)]
           [ex (cdr ene-pos)]
           [ey (car ene-pos)]) 
        (cond [(< bx ex) (if (< ey by) 1 4)]
              [else (if (< ey by) 2 3)])))
    
    (define (desired-list quad); extracts the desired list after taking ene-quadrant
      (cond[(= 1 quad) (first list-for-all-quads)]
           [(= 2 quad) (second list-for-all-quads)]
           [(= 3 quad) (third list-for-all-quads)]
           [(= 4 quad) (fourth list-for-all-quads)]))
     ;;the list is arranged in decreasing order of probabilities of its elements 
  ;(representing directions) 
  ;the probabilities are ensured using following function
     (define (assgn-prob l)
      (let([n (remainder (random 400) 20)])
        (cond[(and(<= 8 n)(>= 15 n)) (first l)]
             [(or(and(<= 5 n) (>= 7 n))(and(<= 16 n)(>= 18 n))) (second l)]
             [(and (<= 0 n)(>= 2 n)) (third l)]
             [else (fourth l)])))
    
    (assgn-prob (desired-list (quadrant-of-ene))))
  
 
  (define (gettable? pos); checks whether a position is achievable
    (let ([rowno (car pos)]
          [colno (cdr pos)])
      (if (send (vector-2d-ref level-vec rowno colno) is-any-thing?) #f #t)))
    
  (define (bomb-in-path? cur-pos next-dir); checks if there is a bomb placed in the path of enemy
    (if (null? bomb-list) #f
        (let ([bomb-pos (send (car bomb-list) get-bomb-pos)])
          (cond [(equal? next-dir 'r) (if (equal? (car cur-pos)(car bomb-pos))
                                             (if (> (cdr cur-pos)(cdr bomb-pos)) #f #t)
                                             #f)]
                [(equal? next-dir 'l) (if (equal? (car cur-pos)(car bomb-pos))
                                          (if (< (cdr cur-pos)(cdr bomb-pos)) #f #t)
                                          #f)]
                [(equal? next-dir 'u) (if (equal? (cdr cur-pos)(cdr bomb-pos))
                                          (if (< (car cur-pos)(car bomb-pos)) #f #t)
                                          #f)]
                [(equal? next-dir 'd) (if (equal? (cdr cur-pos)(cdr bomb-pos))
                                         (if (> (car cur-pos)(car bomb-pos)) #f #t)
                                         #f)]))))
  
  ; generates final movement of enemy after checking all conditons
  (define (loop-till-final counter counter1)            
    (let* ([dir1 (helper)]
           [next-pos (cond [(equal? dir1 'r) (cons (car ene-pos)  (+ (cdr ene-pos) 1))]
                            [(equal? dir1 'l) (cons (car ene-pos)  (- (cdr ene-pos) 1))]
                            [(equal? dir1 'u) (cons (- (car ene-pos) 1) (cdr ene-pos))]
                            [(equal? dir1 'd) (cons (+ (car ene-pos) 1) (cdr ene-pos))])])
      (if(not(and(<= (car next-pos) 12)(>= (car next-pos) 0)(<= (cdr next-pos) 22)(>= (cdr next-pos) 0))) 
         (loop-till-final counter counter1)   
         (if (gettable? next-pos) 
             (if (and (< counter 3) 
                      (bomb-in-path? ene-pos next-pos))
                 (loop-till-final (+ 1 counter) counter1)
                 dir1)
             (if (> counter1 10) 
                 'f
                 (loop-till-final counter (+ counter1 1)))))))
  (loop-till-final 0 0))
