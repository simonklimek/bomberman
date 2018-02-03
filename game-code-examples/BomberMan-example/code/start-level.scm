(include "moving-object.scm")
(include "bomb.scm")
(define bomby (new bomberman% [pos-pair (cons 0 0)]
                              [dir 'r]
                              [prev-dir #f]
                              [speed-factor 5]
                              [image "Images/bomby.png"]
                              [alive #t]))
(define e1 (new enemy% [target-pos (send bomby get-pos-pair)]
                       [enemy-index 1]
                       [image "Images/enemy.jpg"]))
(define e2 (new enemy% [target-pos (send bomby get-pos-pair)]
                       [enemy-index 2]
                       [image "Images/enemy.jpg"]))
(define e3 (new enemy% [target-pos (send bomby get-pos-pair)]
                       [enemy-index 3]
                       [image "Images/enemy.jpg"]))
(define e4 (new enemy% [target-pos (send bomby get-pos-pair)]
                       [enemy-index 4]
                       [image "Images/enemy.jpg"]))
(define e5 (new enemy% [target-pos (send bomby get-pos-pair)]
                       [enemy-index 5]
                       [image "Images/enemy.jpg"]))
(define e6 (new enemy% [target-pos (send bomby get-pos-pair)]
                       [enemy-index 6]
                       [image "Images/enemy.jpg"]))
(define e7 (new enemy% [target-pos (send bomby get-pos-pair)]
                       [enemy-index 7]
                       [image "Images/enemy.jpg"]))
(define e8 (new enemy% [target-pos (send bomby get-pos-pair)]
                       [enemy-index 8]
                       [image "Images/enemy.jpg"]))
(define e9 (new enemy% [target-pos (send bomby get-pos-pair)]
                       [enemy-index 9]
                       [image "Images/enemy.jpg"]))
(define e10 (new enemy% [target-pos (send bomby get-pos-pair)]
                       [enemy-index 10]
                       [image "Images/enemy.jpg"]))
(define enemy-list (list e1 e2 e3 e4 e5 e6 e7 e8 e9 e10))
(define bomb-list '())