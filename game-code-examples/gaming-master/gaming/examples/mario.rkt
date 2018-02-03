#lang racket

(require gaming)

(define the-screen
  (new screen% 
       [width 800]
       [height 500]))

(define the-world
  (new world% [screen the-screen]))

(define mario
  (new game-object%
       [world the-world]
       [controlled? #t]
       [position (new point% [x 0] [y 0])]))

(define ground-line
  (new segment%
       [body (send the-world get-body)]
       [a (new point% [x 0] [y 0])]
       [b (new point% [x (send the-screen get-width)] [y 0])]))

