#lang scribble/manual

@(require (for-label racket/base racket/class gaming/game-object))

@title["Game Objects"]

@defmodule[gaming/game-object]

A game object is any object that takes part in the game dynamics in some way,
either passively by being an uncontrolled obstacle,
or actively by being controlled by the player.

@defclass[game-object% object% ()]{

 Represents an object in the game. The flag @code{controlled?} determines whether this
 game object is actively controlled by the player or just plays a passive role, being
 influenced by neighbouring objects and the physical forces.

 @defmethod[(get-x) number?]{
  Quickly get the x-coordinate of the position of this game object.
 }
 
 @defmethod[(get-y) number?]{
  Quickly get the y-coordinate of the position of this game object.
 }
 
 @defmethod[(get-position) void?]{
  Gets the current position of the game object.

  Note that this position might get updated by the physics engine.
 }

 @defmethod[(set-position [new-pos (is-a? point%)]) (is-a? point%)]{
  Sets the current position of the game object.

  Updating a game object's position is only safe for objects that have @code{controlled?} set to @code{#t}.
 }

 @defmethod[(get-velocity) void?]{
  Gets the current velocity of the game object.

  Note that this velocity might get updated by the physics engine.
 }

 @defmethod[(set-velocity [new-vel (is-a? point%)]) (is-a? point%)]{
  Sets the current velocity of the game object.

  Updating a game object's velocity is only safe for objects that have @code{controlled?} set to @code{#t}.
 }
 
}

