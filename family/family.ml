open OCanren

type person = Joe | Edward | Kate | Emily | William
[@@deriving gt ~options:{ show }]

let male x = conde [ x === !!Joe; x === !!Edward; x === !!William ]
let female x = conde [ x === !!Kate; x === !!Emily ]

let parent x y =
  conde
    [
      x === !!William &&& (y === !!Kate);
      x === !!Joe &&& (y === !!Emily);
      x === !!Joe &&& (y === !!Edward);
      x === !!Kate &&& (y === !!Emily);
      x === !!Kate &&& (y === !!Edward);
    ]

let father x y = parent x y &&& male x
let mother x y = parent x y &&& female x
let sibling x y = fresh z (x =/= y) (parent z x) (parent z y)
let brother x y = sibling x y &&& male x
let sister x y = sibling x y &&& female x
let grandfather x y = fresh z (father x z) (parent z y)
let grandmother x y = fresh z (mother x z) (parent z y)

let _ =
  let show_person = GT.show logic @@ GT.show person in
  let show_answers ~msg f answers =
    Printf.printf "%s: [" msg;
    (match answers with
    | [] -> ()
    | answer :: rest ->
        Printf.printf "%s" @@ f answer;
        List.iter (fun ans -> Printf.printf ", %s" @@ f ans) rest);
    Printf.printf "]%!\n"
  in
  let run ~msg n query =
    run q query (fun x -> x#reify reify)
    |> Stream.take ~n
    |> show_answers show_person ~msg
  in

  let run2 ~msg n query =
    OCanren.run qr query (fun x y -> (x#reify reify, y#reify reify))
    |> Stream.take ~n
    |> show_answers (GT.show Std.Pair.ground show_person show_person) ~msg
  in

  run (-1) (fun _ -> male !!Kate) ~msg:"male Kate";
  run (-1) (fun _ -> male !!Joe) ~msg:"male Joe";
  run (-1) (fun q -> male q) ~msg:"male q";
  run (-1) (fun q -> female q) ~msg:"female q";
  run (-1) (fun q -> father q !!Edward) ~msg:"father q Edward";
  run (-1) (fun q -> mother q !!Emily) ~msg:"mother q Emily";
  run (-1) (fun q -> brother q !!Emily) ~msg:"brother q Emily";
  run (-1) (fun q -> sister q !!Emily) ~msg:"sister q Emily";
  run (-1) (fun q -> grandfather q !!Emily) ~msg:"grandfather q Emily";
  run (-1) (fun q -> grandmother q !!Emily) ~msg:"grandmother q Emily";
  run2 (-1) (fun p q -> father p q) ~msg:"father p q"
