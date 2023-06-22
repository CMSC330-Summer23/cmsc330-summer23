# Discussion 6 Lexer, Parser, Evaluator for ANON

## Reminders
* Project 2 is out and is due June 30th

## Coding Exercise
* To go from source code to a running program, there are 3 steps (at least for our purposes):
    * Tokenizing/Lexing (separating text into smaller tokens)
    * Parsing (generating something meaningful from the tokens - an AST)
    * Interpreting (evaluating the result of the AST) 

## New Language

We will now write a Lexer, Parser, and Evaluator for a new language called ANON (And, Not, Or, Nand) that handles boolean expressions. 

* Consider the following grammar:
    * E -> `&&` E E \
       | `||` E E\
       |   `--`E E\
       |    `!` E\
       |    `b` \
    **where b is true or false**

Implement the Lexer, Parser, and Evaluator for this new language for boolean expressions

## Lexer
Notice the new token types that we have for our Lexer.
- We now have
    -   `Bool of bool`
    -   `Op of string`
   

### Examples
```ocaml
alexer "true" = [Bool true]
alexer "&& true false" = [Op("&&"); Bool(true); Bool(false)]
alexer "|| true true" = [Op("||"); Bool(true); Bool(true)]
```
You can use `failwith "lexer failed"` if the input contains characters which cannot be represented by the tokens.

## Parser
Below is the type `ast`, which is returned by the parser.

```ocaml
let ast =
  | Leaf of bool
  | Binode of string * ast * ast
  | Node of string * ast 
```


 - More about `Binode` and `Node`
        - `Binode` takes in two parse trees
        - `Node` only takes in one parse tree to account for the `not` operator we have

Since we have `Binodes` and `Nodes`, we have to take these into account when we write the Parser. We need a match statement for specifically the `not` operator that uses our `Node` type. The rest is very similar to the Parser you built in lecture.

### Examples
``` ocaml
aparse [Bool true] = Leaf(true)
aparse [Op "&&"; Bool true; Bool false] = Binode ("&&", Leaf true, Leaf false)
aparse [Op "&&"; Op "!"; Bool false; Op "||"; Bool true; Bool true] = Binode ("&&", Node ("!", Leaf false), Binode ("||", Leaf true, Leaf true))

```

## Evaluator
The structure of the Evaluator is also very similar to the one you build in lecture, but you have to change the logic so that it supports boolean operations.

Remember the operations we have
- && (and)
- || (or)
- \-- (nand)
- ! (not)

and the booleans
- true
- false

### Examples
```ocaml
aeval (aparse (alexer "false")) = false
aeval (aparse (alexer "|| true true")) = true
aeval (aparse (alexer "&& ! false || true true")) = true
```

## Extra Credit (Optional)
Implement `xlexer`, `xparse`, and `xeval` for a language that is similar to the one we just implemented. This language will support variables, meaning that you can assign boolean expressions to variable names and then use these variables in other expressions. 

The different token names are `Xop of string`, `Xbool of bool`, `Let`, `Variable of string`, `Equal`, `In`

The CFG for this new language will be
* E -> `&&` E E \
       | `||` E E\
       |   `--`E E\
       |    `!` E\
       |    `b` \
       | `let` Variable `=` E `in` E

b represents `true` or `false`\
Variable represents a letter between a-z


Below is the type `xast`, which is returned by the parser.

```ocaml
let xast =
  | Xleaf of bool 
  | Xbinode of string * xast * xast 
  | Xnode of string * xast 
  | Var of string 
  | Binding of string * xast * xast
``` 

This is what you will need to keep in mind to get this feature to work:
- Lexer 
    - Take into account the new tokens: `Let`, `In`, `Equal`, and `Variable of string`
    - Variables are only 1 character length long 
- Parser
    - You will need new cases to account for let variable declarations and the variable value itself
    - You will need to use the `Binding` and `Var` xast types to implement the Parser
- Evaluator 
    - Create the cases needed for the new AST types that will be used (`Binding` and `Var`)
    - For `Binding`, you will need to utilize the environment, which is a list, to keep track of what variable is binded to what boolean expression
    - For `Var`, you will need to use the `lookup` function to retrieve the associated value to the variable in the environment

### Examples
```ocaml
xeval (xparse (xlexer "let x = true in x")) = true
xeval (xparse (xlexer "let x = true in let y = false in && x y")) = false
xeval (xparse (xlexer "let x = && -- true false true in || x true ")) = true
```

## Testing
You should be able to run `dune runtest -f` to test your functions

## Submitting

For this discussion, you will be submitting one file, `anon.ml`

Submitting should be the same as submitting your projects.
First, make sure all your changes are pushed to github using the git add, git commit, and git push commands.

Next, to submit your discussion, you can run `submit` from your project directory.

The submit command will pull your code from GitHub, not your local files. If you do not push your changes to GitHub, they will not be uploaded to gradescope.
