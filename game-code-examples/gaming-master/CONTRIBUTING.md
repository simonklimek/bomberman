Contribution Guidelines
=======================

This document is here to help you to contribute to the source code of Racket
gaming. Depending of your level of expertise, some parts of the library may not 
be that straightforward, which is why we are here to help.

## Getting Familiar With The Dependencies

Racket gaming depends on [ramunk](https://github.com/samvv/ramunk), which in
turn depends on [AutoFFI](https://github.com/AutoFFI/AutoFFI). _ramunk_ is the
library which binds to the [Chipmunk2D physics library](https://chipmunk-phyiscs.org).
The Racket API is identical to the C API thanks to AutoFFI, a FFI binding
generation tool. If you think you're up for it, contributing to AutoFFI would
be a really great way to help.

[Rx](https://github.com/samvv/racket-rx) is a tiny library which hides away
the nasty details of transforming the native `racket/gui` classes to
event-driven equivalents. On top of that, it provides some nice utilities for
working with [event streams](https://en.wikipedia.org/wiki/Event_stream_processing).
If you're not familiar with them, we can recommend 
[this article](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754).

## Contribution Steps

Just fork the repository and open a [pull request](https://github.com/samvv/racket-gaming/compare) whenever you like.

