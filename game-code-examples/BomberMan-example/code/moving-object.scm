;Moving object Class for bomberman and enemies

(define moving-object%
  (class object%
    (init-field [pos-pair (cons 0 0)])
    (init-field [dir 1])
    (init-field [prev-dir #f])
    (init-field [speed-factor 5]) 
    (init-field [image "str"])
    (init-field [alive #t])
    (super-new)
    (define/public (get-pos-pair) pos-pair)
    (define/public (get-image) image)
    (define/public (get-dir) dir)
    (define/public (get-speed-factor) speed-factor)
    (define/public (get-prev-dir)  prev-dir)
    (define/public (get-alive?) alive)
    (define/public (set-pos-pair p) 
      (set! pos-pair p))
    (define/public (set-image adr) 
      (set! image adr))
    (define/public (set-dir i) 
      (set! dir i))
    (define/public (set-speed-factor f) 
      (set! speed-factor f))
    (define/public (set-alive val) 
      (set! alive val))))

(define bomberman%
  (class moving-object%
    (init-field [bomb-no 1])
    (super-new)
    (define/public (get-bomb-no) bomb-no)
    (define/public (set-bomb-no n)
      (set! bomb-no n))))

(define enemy%
  (class moving-object%
    (super-new)
    (init-field [target-pos (cons 0 0)])
    (init-field [enemy-index 0])
    (define/public (set-target-pos p)
      (set! target-pos p)))) 