(require graphics/graphics)
;Files included  
(include "board.scm")
(include "ene-move.scm")
(include "moving-object.scm")
(include "start-level.scm")
(include "game-over.scm")
(include "level-cleared.scm")
(include "paswd-window.scm")
(open-graphics)
(define brick-wall "Images/brick-wall.jpg")
(define door "Images/door.jpg")               
(define perm-wall "Images/perm-wall.jpg") 

(define (posn->cons p) ; Converts position in pixels to cons pair positions that are useful in our code
  (cons (/ (posn-y p) 50) (/ (posn-x p) 50)))

(define (cons->posn p) ; Converts cons pair into pixel position on window
  (make-posn (* 50 (cdr p)) (* 50 (car p))))

(define level-vec '()) ; initialisin level vector, This is the final maze for a particular level
                       ; It is generated using probability concepts
(define (level i)
  (define timer 0)
  (define (update-timer)
    (set! timer (+ timer 1)))
  (define level-window (open-pixmap  "Bomberman-levels" 1150 650))
  (define level-l (board-generator i))
  (init-board level-l)
  (set! level-vec board-vec)
  (define bomb-flag 0)
  
  (define (paste-image viewport pos image) ; For pasting specific images ate their appropriate positions
    (begin
      (send (vector-2d-ref level-vec (car (posn->cons pos)) (cdr (posn->cons pos)))
            set-image image)
      ((draw-pixmap viewport) image pos (make-rgb 0 0 0))))
  
  (define (set-bomby) ; It sets our bomberman on the level vector. Initial position of bomby is fixed (top left of maze)
    (begin
      (send (vector-2d-ref level-vec (car (send bomby get-pos-pair)) (cdr (send bomby get-pos-pair)))
            set-bomberman #t)
      ((draw-pixmap level-window) (send bomby get-image) (make-posn 0 0) (make-rgb 0 0 0))))
  
  (define (set-enemies l) ; It sets the images of enemies at thier generated positions 
    (if (null? l)
        #t
        (begin
          ((draw-pixmap level-window) (send (car l) get-image) (cons->posn (send (car l) get-pos-pair)) (make-rgb 0 0 0))
          (set-enemies (cdr l)))))
  
  (define (initialise) ; This pastes all the images of brick wall bomby enemies etc..
    (define (make-level)
      (define i 0)
      (define j 0)
      (define (make-level-h-1)
        (if(< i 13)
           (begin
             (make-level-h-2 (vector-ref level-vec i))
             (set! i (+ i 1))
             (make-level-h-1))
           (set! i 0)))
      (define (make-level-h-2 vec)
        (if(< j 23)
           (begin
             (cond[(and (odd? i)(odd? j))
                   (paste-image level-window (make-posn (* j 50) (* i 50)) perm-wall)]
                  [(send (vector-ref vec j) is-door?)
                   (paste-image level-window (make-posn (* j 50) (* i 50)) door)]
                  [(send (vector-ref vec j) is-brick-wall?)
                   (paste-image level-window (make-posn (* j 50) (* i 50)) brick-wall)])
             (set! j (+ j 1))
             (make-level-h-2 vec))
           (set! j 0)))
      (make-level-h-1))
    (begin
      ((draw-pixmap level-window) "Images/bg.jpg" (make-posn 0 0) (make-rgb 0 0 0))
      (make-level)
      (set-bomby)
      (set-enemies enemy-list)
      (copy-viewport level-window window1)))
  
  (define (move-bomby key-val) ; It moves bomby as per the keyboard input by user  
    (define (modify-b p)
      (let ([current-position (cons->posn (send bomby get-pos-pair))])
        (if (or (< (posn-x p) 0)
                (> (posn-x p) 1100)
                (< (posn-y p) 0)
                (> (posn-y p) 600)
                (equal? p current-position)               
                (let ([pair (posn->cons p)])
                  (or (send (vector-2d-ref level-vec (car pair) (cdr pair)) is-brick-wall?)
                      (and (odd? (car pair)) (odd? (cdr pair))))))
            #t
            (begin
              (let ([pair (posn->cons current-position)])
                (paste-image level-window current-position 
                             (send (vector-2d-ref level-vec (car pair) (cdr pair)) get-image))
                (send (vector-2d-ref level-vec (car pair) (cdr pair)) set-bomberman #f))
              (send (vector-2d-ref level-vec (car (posn->cons p)) (cdr (posn->cons p))) 
                    set-bomberman #t)
              ((draw-pixmap level-window) (send bomby get-image) p (make-rgb 0 0 0))
              (send bomby set-pos-pair (posn->cons p))
              (copy-viewport level-window window1))))) 
    
    (let ([current-posn (cons->posn (send bomby get-pos-pair))])
      (cond [(equal? 'right key-val) 
             (modify-b (make-posn (+ (posn-x current-posn) 50)
                                  (posn-y current-posn)))]
            [(equal? 'left key-val) 
             (modify-b (make-posn (- (posn-x current-posn) 50)
                                  (posn-y current-posn)))]
            [(equal? 'up key-val) 
             (modify-b (make-posn (posn-x current-posn)
                                  (- (posn-y current-posn) 50)))]
            [(equal? 'down key-val) 
             (modify-b (make-posn (posn-x current-posn)
                                  (+ (posn-y current-posn) 50)))]
            [else (modify-b current-posn)])))
  
  (define (move-villain villain) ; it moves the enemies according to the AI that we have incorporated in our game
    (define (next-posn vil)
      (let ([dir (get-ene-dir (send bomby get-prev-dir) (send bomby get-pos-pair) (send villain get-pos-pair))]
            [pair (send villain get-pos-pair)])
        (cond [(equal? dir 'r) (make-posn (+ (* 50 (cdr pair)) 50)
                                          (* 50 (car pair)))]
              [(equal? dir 'l) (make-posn (- (* 50 (cdr pair)) 50)
                                          (* 50 (car pair)))]
              [(equal? dir 'u) (make-posn (* 50 (cdr pair))
                                          (- (* 50 (car pair)) 50))]
              [(equal? dir 'd) (make-posn (* 50 (cdr pair))
                                          (+ (* 50 (car pair)) 50))]
              [(equal? dir 'f) (make-posn (* 50 (cdr pair)) (* 50 (car pair)))]
              [else #f])))
    (begin
      (let* ([pair (send villain get-pos-pair)]
             [p (next-posn villain)])
        (paste-image level-window (cons->posn pair)
                     (send (vector-2d-ref level-vec (car pair) (cdr pair)) get-image))
        (send (vector-2d-ref level-vec (car pair) (cdr pair)) set-enemy #f)
        (send (vector-2d-ref level-vec (car (posn->cons p)) (cdr (posn->cons p))) 
              set-enemy #t)
        ((draw-pixmap level-window) (send villain get-image) p (make-rgb 0 0 0))
        (send villain set-pos-pair (posn->cons p))
        (copy-viewport level-window window1))))
  
  (define (move-villains-list l) ; This function moves all the enemies that are alive..
    (if (null? l)
        #t
        (begin
          (move-villain (car l))
          (move-villains-list (cdr l)))))
  
  (define (gameflow) ; This is the function that is repeatedly called while game is in progress, it controls all activities at that time
    (let([key-p (ready-key-press window1)])
      (begin
        (if (equal? #f key-p) (void)
            (if (equal? #\space (key-value key-p))
                (plant-bomb)
                (move-bomby (key-value key-p))))
        (if (= 1 bomb-flag) (clear-off) (void))
        (if(null? bomb-list)(void)
           (let([bomb (car bomb-list)])
             (if (> 0 (send bomb get-timer-value))
                 (blast-off)
                 (send bomb update-timer))))
        
        (if(not(null? enemy-list))
           (begin
             (let([l (filter (λ(x)(equal? (send bomby get-pos-pair) (send x get-pos-pair)))
                             enemy-list)])
               (if(null? l)
                  (begin
                    (if (even? timer)
                        (begin
                          (move-villains-list enemy-list)
                          (update-timer))
                        (update-timer))
                    (sleep 0.1)
                    (gameflow))
                  (game-over))))
           (if(equal? #t (send (vector-2d-ref board-vec (car (send bomby get-pos-pair))
                                              (cdr (send bomby get-pos-pair))) is-door?))
              (begin 
                (level-cleared i)
                (next-level-paswd i))
              (gameflow))))))
  
  
  
  (define (set-flame pos); This generates list of valid positions where flames of a bomb particlar bomb can reach
    (let ([x (car pos)] [y (cdr pos)])
      (cond [(and(= x 0)(= y 0)) (let* ([x1 'null] [x2 0] [x3 'null] [x4 1]
                                                   [y1 'null][y2 1][y3 'null][y4 0]
                                                   [p (vector-2d-ref level-vec x y)]
                                                   [p2 (vector-2d-ref level-vec x2 y2)]
                                                   [p4 (vector-2d-ref level-vec x4 y4)])
                                   (begin
                                     (send p set-flame #t)
                                     (send p2 set-flame #t)
                                     (send p4 set-flame #t)
                                     (list (cons x y) (cons x2 y2) (cons x4 y4))))]
            [(and (= x 12)(= y 0)) (let*([x1 'null][x2 12][x3 11][x4 'null]
                                                   [y1 'null][y2 1][y3 0][y4 'null]
                                                   [p (vector-2d-ref level-vec x y)]
                                                   [p2 (vector-2d-ref level-vec x2 y2)]
                                                   [p3 (vector-2d-ref level-vec x3 y3)])
                                     (begin
                                       (send p set-flame #t)
                                       (send p2 set-flame #t)
                                       (send p3 set-flame #t)
                                       (list (cons x y) (cons x2 y2) (cons x3 y3))))] 
            [(and(= x 0)(= y 22)) (let*([x1 0][x2 'null][x3 'null][x4 1]
                                              [y1 21][y2 'null][y3 'null][y4 22]
                                              [p (vector-2d-ref level-vec x y)]
                                              [p1 (vector-2d-ref level-vec x1 y1)]
                                              [p4 (vector-2d-ref level-vec x4 y4)])
                                    (begin
                                      (send p set-flame #t)
                                      (send p1 set-flame #t)
                                      (send p4 set-flame #t)
                                      (list (cons x y) (cons x1 y1) (cons x4 y4))))]
            [(and(= x 12)(= y 22)) (let*([x1 12][x2 'null][x3 11][x4 'null]
                                                [y1 21][y2 'null][y3 22][y4 'null]
                                                [p (vector-2d-ref level-vec x y)]
                                                [p1 (vector-2d-ref level-vec x1 y1)]
                                                [p3 (vector-2d-ref level-vec x3 y3)])
                                     (begin
                                       (send p set-flame #t)
                                       (send p1 set-flame #t)
                                       (send p3 set-flame #t)
                                       (list (cons x y) (cons x1 y1) (cons x3 y3))))]
            [(and(= x 0)(odd? y)) (let*([x1 0][x2 0][x3 'null][x4 'null]
                                              [y1 (- y 1)][y2 (+ y 1)][y3 'null][y4 'null]
                                              [p (vector-2d-ref level-vec x y)]
                                              [p1 (vector-2d-ref level-vec x1 y1)]
                                              [p2 (vector-2d-ref level-vec x2 y2)])
                                    (begin
                                      (send p set-flame #t)
                                      (send p1 set-flame #t)
                                      (send p2 set-flame #t)
                                      (list (cons x y) (cons x1 y1) (cons x2 y2))))]
            [(and(= x 12)(odd? y)) (let*([x1 12][x2 12][x3 'null][x4 'null]
                                                [y1 (- y 1)][y2 (+ y 1)][y3 'null][y4 'null]
                                                [p (vector-2d-ref level-vec x y)]
                                                [p1 (vector-2d-ref level-vec x1 y1)]
                                                [p2 (vector-2d-ref level-vec x2 y2)])
                                     (begin
                                       (send p set-flame #t)
                                       (send p1 set-flame #t)
                                       (send p2 set-flame #t)
                                       (list (cons x y) (cons x1 y1) (cons x2 y2))))]
            [(and(odd? x)(= 0 y)) (let*([x1 'null][x2 'null][x3 (- x 1)][x4 (+ x 1)]
                                                  [y1 'null][y2 'null][y3 0][y4 0]
                                                  [p (vector-2d-ref level-vec x y)]
                                                  [p3 (vector-2d-ref level-vec x3 y3)]
                                                  [p4 (vector-2d-ref level-vec x4 y4)])
                                    (begin
                                      (send p set-flame #t)
                                      (send p3 set-flame #t)
                                      (send p4 set-flame #t)
                                      (list (cons x y) (cons x3 y3) (cons x4 y4))))]
            [(and(odd? x)(= 22 y)) (let*([x1 'null][x2 'null][x3 (- x 1)][x4 (+ x 1)]
                                                   [y1 'null][y2 'null][y3 22][y4 22]
                                                   [p (vector-2d-ref level-vec x y)]
                                                   [p3 (vector-2d-ref level-vec x3 y3)]
                                                   [p4 (vector-2d-ref level-vec x4 y4)])
                                     (begin
                                       (send p set-flame #t)
                                       (send p3 set-flame #t)
                                       (send p4 set-flame #t)
                                       (list (cons x y) (cons x3 y3) (cons x4 y4))))]
            [(and(= x 0)(even? y)) (let*([x1 0][x2 0][x3 'null][x4 (+ x 1)]
                                               [y1 (- y 1)][y2 (+ y 1)][y3 'null][y4 y]
                                               [p (vector-2d-ref level-vec x y)]
                                               [p1 (vector-2d-ref level-vec x1 y1)]
                                               [p2 (vector-2d-ref level-vec x2 y2)]
                                               [p4 (vector-2d-ref level-vec x4 y4)])
                                     (begin
                                       (send p set-flame #t)
                                       (send p1 set-flame #t)
                                       (send p2 set-flame #t)
                                       (send p4 set-flame #t)
                                       (list (cons x y) (cons x1 y1) (cons x2 y2) (cons x4 y4))))]
            [(and(= x 12)(even? y)) (let*([x1 12][x2 12][x3 (- x 1)][x4 'null]
                                                 [y1 (- y 1)][y2 (+ y 1)][y3 y][y4 'null]
                                                 [p (vector-2d-ref level-vec x y)]
                                                 [p1 (vector-2d-ref level-vec x1 y1)]
                                                 [p2 (vector-2d-ref level-vec x2 y2)]
                                                 [p3 (vector-2d-ref level-vec x3 y3)])
                                      (begin
                                        (send p set-flame #t)
                                        (send p1 set-flame #t)
                                        (send p2 set-flame #t)
                                        (send p3 set-flame #t)
                                        (list (cons x y) (cons x1 y1) (cons x2 y2) (cons x3 y3))))]
            [(and(even? x)(= 0 y))(let*([x1 'null][x2 x][x3 (- x 1)][x4 (+ x 1)]
                                                  [y1 'null][y2 (+ y 1)][y3 0][y4 0]
                                                  [p (vector-2d-ref level-vec x y)]
                                                  [p2 (vector-2d-ref level-vec x2 y2)]
                                                  [p3 (vector-2d-ref level-vec x3 y3)]
                                                  [p4 (vector-2d-ref level-vec x4 y4)])
                                    (begin
                                      (send p set-flame #t)
                                      (send p2 set-flame #t)
                                      (send p3 set-flame #t)
                                      (send p4 set-flame #t)
                                      (list (cons x y) (cons x2 y2) (cons x3 y3) (cons x4 y4))))]
            [(and(even? x)(= 22 y)) (let*([x1 x][x2 'null][x3 (- x 1)][x4 (+ x 1)]
                                                [y1 (- y 1)][y2 'null][y3 22][y4 22]
                                                [p (vector-2d-ref level-vec x y)]
                                                [p1 (vector-2d-ref level-vec x1 y1)]
                                                [p3 (vector-2d-ref level-vec x3 y3)]
                                                [p4 (vector-2d-ref level-vec x4 y4)])
                                      (begin
                                        (send p set-flame #t)
                                        (send p1 set-flame #t)
                                        (send p3 set-flame #t)
                                        (send p4 set-flame #t)
                                        (list (cons x y) (cons x1 y1) (cons x3 y3) (cons x4 y4))))]
            [(and(even? x)(even? y)) (let*([x1 x][x2 x][x3 (- x 1)][x4 (+ x 1)]
                                                 [y1 (- y 1)][y2 (+ y 1)][y3 y][y4 y]
                                                 [p (vector-2d-ref level-vec x y)]
                                                 [p1 (vector-2d-ref level-vec x1 y1)]
                                                 [p2 (vector-2d-ref level-vec x2 y2)]
                                                 [p3 (vector-2d-ref level-vec x3 y3)]
                                                 [p4 (vector-2d-ref level-vec x4 y4)])
                                       (begin
                                         (send p set-flame #t)
                                         (send p1 set-flame #t)
                                         (send p2 set-flame #t)
                                         (send p3 set-flame #t)
                                         (send p4 set-flame #t)
                                         (list (cons x y) (cons x1 y1) (cons x2 y2) (cons x3 y3) (cons x4 y4))))]
            [(and(even? x)(odd? y)) (let*([x1 x][x2 x][x3 'null][x4 'null]
                                                [y1 (- y 1)][y2 (+ y 1)][y3 'null][y4 'null]
                                                [p (vector-2d-ref level-vec x y)]
                                                [p1 (vector-2d-ref level-vec x1 y1)]
                                                [p2 (vector-2d-ref level-vec x2 y2)])
                                      (begin
                                        (send p set-flame #t)
                                        (send p1 set-flame #t)
                                        (send p2 set-flame #t)
                                        (list (cons x y) (cons x1 y1) (cons x2 y2))))]
            [(and(odd? x)(even? y)) (let*([x1 'null][x2 'null][x3 (- x 1)][x4 (+ x 1)]
                                                    [y1 'null][y2 'null][y3 y][y4 y]
                                                    [p (vector-2d-ref level-vec x y)]
                                                    [p3 (vector-2d-ref level-vec x3 y3)]
                                                    [p4 (vector-2d-ref level-vec x4 y4)])
                                      (begin
                                        (send p set-flame #t)
                                        (send p3 set-flame #t)
                                        (send p4 set-flame #t)
                                        (list (cons x y) (cons x3 y3) (cons x4 y4))))])))
  
  (define (plant-bomb) ; This displays image of bomb and starts its timer
    (if (null? bomb-list)
        (let ([bomb (new bomb% [timer 3] [bomb-pos (send bomby get-pos-pair)] [flame-l (set-flame (send bomby get-pos-pair))])])
          (begin
            (set! bomb-list (cons bomb bomb-list))
            (send (vector-2d-ref level-vec (car (send bomby get-pos-pair)) (cdr (send bomby get-pos-pair)))
                  set-bomb #t)
            (paste-image level-window (cons->posn (send bomb get-bomb-pos)) "Images/bomb1.jpg")))
        (void)))
  
  (define (remove1 x l)
    (if(null? l)'()
       (if(equal? x (car l))(cdr l)
          (cons (car l) (remove1 x (cdr l))))))
  
  (define (kill-that-enemy p) ; this is used to kill enemy objects from enemy list
    (let([l (filter (λ(x)(equal? (get-field pos-pair x) p)) enemy-list)])
      (set! enemy-list (remove1 (car l) enemy-list))))
  
  (define (check-pos pos) ; It does all functionalities of bomb  like killing enemy objects or killing bombeman and calling gameover 
    ; or removing brick walls upon explosion
    (let ([p (vector-2d-ref level-vec (car pos) (cdr pos))])
      (cond [(send p is-brick-wall?)
             (begin
               (send p set-brick-wall #f)
               ((draw-pixmap level-window) "Images/flame.png" (cons->posn pos) (make-rgb 0 0 0)))]
            [(send p is-enemy?) (begin                                
                                  (send p set-enemy #f)
                                  (kill-that-enemy pos)
                                  ((draw-pixmap level-window) "Images/flame.png" (cons->posn pos) (make-rgb 0 0 0)))]
            
            [(send p is-bomberman?) (game-over)]
            [else ((draw-pixmap level-window) "Images/flame.png" (cons->posn pos) (make-rgb 0 0 0))])))
  
  (define (blast-off) ; This is called when timer of any bomb hits zero 
    (let* ([bomb (car bomb-list)]
           [l (send bomb get-flame-l)])
      (display '&)
      (define (helper l)
        (if (null? l)(void)
            (begin
              (check-pos (car l))
              (helper (cdr l)))))
      (begin
        (helper l)
        (set! bomb-flag 1))))
  
  (define (clear-off) ; It does graphical part after bomb explosion like pasting images of background in place of brick walls etc..
    (define (helper l)
      (if(null? l)(void)
         (begin
           (send (vector-2d-ref level-vec (car (send (car bomb-list) get-bomb-pos))
                                (cdr (send (car bomb-list) get-bomb-pos)))
                 set-bomb #f)
           (if (send (vector-2d-ref level-vec (caar l) (cdar l)) is-door?)
               (paste-image level-window (cons->posn (car l)) "Images/door.jpg")  
               (paste-image level-window (cons->posn (car l)) "Images/bg-block.jpg"))
           (helper (cdr l)))))
    (begin
      (set! bomb-flag 0)
      (helper (send (car bomb-list) get-flame-l))
      (set! bomb-list '())))  
  (begin
    (initialise)
    (gameflow)))