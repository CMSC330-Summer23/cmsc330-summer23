# Discussion 8 Rust

## Reminders
- Project 2 Due TOMORROW! (11:59 PM)
- Graded quiz due tonight
- Final exam next week!

## Rust

Modern language designed for concurrency; it's similar to C++ and OCaml, but does it in a fast, type-safe, and thread-safe manner
* How does it achieve speed and safety? It avoids Garbage Collection, and instead uses rules for memory management 

	`let mut x = String::from("hello");` &lt;- Mutability

	`do_something(&mut x);` &lt;- Borrowing, avoids ownership change

	`println("{}",x);`

You will learn more about this next lecture. For this discussion we are just going to do practice coding in Rust.

### Rust Linked List
For discussion today, you will be implementing functions that use linked lists.

Let's see how a linked list looks like in Rust.
```rust
pub enum List {
    Cons(i32, Box<List>),
    Nil
}
```
Notice its recursive definition and notice the Box type. A Box basically allocates memory in the heap. It acts like a smart pointer which automatically allocates the right ammount of memory to store our data. We use a Box to recursivly define our linked list for this reason. If we did not use a Box, Rust would not know how much memory to allocate for our data.

Let's implement a `to_string` together for our linked list.

Implement the following functions for linked lists.

`insert(self, n: i32) -> List`
- return a linked list with the element `n` inserted at the end of the linked list

`reverse(self) -> List`
- return a reversed linked list of the caller linked list

`remove(self, target: i32) -> List`
- return a linked list with `target removed` from it. If the target does not exist return `Nil`

`contains(self, target:i32) -> bool`
- return `true` if the linked list contains the `target` element else return `false`

`insert_at(self, i:i32, n:i32) -> List`
- insert at index `i` in the linked list the given element `n`. The linked list is 0-indexed

`size(self) -> i32`
- return how many nodes the linked list has

`map(self, f: fn(i32) -> i32) -> List`
- Like map with lists in Ocaml, implement a map function that returns a linked list where a function `f` is applied onto each element of the linked list

## Code Blocks
Let's do some practice with code blocks in rust.

## Submitting
Submit the Rust coding portion of this discussion as you normally would with `git add`, `git commit -m ---`, and `git push`. Then use the submit command to submit your code to github. Remember that you also have a gradescope quiz due tonight on code blocks in rust.
