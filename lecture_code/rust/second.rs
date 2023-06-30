fn foo(y:i32)->i32{
  let z = y + 1;
  z
}

fn main(){
  let x = foo(3);
  println!("{}",x);
}

fn main(){
  println!("Hello World!")
}

expressions in rust
 + don't end in semicolon
 + have a value they evaluate to

first expresssion:
  { (stmt;)*
    e?
  }
  => whatever e evaluates to

  { let x = 3 + 1;
    let y = 5 + 2;
    x + y
  } => 11

  let a = {let x = 5; let y = 2; x + y}
  println!("{}",a) //should print 7

what about:
  {let x = 5;
   let y = 6;
   x + y;
  } => () //type unit

{ let x = {let y =5;y};
  let z = {let a=4+1;a-2};
  x * z
}

fn bar(x:i32) -> i32 Option{
  Some(x);
}

if expression
if guard {
  //block 1 => 'a
}else{
  //block 2 => 'a
}
=> 'a

if guard {
  //block 1 => 'a
}else if{
  //block 2 => 'a
}else{

}
=> 'a

if guard {
  let x = 5;
} => ()

let x = if true {3;} else {4;};

for iteration {
  
};

match x {
1 => 2,
2 => if true {3} else {4},
_ => {let y = 4; let x = 3; x + y},
} => i32 

types in rust
flat types
bool
integers -> i32,i8,i64,i16,isize
floats -> f32, f64
char -> utf-8

Scalar Types
String -> "Hello"
array -> [String;3] //arrays have type it holds and size of array
Tuple -> (i32,i32) //tuple of size 2
         (i32,i32,i32) is not the same as (i32,i32)
         () -> unit 
Vector and slices -> more on friday

rust is by default, immutable
let x = 3;
x +=3; //fails

let mut x = 3;
x+=3; //is fine

we will shadow variables 
{
  let x = 3;
  { let x = 5;
    println!("{}",x); //prints 5
    { let y = 5;
      println1("{}",x+y)//prints 10
    }
  };
  println!("{}",x) //prints 3
  printf("%s\n","hello");
  printf("%s\t%d\n","hello",6);
  println!("{}\t{}","hello",6);
}

let z = { let x = 5;
  let y = 6;
  x + y;
  7
}
z == 7

{
(stmt;)*
e?
}

{let x =5;
  let y = 6;
  println!("{}\t{}",x,y);
  x + y
}

let x = 5 in let y = 6 in let _ = print_int x in let _ = print_int y in x + y

