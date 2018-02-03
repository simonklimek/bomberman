#lang racket

(define circle-radius 25)

(require gaming)

(define the-screen
  (new screen%
       [title "My First Game!"]
       [width 600]
       [height 600]))

(define the-world 
  (new world% 
       [screen the-screen]
       [gravity (make-point 0 9.81)]))

(define the-ground
  (new segment%
       [a (make-point 0 (- (send the-screen get-height) (* circle-radius 2)))]
       [b (make-point (send the-screen get-width) (- (send the-screen get-height) (* circle-radius 2)))]
       [elasticity 1.0]
       [friction 1.0]))

(send the-world add-shapes the-ground)

(define falling-circle
  (new game-object%
       [world the-world]
       [position (make-point 300 300)]
       [image (circle circle-radius "solid" "blue")]
       [shape
         (new circle%
              [radius circle-radius]
              [elasticity 1.0]
              [friction 1.0])]))

(send the-world play)

