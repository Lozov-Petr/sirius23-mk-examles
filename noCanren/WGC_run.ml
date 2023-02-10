open OCanren
open Tester
open WGC

let empty_side = HO.ctor_gside !!false !!false !!false !!false
let full_side = HO.ctor_gside !!true !!true !!true !!true
let init = Std.pair full_side empty_side
let final = Std.pair empty_side full_side

let _ =
  let run n =
    run_r
      (Std.List.reify HO.move_reify)
      (GT.show Std.List.logic @@ GT.show HO.move_logic)
      n q qh
  in
  run 100 ("First answer", fun q -> FO.eval init q final)
