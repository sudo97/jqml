let path =
  let open Jqml.Path in
  let pp fmt k =
    match k with
    | Obj key -> Format.fprintf fmt ".%s" key
    | Arr n -> Format.fprintf fmt "[%d]" n
    | ArrSlice (start, end_) -> Format.fprintf fmt "[%d:%d]" start end_
  in
  let eq = ( = ) in
  Alcotest.testable pp eq
;;

let empty_path_test () =
  Alcotest.(check (result (list path) string)) "empty path" (Ok []) (Jqml.Path.parse "")
;;

let single_object_field_test () =
  Alcotest.(check (result (list path) string))
    "single object field"
    (Ok [ Obj "hello" ])
    (Jqml.Path.parse ".hello")
;;

let single_array_index_test () =
  Alcotest.(check (result (list path) string))
    "single array index"
    (Ok [ Arr 0 ])
    (Jqml.Path.parse "[0]")
;;

let field_and_index_test () =
  Alcotest.(check (result (list path) string))
    "field and index"
    (Ok [ Obj "hello"; Arr 0 ])
    (Jqml.Path.parse ".hello[0]")
;;

let nested_array_test () =
  Alcotest.(check (result (list path) string))
    "nested array"
    (Ok [ Arr 0; Arr 1; Arr 2; Arr 3 ])
    (Jqml.Path.parse "[0][1][2][3]")
;;

let nested_object_test () =
  Alcotest.(check (result (list path) string))
    "nested object"
    (Ok [ Obj "hello"; Obj "world"; Obj "foo"; Obj "bar" ])
    (Jqml.Path.parse ".hello.world.foo.bar")
;;

let nested_array_and_object_test () =
  Alcotest.(check (result (list path) string))
    "nested array and object"
    (Ok [ Arr 0; Obj "hello"; Arr 1; Obj "world"; Arr 2; Obj "foo"; Arr 3; Obj "bar" ])
    (Jqml.Path.parse "[0].hello[1].world[2].foo[3].bar")
;;

let cases =
  [ "empty path", `Quick, empty_path_test
  ; "single object field", `Quick, single_object_field_test
  ; "single array index", `Quick, single_array_index_test
  ; "field and index", `Quick, field_and_index_test
  ; "nested array", `Quick, nested_array_test
  ; "nested object", `Quick, nested_object_test
  ; "nested array and object", `Quick, nested_array_and_object_test
  ]
;;
