# Discussion 5 Ocaml HOF and Trees

## Reminders
1. Project 2 will be released Wednesday  Due June 30th

## Submitting

For this discussion you will be submitting two files, `hof.ml` and `trees.ml`. 

Submitting should be the same as submitting your projects.
First, make sure all your changes are pushed to github using the git add, git commit, and git push commands.

Next, to submit your project, you can run `submit` from your project directory.

The submit command will pull your code from GitHub, not your local files. If you do not push your changes to GitHub, they will not be uploaded to gradescope.

## Part 1: HOF

`is_present lst x`
- Returns a list of the same length as `lst` which has a `1` at each position in which the corresponding position in `lst` is equal to `x`  and a `0` otherwise.
- Examples:
  + `is_present [1;2;3] 1 == [1;0;0]`
  + `is_present [1;2;1] 1 == [1;0;1]`

`count_occ lst target`
- Returns how many elements in `lst` are equal to `target`
- Examples:
  + `count_occ [1;2;3] 1 == 1`
  + `count_occ [1;1;1] 1 == 3`

`uniq lst`
-    Given a list  returns a list with all duplicate elements removed. Order does not matter.
- Examples:
  + `uniq[1;2;1;2] == [1;2]`
  + `uniq[4;3;2;1] == [4;3;2;1]`

`find_max matrix`
- given a list of lists find the maximum. You may assume the inputs are non-negative ints.
- Examples:
  + `find_max[[1;2];[3;4];[5;6]] == 6`
  + `find_max[[1;1];[1];[1]] == 1`

`count_ones matrix`
- given a matrix count how many 1s are in the matrix
- Examples:
  + `count_ones[[1;1];[1];[1]] == 4`
  + `count_ones[[];[3];[0]] == 0`

`addgenerator x`
- return a function that adds x to its parameter
- Examples:
  + `(addgenerator 4) 5 == 9`
  + `(addgenerator 1) 5 == 6`

`apply_to_self`
- return a function that takes in 2 parameters. The first is an element and the second is a function. The body of the function should add the element to the application of the function to the element. You may assume that the element is an int
- Examples:
  + `apply_to_self 2 (fun x -> x +1) == 5 (*2 + 2 + 1*)`
  + `apply_to_self 4 (fun x -> -x) == 0 (*4 + -4*)`

`ap fns args`
- Applies each function in `fns` to each argument in `args` in order  collecting all results in a single list.
- Examples:
  + `ap [fun x -> x + 1; fun x -> -x] [1;2;3] == [2;3;4;-1;-2;-3]`
  + `ap [fun x -> x - 1; fun x -> 4] [1;2;3] == [0;1;2;4;4;4]`

`map2 matrix f`
- write a function that is similar to `map` but works on lists of lists
- Examples:
  + `map2 [[1;2;3];[4;5;6]] (fun x -> -x) == [[-1;-2;-3];[-4;-5;-6]]`
  + `map2 [[1;2;3];[4;5;6]] (fun x -> 0) == [[0;0;0];[0;0;0]]`

## Part 2: Trees

To get more practice with pattern matching, custom data types and map/fold, let's build a `tree` data type!

First, we will define the `tree` type:

```ocaml
type 'a tree = 
  | Leaf 
  | Node of int * tree * tree
```

This recursively defines a `tree` to either be a
- `Leaf` 
- `Node` with a left sub-`tree`, an integer, and a right sub-`tree`

Implement the following functions given this type

`numNodes t`
- Type: `tree -> int`
- Return the number of nodes in a tree

`sum t`
- Type: `tree -> int`
- Return the sum of all nodes of a tree

`mirror t`
- Type: `tree -> tree`

`trim t d` 
- Type: `tree -> int -> tree`
- Given a tree `t` remove the bottom most nodes of the tree.
- Hint: Do this using the parameter d where d is the depth of the tree

`in_order t`
- Type: `tree -> int list `
- Return the inorder traversal of a tree

`pre_order t`
- Type: `tree -> int list`
- Return the preorder traversal of a tree

`post_order t`
- Type: `tree -> int list`
- Return the postorder traversal of a tree

`tree_map t f`
- Type: `tree -> (int -> int) -> tree`
- Return a tree where the function `f` is applied to all of the nodes of the tree, `t` 

`max_bst t`
- Type: `tree -> int`
- Return the maximum value in the given binary tree

`min_bst t`
- Type: `tree -> int`
- Return the minimum value in the given binary tree

`insert_bst t e`
- Type: `tree -> int -> tree`
- Insert the given element `e` into the binary tree `t`

`remove_bst t e`
- Type: `tree -> int -> tree`
- Remove the given element `e` that is in the binary tree `t`

## Part 3: Extra Credit (Optional)

Given tree_fold 

```ocaml
let rec tree_fold f init tree = 
  match tree with
  | Node(v, l, r) ->
     let l_val = tree_fold f init l in
     let r_val = tree_fold f init r in
     f l_val v r_val
  | Leaf -> init
```

Implement the functions `tf_map t`, `tf_mirror`, `tf_in_order`, and `tf_trim` that are analogous to the ones implemented in Part 2


## Testing

You should be able to run `dune runtest -f` to test your functions
