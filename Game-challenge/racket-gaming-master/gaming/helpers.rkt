#lang racket/gui

(require syntax/srcloc
         2htdp/image
         (only-in mrlib/image-core render-image))

(provide unknown-image
         bitmap/sized
         define/delegate)

(define (dirname path)
  (let-values ([(base name must-be-dir?) (split-path path)])
    base))

(define-syntax-rule (bitmap/sized w h path)
  (let ((src (bitmap path))
        (dest (make-bitmap w h)))
    (define dc (send dest make-dc))
    (send dc set-scale 
          (/ w (image-width src))
          (/ h (image-height src)))
    (render-image src dc 0 0)
    dest))

(define (unknown-image)
  (bitmap gaming/assets/unknown.png))

;(define (image->bitmap image)
  ;(let* ([width  (image-width  image)]
         ;[height (image-height image)]
         ;[bm     (make-object bitmap% width height #f #f)]
         ;[dc     (send bm make-dc)])
    ;(send dc set-smooting 'aligned)
    ;(send dc clear)
    ;(send image draw dc 0 0 0 0 width height 0 0 #f)
    ;bm))

(define-syntax-rule (define/delegate (method-name args ...) target)
  (define/public (method-name args ...)
    (send target method-name args ...)))

