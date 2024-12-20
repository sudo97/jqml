(* open Json_testable *)

let () =
  let open Alcotest in
  run "jqml" [ "access_path", Test_access.cases; "parse path", Test_parse.cases ]
;;
