#lang racket/gui
(require "bomberman-v03.rkt")
(require racket/draw
         net/url)
(define logo
  (read-bitmap (get-pure-port (string->url "https://orig00.deviantart.net/dd4e/f/2014/352/7/f/bomberman_logo_by_bloodsoft-d8aajw3.png"))))

(define frame (new frame% [label "bomberman"]
                   [width 300]
                   [height 200]))

(define msg1 (new message% [parent frame]
                  [label logo]))
(new horizontal-panel% [parent frame])
(new horizontal-panel% [parent frame])
(define panel (new horizontal-panel% [parent frame]))
(new button% [parent panel]
     [label "Start game"]
     [callback (λ(button event)
                 (go))])
(define vpanel (new vertical-panel% [parent panel]))
(new button% [parent vpanel]
     [label "high score"]
     [callback (λ(button event)
                 ("highscore.txt"))]) 
(new button% [parent panel]
     [label "Exit"]
     [callback (λ(button event)
                 (send frame show #f))]) 



(send frame show #t)