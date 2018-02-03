#lang racket

(provide declare chain)

(define-syntax-rule (declare var)
  (define var (void)))

(define-syntax chain
  (syntax-rules ()
    [(chain expr) expr] ; done
    [(chain object (method-expr args ...) exps ...) ; calling a method
     (chain (send object method-expr args ...) exps ...)]
    [(chain object field-expr exps ...) ; looking up a field
     (chain (get-field field-expr object) exps ...)]))


