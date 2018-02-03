#lang racket

(require gaming)

(define cannon-move-speed 120)
(define cannon-image (rectangle 10 20 "solid" "white"))
(define min-static-time 250)
(define max-static-time 5000)
(define min-explode-strength 10)
(define max-explode-strength 100)
(define min-num-shards 2)
(define max-num-shards 25)
(define min-bolt-radius 10)
(define max-bolt-radius 25)
(define min-shard-radius 10)
(define max-shard-radius 25)

(define (random-between min max)
  (+ min (random (- max min))))

(define (random-color)
  (make-color (random 255) (random 255) (random 255)))

(define the-screen
  (new screen%
       [title "Fireworks"]
       [width 600]
       [height 600]))

(define the-world
  (new world%
       [background "black"]
       [screen the-screen]
       [gravity (make-point 0 9.81)]))

(define shard%
  (class game-object%
    (init radius color)
    (super-new [image (circle radius "solid" color)])))

(define bolt%
  (class game-object%

    (inherit/super get-world get-position)

    (init-field 
      [explode-strength (random-between min-explode-strength max-explode-strength)]
      [num-shards (random-between min-num-shards max-num-shards)]
      [shard-radius (random-between min-shard-radius max-shard-radius)]
      [shard-color (random-color)]
      [color (random-color)]
      [radius (random-between min-bolt-radius max-bolt-radius)])

    (super-new [image (circle radius "solid" color)])

    (define/public (explode)
      (do ((i 0 (+ i 1)))
        ((= i num-shards))
         (let ((angle (* (/ i num-shards) (* 2 pi)))
               (vel (angle->point angle)))
           (send vel scale explode-strength)
           (new shard%
                [radius shard-radius]
                [color shard-color]
                [world (get-world)]
                [velocity vel]
                [position (get-position)]))))


    ))


(define cannon%
  (class game-object%

    (inherit/super get-position get-velocity get-angle)
    
    (init-field [fire-strength 200])

    (super-new
       [image cannon-image]
       [controlled? #t])

    (define/public (fire pos)
      (define velocity (angle->point (get-angle)))
      (send velocity scale (+ fire-strength (random 200)))
      (define bolt 
        (new bolt% 
             [position (get-position)]
             [velocity velocity]
             [world the-world]))
      (after (random (- min-static-time max-static-time))
             (lambda () (send bolt explode))))

    (define/public (go-right)
      (send (get-velocity) set-x cannon-move-speed))
    (define/public (go-left)
      (send (get-velocity) set-x (- cannon-move-speed)))

    ))

(define the-cannon
  (new cannon%
       [world the-world]
       [position 
         (make-point 
           (/ (send the-screen get-width) 2) 
           (- (send the-screen get-height) 
              (image-height cannon-image)))]))

(send the-screen on-key-down #\a (lambda (key-event) (send the-cannon go-left)))
(send the-screen on-key-down #\d (lambda (key-event) (send the-cannon go-right)))
(send the-screen on-key-down #\space (lambda (key-event) (send the-cannon fire)))

(send the-world play)

