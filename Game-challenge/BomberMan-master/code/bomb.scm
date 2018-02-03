;Defining bomb% class , all bombs that are placed and exploded are objects of this class 

(define bomb%
  (class object%
    (init-field (timer 0.0)) ; timer that keeps record of time after which bomb should explode like in circuit simulation
    (init-field (bomb-pos  (cons 0 0))) ; Position where bomb is set
    (init-field (flame-l '())) ; List of positions where flame of any bomb can reach in form of cons pairs 
    (super-new)
    (define/public (get-timer-value) timer) 
    (define/public (get-bomb-pos) bomb-pos)
    (define/public (get-flame-l) flame-l)
    (define/public (set-timer-value val)
      (set! timer val))
    (define/public (update-timer) (set! timer (- timer 0.2)))
    (define/public (set-flame-l l)
      (set! flame-l l))
    (define/public (set-bomb-pos p)
      (set! bomb-pos p))))