let json =
  let pp = Yojson.Safe.pp in
  let eq a b = Yojson.Safe.equal a b in
  Alcotest.testable pp eq
;;

let test_empty_path () =
  Alcotest.(check (result json string))
    "empty path"
    (Ok (`Assoc []))
    (Jqml.Path.access [] (`Assoc []))
;;

let test_single_object_field () =
  Alcotest.(check (result json string))
    "single object field"
    (Ok (`String "world"))
    (Jqml.Path.access [ Obj "hello" ] (`Assoc [ "hello", `String "world" ]))
;;

let test_single_array_index () =
  Alcotest.(check (result json string))
    "single array index"
    (Ok (`String "world"))
    (Jqml.Path.access [ Arr 0 ] (`List [ `String "world" ]))
;;

let test_nested_object_field () =
  Alcotest.(check (result json string))
    "nested object field"
    (Ok (`String "world"))
    (Jqml.Path.access
       [ Obj "hello"; Obj "world" ]
       (`Assoc [ "hello", `Assoc [ "world", `String "world" ] ]))
;;

let test_nested_array_index () =
  Alcotest.(check (result json string))
    "nested array index"
    (Ok (`String "world"))
    (Jqml.Path.access [ Arr 0; Arr 0 ] (`List [ `List [ `String "world" ] ]))
;;

let test_nested_array_index_out_of_bounds () =
  Alcotest.(check (result json string))
    "nested array index out of bounds"
    (Error "Index out of bounds")
    (Jqml.Path.access [ Arr 0; Arr 1 ] (`List [ `List [ `String "world" ] ]))
;;

let test_obj_and_arr_mixed () =
  Alcotest.(check (result json string))
    "obj and arr mixed"
    (Ok (`String "world"))
    (Jqml.Path.access
       [ Obj "hello"; Arr 0 ]
       (`Assoc [ "hello", `List [ `String "world" ] ]))
;;

let test_unexisting_field () =
  Alcotest.(check (result json string))
    "unexisting field"
    (Error "Field not found")
    (Jqml.Path.access [ Obj "hello" ] (`Assoc []))
;;

let test_array_slice () =
  Alcotest.(check (result json string))
    "array slice"
    (Ok (`List [ `String "a" ]))
    (Jqml.Path.access
       [ ArrSlice (0, 1) ]
       (`List [ `String "a"; `String "b"; `String "c" ]));
  Alcotest.(check (result json string))
    "array slice"
    (Ok (`List [ `String "b"; `String "c" ]))
    (Jqml.Path.access
       [ ArrSlice (1, 3) ]
       (`List [ `String "a"; `String "b"; `String "c" ]));
  Alcotest.(check (result json string))
    "array slice"
    (Ok (`List [ `String "b"; `String "c" ]))
    (Jqml.Path.access
       [ ArrSlice (1, 4) ]
       (`List [ `String "a"; `String "b"; `String "c" ]))
;;

let cases =
  Alcotest.
    [ test_case "empty" `Quick test_empty_path
    ; test_case "single_object_field" `Quick test_single_object_field
    ; test_case "single_array_index" `Quick test_single_array_index
    ; test_case "nested_object_field" `Quick test_nested_object_field
    ; test_case "nested_array_index" `Quick test_nested_array_index
    ; test_case
        "nested_array_index_out_of_bounds"
        `Quick
        test_nested_array_index_out_of_bounds
    ; test_case "obj_and_arr_mixed" `Quick test_obj_and_arr_mixed
    ; test_case "unexisting_field" `Quick test_unexisting_field
    ; test_case "array_slice" `Quick test_array_slice
    ]
;;
