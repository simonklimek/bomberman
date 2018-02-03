(require graphics/graphics)
(open-graphics)
(define x-list '(1 0 1 1 0 1 0 0))
(define y-list '(0 1 0 0 -1 0 1 1))
(define p (make-posn 0 0))
(define window1 (open-viewport "Bomberman" 1150 650))                             
(define start (open-pixmap "Bomberman" 1150 650)) 


(define (update-position)
  (begin
    (set! p (make-posn (+ (posn-x p) (* 50 (car x-list)))
                       (+ (posn-y p) (* 50 (car y-list)))))
    (set! x-list (cdr x-list))
    (set! y-list (cdr y-list))
    p))

(define (movement)
  ((clear-solid-rectangle start) p 50 50)
  ((draw-pixmap start) "Images/bg-block.jpg"
                       (update-position)
                       (make-rgb 0 0 0))
  (sleep 0.5)
  (copy-viewport start window1)
  (movement)) 

(movement)