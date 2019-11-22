#!/usr/bin/env scheme-r5rs

;Print output from interpreting a given list of PLAN programs
;Usage: ./plan.scm [filename]
(define main
  (lambda (args)
    (load "myfns.ss") ;File defining myinterpreter
    (load (cadr args)) ;File defining examples
    (for-each
      (lambda (l)
        (write l)
        (newline))
      (myinterpreter examples))))
