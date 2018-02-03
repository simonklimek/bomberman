#lang racket

(require gaming)

(define init-ball-count 20)
(define ball-radius 25)

(define the-screen (new screen% [width 600] [height 600]))

(define the-world 
  (new world%
       [screen the-screen]
       [gravity (make-point 0 300)]))

(define (random-position)
  (make-point 
    (random (send the-screen get-width))
    (random (send the-screen get-height))))

(define ball%
  (class game-object%
    (super-new 
      [world the-world]
      [image (bitmap/sized (* ball-radius 2) (* ball-radius 2) gaming/examples/assets/football.png)]
      ;[image (rectangle 10 20 "solid" "red")]
      [shape (new circle% 
                  [radius ball-radius]
                  [friction 0.5]
                  [elasticity 1.0])])))

(define balls
  (build-list init-ball-count (lambda (i) (new ball% [position (random-position)]))))

(define sw (- (send the-screen get-width) ball-radius))
(define sh (- (send the-screen get-height) (* 2 ball-radius)))

(define top 
  (new segment%
       [friction 1.0]
       [elasticity 1.0]
       [a (make-point 0 0)]
       [b (make-point sw 0)]))

(define bottom
  (new segment%
       [friction 1.0]
       [elasticity 1.0]
       [a (make-point 0 sh)]
       [b (make-point sw sh)]))

(define right
  (new segment%
       [friction 1.0]
       [elasticity 1.0]
       [a (make-point sw 0)]
       [b (make-point sw sh)]))

(define left
  (new segment%
       [friction 1.0]
       [elasticity 1.0]
       [a (make-point (- ball-radius) 0)]
       [b (make-point (- ball-radius) sh)]))

(send the-world add-shapes bottom top right left)

(send the-world play)

