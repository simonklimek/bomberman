(require graphics/graphics)
; Files included 
(include "new-game.scm")
(include "credits.scm")
(include "controls.scm")

(open-graphics)
(define window1 (open-viewport "Bomberman" ; Window of required size
                               1150
                               650))
(define (main) ; this is our main funtion which gets called when Ctrl + R is pressed
  (begin
    (define start 
      (open-pixmap "Bomberman"
                   1150
                   650))
    ((draw-pixmap start) "Images/1.jpg"
                         (make-posn 0 0)
                         (make-rgb 0 0 0))
    
    (copy-viewport
     start
     window1))   
  (define (mouse-click) ; Taking mouse click to decide among new game , quit etc...
    (define p (make-posn 0 0))
    (set! p (mouse-click-posn  (get-mouse-click window1)))
    (let([x (posn-x p)] [y (posn-y p)])
      (cond[(and(<= x 435)(<= y 375)(>= x 192)(>= y 286)) (let ([f (lambda()
                                                                     (clear-viewport window1)
                                                                     (new-game))])
                                                            (f))]
           [(and(<= x 710)(<= y 422)(>= x 468)(>= y 336)) (let ([f (lambda()
                                                                     (clear-viewport window1)
                                                                     (controls))])
                                                            (f))]
           
           [(and(<= x 432)(<= y 592)(>= x 189)(>= y 506))(let ([f (lambda()
                                                                    (clear-viewport window1)
                                                                    (credits))])
                                                           (f))]
           [(and(<= x 711)(<= y 538)(>= x 467)(>= y 450))(close-graphics)]
           [else (mouse-click)])))
  (mouse-click))
(main)