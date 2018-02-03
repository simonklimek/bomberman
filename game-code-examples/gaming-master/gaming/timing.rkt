#lang racket

(require (only-in racket/gui timer% yield)
         "syntax.rkt")

(provide game-loop%
         after)

(define job<%> 'todo)

(define job%
  (class object%
    (init-field game-loop callback)
    (super-new)
    (define/public (cancel)
      (send game-loop remove-callback callback))
    (define/public (continue)
      (send game-loop add-callback callback))))

(define game-loop% 
  (class object%
  
    (init-field [framerate 60])

    (define callbacks (mutable-set))
    (define started? #f)

    (declare timestamp)
    (define (on-tick)
      (yield)
      (define now (current-milliseconds))
      (define delta (- now timestamp))
      (set-for-each callbacks (lambda (callback) (callback delta)))
      (set! timestamp now))

    (define timer (new timer% [notify-callback on-tick]))

    (super-new)

    (define/public (add-callback callback)
      (set-add! callbacks callback))
    (define/public (remove-callback callback)
      (set-remove! callbacks callback))

    (define/public (start)
      (when (not started?)
        (set! timestamp (current-milliseconds))
        (send timer start (round (* (/ 1 framerate) 1000)))
        (set! started? #t)))
    (define/public (stop)
      (send timer stop)
      (set! started? #f))

    (define/public (add callback)
      (add-callback callback)
      (make-object job% this callback))

    ))

(define (after msec callback)
  (new timer% [notify-callback callback] [interval msec])
  ; TODO: allow cancellation of event
  )

