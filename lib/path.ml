open Base

type t =
  | Arr of int
  | Obj of string
  | ArrSlice of int * int
  | ForEach of t

let rec access path (json : Yojson.Safe.t) =
  let recur acc err v = Result.(v |> of_option ~error:err >>= access acc) in
  match path, json with
  | [], _ -> Ok json
  | Obj key :: rest, `Assoc fields ->
    List.find_map fields ~f:(fun (k, v) -> if String.(k = key) then Some v else None)
    |> recur rest "Field not found"
  | Arr n :: rest, `List lst -> List.nth lst n |> recur rest "Index out of bounds"
  | [ ArrSlice (start, end_) ], `List lst ->
    Ok (`List (List.take (List.drop lst start) (end_ - start)))
  | ArrSlice (_, _) :: _, _ -> Error "TODO: array slice can only be the last path for now"
  | ForEach _ :: _, _ -> Error "Not implemented"
  | _ -> Error "Invalid path"
;;

let parse =
  let open Angstrom in
  let dot = char '.' in
  let key = take_while1 (fun c -> Char.(c <> '.' && c <> '[' && c <> ']')) in
  let integer =
    take_while1 (function
      | '0' .. '9' -> true
      | _ -> false)
  in
  let obj = dot *> key >>| fun key -> Obj key in
  let full_slice =
    (fun start end_ -> ArrSlice (Int.of_string start, Int.of_string end_))
    <$> char '[' *> integer
    <*> (char ':' *> integer <* char ']')
  in
  let slice_no_max =
    char '[' *> integer
    <* char ':'
    <* char ']'
    >>| fun n -> ArrSlice (Int.of_string n, Int.max_value)
  in
  let slice_no_min =
    char '[' *> char ':' *> integer <* char ']' >>| fun n -> ArrSlice (0, Int.of_string n)
  in
  let arr = char '[' *> integer <* char ']' >>| fun n -> Arr (Int.of_string n) in
  let path =
    many1 (obj <|> arr <|> full_slice <|> slice_no_max <|> slice_no_min)
    <|> fail "invalid form"
  in
  parse_string ~consume:Consume.All path
;;
