let main () =
  let entries = Storage.run () in
  Rss.write_rss entries

let _ =
  main ()
