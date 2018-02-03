

(include "pos.scm")
(include "board-generator.scm")
(include "start-level.scm")

(define (make-2d-vector r c f)
  (build-vector r (λ(x)(build-vector c (λ(y)(f))))))
(define (vector-2d-ref v i j)
  (vector-ref (vector-ref v i) j))
(define (vector-2d-set! v i j val) 
  (vector-set! (vector-ref v i) j val))

(define (element x l)
  (if(null? l)(void)
     (if(= x 1)(car l)
        (element (- x 1) (cdr l)))))


;Incorporating while loop as in C++

(define (while cond inc op cur val)
  (if (not (cond cur)) val
      (while cond inc op (inc cur) (op val cur))))

;Board vector that represents our maze internally as 2D vector of pos% class objects

(define board-vec (make-2d-vector 13 23 (λ()(new pos%)))) ; creating board vector
(define (init-board l)
  (define brick-wall (car l)) ; list of postions where brick wall would be present.
  (define enemy (caddr l)) ; list of postions where enemy would be present.
  (define door (caadr l)) ; list of postions where door would be present.
  (define (init-board-1) ; setting the board vector positions with enemies, door, brick walls etc...
    (define i 0)
    (define j 0)
    (define (init-board-h-1)
      (if(< i 13)
         (let([v1 (vector-ref board-vec i)])
           (if(odd? i)          
              (begin
                (vector-set! board-vec i (init-board-h-2 v1))
                (set! i (+ i 1))
                (init-board-h-1))
              (begin
                (set! i (+ i 1))
                (init-board-h-1))))
         (set! i 0)))
    (define (init-board-h-2 vec)
      (if(< j 23)
         (if(odd? j)
            (begin            
              (send (vector-ref vec j)
                    initialise
                    #f #f #t #f #f #f #f #f)
              (vector-set! vec j (vector-ref vec j))
              (set! j (+ j 1))
              (init-board-h-2 vec))
            (begin
              (set! j (+ j 1))
              (init-board-h-2 vec)))
         (begin
           (set! j 0)
           vec)))
    (init-board-h-1))
  (define (init-board-2 l) ; This funtions assigns generated postions of brick walls with appropriate values
    (if(null? l)#t
       (let([x (caar l)] [y (cdar l)])
         (begin
           (send (vector-2d-ref board-vec x y) set-brick-wall #t)
           (init-board-2 (cdr l))))))
  (define (init-board-3 l) ; This function assigns generated postions of enemies with appropriate values
    (if(null? l)#t
       (let([x (caar l)] [y (cdar l)])
         (begin
           (send (vector-2d-ref board-vec x y) set-enemy #t)
           (send (element (- 11 (length l)) enemy-list) set-pos-pair (car l)) 
           (init-board-3 (cdr l))))))
  (define (init-board-4) ; This function initialises postion of door
    (send (vector-2d-ref board-vec (car door) (cdr door)) set-door #t))
  (init-board-1)
  (init-board-2 brick-wall)
  (init-board-3 enemy)
  (init-board-4))