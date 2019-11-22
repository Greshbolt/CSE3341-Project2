; Main program for parsing which input is given
(define (prog var_list expr_list)
    (cond
        ((integer? expr_list) expr_list)
        ((symbol? expr_list) (findid var_list expr_list))
        ((equal? (car expr_list) 'mylet) (mylet var_list (cadr expr_list) (caddr expr_list) (cadddr expr_list)))
        ((equal? (car expr_list) 'mymul) (mymul var_list (cadr expr_list) (caddr expr_list)))
        ((equal? (car expr_list) 'myadd) (myadd var_list (cadr expr_list) (caddr expr_list)))
        ((equal? (car expr_list) 'myneg) (myneg var_list (cadr expr_list)))
        ((equal? (car expr_list) 'myignore) (myignore))
        )
)
; The myadd function
(define (myadd var_list lexpr rexpr)
    (+ (prog var_list lexpr) (prog var_list rexpr))
)
; The myignore function
(define (myignore)
    (+ 0 0)
)
; The mymul function
(define (mymul var_list lexpr rexpr)
    (* (prog var_list lexpr) (prog var_list rexpr))
)
; The myneg function
(define (myneg var_list expr)
    (* -1 (prog var_list expr))
)
; The mylet function
(define (mylet var_list iden lexpr rexpr)
    (prog (cons (cons iden (prog var_list lexpr)) var_list) rexpr )
)
; A personally made function for finding the id from the list of bindings.
(define (findid var_list iden)
    (cond 
        ((equal? iden (caar var_list)) (cdar var_list))
        (#t (findid (cdr var_list) iden))
        )
)
; The main myinterpreter function to be called for execution
(define (myinterpreter prog_list)
    (cons (prog (cons '() '()) (cadar prog_list)) (if (null? (cdr prog_list)) '() (myinterpreter (cdr prog_list))))
)