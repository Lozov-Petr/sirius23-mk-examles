open GT
open OCanren
open OCanren.Std
open Tester
open Bridge
open Bridge.HO

(*************************************************)

let show_nat n =
  let rec nat2int = function Nat.O -> 0 | S n -> 1 + nat2int n in
  Printf.sprintf "%d" @@ nat2int n

let show_step f = function
  | One x -> f x
  | Two (x, y) -> Printf.sprintf "(%s, %s)" (f x) (f y)

let myshow x =
  show Pair.ground (show List.ground (show_step show_person)) show_nat x

(*************************************************)

let _ =
  let open Peano.FO in
  run_r
    (Pair.prj_exn (List.prj_exn step_prj_exn) Nat.prj_exn)
    myshow 1 q qh
    ( "answers",
      fun q ->
        fresh (ans time)
          (q === pair ans time)
          (time === nat 17)
          (FO.getAnswer ans FO.standartTimes time) )

(* let _ =
   let open Peano.FO in
   run_r
     (Pair.prj_exn (List.prj_exn step_prj_exn) Nat.prj_exn)
     myshow (-1) q qh
     ( "answers",
       fun q ->
         fresh (ans time)
           (q === pair ans time)
           (Peano.FO.( <= ) time (nat 17) !!true)
           (FO.getAnswer ans FO.standartTimes time) ) *)
