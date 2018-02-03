;Random cons pair generator
(define (random-pair-generator xlow xhigh ylow yhigh)
  (let ([nx (- xhigh xlow)]
        [ny (- yhigh ylow)])
    (cons (+ xlow (random nx)) (+ ylow (random ny)))))

;Checks if element is a member of the list
(define (is-member? element list)
  (not (null? (filter (λ(x)
                        (equal? element x))
                      list))))
 
;structure definition 
(define-struct block (xlow xhigh ylow yhigh))

;Board generator
(define (board-generator level)
  (define no-of-brick-wall-per-block
    (cond [(= level 1) 5]
          [(= level 2) 4]
          [(= level 3) 4]
          [(= level 4) 3]
          [(= level 5) 3]))
  (define brick-wall-list '())
  (define power-list '())
  (define (check-perm-wall p) ; p is a cons pair
    (and (odd? (car p)) (odd? (cdr p))))
  (define (power-pos-generator)
    (if (>= (length power-list) 3)
        power-list
        (let ([p (random-pair-generator 0 13 0 23)])
          (if (check-perm-wall p)
              (power-pos-generator)
              (if (is-member? p power-list)
                  (power-pos-generator)
                  (begin
                    (set! power-list (cons p power-list))
                    (power-pos-generator)))))))
  (define (door-generator)
    (let ([p (random-pair-generator 0 13 0 23)])
      (if (and (not (is-member? p brick-wall-list))
               (not (is-member? p power-list))
               (not (check-perm-wall p)))
          (list p)
          (door-generator)))) 
  (define (enemy-pos-generator)
    (define (helper l)
      (if(equal? 10 (length l))l
         (let ([p (random-pair-generator 0 13 0 23)])
           (if (and (not (is-member? p brick-wall-list))
                    (not (check-perm-wall p))
                    (not (and (< (car p) 4) (< (cdr p) 4)))
                    (not (is-member? p l)))
               (helper (cons p l))
               (helper l)))))
    (helper '()))
  (define (brick-wall-in-block-generator no-of-walls 
                                         blck)
    (define (helper l n)
      (if (= n 0)
          l
          (let ([p (random-pair-generator (block-ylow blck) (block-yhigh blck)
                                          (block-xlow blck) (block-xhigh blck))])
            (cond [(check-perm-wall p) (helper l n)]
                  [(is-member? p l) (helper l n)]
                  [else (helper (cons p l) (- n 1))]))))
    (helper '() no-of-walls))
  (define (last-row-generator)
    (if (>= (length brick-wall-list) (- (- 16 (* 2 level)) 1))
        (let ([p (cons 12 (random 23))])
          (if (is-member? p brick-wall-list)
              (last-row-generator)
              (set! brick-wall-list 
                    (cons p brick-wall-list))))
        (let ([p (cons 12 (random 23))])
          (if (is-member? p brick-wall-list)
              (last-row-generator)
              (begin 
                (set! brick-wall-list 
                      (cons p brick-wall-list))
                (last-row-generator))))))
  (define (next-block blck)
    (cond [(= (block-yhigh blck) 12) (block (+ (block-xlow blck) 4)
                                            (if (= (block-xhigh blck) 20)
                                                23
                                                (+ (block-xhigh blck) 4))
                                            0
                                            4)]
          [else (block (block-xlow blck)
                       (block-xhigh blck)
                       (+ (block-ylow blck) 4)
                       (+ (block-yhigh blck) 4))]))
  (define first-block (block 0 4 0 4))
  (define (first-block-generator)
    (define n
      (cond [(= level 1) 6]
            [(= level 2) 5]
            [(= level 3) 4]
            [(= level 4) 3]
            [(= level 5) 2]))
    (define (helper i l)
      (if (= i 0) l
          (let ([p (random-pair-generator 0 4 0 4)])
            (cond [(or (equal? (cons 0 0) p)
                       (equal? (cons 1 0) p)
                       (equal? (cons 0 1) p)
                       (check-perm-wall p)
                       (is-member? p l)) (helper i l)]
                  [else (helper (- i 1) (cons p l))]))))
    (set! brick-wall-list (append (helper n '()) brick-wall-list)))  
  (define (final-generator)
    (define (helper blck)
      (if (and (= 0 (block-xlow blck))
               (= 0 (block-ylow blck))
               (= 4 (block-xhigh blck))
               (= 4 (block-yhigh blck)))
          (begin
            (first-block-generator)
            (helper (next-block blck)))
          (if (and (= (block-xhigh blck) 23)
                   (= (block-yhigh blck) 12))
              (begin 
                (set! brick-wall-list 
                      (append 
                       (brick-wall-in-block-generator no-of-brick-wall-per-block
                                                      blck)
                       brick-wall-list))
                brick-wall-list)
              (begin
                (set! brick-wall-list 
                      (append 
                       (brick-wall-in-block-generator no-of-brick-wall-per-block
                                                      blck)
                       brick-wall-list))
                (helper (next-block blck))))))
    (begin
      (last-row-generator)
      (helper (block 0 4 0 4))))
  (begin
    (list (final-generator)
          (door-generator)
          (enemy-pos-generator))))