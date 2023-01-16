open GT
open OCanren
open OCanren.Std
open Tester
open Bridge.HO

(*************************************************)
module Gperson = struct
  [%%distrib
  type nonrec t = gperson =
    | A
    | B
    | C
    | D
  [@@deriving gt ~options:{ show; gmap }]

  type nonrec ground = t]
end

module Gpeano = struct
  [%%distrib
  type nonrec 'a0 t = 'a0 gpeano =
    | O 
    | S of 'a0
  [@@deriving gt ~options:{ show; gmap }]

  type ground = ground t]
end

module Gstep = struct
  [%%distrib
  type nonrec 'a0 t = 'a0 gstep =
    | One of 'a0
    | Two of 'a0 * 'a0
  [@@deriving gt ~options:{ show; gmap }]

  type nonrec ground = Gperson.ground t]
end

let show_person = function
  | A -> "A"
  | B -> "B"
  | C -> "C"
  | D -> "D"
;;

let show_step f = function
  | One x -> f x
  | Two (x, y) -> Printf.sprintf "(%s, %s)" (f x) (f y)
;;

let show_nat n = 
  let rec nat2int = function
  | O -> 0
  | S n -> 1 + nat2int n in
  Printf.sprintf "%d" @@ nat2int n

let myshow x = show Pair.ground show_nat (show List.ground (show_step show_person)) x

(*************************************************)

let rec int2nat i = if i = 0 then o () else s @@ int2nat @@ (i - 1)

let less_17 x =
  let rec less x y  =
    conde [
      fresh (y') 
        (x === o ()) 
        (y === s y');
      fresh (x' y')
        (x === s x')
        (y === s y')
        (less x' y')
    ] 
  in 
  less x (int2nat 17)

(** For high order conversion **)
let getAnswer q t r = getAnswer (( === ) q) t r

let _ =
  run_r
    (Pair.prj_exn Gpeano.prj_exn @@ List.prj_exn Gstep.prj_exn)
    myshow
    1
    q
    qh
    ("answers", fun q -> 
      fresh (time answer)
        (q === pair time answer)
        (time === int2nat 17)
        (getAnswer answer standartTimes (some time)))
;;
