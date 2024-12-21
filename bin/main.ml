let () =
  let ( let* ) x f = Result.bind x f in
  let path = Sys.argv.(1) in
  let input = In_channel.input_all In_channel.stdin in
  (let* path = Jqml.Path.parse path in
   let* res = Yojson.Safe.from_string input |> Jqml.Path.access path in
   Format.printf "%s\n" @@ Yojson.Safe.pretty_to_string res;
   Ok ())
  |> Result.iter_error (fun err -> Format.printf "Error: %s\n" err)
;;
