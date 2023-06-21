# Project 2: Lambda Calc Interpreter
Due: June 25th, 2023 at 11:59 pm (late June 26th, *10% penalty*; June 27, *20% penalty*)

Points: 35 public, 35 semipublic, 30 secret

## Introduction

In project 2 you will implement an interpreter for Lambda calculus. An interpreter consists of three components: Lexer (tokenizer), parser, and evaluator (interpreter).

Your lexer function will convert an input string to a token list, your parser function will consume these tokens to produce an abstract symbol tree (AST), and your evaluator will reduce the lambda calculus expression.

Here is an example call to the lexer, parser, and evaluator.

```ocaml
let toks = tokenize "((Lx. x) a)" in
let ast = parse toks in
let value = reduce [] ast in value
``` 

```ocaml
assert_equal toks [Tok_LParen;Tok_LParen;Tok_Lambda;Tok_Var "x";Tok_Dot;Tok_Var "x";Tok_RParen;Tok_Var "a";Tok_RParen]
assert_equal ast  (Application (Func ("x" Var "x"), Var "a"))
assert_equal value (Var "a")
```

### Ground Rules

In your code, you may use any OCaml modules and features we have taught in this class **except imperative OCaml** features like references, mutable records, and arrays. Functions given in lecture will probably need to be modified for this project. 

### Testing & Submitting

First, make sure all your changes are pushed to Github using the `git add`, `git commit`, and `git push` commands. You can refer to [my notes](https://bakalian.cs.umd.edu/assets/notes/git.pdf) for assistance. Additionally you can refer to a [testing repo](https://github.com/CliffBakalian/git-basics) I made, but it's recommended you make your own.

Next, to submit your project, you can run `submit` from your project directory.

The `submit` command will pull your code from GitHub, not your local files. If you do not push your changes to GitHub, they will not be uploaded to gradescope.

You can test your interpretor directly by running `dune utop src` in the project2 directory. The necessary functions and types will automatically be imported for you.

You can write your own tests which only test the parser by feeding it a custom token list. For example, to see how the expression `(Lx. x)` would be parsed, you can construct the token list manually (e.g. in `utop`):

```ocaml
parse_expr [Tok_LParen;Tok_Lambda;Tok_Var("x");Tok_dot;Tok_Var("x");Tok_RParen];;
```

Start with the lexer. Test the lexer thoroughly. Then use the lexer to generate input to test your parser. Test your parser thoroughly. Then use the lexer and parser to generate input for your evaluator.

## Part 1: The Lexer (aka Scanner or Tokenizer)

Your parser will take as input a list of tokens; this list is produced by the *lexer* (also called a *scanner* or *tokenizer*) as a result of processing the input string. Lexing is readily implemented by the use of regular expressions, as demonstrated during lecture. Information about OCaml's regular expressions library can be found in the [`Str` module documentation][str doc]. You aren't required to use it, but you may find it helpful.

Your lexer must be written in [lexer.ml](./src/lexer.ml). You will need to implement the following function: 

#### `tokenize`

- **Type:** `string -> token list` 
- **Description:** Converts a lambda calc expression (given as a string) to a corresponding token list.
- **Exceptions:** `raise Failure (tokenizing failed)` if the input contains characters which cannot be represented by the tokens.
- **Examples:**
  ```ocaml
  tokenize "L" = [Tok_Lambda]

  tokenize "(Lx. (x x))" = [Tok_LParen; Tok_Lambda; Tok_Var "x"; Tok_Dot; Tok_LParen; Tok_Var "x"; Tok_Var "x"; Tok_RParen; Tok_RParen]

  tokenize ".. L aL." = [Tok_Dot; Tok_Dot; Tok_Lambda; Tok_Var "a"; Tok_Lambda; Tok_Dot]

  tokenize "$" (* raises Failure because $ is not a valid token*)
  ```

The `token` type is defined in [tokenTypes.ml](./src/tokenTypes.ml).

Important Notes:
- The lexer input is case-sensitive.
  - "L" should not be lexed as `[Tok_Var "L"]`, but as `[Tok_Lambda]`
  -  "l" should not be lexed as `[Tok_Lambda]` but as `[Tok_Var "l"]`.
- Tokens can be separated by arbitrary amounts of whitespace, which your lexer should discard. Spaces, tabs ('\t'), and newlines ('\n') are all considered whitespace.
- When escaping characters with `\` within Ocaml strings/regexp, you must use `\\` to escape from both the string and the regexp.

Token Name | Lexical Representation
--- | ---
`Tok_LParen` | `(`
`Tok_RParen` | `)`
`Tok_Dot` | `.`
`Tok_Var` | `[a-z]`
`Tok_Lambda` | `L`
`_` | `raise (Failure "tokenizing failed")`

Notes:
- Your lexing code will feed the tokens into your parser, so a broken lexer can cause you to fail tests related to parsing. 

## Part 2: Parsing Lambda Calc Expressions

In this part, you will implement `parse`, which takes a list of tokens and outputs an AST for the input expression of type `expr`. Put all of your parser code in [parser.ml](./src/parser.ml) in accordance with the signature found in [parser.mli](./src/parser.mli). 

We present a quick overview of `parse` first, then the definition of AST types it should return, and finally the grammar it should parse.

### `parse`
- **Type:** `token list -> expr`
- **Description:** Takes a list of tokens and returns an AST representing the expression corresponding to the given tokens.
- **Exceptions:** `raise Failure (parsing failed)` if the input fails to parse i.e does not match the expressions grammer.
- **Examples** (more below):
  ```ocaml
  parse [Tok_Var "a"] = (Var "a")

  (* tokenize "(((Lx. (x x)) a) b)" *)
  parse [Tok_LParen; Tok_LParen; Tok_LParen;Tok_Lambda; Tok_Var "x"; Tok_Dot;Tok_LParen; Tok_Var "x"; Tok_Var "x"; Tok_RParen; Tok_RParen; Tok_Var "a";Tok_RParen; Tok_Var "b"; Tok_RParen] = 
  (Application (Application (Func ("x", Application (Var "x", Var "x")), Var "a"),Var "b"))

  parse [] (* raises Failure *)
  parse [Tok_Lambda;Tok_Var "x";Tok_Dot;Tok_Var "x"]  (* raises Failure because missing parenthesis *)
  ```

### AST and Grammar for `parse_expr`

Below is the AST type `expr`, which is returned by `parse`.

```ocaml
let expr =
  | Var of char
  | Func of char * expr
  | Application of expr * expr 
```

In the grammar given below, the syntax matching tokens (lexical representation) is used instead of the token name. For example, the grammar below will use `(` instead of `Tok_LParen`. 

The grammar is as follows:

```text
e -> x
   | (Lx.e)
   | (e e)
```

## Part 3: Evaluating Parsed Expressions

The evaluator will consist of four functions, all of which demonstrate properties of an evaluator. The four functions are `reduce`, `laze`, `eager`, and `isalpha`. All of these functions will be implemented in the `eval.ml` file located at `./src/eval.ml`.

***Do not alpha convert in the next three functions!***

#### `reduce`

- **Type:** `expr -> token list` 
- **Description:** Reduces a lambda calc expression down to beta normal form.
- **Examples:**
  ```ocaml
  reduce Var("x") = Var("x")
  reduce Application(Func("x",Var("x")),Var("y")) = Var("y")
  ```


#### `laze`

- **Type:** `expr -> expr` 
- **Description:** Performs a single beta reduction using the lazy precedence
- **Examples:**
  ```ocaml
  laze Var("x") = Var("x")
  laze Application(Func("x",Var("x")),Var("y")) = Var("y")
  laze Application(Func("x",Var("x")),Application(Func("y",Var("y")),Var("z"))) = Application(Func("y",Var("y")),Var("z"))
  ```

  
#### `eager`

- **Type:** `expr -> expr` 
- **Description:** Performs a single beta reduction using the eager precedence
- **Examples:**
  ```ocaml
  eager Var("x") = Var("x")
  eager Application(Func("x",Var("x")),Var("y")) = Var("y")
  eager Application(Func("x",Var("x")),Application(Func("y",Var("y")),Var("z"))) = Application(Func("x",Var("x")),Var("z"))
  ```
  
#### `isalpha`
- **Type:** `expr -> expr -> bool` 
- **Description:** Returns true if the two inputs are alpha equivalent to each other. False otherwise.
- **Examples:**
  ```ocaml
  isalpha Var("x") Var("x") = true
  isalpha Var("y") Var("x") = false 
  isalpha Func("x",Var("x")) Func("y",Var("y")) = true
  ```

## Academic Integrity

Please **carefully read** the academic honesty section of the course syllabus. Academic dishonesty includes posting this project and its solution online like a public github repo. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

[str doc]: https://caml.inria.fr/pub/docs/manual-ocaml/libref/Str.html
