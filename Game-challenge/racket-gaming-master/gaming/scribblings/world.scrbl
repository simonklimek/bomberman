#lang scribble/manual 

@(require racket/class (for-label racket/class racket/base gaming/world))

@title["The World"]

@defmodule[gaming/world]

A world represents a unique collection of game objects and defines the
relationships between these objects. The world can keep this information
in any way it chooses to, which allows for some critical performance 
optimizations.

@defclass[world% object% ()]{

 Represents one world. Usually, one instance of this object is created for each level in the game.
                             
 @defmethod[(add-shape [shape (is-a? shape%)] ...) void?]{
  Adds a shape to the world itself. The shape will be attached to a virtual
  static game object, which is to say that none of the physical forces
  will act on the shape.

  This method is generally useful for adding impenetrable static structures,
  such as a fixed gound for left and right edges.
 }

 @defmethod[(play) void?]{
  Start simulation of the world, meaning that physical forces will interact and the result will be drawn to the screen.
 }

 @defmethod[(pause) void?]{
  Pauses all physical forces and keeps the game standing still on the current frame.
 }

}
