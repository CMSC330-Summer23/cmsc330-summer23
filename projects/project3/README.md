# Project 3: Rust

Due: July 7th, 2023 at 11:59 pm (*"late deadline" with no penalty*: July 9th; *Late deadline with 10% penalty*: July 10th;  *Late deadline with 20% penalty*: July 11th)

Points: 30 public, 50 semipublic, 20 secret

Rust aims to be a better C, a safer C. There are trade-offs to this though. 
Let's see them.

### Project Files
- Rust Files
  - *src/lib.rs*: This file describes the structure of the Rust library you are making. You should not modify it.
  - *src/c2rust.rs*: This file contains the functions you must implement for part 1.
  - *src/evaluator.rs*: This file contains the functions you must implement for part 2.
  - *tests/public/mod.rs*: These are the public tests. Feel free to write your own.
 
### Compilation and Tests
In order to compile the project, simply run `cargo build`. To test, run `cargo test` in the root directory of the project. The tests won't run if any part of the project does not compile.

### Part 1: Going from C to Rust

Security comes at a cost, which is typically convenience. While Rust is safe,
it comes at the cost of easy implementation. To showcase this, we will
give you three basic C functions that you need to convert to Rust. 
The functions can be found in `c2rust.c`, and you will write the rust version in 
`c2rust.rs`. You must keep the headers the same as what we give you. 

The function headers are shown below:

#### `fn bar(str: &str) -> str`

#### `fn foo(str0: &str, str1: &str) -> [String; 2])`

#### `fn mkString(i: i32) -> String`

***Note***: You must keep the program flow the same. Consider the following:
```text
int x = 5;
int y = 6;
x+= 7;
int z = 8;

This cannot be converted to

int x = 5;
x+=7;
int y = 6;
int z = 8;
```

### Part 2: Vending Machine

Now that you know how languages are related to computational ability (Project 1)
and how we design and implement languages (Project 2), it's time to wrap this up
and combine the concepts in Rust.

Consider the following scenario:
You are designing a vending machine that accepts 5 cent, 10 cent, and 
25 cent coins. 
The customer has any 5 coins consisting of 5 cent, 10 cent, and 25 cent coins. 
They will also choose the snacks that they wish to buy. This can occur in any order.

Let's think about this in terms of a compiler. 
The vending machine needs to take the customer's order and payment, and then 
process it so that they can determine whether or not they should dispense the items. 
The vending machine should only successfully dispense the items if the customer has paid enough prior to ordering the item (otherwise, the business will be losing a lot of money!).

As we know, a compiler is made of three parts: the lexer, the parser, and the evaluator. 
Let's say the customer's order and payment are processed into a file. 
We can extract the text from the file as a string, which can be lexed into a token list consisting of `Food(String)` and `Paid(i32)` tokens. 
Then, the parser will take in this token list and return an ast. 
In our case, the ast can be represented as a linked list, where an ast can either be a `Paid(i32, Box<ast>)`, `Snack(String, Box<ast>)`, or a `Leaf`.

Finally, we have our evaluator. This is going to take in the ast, which the evaluator is going to use to tell the vending machine whether or not the customer has paid enough money. 
To actually do this, we're also going to need to know what the price of all of the vending machine's snacks are. 
We will store this information in a hashmap, with the keys being the names of the snacks and the values being their prices. 

Now if you think about it, a vending machine is a prime example of a FSM. 
Edges are adding coins or vending items (actions), 
and states represent how much money the machine has (state of the machine).

So to help you evaluate, you will need to build a FSM depending on the prices that exist.

#### `fn create_fsm(hm:HashMap<&str,i32>) -> Fsm`

- **Description:** Takes in a HashMap which dictates how much each item is. 
Creates and returns a finite state machine that represents all of the possible ways a customer could interact with the vending machine.

We will represent the Fsm structure as the following:
```rust
struct Fsm { 
  alphabet: Vec<i32>,
  start: i32,
  states: Vec<(i32, Vec<&'a str>)>,
  transitions: Vec<(i32,i32,i32)>,
  items: HashMap<&'a str,i32>,
}
```

Notice that there is no final states attribute like we had in Project 1. In addition, we have added an `items` attribute in order to have access to the HashMap of prices.
If we consider each state as a node in the graph, then at each node, the machine has a certain amount of money, which is enough to vend a certain list of items. 

So suppose a customer has only 2 coins, one 5-cent and one 10-cent coin for a total of 15 cents.
Additionally, the vending machine has some items: candy that costs 5 cents, and chocolate that costs 10 cents.

An example FSM would look like the following:
```text
let fsm = FSM {
  alphabet: [5,10,-5,-10]
  start: 0
  states: [(0,[]),(1,[candy]),(2,[candy,chocolate]),(3,[candy,chocolate])]
  transitions: [(0,5,1),(0,10,2),(1,5,2),(1,10,3),(2,5,3),(3,-5,2),(3,-10,1),(2,-5,1),(2,-10,0),(1,-5,0)]
  items: {"candy" => 5, "chocolate" => 10}
  }
```
This means that when you insert a 5-cent coin, you move to state 1 and are able to vend "candy". 
If you inserted a 10 cent coin after that, you move to state 3, and can vend either "candy" or "chocolate".
Based on the items hash, if you vend "candy", you move to state 1. If you want a second item, you can either get another piece of candy or a piece of chocolate.

#### `fn eval(fsm: &Fsm, actions: &Ast) -> bool`

- **Description:** Takes in a finite state machine and the ast, and **uses the finite state machine to determine whether or not the actions are valid**. 
Returns `true` if the actions are all legal. Returns `false` otherwise. You may assume that `fsm` is either a result of calling `create_fsm` or a DFA.
- **Examples:**
  ```rust
  let lst = Ast::Paid(5,Box::new(Ast::Snack(String::from("candy"),Box::new(Ast::Paid(10,Box::new(Ast::Snack(String::from("chocolate"),Box::new(Ast::Leaf))))))));
  let mut prices: HashMap<&str,i32> = HashMap::new();
  prices.insert("candy", 5);
  prices.insert("chocolate", 10);
  // create the fsm from the previous example here
  assert_eq!(eval(&fsm, &lst), true);
  ```

With the fsm used in this example, the eval function with the current ast would evaluate to true. However, if the customer instead inserted 5 cents and then chocolate, the eval function would evaluate to false because 5 cents is not enough to buy chocolate. On the other hand, if the customer had inserted 10 cents, bought candy, inserted 5 more cents, and bought chocolate, the function would evaluate to true because the customer has 5 cents leftover from buying candy. Inserting 10 cents, 5 more cents, and then buying candy and chocolate would also evaluate to true. Basically, there has to be enough money inserted into the vending machine to buy a snack **before** the customer tries to buy the snack.

## Academic Integrity

Please **carefully read** the academic honesty section of the course syllabus. Academic dishonesty includes posting this project and its solution online like a public github repo. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.
