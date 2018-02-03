#lang scribble/manual

@(require (for-label racket/class racket/base rx/event-emitter gaming/screen))

@title["Devices"]

@defmodule[gaming/screen]

Interaction with the user is facilitated through so-called @italic{devices}.

@defclass[screen% object% ()]{

  @defmethod[(on-key-down [key (or/c char? symbol?)] [method procedure?]) subscription?]{
    Registers a procedure to be called whenever a certain key on the keyboard is pressed. 
  }

  @defmethod[(on-key-up [key (or/c char? symbol?)] [method procedure?]) subscription?]{
    Registers a procedure to be called whenever a certain key on the keyboard is released. 
  }

}

