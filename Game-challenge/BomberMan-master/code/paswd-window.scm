(require racket/string)
(require racket/gui)
(define (next-level-paswd i) ; For making password protected levels we created a window which can take text input from the user
  (define count 1)
  (define (paswd-window)
    (define frame (new frame% [label "Enter the next level"]
                       [width 400]
                       [height 200]))
     
    (send frame show #t)
    
    (define message (if (= count 1) "Enter the password for next level "
                       "wrong password, enter again"))
    (define msg (new message% [parent frame]
                     [label message]))
    (define passwd-field (new text-field% [label "password"]
                              [parent frame]
                              [vert-margin 10];both side margin	 
                              [horiz-margin 100]
                              [style '( single password)]))
    (new button% [parent frame]
         [label "Done"]             
         [callback (lambda (button event)
                     (if (equal? (send passwd-field get-value) (passwd i)) 
                         (begin 
                           (send frame show #f)
                           (level (+ i 1)))
                         (begin(set! count (+ 1 count))(send frame show #f)(paswd-window))))]))
  (if (= i 5)
      (level-cleared 5)
      (paswd-window)))

(define (passwd i)
  (cond [(= i 1) "level2"]
        [(= i 2) "level3"]
        [(= i 3) "level4"]
        [(= i 4) "level5"]))
                 


