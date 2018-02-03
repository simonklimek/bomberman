; This calls function for next level once any particular level is cleared
(define (level-cleared i)
  ((draw-pixmap window1) (im i) (make-posn 0 0) (make-rgb 0 0 0))  
  (if (= i 5)
      (close-graphics)
      (sleep 2)))

(define (im i)
  (cond [(= i 1) "Images/level1.jpg"]
        [(= i 2) "Images/level2.jpg"]
        [(= i 3) "Images/level3.jpg"]
        [(= i 4) "Images/level4.jpg"]
        [(= i 5) "Images/level5.jpg"])) 