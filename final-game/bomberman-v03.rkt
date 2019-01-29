#lang racket
(provide go)
#|

BOMBERMAN GAME v0.3 - TO RUN GAME TYPE "(GO)" INTO RACKET CONSOLE

TODO:
- Do something with gem object or convert it to some collective booster
- Bomb object - placing, timing, fire, colision logic
- Map objects arrangement:bricks, oponents, empty-scene  //EMPTY SPACE DONE
- Oponents able to kill you
- Bombs and fire - entire logic
- Power ups under random bricks
- Power up enchance bomb fire
- Message or notyfication when you win the game
- Score bar, score rates
- Multiplayer via client -> server Join / Host
- Player dead logic and collisions with other oponents etc

IDEAS;
- MDX LOGO ON ONE BLOCK
- WELCOME SCREEN WITH MENU TO START , HELP , JOIN , HOST , EXIT GAME

add more...
|#

(require 2htdp/universe)
(require 2htdp/image)
(require lang/posn)
(require "util.rkt")

;; Debug
;;(require unstable/debug)
(require racket/trace)
;;DON't CHANGE SIZE OF MAP!
(define WIDTH 21)
(define HEIGHT 15)
(define BLOCK-SIZE 50)
(define TICK-RATE 0.01)

(struct world (landscape player level) #:transparent)
;; A-landscape is (make-vector (* WIDTH HEIGHT))
(struct pos (x y) #:transparent)
(struct player (pos) #:transparent)
(struct block (what pos) #:transparent)
(struct bomb (pos) #:transparent)
  
(define PLAYER-IMG (bitmap "images/player1.png"))
(define DEAD-PLAYER-IMG (bitmap "images/player1dead.png"))
(define BRICK-IMG (bitmap "images/brick.png"))
(define WALL-IMG (bitmap "images/wall.png"))
(define GEM-IMG (bitmap "images/gem.png"))
(define GHOST-IMG (bitmap "images/ghost2.png"))
(define BACKGROUND (bitmap "images/bg.png"))
(define BOMB-IMG (bitmap "images/bomb.png"))

(define blocksym->img (λ (x-symbol)
  (cond
    [(eq? x-symbol 'brick) BRICK-IMG]
    [(eq? x-symbol 'wall) WALL-IMG]
    [(eq? x-symbol 'gem) GEM-IMG]
    [(eq? x-symbol 'ghost) GHOST-IMG]
    [(eq? x-symbol 'bomb) BOMB-IMG]
    [(eq? x-symbol 'player1dead) DEAD-PLAYER-IMG];new
    [else BACKGROUND])))

;-----------------  ^^ GOT IT ^^ --------------------------

(define vec-index (λ (a-pos)
  (+ (* (pos-y a-pos) WIDTH) (pos-x a-pos))))

(define get-blocksym (λ (a-landscape a-pos)
  (vector-ref a-landscape (vec-index a-pos))))

(define get-block (λ (a-landscape a-pos)
  (block (get-block a-landscape a-pos) a-pos)))

(define set-block! (λ (a-landscape a-block)
  (vector-set! a-landscape (vec-index (block-pos a-block))
               (block-what a-block))))

(define clear-block! (λ (a-landscape a-pos)
  (set-block! a-landscape (block 0 a-pos))))

;1ST TRY TO PLACE THE IMAGE BOMB AT PLAYER PLACE - DOESNT WORK
(define set-bomb! (λ (a-landscape a-block)
  (set-block! a-landscape (block 'bomb))))

(define pos->px (λ (p)
  (+ (/ BLOCK-SIZE 2) (* p BLOCK-SIZE))))

(define move-pos (λ (a-pos dx dy)  ;;101 page explanation
  (pos (+ (pos-x a-pos) dx)
       (+ (pos-y a-pos) dy))))

(define what-is-next-to (λ (a-landscape a-pos dx dy)
  ;; What is at a-pos + dx/dy? Return symbol
  (get-blocksym a-landscape (move-pos a-pos dx dy))))

;; What is bellow funciton can be modyfied to check: What is around? 
(define what-is-below (λ (a-landscape a-pos)
  (what-is-next-to a-landscape a-pos 0 1)))  

(define block-next-to (λ (a-landscape a-pos dx dy)
  ;; Like what-is-next-to but return block
  (let ([d-pos (move-pos a-pos dx dy)])
    (block (get-blocksym a-landscape d-pos) d-pos)
  )))

;(define (can-fall? a-landscape a-block)
;  (let ([this-block (block-what a-block)]
;        [block-below (what-is-below a-landscape (block-pos a-block))])
;    (if (eq? this-block 'falling-boulder)
;        (member block-below '(0 player))
;        (eq? block-below 0))))

(define is-boulder? (λ (a-block)
;  (or (eq? (block-what a-block) 'boulder)
      (eq? (block-what a-block) 'falling-boulder)))

(define (is-gem? a-block) (eq? (block-what a-block) 'gem))
(define (is-ghost? a-block) (eq? (block-what a-block) 'ghost))
(define (is-empty? a-block) (eq? (block-what a-block) 0))
(define (is-player? a-block) (eq? (block-what a-block) 'player1dead));new

;; Filter which browse world for argument a-pred and return T /F
(define landscape-filter (λ (a-landscape a-pred)
  ;; Return a list of blocks that match predicate
  ;; A block is a (what pos)
  (for*/list ([y (range HEIGHT)]
              [x (range WIDTH)]
              #:when (a-pred (block
                              (vector-ref a-landscape (vec-index (pos x y)))
                              (pos x y))))
    (block (vector-ref a-landscape (vec-index (pos x y)))
           (pos x y)))))

;; Check function - if it's no gems left
(define no-gems-left? (λ (a-landscape)
  (empty? (landscape-filter a-landscape is-gem?))))

(define blanks-next-to (λ (a-landscape a-pos)
  ;; Return blanks poses next to this pos (N, E, S, W)
  (define bn block-next-to)
  (define blank-blocks
    (filter (or is-empty? is-player?) (list 
           (bn a-landscape a-pos -1 0)
           (bn a-landscape a-pos 1 0)
           (bn a-landscape a-pos 0 -1)
           (bn a-landscape a-pos 0 1))
            ))
  (map block-pos blank-blocks)))


;; - - Background, blocks  & objects - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define random-block (λ (level)
  ;; game scene randomly filled by gem and ghost
  ;- need to be redesigned this part to make places free of bricks - with green bg only
  (random-choice
   (append
    (times-repeat (+ 5 (- 10 (* 2 level))) 'brick)
    '(gem ghost 0 0 0)))))    ;  i deleted boulders from list 
                             ;  to add empty block put "0" in a random-block function
(define make-landscape (λ (level)
  (for*/vector ([y (range HEIGHT)]
                [x (range WIDTH)])
    (cond
      ;; Walls around the edges and concrete blocks every second block 
      [(or (= x 0) (= x (- WIDTH 1))
           (= y 0) (= y (- HEIGHT 1))) 'wall]
      [(and (even? x) (even? y)) 'wall]
      
      ;; Empty block !(pos 1 1)
      ;; Logic to make empty block at all corners
      ;; You can't change the game size in definitions
      [(and (or (and (> x 1) (< x 4)) (and (> x 16) (< x 20))) (or (= y 1) (= y 13))) 0]
      [(and (or (= x 1) (= x 19)) (or (and (> y 1) (< y 4)) (and (> y 10) (< y 14)))) 0]
      ;; Empty blocks at center :cross shape
      [(and (and (> x 8) (< x 14)) (= y 7)) 0]
      [(and (= x 11) (and (> y 4) (< y 10))) 0]
      
      ;; Player pos
      [(and (= x 1) (= y 1)) 'player]
      [else (random-block level)]))
  ))

;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;; Events & movement
;;player:
(define set-players-block! (λ (a-landscape old-pos new-pos)
        (clear-block! a-landscape old-pos)
        (set-block! a-landscape (block 'player new-pos))))


;(define (boulders-fall! a-landscape)
;  (define boulders (landscape-filter a-landscape is-boulder?))
;  (for ([b boulders])
;    (if (can-fall? a-landscape b)
;        (let* ([cur-pos (block-pos b)]
;               [new-pos (move-pos cur-pos 0 1)]
;               [new-boulder (block 'falling-boulder new-pos)])
;          (clear-block! a-landscape cur-pos)    !!VERY IMPORTANT LINE
;          (set-block! a-landscape new-boulder))
;        (set-block! a-landscape (block 'boulder (block-pos b))))
;    ))

 (define ghosts-move! (λ (a-landscape)
  (if (< (random) 0.1)
      (let ([ghosts (landscape-filter a-landscape is-ghost?)])
        (for ([d ghosts])
          (let* ([can-move (blanks-next-to a-landscape (block-pos d))]
                 ;[can-move (player-next-to a-landscape (block-pos d))] ;new
                 [new-pos (random-choice can-move)])
            (if new-pos
                (begin
                  (clear-block! a-landscape (block-pos d))
                  (set-block! a-landscape (block 'ghost new-pos))
                  )
                #f))))
      #f)))
  
;; Create new game when no gems left ;; next-world! TICK-RATE
(define next-world! (λ (w)
  (if (no-gems-left? (world-landscape w))
      (let ([next-level (add1 (world-level w))])
        (world (make-landscape next-level) (player (pos 1 1)) next-level))
     (begin
 ;       (boulders-fall! (world-landscape w))
        (ghosts-move! (world-landscape w))
        w))))

;; DEFINE OBJECTS WHICH PLAYER CAN GO THROUGH
;; REMOVE BRICK AFTER ! 
(define player-can-move (λ (a-landscape a-player dx dy)
  (member (what-is-next-to a-landscape (player-pos a-player) dx dy)
          '(0 brick gem)))) ;; ghost

;; NOT APLICABLE TO OUR GAME
(define player-can-push-boulder (λ (a-landscape a-player dx dy)
  (and (zero? dy)
       (eq? (what-is-next-to a-landscape (player-pos a-player) dx 0) 'boulder)
       (eq? (what-is-next-to a-landscape (player-pos a-player) (* dx 2) 0) 0))))

;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
;; Player can move if there's brick (remove later), gem or empty space.
;; Change the landscape (players's pos)
;; Get rid of boulder later from the code

(define try-move-player! (λ (a-landscape a-player dx dy) ;; Ex: (key=? a-key "left") (try-move-player! l f -1 0)
  (let* ([cur-pos (player-pos a-player)]                 ;;l - player-pos; f - a-player; dx; dy;
        [new-pos (move-pos cur-pos dx dy)])
    (if (player-can-move a-landscape a-player dx dy)
      (begin
        (set-players-block! a-landscape cur-pos new-pos)
        (player new-pos))
      ;;no need piece bellow
      
      (if (player-can-push-boulder a-landscape a-player dx dy)
          (begin
            (clear-block! a-landscape new-pos)
            (set-block! a-landscape (block 'boulder (move-pos new-pos dx dy)))
            (set-players-block! a-landscape cur-pos new-pos)
            (player new-pos))
          a-player)
 ))))

;; - - Key Controls - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(define direct-player! (λ (w a-key)
  (define f (world-player w))
  (define l (world-landscape w))
  (define newf
    (cond
      [(key=? a-key "left") (try-move-player! l f -1 0)]
      [(key=? a-key "right") (try-move-player! l f 1 0)]
      [(key=? a-key "up") (try-move-player! l f 0 -1)]
      [(key=? a-key "down") (try-move-player! l f 0 1)]
     
    ;  [(key=? a-key " ") (set-bomb-block! a-landscape a-pos)]
     
      [else f]))    
  
  (if (or (key=? a-key "r") (key=? a-key "R") )
      (world (make-landscape (world-level w)) (player (pos 1 1)) (world-level w))
      (world (world-landscape w) newf (world-level w)))
))

(define player-dead? (λ (w)
                       ;; player is dead if he's not at his location in the landscape
                       ;; e.g. there's a boulder there
                       (let
                           ([fp (player-pos (world-player w))])
                         (not (eq? (get-blocksym (world-landscape w) fp) 'player))
                         )
                       ))

;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;; Rendering

(define img+scene (λ (pos img scene)   ;;explanation 106 page
  (place-image img
               (pos->px (pos-x pos)) (pos->px (pos-y pos))
               scene)))

(define player+scene (λ (a-player scene)
  (img+scene (player-pos a-player) PLAYER-IMG scene)))

(define dead-player+scene (λ (a-player scene)
  (img+scene (player-pos a-player) DEAD-PLAYER-IMG scene)))

(define landscape-images (λ (a-landscape)
  (map blocksym->img (vector->list a-landscape))))

(define (landscape-posns)
  (for*/list ([y (range HEIGHT)]
              [x (range WIDTH)])
    (make-posn (pos->px x) (pos->px y))
    ))
    
(define landscape+scene (λ (a-landscape scene)
  (place-images (landscape-images a-landscape)
                (landscape-posns) scene)))
;; Main rendering function
(define render-world (λ (w)
  (define scene (landscape+scene (world-landscape w)
                                 (empty-scene (* WIDTH BLOCK-SIZE)
                                              (* HEIGHT BLOCK-SIZE) (make-color 0 122 59))))
  (if (player-dead? w)
      (dead-player+scene (world-player w) scene)
      (player+scene (world-player w) scene))))

;; - - Launcher - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;; (world '#(wall wall wall) (player (pos 1 1)) 1)
(define (go)
  (big-bang (world (make-landscape 1) (player (pos 1 1)) 1)
            (on-tick next-world! TICK-RATE)
            (on-key direct-player!)
            (to-draw render-world)
            (stop-when player-dead?)))
