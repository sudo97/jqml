type t =
  | Arr of int
  | Obj of string
  | ArrSlice of int * int
  | ForEach of t

let rec access path (json : Yojson.Safe.t) =
  let recur acc err v =
    v |> Option.to_result ~none:err |> Fun.flip Result.bind (access acc)
  in
  match path, json with
  | [], _ -> Ok json
  | Obj key :: rest, `Assoc fields ->
    List.assoc_opt key fields |> recur rest "Field not found"
  | Arr n :: rest, `List lst -> List.nth_opt lst n |> recur rest "Index out of bounds"
  | ArrSlice (start, end_) :: [], `List lst ->
    Ok
      (`List
          (lst |> List.to_seq |> Seq.drop start |> Seq.take (end_ - start) |> List.of_seq))
  | ArrSlice (_, _) :: _, _ ->
    failwith "TODO: array slice can only be the last path for now"
  | ForEach _ :: _, _ -> failwith "Not implemented"
  | _ -> Error "Invalid path, the accessor and the json are not compatible"
;;

let parse =
  let open Angstrom in
  let dot = char '.' in
  let key = take_while1 (fun c -> c <> '.' && c <> '[' && c <> ']') in
  let integer =
    take_while1 (function
      | '0' .. '9' -> true
      | _ -> false)
  in
  let obj = dot *> key >>| fun key -> Obj key in
  let full_slice =
    (fun start end_ -> ArrSlice (int_of_string start, int_of_string end_))
    <$> char '[' *> integer
    <*> (char ':' *> integer <* char ']')
  in
  let slice_no_max =
    char '[' *> integer
    <* char ':'
    <* char ']'
    >>| fun n -> ArrSlice (int_of_string n, Int.max_int)
  in
  let slice_no_min =
    char '[' *> char ':' *> integer <* char ']' >>| fun n -> ArrSlice (0, int_of_string n)
  in
  let arr = char '[' *> integer <* char ']' >>| fun n -> Arr (int_of_string n) in
  let path =
    many1 (obj <|> arr <|> full_slice <|> slice_no_max <|> slice_no_min)
    <|> fail "invalid form"
  in
  parse_string ~consume:Consume.All path
;;
