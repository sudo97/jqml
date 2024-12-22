type t =
  | Arr of int
  | Obj of string
  | ArrSlice of int * int

let rec access path (json : Yojson.Safe.t) =
  let recur acc err v =
    v |> Option.to_result ~none:err |> Fun.flip Result.bind (access acc)
  in
  match path with
  | [] -> Ok json
  | Obj key :: rest ->
    (match json with
     | `Assoc fields -> List.assoc_opt key fields |> recur rest "Field not found"
     | _ -> Error "Expected an object")
  | Arr n :: rest ->
    (match json with
     | `List lst -> List.nth_opt lst n |> recur rest "Index out of bounds"
     | _ -> Error "Expected a list")
  | ArrSlice (start, end_) :: [] ->
    (match json with
     | `List lst ->
       Ok
         (`List
             (lst
              |> List.to_seq
              |> Seq.drop start
              |> Seq.take (end_ - start)
              |> List.of_seq))
     | _ -> Error "Expected a list")
  | ArrSlice (_, _) :: _ -> failwith "TODO: array slice can only be the last path for now"
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
  let arr = char '[' *> integer <* char ']' >>| fun n -> Arr (int_of_string n) in
  let path = many (obj <|> arr) in
  parse_string ~consume:Consume.All path
;;
