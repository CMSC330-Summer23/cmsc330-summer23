open LpTypes

(* E -> + E E
       |- E E
       |* E E
       |/ E E
       | n, where n is an integer

*)


let rec lex_help str pos lst_of_words = 
  let length = String.length str in 
    if pos >= length then lst_of_words
    else if Str.string_match (Str.regexp "-?[0-9]+") str pos then 
      let value = Str.matched_string str in
      lex_help str (pos + (String.length value)) (lst_of_words @ [Num(int_of_string value)])
    else if Str.string_match (Str.regexp "\\+\\|-\\|\\*\\|/") str pos then 
      let value = Str.matched_string str in
      lex_help str (pos + 1 ) (lst_of_words @[Op(value)])
    else if Str.string_match (Str.regexp " ") str pos then 
      lex_help str (pos + 1) lst_of_words
    else failwith "words not in lecicon"

let lexer str = 
    lex_help str 0 []


let rec parse_help lst =  match lst with
  [] -> failwith "parser failed"
  |Num(x)::t -> Leaf(x),t
  |Op(x)::t -> let lefttree,rest1 = parse_help t in 
               let righttree,rest2 = parse_help rest1 in 
               Node(x,lefttree,righttree),rest2
  |_ -> failwith "parse error"
  
let rec parse lst = 
  let tree,rest = parse_help lst in 
  if rest = [] then tree 
  else failwith "not grammatically correct"

let rec eval ast = match ast with
  Leaf(x) -> x
  |Node("+",l,r) ->  (eval l) + (eval r)
  |Node("-",l,r) ->  (eval l) - (eval r)
  |Node("*",l,r) ->  (eval l) * (eval r)
  |Node("/",l,r) ->  (eval l) / (eval r)

