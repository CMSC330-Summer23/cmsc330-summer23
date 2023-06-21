open OUnit2
open Lexparse.Lp
open Lexparse.LpTypes

let student1 _ =
  let result = true in 
  let student = true in 
  assert_equal student result ~msg:"student1" 

let suite = 
  "student" >::: [
    "student1" >:: student1;
  ]

let _ = run_test_tt_main suite
