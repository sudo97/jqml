open Base

let ( let* ) = Result.( >>= )

let () =
  let path = (Sys.get_argv ()).(1) in
  let input = In_channel.input_all In_channel.stdin in
  (let* path = Jqml.Path.parse path in
   let* res = Yojson.Safe.from_string input |> Jqml.Path.access path in
   Stdio.printf "%s\n" @@ Yojson.Safe.pretty_to_string res;
   Ok ())
  |> Result.iter_error ~f:(fun err -> Stdio.eprintf "Error: %s\n" err)
;;
