let () =
  let path = Sys.argv.(1) in
  let input = In_channel.input_all In_channel.stdin in
  let path = Jqml.Path.parse path in
  let res =
    Result.bind path (fun path -> Yojson.Safe.from_string input |> Jqml.Path.access path)
  in
  match res with
  | Ok res -> Format.printf "%s\n" @@ Yojson.Safe.pretty_to_string res
  | Error err -> Format.printf "Error: %s\n" err
;;
