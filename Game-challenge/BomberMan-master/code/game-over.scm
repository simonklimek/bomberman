;Displays gameover window when bomby dies 

(define (game-over)
  ((draw-pixmap window1) "Images/game-over.jpg" (make-posn 0 0) (make-rgb 0 0 0))
  (sleep 2)
  (close-graphics)) 