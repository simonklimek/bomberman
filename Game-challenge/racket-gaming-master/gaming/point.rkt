#lang racket

(require ramunk)

(provide point%
         cp-property-point%
         make-point
         angle->point)

(define cp-property-point% 
  (class object%

    (super-new)
    
    (abstract get-cpv)
    (abstract set-cpv)

    (define/public (get-x) 
      (cpVect-x (get-cpv)))
    (define/public (get-y) 
      (cpVect-y (get-cpv)))

    (define/public (set-x new-x)
      (define cp-v (get-cpv))
      (set-cpVect-x! cp-v (exact->inexact new-x))
      (set-cpv cp-v))
    (define/public (set-y new-y)
      (define cp-v (get-cpv))
      (set-cpVect-y! cp-v (exact->inexact new-y))
      (set-cpv cp-v))

    (define/public (add oth)
      (define cp-v (get-cpv))
      (set-cpVect-x! cp-v (+ (cpVect-x cp-v) (send oth get-x)))
      (set-cpVect-y! cp-v (+ (cpVect-y cp-v) (send oth get-y)))
      (set-cpv cp-v))
    
    (define/public (sub oth)
      (define cp-v (get-cpv))
      (set-cpVect-x! cp-v (- (cpVect-x cp-v) (send oth get-x)))
      (set-cpVect-y! cp-v (- (cpVect-y cp-v) (send oth get-y)))
      (set-cpv cp-v))

    (define/public (scale factor)
      (define cp-v (get-cpv))
      (set-cpVect-x! cp-v (* (cpVect-x cp-v) factor))
      (set-cpVect-y! cp-v (* (cpVect-y cp-v) factor))
      (set-cpv cp-v))

    (define/public (to-cpv)
      (get-cpv))

    (define/public (copy oth)
      (set-cpv (send oth to-cpv)))

    ))

(define point%
  (class object%
    (init-field x y)
    (super-new)
    (define/public (get-x) x)
    (define/public (get-y) y)
    (define/public (add oth)
      (set! x (+ x (send oth get-x)))
      (set! y (+ y (send oth get-y))))
    (define/public (sub oth)
      (set! x (- x (send oth get-x)))
      (set! y (- y (send oth get-y))))
    (define/public (scale factor)
      (set! x (* x factor))
      (set! y (* y factor)))
    (define/public (copy oth)
      (set! x (send oth get-x))
      (set! y (send oth get-y)))
    (define/public (to-cpv)
      (cpv (exact->inexact x) (exact->inexact y)))
    ))

;(define point%
  ;(class object%
    ;(init-field del)
    ;(super-new)
    ;(define/public (get-x)
      ;(send del get-x))
    ;(define/public (get-y)
      ;(send del get-y))
    ;(define/public (add oth)
      ;(send del add oth))
    ;(define/public (sub oth)
      ;(send del sub oth))
    ;(define/public (scale factor)
      ;(send del scale factor))
    ;))

(define (angle->point a)
  (make-point (cos a) (sin a)))

(define (make-point x y)
  (make-object point% x y))

