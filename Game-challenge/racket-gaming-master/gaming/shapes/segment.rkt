#lang racket

(provide segment%)

(require ramunk)
  
(define segment%
  (class object%

    (init-field a b [radius 0.0] [elasticity 0.0] [friction 0.0])

    (super-new)

    (define/public (get-cp-shape cp-body)
      (define cp-shape (cpSegmentShapeNew cp-body (send a to-cpv) (send b to-cpv) (exact->inexact radius)))
      (cpShapeSetElasticity cp-shape elasticity)
      (cpShapeSetFriction cp-shape friction)
      cp-shape)

    (define/public (get-point-a)
      a)

    (define/public (get-point-b)
      b)

    (define/public (get-radius)
      radius)

    ))

