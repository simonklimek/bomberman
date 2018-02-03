#lang racket
(require 2htdp/image)
(require 2htdp/universe)

                                   ; Ex 181

(define WIDTH 10)
(define segment (circle 10 "solid" "red"))
(define scn (empty-scene 400 400))
  
; A World is a structure:
 (make-world dir posn)
(define-struct world (dir posn))
; A dir is one of:
; - "left"
; - "right"
; - "up"
; - "down"

; A posn is:
; -(make-posn x y)

; example:
(define world1 (make-world "up" (make-posn 300 200)))
(define world2 (make-world "down" (make-posn 200 200)))
(define world3 (make-world "right" (make-posn 100 100)))

; to-draw 
; draw : World -> Image
; renders the world on the scene
(define (draw w)
  (place-image segment (posn-x (world-posn w)) (posn-y (world-posn w)) scn))
 
(check-expect (draw world1) (place-image segment 300 200 scn))
(check-expect (draw world2) (place-image segment 200 200 scn))

; on-tick
; tick : World -> World
; changes the world to a new world
(define (tick w) 
  (cond [(string=? (world-dir w) "up") (make-world "up"
                                        (make-posn (posn-x (world-posn w))
                                                   (- (posn-y (world-posn w)) WIDTH))
                                        )]
        [(string=? (world-dir w) "down") (make-world "down" 
                                        (make-posn (posn-x (world-posn w))
                                                   (+ (posn-y (world-posn w)) WIDTH))
                                         )]
        [(string=? (world-dir w) "left") (make-world "left" 
                                        (make-posn (- (posn-x (world-posn w)) WIDTH)
                                                   (posn-y (world-posn w)))
                                         )]
        [(string=? (world-dir w) "right") (make-world "right" 
                                        (make-posn (+ (posn-x (world-posn w)) WIDTH)
                                                   (posn-y (world-posn w)))
                                         )]))
(check-expect (tick world1) (make-world "up" (make-posn 300 190)))
(check-expect (tick world2) (make-world "down" (make-posn 200 210)))
(check-expect (tick world3) (make-world "right" (make-posn 110 100)))

; on-key 
; key : World, KeyEvent -> World
; changes the world based on the KeyEvent
(define (key w ke)
  (cond [(key=? ke "up") (make-world "up" (make-posn (posn-x (world-posn w))
                                                     (- (posn-y (world-posn w)) WIDTH)))]
        [(key=? ke "down") (make-world "down" (make-posn (posn-x (world-posn w))
                                                          (- (posn-y (world-posn w)) WIDTH)))]
        [(key=? ke "left") (make-world "left" (make-posn ( - (posn-x (world-posn w)) WIDTH)
                                                          (posn-y (world-posn w))))]
        [(key=? ke "right") (make-world "right" (make-posn (+ (posn-x (world-posn w)) WIDTH)
                                                          (posn-y (world-posn w))))]))
(check-expect (key world1 "right") (make-world "right"
                                               (make-posn 310 200)))
(check-expect (key world2 "left") (make-world "left"
                                               (make-posn 190 200)))
(check-expect (key world3 "up") (make-world "up"
                                               (make-posn 100 90)))
 
(big-bang world1
          [to-draw draw]
          [on-tick tick 0.5]
          [on-key key])

                                 ; Ex 182

; modify the draw function:
; new-draw : World -> Image
; renders the world on the scene
(define (new-draw w)
  (place-image segment (posn-x (world-posn w)) (posn-y (world-posn w))
               (if (or (< (posn-x (world-posn w)) 0)
                        (< (posn-y (world-posn w)) 0)
                         (> (posn-x (world-posn w)) 390)
                          (> (posn-y (world-posn w)) 390))
                    (place-image (text "worm hits border" 20 "black")
                                  100 300 scn)
                    scn)))

(check-expect (new-draw (make-world "up" (make-posn 450 300)))
              (place-image (text "worm hits border" 20 "black")
                                  100 300 scn))

(big-bang world1  
          [to-draw new-draw]
          [on-tick tick 0.5]
          [on-key key])

                                   ; Ex 183

; A Worm is a atructure:
; (make-worm head tail dir)
(define-struct worm (head tail dir))

; A head is:
; - (make-head (make-posn x y))

; A tail is one 0f:
; - empty
; - (cons (make-posn x y) tail)

; A dir is one of:
; - "up"
; - "down"
; - "left"
; - "right"

; examples:
(define worm1 (make-worm (make-posn 200 200)
                         (cons (make-posn 200 210) empty) "up"))
(define worm2 (make-worm (make-posn 100 100)
                         (cons (make-posn 110 100)
                               (cons (make-posn 120 100) empty)) "right"))
(define worm3 (make-worm (make-posn 90 90)
                         empty "right"))
(define worm4 (make-worm (make-posn 100 100)
                         (cons (make-posn 110 100)
                               (cons (make-posn 120 100)
                                     (cons (make-posn 130 100)
                                           (cons (make-posn 140 100)
                                           empty)))) "right")) 
(define worm5 (make-worm (make-posn 40 40)
                         (list (make-posn 40 50) (make-posn 40 60) (make-posn 30 60) (make-posn 30 50) (make-posn 30 40) (make-posn 40 40)) "up"))


                               ; Ex 184

; to-draw:
; render-worm : Worm -> Image
; The function renders the world on the scene
(define (render-worm w)
  (cond [(hits-wall? w) (place-image (text "Worm hits wall" 20 "black")
                                  100 300 scn)]
        [(hits-itself? w (worm-tail w)) (place-image (text "Worm hits itself" 20 "black")
                                  100 300 scn)] 
        [(cons? (worm-tail w)) (render-head (worm-head w) (render-tail (worm-tail w) scn))]))
 
; hits-wall? : Worm -> Boolean
; determines whether the worm hits the wall
(define (hits-wall? w)
  (if (or (< (posn-x (worm-head w)) 0) 
          (< (posn-y (worm-head w)) 0) 
          (> (posn-x (worm-head w)) 390) 
          (> (posn-y (worm-head w)) 390))
         true false)) 

(check-expect (hits-wall? worm1) false)
(check-expect (hits-wall? (make-worm (make-posn 400 400) 
                                     (list (make-posn 390 400) (make-posn 380 400)) "right"))
              true) 
(check-expect (hits-wall? worm2) false)
                          
 
; hits-itself? : Worm -> Boolean
; determines whether the worm hits itself
(define (hits-itself? w tail)
  (cond [(empty? tail) false]
        [(and (= (posn-x (worm-head w)) (posn-x (first tail)))
              (= (posn-y (worm-head w)) (posn-y (first tail))))
         true]
        [else (hits-itself? w (rest tail))]))

(check-expect (hits-itself? worm1 (worm-tail worm1)) false)
(check-expect (hits-itself? worm5 (worm-tail worm5)) true)
       
        
; render-head : World Head -> Image
; renders the head on the scene
(define (render-head head image)
  (place-image segment (posn-x head) (posn-y head) image))

(check-expect (render-head (make-posn 20 20) scn) (place-image segment 20 20 scn))
(check-expect (render-head (make-posn 50 50) scn) (place-image segment 50 50 scn))
  
; render-tail : World tail -> Image
  ; renders the tail on the scene
(define (render-tail tail scn)
  (cond [(empty? tail) scn]
        [else (place-image segment (posn-x (first tail)) (posn-y (first tail))
               (render-tail (rest tail) scn))]))

(check-expect (render-tail empty scn) scn)
(check-expect (render-tail (list (make-posn 20 20) (make-posn 50 50)) scn)
              (place-image segment 20 20 (place-image segment 50 50 scn)))

; on-tick:
; tick-worm :
; changes the worm to a new worm 
(define (tick-worm w)
  (make-worm (tick-head (worm-head w) (worm-dir w))
             (tick-tail (worm-tail w) (worm-head w))
             (worm-dir w))) 

; tick-head : Head -> Head
; changes the head of worm to a new head
(define (tick-head head dir)
  (cond [(string=? dir "up") (make-posn (posn-x head) (- (posn-y head) WIDTH))] 
                                        
        [(string=? dir "down") (make-posn (posn-x head) (+ (posn-y head) WIDTH))]  
                                         
        [(string=? dir "left") (make-posn (- (posn-x head) WIDTH) (posn-y head))] 
                                         
        [(string=? dir "right") (make-posn (+ (posn-x head) WIDTH) (posn-y head))]))

(check-expect (tick-head (make-posn 40 30) "up") (make-posn 40 20))
(check-expect (tick-head (make-posn 50 90) "right") (make-posn 60 90))

; tick-tail : Worm Tail-> Worm Tail
; changes the tail of worm to a new tail 
(define (tick-tail tail head)
  (cond [(empty? tail) (cons head empty)]   
        [else (cons head (reverse (rest (reverse tail))))]))  

(check-expect (tick-tail empty (make-posn 40 40)) (cons (make-posn 40 40) empty))
(check-expect (tick-tail (list (make-posn 100 90) (make-posn 100 100)) (make-posn 100 80))
              (list (make-posn 100 80) (make-posn 100 90)))

; on-key:
; key-worm: Worm, KeyEvent -> Worm
; changes the worm into a new worm based on the given KeyEvent
(define (key-worm w ke)
  (cond [(and (string=? (worm-dir w) "left") (key=? ke "right")) w]
        [(and (string=? (worm-dir w) "right") (key=? ke "left")) w]
        [(and (string=? (worm-dir w) "up") (key=? ke "down")) w]
        [(and (string=? (worm-dir w) "down") (key=? ke "up")) w]
        [(key=? ke "up") (make-worm (worm-head w)
                                    (worm-tail w)
                                    "up")]
        [(key=? ke "down") (make-worm (worm-head w)
                                      (worm-tail w)
                                      "down")]
        [(key=? ke "left") (make-worm (worm-head w)
                                      (worm-tail w)
                                      "left")]
        [(key=? ke "right") (make-worm (worm-head w)
                                       (worm-tail w)
                                       "right")]))

(check-expect (key-worm worm1 "down") worm1)
(check-expect (key-worm worm2 "up") (make-worm (worm-head worm2) (worm-tail worm2)
                                               "up"))
(check-expect (key-worm worm3 "down") (make-worm (worm-head worm3) (worm-tail worm3)
                                                "down"))
                                    
(define (worm-died w)
  (if (or (hits-wall? w) (hits-itself? w))
      true false)) 
 
(big-bang worm4 
          [to-draw render-worm]
          [on-tick tick-worm 0.5]
          [on-key key-worm]
          )

                                 ; Ex 185

; A Game is a structure:
; (make-game worm food)
(define-struct game (worm food)) 

; A worm is a structure
; (make-worm head tail dir)

; A head is:
; - (make-posn Number Number)

; A tail is one 0f:
; - empty
; - (cons (make-posn x y) tail)

; A dir is one of:
; - "up"
; - "down"
; - "left"
; - "right"

; A food is:
; (make-posn Number Number)
(define food1 (make-posn 40 40))

(define food (circle 12 "solid" "blue"))

; Examples:
(define game1 (make-game (make-worm (make-posn 40 40)
                         (list (make-posn 50 40) (make-posn 60 40) (make-posn 70 40))
                         "right")
                         (make-posn 100 100)))
(define game2 (make-game (make-worm (make-posn 100 150)
                         (list (make-posn 100 160) (make-posn 100 170))
                         "down")
                         (make-posn 300 300)))

                        ; to-draw 
; render-game: Game -> Image
; renders the game on the scene
(define (render-game g)
  (render-food g (render-worm (game-worm g))))

; render-food: Food of Game, Image-> Image
; ; renders the food image on the scene
(define (render-food g image)
  (place-image food (posn-x (game-food g)) (posn-y (game-food g))
               image))

(check-expect (render-food game1 scn)
              (place-image food 100 100 scn))
(check-expect (render-food game2 scn)
              (place-image food 300 300 scn))

                       ; on-tick
; tick-game: Game -> Game
; changes the Game to a new Game
(define (tick-game g)
  (cond [(get-food? g (worm-head (game-worm g))) (lengthen g)]
        [else (tick-another-worm g)]))

; get-food? : Game Head-> Boolean
; determines whether the worm gets the food in the game
(define (get-food? g head)
  (cond 
        [(and (= (posn-x head) (posn-x (game-food g)))
              (= (posn-y head) (posn-y (game-food g))))
         true]
        [else false]))

(check-expect (get-food? game1 (make-posn 30 30)) false)
(check-expect (get-food? game2 (make-posn 300 300)) true)

; lengthen: Game -> Game
; changes the game to a new game
(define (lengthen g) 
  (make-game (make-worm (make-new-head (game-worm g))
                        (add-to-tail (worm-tail (game-worm g)) (worm-head (game-worm g)))
                        (worm-dir (game-worm g)))
             (make-posn (* 10 (random 40)) (* 10 (random 40)))))

; make-new-head: Worm -> Head
; makes a new head
(define (make-new-head w)
  (cond [(string=? (worm-dir w) "up") (make-posn (posn-x (worm-head w)) 
                                                 (- (posn-y (worm-head w)) WIDTH))]
        [(string=? (worm-dir w) "down") (make-posn (posn-x (worm-head w))
                                                 (+ (posn-y (worm-head w)) WIDTH))]
        [(string=? (worm-dir w) "left") (make-posn (- (posn-x (worm-head w)) WIDTH)
                                                  (posn-y (worm-head w)))]
        [(string=? (worm-dir w) "right") (make-posn (+ (posn-x (worm-head w)) WIDTH)
                                                   (posn-y (worm-head w)))])) 
  

; add-to-tail: 
; add one more posn to the tail of the game
(define (add-to-tail tail head)
  (cons head tail))

;tick-another-worm Game -> Game
; changes the game to a new game
(define (tick-another-worm g)
  (make-game (tick-worm (game-worm g))
             (game-food g)))

                                ; on-key
; key-game : Game, KeyEvent-> Game
; changes the game to a new game based on the given KeyEvent
(define (key-game g ke)
  (make-game (key-worm (game-worm g) ke)
             (game-food g)))

                                ; stop-when
; game-ends: Game -> Boolean
; determines whether the game ends
(define (game-ends g)
  (if (or (hits-wall? (game-worm g))
      (hits-itself? (game-worm g) (worm-tail (game-worm g)))) true false))

(big-bang game2 
          [to-draw render-game]
          [on-tick tick-game 0.05]
          [on-key key-game]
          )
              


