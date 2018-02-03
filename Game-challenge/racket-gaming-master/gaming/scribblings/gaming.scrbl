#lang scribble/manual

This package provides a basic framework to developing games in the Racket language.

@(require (for-label racket/base racket/class gaming))

@title{Racket Game Library}

@defmodule[gaming]{
  Provides all classes and functions neccessary for developing games.
}

@include-section["world.scrbl"]
@include-section["objects.scrbl"]
@include-section["devices.scrbl"]

