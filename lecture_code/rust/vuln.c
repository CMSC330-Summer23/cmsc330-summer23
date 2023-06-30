{
  int* x = malloc(sizeof(int));
  ...
  //at some point
  free(x);
  //if we do not free, mem leak
}

{
  int* x = malloc(sizeof(int));
  free(x);
  *x = 5;
  // use after free
}

{
  int* x = malloc(sizeof(int));
  free(x);
  ....
  free(x);
  //double free

}

properties of values stored on stack: 
 + fixed lifetime
 + fixed size

in rust, we have two new ideas: 
  + ownership
  + lifetimes

In rust, a lifetime is part of a variables type
  in Java :
    int x = 3; //works
    int x = 5.6; //fail
  in rust
    int x = 3; //incorrect syntax, but also, we need a lifetime
    int x = 3 with a lifetime of some function //incorrect syntax, but will compile

basic rust today



    

