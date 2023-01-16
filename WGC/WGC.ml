open GT
open OCanren

ocanren type move = Empty | Goat | Wolf | Cabbage

let qua a b c d = !!(a, b, c, d)
let [
      ([ isGoat; isWolf; isCabbage; isMan ] as are);
      ([ noGoat; noWolf; noCabbage; noMan ] as no);
    ] =
  List.map
    (fun f ->
      List.map
        (fun p s -> p f s)
        [
          (fun f s -> ocanren { fresh x, y, z in s == (f, x, y, z) });
          (fun f s -> ocanren { fresh x, y, z in s == (x, f, y, z) });
          (fun f s -> ocanren { fresh x, y, z in s == (x, y, f, z) });
          (fun f s -> ocanren { fresh x, y, z in s == (x, y, z, f) });
        ])
    [ !!true; !!false ]

let safe state =
  let safe' side = ocanren {
    isMan side |
    noMan side & {
      noGoat side |
      isGoat side & noCabbage side & noWolf side
  }}
  in
  ocanren {
  fresh left, right in
    state == (left, right) &
  safe' left &
  safe' right
  }

let swap state state' =
  ocanren {
    fresh left, right in
    state == (left, right) &
    state' == (right, left)
  }

let step state move state' =
  let step' left right state' = ocanren {
    fresh lm, lg, lw, lc, rm, rg, rw, rc in
      left == (lg, lw, lc, lm) &
      right == (rg, rw, rc, rm) & {
        move == Empty &
        state' == ((lg, lw, lc, false), (rg, rw, rc, true)) &
        safe state'
      | move == Goat &
        isGoat left &
        state' == ((false, lw, lc, false), (true, rw, rc, true)) &
        safe state'
      | move == Wolf &
        isWolf left &
        state' == ((lg, false, lc, false), (rg, true, rc, true)) &
        safe state'
      | move == Cabbage &
        isCabbage left &
        state' == ((lg, lw, false, false), (rg, rw, true, true)) &
        safe state'
  }}
  in
  ocanren {
  fresh left, right in
    state == (left, right) & {
      isMan left & noMan right & step' left right state' |
      isMan right & noMan left &
        fresh state'' in
          step' right left state'' &
          swap state'' state'
  }}

let rec eval state moves state' = ocanren {
      moves == [] & state == state' |
      fresh move, moves', state'' in
        moves == move :: moves' &
        step state move state'' &
        eval state'' moves' state'
    }

ocanren type state = (GT.bool * GT.bool * GT.bool * GT.bool) * (GT.bool * GT.bool * GT.bool * GT.bool);;
ocanren type solution = move Std.List.ground ;;

let _ =
  List.iter (fun s -> Printf.printf "%s\n" @@ show solution s)
  @@ Stream.take ~n:100
  @@ run q
       (fun q -> ocanren {
         eval ((true, true, true, true),
               (false, false, false, false))
              q
              ((false, false, false, false),
               (true, true, true, true))
       })
       (fun s -> s#reify prj_exn_solution)
