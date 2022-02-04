let main () =
  Sql.entries ()
  |> Rss.write_rss

let _ =
  main ()
