#lang racket

(provide circle%)

(require ramunk
         "../point.rkt")

(define circle%
  (class object%
   
    (init-field radius [elasticity 0.0] [friction 0.0] [offset (make-point 0 0)])

    (super-new)

    (define/public (get-cp-shape cp-body)
      (define cp-shape (cpCircleShapeNew cp-body (exact->inexact radius) (send offset to-cpv)))
      (cpShapeSetElasticity cp-shape elasticity)
      (cpShapeSetFriction cp-shape friction)
      cp-shape)

    ))

