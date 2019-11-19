(define (prog expr_list var_list)
    (define (myadd lexpr rexpr var_list)
        (+ (prog lexpr var_list) (prog rexpr var_list))
    )

)
