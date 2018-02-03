;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ai_final_project) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
; Making Snake Play Itself
; Alaina Kafkes

(require "snake-lib.rkt")
; This library includes the following definitions:

; a game is
; (make-game snake food nat)
; (define-struct game (snake food ticks))

; a direction is either
; - 'up
; - 'down
; - 'left
; - 'right

; a snake is
; (make-snake direction body)
; (define-struct snake (heading segments))

(define sample-snake1 (make-snake 'up
                                 (list (make-posn 25 25)
                                       (make-posn 25 24)
                                       (make-posn 25 23)
                                       (make-posn 25 22))))
(define sample-snake2 (make-snake 'left
                                 (list (make-posn 3 40)
                                       (make-posn 4 40)
                                       (make-posn 5 40)
                                       (make-posn 6 40)
                                       (make-posn 7 40))))
(define sample-game2 (make-game
                      sample-snake2
                      (list (make-posn 49 33)
                            (make-posn 5 17))
                      3))

; GAME START FUNCTION ----------------------------------
(define game-start (make-game
                      sample-snake1
                      (list (make-posn 3 37)
                            (make-posn 15 20)
                            (make-posn 1 1)
                            (make-posn 44 9))
                      45))
; ------------------------------------------------------

; a body is either
; - (cons posn empty)
; - (cons posn body)
; x-coordinates increase from 1 to board-length (inclusive)
;   toward the right
; y-coordinates increase from 1 to board-length (inclusive)
;   toward the top
; the default value for board-length is 50

; a food is either
; - empty
; - (cons posn food)

;;; add-food: game posn -> game
;;; to add food to a specified board position
(define (add-food g p)
  (make-game (game-snake g)
             (cons p (game-food g))
             (game-ticks g)))

(check-expect (add-food game-start (make-posn 4 34))
              (make-game sample-snake1
                         (list (make-posn 4 34)
                               (make-posn 3 37)
                               (make-posn 15 20)
                               (make-posn 1 1)
                               (make-posn 44 9))
                         45))
(check-expect (add-food game-start (make-posn 20 15))
              (make-game sample-snake1
                         (list (make-posn 20 15)
                               (make-posn 3 37)
                               (make-posn 15 20)
                               (make-posn 1 1)
                               (make-posn 44 9))
                         45))

;;; change-direction: game direction -> game
;;; to change the direction in which the snake is traveling
(define (change-direction g direct)
  (make-game (make-snake direct
                         (snake-segments (game-snake g)))
             (game-food g)
             (game-ticks g)))

(check-expect (change-direction game-start 'left)
              (make-game (make-snake 'left
                                     (list (make-posn 25 25)
                                           (make-posn 25 24)
                                           (make-posn 25 23)
                                           (make-posn 25 22)))
                         (game-food game-start)
                         (game-ticks game-start)))
(check-expect (change-direction game-start 'right)
              (make-game (make-snake 'right
                                     (list (make-posn 25 25)
                                           (make-posn 25 24)
                                           (make-posn 25 23)
                                           (make-posn 25 22)))
                         (game-food game-start)
                         (game-ticks game-start)))

;;; game-score: game -> nat
;;; to compute the player's score based on the snake's length
;;;   and the time (ticks) it takes to reach that length
(define (game-score g)
  (- (* (quantify (snake-segments (game-snake g))) 100)
     (game-ticks g)))

(check-expect (game-score game-start) 355)
(check-expect (game-score sample-game2) 497)

;;; game-over?: game -> boolean
;;; to detect when the snake runs into itself or a wall
(define (game-over? g)
  (cond [(not (all-false (map (lambda (x) (or (= (posn-x x) 51)
                                              (= (posn-y x) 51)))
                              (snake-segments (game-snake g)))))
         true]
        [(not (all-false (map (lambda (x) (or (= (posn-x x) 0)
                                              (= (posn-y x) 0)))
                              (snake-segments (game-snake g)))))
         true]
        [(= (game-score g) 0)             true]
        [else         (self-hit (snake-segments (game-snake g)))]))

(check-expect (game-over? sample-game2) false)
(check-expect (game-over? game-start) false)

;;; advance-game: game -> game
;;; to move the game forward one step
;;;   - to increment the game's tick component
;;;   - to *possibly* cause the snake to eat/grow
;;;       (but snake loses its end segment)
(define (advance-game g)
  (cond [(eat? g)           (make-game
                             ;(snake-eat (game-snake g))
                             (snake-eat
                              (make-snake (good-direct g)
                                          (snake-segments (game-snake g))))
                             (remove-food g (game-food g))
                             (+ 1 (game-ticks g)))]
        [else               (make-game
                             (make-snake
                              ;(snake-heading (game-snake g))
                              (good-direct g)
                              (move-list-of-segments
                              (snake-segments (game-snake g))
                              (snake-heading (game-snake g))))
                             (game-food g)
                             (+ 1 (game-ticks g)))]))

;(check-expect (advance-game game-start)
;              (make-game (make-snake 'up
;                                     (list (make-posn 25 26)
;                                           (make-posn 25 25)
;                                           (make-posn 25 24)
;                                           (make-posn 25 23)))
;                         (list (make-posn 3 37)
;                               (make-posn 15 20)
;                               (make-posn 1 1)
;                               (make-posn 44 9))
;                         46))
;
;(check-expect (advance-game sample-game2)
;              (make-game (make-snake 'left
;                                     (list (make-posn 2 40)
;                                           (make-posn 3 40)
;                                           (make-posn 4 40)
;                                           (make-posn 5 40)
;                                           (make-posn 6 40)))
;                         (list (make-posn 49 33)
;                               (make-posn 5 17))
;                         4))

; good-direct: game -> direct
; to determine what direction the snake SHOULD go
(define (good-direct g)
  (cond [(symbol=? (snake-heading (game-snake g)) 'up)
         (if (= (posn-y (first (snake-segments (game-snake g)))) 49)
             (cond [(>= (posn-x (first (snake-segments (game-snake g))))
                        25)             'left]
                   [else                'right])
             
             (cond [(and (< (posn-y (first (snake-segments (game-snake g))))
                            (posn-y (first (game-food g))))
                         (= (posn-x (first (snake-segments (game-snake g))))
                            (posn-x (first (game-food g)))))
                          'up]
                   [(and (> (posn-x (first (snake-segments (game-snake g))))
                            (posn-x (first (game-food g))))
                         (= (posn-y (first (snake-segments (game-snake g))))
                            (- (posn-y (first (game-food g))) 1)))
                          'left]
                   [(and (< (posn-x (first (snake-segments (game-snake g))))
                            (posn-x (first (game-food g))))
                         (= (posn-y (first (snake-segments (game-snake g))))
                            (- (posn-y (first (game-food g))) 1)))
                         'right]
                   [else                (snake-heading (game-snake g))]
                   ))]
        [(symbol=? (snake-heading (game-snake g)) 'down)
         (if (= (posn-y (first (snake-segments (game-snake g)))) 2)
             (cond [(>= (posn-x (first (snake-segments (game-snake g))))
                        25)             'left]
                   [else                'right])
             (cond [(and (> (posn-y (first (snake-segments (game-snake g))))
                            (posn-y (first (game-food g))))
                         (= (posn-x (first (snake-segments (game-snake g))))
                            (posn-x (first (game-food g)))))
                        'down]
                   [(and (> (posn-x (first (snake-segments (game-snake g))))
                            (posn-x (first (game-food g))))
                         (= (posn-y (first (snake-segments (game-snake g))))
                            (+ 1 (posn-y (first (game-food g))))))
                    'left]
                   [(and (< (posn-x (first (snake-segments (game-snake g))))
                            (posn-x (first (game-food g))))
                         (= (posn-y (first (snake-segments (game-snake g))))
                            (+ 1 (posn-y (first (game-food g))))))
                         'right]
                   [else                (snake-heading (game-snake g))]
                   ))]
        [(symbol=? (snake-heading (game-snake g)) 'right)
         (if (= (posn-x (first (snake-segments (game-snake g)))) 49)
             (cond [(>= (posn-y (first (snake-segments (game-snake g))))
                        25)             'down]
                   [else                'up])
             (cond [(and (< (posn-x (first (snake-segments (game-snake g))))
                            (posn-x (first (game-food g))))
                         (= (posn-y (first (snake-segments (game-snake g))))
                            (posn-y (first (game-food g)))))
                    'right]
                   [(and (< (posn-y (first (snake-segments (game-snake g))))
                            (posn-y (first (game-food g))))
                         (= (posn-x (first (snake-segments (game-snake g))))
                            (- (posn-x (first (game-food g))) 1)))
                    'up]
                   [(and (> (posn-y (first (snake-segments (game-snake g))))
                            (posn-y (first (game-food g))))
                         (= (posn-x (first (snake-segments (game-snake g))))
                            (- (posn-x (first (game-food g))) 1)))
                    'down]
                   [else                (snake-heading (game-snake g))]
                   ))]
        [else
         (if (= (posn-x (first (snake-segments (game-snake g)))) 2)
             (cond [(>= (posn-y (first (snake-segments (game-snake g))))
                        25)             'down]
                   [else                'up])
             (cond [(and (> (posn-x (first (snake-segments (game-snake g))))
                            (posn-x (first (game-food g))))
                         (= (posn-y (first (snake-segments (game-snake g))))
                            (posn-y (first (game-food g)))))
                         'left]
                   [(and (< (posn-y (first (snake-segments (game-snake g))))
                            (posn-y (first (game-food g))))
                         (= (posn-x (first (snake-segments (game-snake g))))
                            (+ (posn-x (first (game-food g))) 1)))
                         'up]
                   [(and (> (posn-y (first (snake-segments (game-snake g))))
                            (posn-y (first (game-food g))))
                         (= (posn-x (first (snake-segments (game-snake g))))
                            (+ (posn-x (first (game-food g))) 1)))
                         'down]
                   [else                (snake-heading (game-snake g))]
                   ))]))

; Ok so this works :3 except the snake sometimes eats itself lolz.

; --- Helper Functions ---

; quantify: list-of-X -> nat
; to count the amount of items in a list
(define (quantify lox)
  (local [(define (helper lox acc)
            (cond [(empty? lox)      acc]
                  [else              (helper (rest lox)
                                             (+ 1 acc))]))]
    (helper lox 0)))

(check-expect (quantify (list 39 29 58 24 78 36)) 6)
(check-expect (quantify (list 'cat 'cat 'cat)) 3)
(check-expect (quantify empty) 0)

; all-false: list-of-booleans -> boolean
; to return true if all booleans in a list-of-booleans are *FALSE*
(define (all-false lob)
  (cond [(empty? lob)       true]
        [else               (and (not (first lob))
                                 (all-false (rest lob)))]))

(check-expect (all-false (list true true true)) false)
(check-expect (all-false (list false false true)) false)
(check-expect (all-false (list false false false)) true)

; all-true: list-of-booleans -> boolean
; to return true if all booleans in a list-of-booleans are true
(define (all-true lob)
  (cond [(empty? lob)       true]
        [else               (and (first lob)
                                 (all-true (rest lob)))]))

(check-expect (all-true (list true true true)) true)
(check-expect (all-true (list true true false)) false)

; self-hit: list -> boolean
; to return whether or not a snake's front segments occupies the same
;   position of one of its other segments (i.e. whether or not the
;   snake has hit itself)
(define (self-hit l)
  (not (all-false (rest (map (lambda (x) (and (= (posn-x (first l))
                                                 (posn-x x))
                                              (= (posn-y (first l))
                                                 (posn-y x))))
                             l)))))

(check-expect (self-hit (snake-segments sample-snake1)) false)
(check-expect (self-hit (snake-segments (make-snake
                                         'up
                                         (list (make-posn 25 25)
                                               (make-posn 25 25))))) true)

; move-segment: posn direction -> posn
; to move an individual segment in a given direction
(define (move-segment p direct)
  (cond [(symbol=? direct 'up)
         (make-posn (posn-x p)
                    (+ 1 (posn-y p)))]
        [(symbol=? direct 'down)
         (make-posn (posn-x p)
                    (- (posn-y p) 1))]
        [(symbol=? direct 'left)
         (make-posn (- (posn-x p) 1)
                    (posn-y p))]
        [else
         (make-posn (+ 1 (posn-x p))
                    (posn-y p))]))

(check-expect (move-segment (make-posn 2 2) 'up)
              (make-posn 2 3))
(check-expect (move-segment (make-posn 2 2) 'down)
              (make-posn 2 1))
(check-expect (move-segment (make-posn 2 2) 'left)
              (make-posn 1 2))
(check-expect (move-segment (make-posn 2 2) 'right)
              (make-posn 3 2))

; move-list-of-segments: list-of-posn direction -> list-of-posn
; to move a list-of-segments in a given direction
(define (move-list-of-segments lop direct)
  (cons (move-segment (first lop) direct)
        (reverse (rest (reverse lop)))))

(check-expect (move-list-of-segments (snake-segments sample-snake1) 'up)
              (list (make-posn 25 26)
                    (make-posn 25 25)
                    (make-posn 25 24)
                    (make-posn 25 23)))
(check-expect (move-list-of-segments (snake-segments sample-snake2) 'left)
              (list (make-posn 2 40)
                    (make-posn 3 40)
                    (make-posn 4 40)
                    (make-posn 5 40)
                    (make-posn 6 40)))

; remove-last: list-of-posn -> list-of-posn
; to return all posn but the last posn in a list-of-posn
(define (remove-last lop)
  (reverse (rest (reverse lop))))

(check-expect (remove-last (snake-segments sample-snake1))
              (list (make-posn 25 25)
                    (make-posn 25 24)
                    (make-posn 25 23)))
(check-expect (remove-last (snake-segments sample-snake2))
              (list (make-posn 3 40)
                    (make-posn 4 40)
                    (make-posn 5 40)
                    (make-posn 6 40)))

; snake-eat: snake -> snake
; to add a segment on to the end of the snake if it eats
(define (snake-eat s)
  (cond [(> (posn-x (first (rest (reverse (snake-segments s)))))
            (posn-x (first (reverse (snake-segments s)))))
         ; pen-posn is to the right of fin-posn -- -1 posn-x
         (make-snake (snake-heading s)
                     (append (snake-segments s)
                             (list (make-posn
                                    (- (posn-x (first
                                                (reverse
                                                 (snake-segments s)))) 1)
                                    (posn-y
                                     (first
                                      (reverse (snake-segments s))))))))]
        [(< (posn-x (first (rest (reverse (snake-segments s)))))
            (posn-x (first (reverse (snake-segments s)))))
         ; pen-posn is to the left of fin-posn -- +1 posn-x
         (make-snake (snake-heading s)
                     (append (snake-segments s)
                             (list (make-posn
                                    (+ (posn-x (first
                                                (reverse
                                                 (snake-segments s)))) 1)
                                    (posn-y
                                     (first
                                      (reverse (snake-segments s))))))))]
        [else
         (cond [(> (posn-y (first (rest (reverse (snake-segments s)))))
                  (posn-y (first (reverse (snake-segments s)))))
               ; pen-posn is above fin-posn -- -1 posn-y
               (make-snake (snake-heading s)
                           (append (snake-segments s)
                                   (list (make-posn
                                          (posn-x (first
                                                   (reverse
                                                    (snake-segments s))))
                                          (- (posn-y
                                              (first
                                               (reverse
                                                (snake-segments s)))) 1)))))]
               [else ; pen-posn is below fin-posn -- +1 posn-y
                (make-snake (snake-heading s)
                            (append (snake-segments s)
                                    (list (make-posn
                                           (posn-x (first
                                                    (reverse
                                                     (snake-segments s))))
                                           (+ (posn-y
                                               (first
                                                (reverse
                                                 (snake-segments s)))) 1)))))]
               )]))

(check-expect (snake-eat sample-snake1)
              (make-snake 'up
                          (list (make-posn 25 25)
                                (make-posn 25 24)
                                (make-posn 25 23)
                                (make-posn 25 22)
                                (make-posn 25 21))))
(check-expect (snake-eat sample-snake2)
              (make-snake 'left
                          (list (make-posn 3 40)
                                (make-posn 4 40)
                                (make-posn 5 40)
                                (make-posn 6 40)
                                (make-posn 7 40)
                                (make-posn 8 40))))

; eat?: game -> boolean
; to determine whether or not a snake has eaten
;   i.e. whether the first snake segments is at the same posn as
;          one of the pieces of food (use map to check all food)
(define (eat? g)
  (if (not (all-false (map (lambda (x)
                             (posn=?
                              (first (snake-segments (game-snake g))) x))
                           (game-food g)))) true false))

(check-expect (eat? game-start) false)
(check-expect (eat? sample-game2) false)

; posn=?: posn posn -> boolean
; to determine whether two positions are the same (equal)
(define (posn=? p1 p2)
  (if (and (= (posn-x p1) (posn-x p2))
           (= (posn-y p1) (posn-y p2)))
      true false))

(check-expect (posn=? (make-posn 4 2)
                      (make-posn 2 4)) false)
(check-expect (posn=? (make-posn 42 16)
                      (make-posn 42 16)) true)

; remove-food: game list-of-posn -> list-of-posn
; to remove food from the game once it has been eaten
(define (remove-food g lop)
  (cond [(empty? lop)                            lop]
        [(posn=? (first (snake-segments (game-snake g))) (first lop))
         (rest lop)]
        [else            (cons (first lop) (remove-food g (rest lop)))]))

(check-expect (remove-food game-start (game-food game-start))
              (list (make-posn 3 37)
                    (make-posn 15 20)
                    (make-posn 1 1)
                    (make-posn 44 9)))
(check-expect (remove-food sample-game2 (game-food sample-game2))
              (list (make-posn 49 33)
                    (make-posn 5 17)))#autosnake
#autosnake
