module L = List
open GT
open Printf
open OCanren
open OCanren.Std
open Nat

let addo x y z = ocanren {
  x == O & y == z |
  fresh x', z' in
    x == S x' & z == S z' & addo x' y z'
}

let mulo x y z = ocanren {
  x == O & z == O |
  fresh x', z' in
    x == S x' & mulo x' y z' & addo y z' z
}

let _ =
  Printf.printf "addo q r 3\n";
  L.iter (fun (q, r) -> printf "  q=%s, r=%s\n" q r)
  @@ Stream.take ~n:(-1)
  @@ run qr
       (fun q r -> addo q r (s (s (s o))))
       (fun q r ->
         (show Nat.logic (q#reify Nat.reify), show Nat.logic (r#reify Nat.reify)));
  Printf.printf "\n%!"

let _ =
  Printf.printf "addo q 1 0\n";
  L.iter (fun q -> printf "  q=%s\n" q)
  @@ Stream.take ~n:(-1)
  @@ run q
       (fun q -> addo q (s o) o)
       (fun q -> show Nat.logic (q#reify Nat.reify));
  Printf.printf "\n%!"

let _ =
  Printf.printf "mulo q r 6\n";
  L.iter (fun (q, r) -> printf "q=%s, r=%s\n" q r)
  @@ Stream.take ~n:4
  @@ run qr
       (fun q r -> mulo q r (s (s (s (s (s (s o)))))))
       (fun q r ->
         (show Nat.logic (q#reify Nat.reify), show Nat.logic (r#reify Nat.reify)));
  Printf.printf "\n%!"
