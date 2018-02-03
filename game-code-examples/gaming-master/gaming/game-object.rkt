#lang racket

(require ramunk
         "helpers.rkt"
         "point.rkt")

(provide game-object%)

(define position-point%
  (class cp-property-point%
    (init-field cp-body)
    (super-new)
    (define/override (get-cpv)
      (cpBodyGetPosition cp-body))
    (define/override (set-cpv new-cpv)
      (cpBodySetPosition cp-body new-cpv))))

(define velocity-point%
  (class cp-property-point%
    (init-field cp-body)
    (super-new)
    (define/override (get-cpv)
      (cpBodyGetVelocity cp-body))
    (define/override (set-cpv new-cpv)
      (cpBodySetVelocity cp-body new-cpv))))

(define game-object%
  (class object%

    (init-field world
                [image (unknown-image)]
                [controlled? #f])

    (init [position (make-point 0 0)]
          [velocity (make-point 0 0)]
          [angle 0.0]
          [mass 1.0]
          [shape #f]
          [shapes '()]
          [moment 100.0])

    (init-field [cp-body (if controlled? (cpBodyNewKinematic) (cpBodyNew mass moment))])
    (cpBodySetPosition cp-body (send position to-cpv))
    (cpBodySetVelocity cp-body (send velocity to-cpv))
    (cpBodySetAngle cp-body (exact->inexact angle))

    (send world add-object this)

    (field [cp-position (make-object position-point% cp-body)]
           [cp-velocity (make-object velocity-point% cp-body)])

    (define shape-hash (make-hash))

    (for ([shape (if shape (cons shape shapes) shapes)])
      (add-shape shape))

    (super-new)

    (define/public (get-angle)
      (cpBodyGetAngle cp-body))

    (define/public (get-x)
      (cpVect-x (cpBodyGetPosition cp-body)))
    (define/public (get-y)
      (cpVect-y (cpBodyGetPosition cp-body)))

    (define/public (add-shape shape)
      (define cp-shape (send shape get-cp-shape cp-body))
      (hash-set! shape-hash shape cp-shape)
      (cpSpaceAddShape (send world get-cp-space) cp-shape))

    (define/public (render)
      image)

    (define/public (get-position)
      cp-position)

    (define/public (get-velocity)
      cp-velocity)

    (define/public (set-position new-pos)
      (send cp-position copy new-pos))

    (define/public (set-velocity new-vel)
      (send cp-velocity copy new-vel))

    (define/public (get-cp-body)
      cp-body)
    
    (define/public (get-world)
      world)

    ))

