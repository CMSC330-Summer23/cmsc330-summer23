type words = Op of string | Num of int

type ast = Leaf of int | Node of string * ast * ast
