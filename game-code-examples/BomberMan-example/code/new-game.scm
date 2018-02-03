(require graphics/graphics)
; File included
(include "level.scm")
(define (new-game) ; It starts our game for the first time
  (begin
    (open-graphics) 
    (define window 
      (open-pixmap "Bomberman"
                   1350
                   950))
    ((draw-pixmap window) "Images/new-game1.jpg"
                          (make-posn 0 0)
                          (make-rgb 0 0 0))    
    (copy-viewport
     window 
     window1))    
  (define (mouse-click) ; Mouse click for selecting level
    (define p (make-posn 0 0))
    (set! p (mouse-click-posn  (get-mouse-click window1)))
    (let([x (posn-x p)] [y (posn-y p)])
      (cond[(and(>= x 110)(>= y 190)(<= x 309)(<= y 259)) (let ([f (lambda()
                                                                      (clear-viewport window1)
                                                                      (level 1))])
                                                             (f))]
           [(and(>= x 461)(>= y 191)(<= x 664)(<= y 261)) (let ([f (lambda()
                                                                      (clear-viewport window1)
                                                                      (next-level-paswd 1))])
                                                             (f))]
           [(and(>= x 290)(>= y 299)(<= x 487)(<= y 368)) (let ([f (lambda()
                                                                      (clear-viewport window1)
                                                                      (next-level-paswd 2))])
                                                             (f))]
           [(and(>= x 112)(>= y 408)(<= x 308)(<= y 477)) (let ([f (lambda()
                                                                      (clear-viewport window1)
                                                                      (next-level-paswd 3))])
                                                             (f))]
           [(and(>= x 470)(>= y 409)(<= x 667)(<= y 478)) (let ([f (lambda()
                                                                      (clear-viewport window1)
                                                                      (next-level-paswd 4))])
                                                             (f))]
           [(and(>= x 821)(>= y 536)(<= x 1064)(<= y 621)) (let ([f (lambda()
                                                                      (clear-viewport window1)
                                                                      (main))])
                                                             (f))]
           [else (mouse-click)])))
  (mouse-click))