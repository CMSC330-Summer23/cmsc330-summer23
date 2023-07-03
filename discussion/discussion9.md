# Discussion 9 - July 2<sup>nd</sup>

## Reminders
* Project 3 Due July 7th, 2023 at 11:59 pm ("late deadline" with no penalty: July 9th; Late deadline with 10% penalty: July 10th; Late deadline with 20% penalty: July 11th)
* Graded rust code at the end of discussion
* Final on Friday!

## What is Rust? 

Modern language designed for concurrency; it's similar to C++ and OCaml, but does it in a fast, type-safe, and thread-safe manner
* How does it achieve speed and safety? It avoids Garbage Collection, and instead uses rules for memory management 

	`let mut x = String::from("hello");` &lt;- Mutability

	`do_something(&mut x);` &lt;- Borrowing, avoids ownership change

	`println("{}",x);`

### Mutability

* Variables can either be declared as mutable (`mut`) or immutable
    * Similar to `const` in C
    * Mutable means the variable can be reassigned, e.g. `let mut x = 0; x = x + 5;`

### Ownership

#### Terms

* **Value**: Data stored in memory (Strings, ints, structs, etc...), values must always be owned by exactly one variable
* **Variable**: may own a value, or be a reference to a value
* **Scope**: The area where a `variable` is defined, usually from the `let` statement until end of its codeblock (`}`)
* **Lifetime**: The area where a `value` is defined, because `value`s can change owners, this is not always the same as the scope of the variable it was initally owned by


#### Rules

* Ownership is a technique used to automatically free variables
    * Each piece of data has a single owner(variable) at a time. When its owner goes out of scope, its value is dropped from memory
    * Ownership changes through two operations
        * Variable assignment
            * Ownership of the value transfers to the new variable, the old variable becomes invalid (no data)
            * Note that primitives like integers, booleans, etc. do not transfer ownership on assignment. Primitives implement the `Copy` trait, so their value can simply be copied to new variables
            * E.g. 
    
    			`let s1 = String::from("hello");` &lt;- s1 is owner
    
    			`let s2 = s1;` &lt;- Ownership is transferred from s1 to s2
    
    			`println!("{}",s1);` &lt;- Error, s1 is now invalid
    
        * Function call
            * When a variable is passed into a function, ownership is transferred to the function, so the variable is invalidated after the function is run
            * `let s1 = String::from("hello"); 	do_something(s1);`
            * Ownership was transferred from s1 to function parameter; s1 is now invalidated
     
### Borrowing/References

* We can use references to get around ownership issues
* Borrowing is similar to pointers in C, two types
    * Mutable ref, `&mut` - Can edit variable, only for mutable variables, only one may exist at any point in time
    * Immutable ref, `&` - Can't edit
* Allows us to pass in references to functions, preventing ownership from going out of scope
* Also used for things like iteration; when looping through list, get a series of references to elements in list
* One limitation: Can only either have `1 mutable ref` or `many immutable refs` at any given time
    * This prevents weird write errors
* Exemplified by String class; `&str` is a read-only pointer to String, whereas String class is similar to array of chars

Example with .iter(): 

```ocaml
let mut arr = [1,2,3];
for &i in arr.iter() {
	println!("{}",i);
}
```

    

What does this mean when you write programs? 


1. Make sure you know which variables are mutable and immutable
2. Be aware of who owns certain variables, and pass around references to make sure ownership doesn't go out

Some common errors are


1. Variable mutability
2. Using variable after it goes out of scope
3. Passing in regular variable instead of reference
4. Failing to return correct value from function
5. Incorrect types (reference when regular variables should be used, etc.)

## Rust Coding
Now that we now more about rust, let's do more coding with rust.

Implement the following functions

`fn gauss(n: i32) -> i32`
* **Description**: Returns the sum 1 + 2 + ... + n.  If n is negative, return -1.
* **Examples**:
```
gauss(3) => 6
gauss(10) => 55
gauss(-17) => -1
```

`fn in_range(lst: &[i32], s: i32, e: i32) -> i32`
* **Description**: Returns the number of elements in the list that are in the range [s,e].
* **Examples**:
```
in_range(&[1,2,3], 2, 4) => 2
in_range(&[1,2,3], 4, 7) => 0
```

`fn subset<T: PartialEq>(set: &[T], target: &[T]) -> bool`
* **Description**: Returns true if target is a subset of set, false otherwise.
* **Examples**:
```
subset(&[1,2,3,4,5], &[1,5,2]) => true
subset(&[1,2,3,4,5], &[1,2,7]) => false
subset(&['a','b','c'], &[]) => true
```

`fn mean(lst: &[f64]) -> Option<f64>`
* **Description**: Returns the mean of elements in lst. If the list is empty, return None.
* **Examples**:
```
mean(&[2.0, 4.0, 9.0]) => Some(5.0)
mean(&[]) => None
```

`fn to_decimal(lst: &[i32]) -> i32`
* **Description**: Converts a binary number to decimal, where each bit is stored in order in the array.
* **Examples**:
```
to_decimal(&[1,0,0]) => 4
to_decimal(&[1,1,1,1]) => 15
```

`fn factorize(n: u32) -> Vec<u32>`
* **Description**: Decomposes an integer into its prime factors and returns them in a vector.  You can assume factorize will never be passed anything less than 2.
* **Examples**:
```
factorize(5) => [5]
factorize(12) => [2,2,3]
```

`fn rotate(lst: &[i32]) -> Vec<i32>`
* **Description**: Takes all of the elements of the given slice and creates a new vector.  The new vector takes all the elements of the original and rotates them, so the first becomes the last, the second becomes first, and so on.
* **Examples**:
```
rotate(&[1,2,3,4]) => [2,3,4,1]
rotate(&[6,7,8,5]) => [7,8,5,6]
```

`fn substr(s: &String, target: &str) -> bool`
* **Description**: Returns true if target is a subtring of s, false otherwise.  You should not use the contains function of the string library in your implementation.
* **Examples**:
```
substr(&"rustacean".to_string(), &"ace") => true
substr(&"rustacean".to_string(), &"rcn") => false
substr(&"rustacean".to_string(), &"") => true
```
## Submitting
Submit the discussion as you normally would with `git add`, `git commit -m "[message]"`, and `git push`. Then use the submit command to submit your code to github. 

## Testing
Use the command `cargo test` to test your code locally.
