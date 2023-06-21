open LpTypes 

val lexer : string -> words list

val parse : words list -> ast

val eval : ast -> int
