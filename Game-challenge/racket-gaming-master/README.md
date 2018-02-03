Simple Racket Game Library
==========================

[![Build Status](https://travis-ci.org/samvv/racket-gaming.svg?branch=master)](https://travis-ci.org/samvv/racket-gaming)

This is a small library written in [Racket](https://racket-lang.org) that aims to make developing
games within Racket more convenient.

This library is excellent for students just starting out with Racket and
programming in general, while it might also be useful to more experienced
programmers who want to quickly prototype a 2D game. The
[issues](https://github.com/samvv/racket-gaming/labels/question) can be used if
you run into any problems.

## Breaking Changes

This library has been extensively refactored with new functionality, while old
functionality has been removed. To learn more, read the [change
log](https://github.com/samvv/racket-gaming/tree/master/CHANGELOG.md).

## Features ##

 - Fully integrated high-performance physics engine
 - Buffered frames preventing flicker

More to come soon!

## Installation

Ensure you have [Racket](https://racket-lang.org) installed, open up a
[terminal](https://help.ubuntu.com/community/UsingTheTerminal), and run the
following command:

```bash
$ raco install gaming
```

If you have problems feel free to open an issue.

**Hint:** if you're upgrading, make sure you read the
[changelog](https://github.com/samvv/racket-gaming/tree/master/CHANGELOG.md)
before doing so!

## Platform Limitations

Currently, only macOS sierra is supported. This is due to the fact that the
[phyics engine](https://github.com/samvv/ramunk)
does not contain any releases yet for other platforms. This will get fixed in
the next couple of weeks, however.

## Hacking Into The Code

Read the [contribution guidelines](https://github.com/samvv/racket-gaming/tree/master/CONTRIBUTING.md)
for more information about how the code is structured and how you can contribute.

## Usage

The following demonstrates how to set up a world, a screen and some game objects.

```racket
#lang racket

(define circle-radius 25)

(require gaming)

(define the-screen
  (new screen%
       [title "My First Game!"]
       [width 600]
       [height 600]))

(define the-world 
  (new world% 
       [screen the-screen]
       [gravity (make-point 0 9.81)]))

(define the-ground
  (new segment%
       [a (make-point 0 (- (send the-screen get-height) (* circle-radius 2)))]
       [b (make-point (send the-screen get-width) (- (send the-screen get-height) (* circle-radius 2)))]
       [elasticity 1.0]
       [friction 1.0]))

(send the-world add-shapes the-ground)

(define falling-circle
  (new game-object%
       [world the-world]
       [position (make-point 300 300)]
       [image (circle circle-radius "solid" "blue")]
       [shape
         (new circle%
              [radius circle-radius]
              [elasticity 1.0]
              [friction 1.0])]))

(send the-world play)
```

You should see a blue circle falling and bouncing off the ground.

### Next steps

Please consult the
[full examples](https://github.com/samvv/racket-gaming/tree/master/gaming/examples) to get
your feet wet and to get an idea how the programs are made. Next, read
the documentation for extensive information on how to use the library. If you're stuck,
just [open an issue at GitHub](https://github.com/samvv/racket-gaming/issues/new).

## Credits

Library created and maintained by Sam Vervaeck.

Thanks to Adriaan Leynse for the original concept and
providing an exemplary implementation using racket/gui.

This library started out as a fork of the library provided by the [Software
Languages Lab](http://soft.vub.ac.be/soft/edu/teaching) as part of one of their
courses. 

