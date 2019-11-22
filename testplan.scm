#!/usr/bin/env scheme-srfi-7

(program
  (requires srfi-34 srfi-78)
  (files "myfns.ss")
  (code

(define myinterpreter-with-exception-handling
  (lambda (progs)
    (call-with-current-continuation
      (lambda (k)
        (with-exception-handler
          (lambda (x)
            (display x)
            (newline)
            (k "Error occurred in myinterpreter"))
          (lambda () (myinterpreter progs)))))))

(define (main args)
  (check-set-mode! 'report-failed)
  (display "; Testing base project...")
  (newline)

  (check (myinterpreter-with-exception-handling
           '((prog 5)))
         => '(5))

  (check (myinterpreter-with-exception-handling
           '((prog
               (myadd
                 (myadd 7 (myignore (mymul 4 5)))
                 (mymul 2 5)))))
         => '(17))

  (check (myinterpreter-with-exception-handling
           '((prog (mylet z (myadd 4 5) (mymul z 2)))))
         => '(18))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet a 66
                      (myadd (mylet b (mymul 2 4) (myadd 2 b))
                             (mymul 2 a))))))
         => '(142))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet x 66
                      (myadd (mylet x (mymul 2 4) (myadd 2 x))
                             (mymul 2 x))))))
         => '(142))

  (check (myinterpreter-with-exception-handling
           '((prog -10)))
         => '(-10))

  (check (myinterpreter-with-exception-handling
           '((prog 1)
             (prog 2)
             (prog 3)
             (prog 4)
             (prog 5)))
         => '(1 2 3 4 5))

  (check (myinterpreter-with-exception-handling
           '((prog
               (myignore 289))))
         => '(0))

  (check (myinterpreter-with-exception-handling
           '((prog
               (myignore
                 (myadd 289 -32)))))
         => '(0))

  (check (myinterpreter-with-exception-handling
           '((prog
               (myadd 289 -32))))
         => '(257))

  (check (myinterpreter-with-exception-handling
           '((prog
               (myadd 289
                      (myneg 32)))))
         => '(257))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mymul -1 -1))))
         => '(1))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mymul -2 16))))
         => '(-32))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mymul
                 (mymul
                   (mymul
                     (mymul 1 2)
                     3)
                   4)
                 5)
               )))
         => '(120))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet a 42 a))))
         => '(42))

  (check (myinterpreter-with-exception-handling
           '((prog (mylet a 42 a))
             (prog (mylet a 8 a))))
         => '(42 8))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet a (mymul 5 2)
                      a))))
         => '(10))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet a (mymul 5 2)
                      (mylet a 8
                             a)))))
         => '(8))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet a (mymul 5 2)
                      (mylet b a
                             b)))))
         => '(10))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet a (mymul 5 2)
                      (mylet b a
                             (mylet a 1
                                    a))))))
         => '(1))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet a 5
                      (mylet b 6
                             a)))))
         => '(5))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet a (myadd 2 3)
                      (mylet b (myadd a 2)
                             a)))))
         => '(5))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet a (myadd 2 3)
                      (mylet b (myadd a 2)
                             b)))))
         => '(7))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet a 1
                      (mylet b 2
                             (mylet c 3
                                    (mylet b 4
                                           a)))))))
         => '(1))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet a 1
                      (mylet b 2
                             (mylet c 3
                                    (mylet b 4
                                           c)))))))
         => '(3))

  (newline)
  (display "; Report for base project:")
  (check-report)
  (newline)

  ;Extra credit test cases
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (check-reset!)
  (display "; Testing extra credit...")
  (newline)

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet a (myfunction b (myadd b b))
                      (a 5)))))
         => '(10))

  (check (myinterpreter-with-exception-handling
           '((prog (mylet a (myfunction b (myadd b b))
                          (mylet a 1 (mymul a a))))))
         => '(1))

  (check (myinterpreter-with-exception-handling
           '((prog (mylet a (myfunction a (myadd a a))
                          (a 5)))))
         => '(10))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet x (mymul 4 5)
                      (mylet s
                             (myfunction n (mymul n n))
                             (s x))))))
         => '(400))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet x (mymul 4 5)
                      (mylet s
                             (myfunction n (mymul n n))
                             (s (myadd (s 2) (s 4))))))))
         => '(400))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet s
                      (myfunction x (mymul x x))
                      (mylet q
                             (myfunction x (s (s x)))
                             (mylet v
                                    (myfunction x (mymul x (q x)))
                                    (v 4)))))))
         => '(1024))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet a 5
                      (mylet a (myfunction a (mymul a a))
                             (a 1))))))
         => '(1))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet x 1
                      (mylet f (myfunction a (myadd a x))
                             (f 1))))))
         => '(2))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet x 1
                      (mylet f (myfunction a (myadd a x))
                             (mylet x 2
                                    (f 1)))))))
         => '(3))

  (check (myinterpreter-with-exception-handling
           '((prog
               (mylet x (myfunction x (myadd x x))
                      (mylet x (myadd (x 100) 5)
                             x)))))
         => '(205))

  (newline)
  (display "; Report for extra credit:")
  (check-report))))