open LpTypes

(* E -> + E E
       |- E E
       |* E E
       |/ E E
       | n, where n is an integer

*)


let lexer input = 
  let length = String.length input in 
    let rec tok pos = 
      if pos >= length then []
      else if Str.string_match (Str.regexp "-?[0-9]+") input pos then 
        let value = Str.matched_string input in
        Num(int_of_string value)::(tok (pos + String.length value))
      else if Str.string_match (Str.regexp "\\+") input pos then 
        Op("+")::(tok (pos + 1)) 
      else if Str.string_match (Str.regexp "\\-") input pos then 
        Op("-")::(tok (pos + 1))
      else if Str.string_match (Str.regexp "\\*") input pos then 
        Op("*")::(tok (pos + 1))
      else if Str.string_match (Str.regexp "/") input pos then 
        Op("/")::(tok (pos + 1))
      else if Str.string_match (Str.regexp "/") input pos then 
        Op("/")::(tok (pos + 1))
      else tok (pos + 1) in
  tok 0


let rec parse_help lst =  match lst with
  [] -> failwith "parser failed"
  |Num(x)::t -> Leaf(x),t
  |Op(x)::t -> let lefttree,rest = parse_help t in 
               let righttree,rest = parse_help rest in 
               Node(x,lefttree,righttree),rest
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

