let database = "irclogs"
let user = "postgres"
let query =
  Stdio.In_channel.with_file "query.sql"
    ~f:Stdio.In_channel.input_all

type t =
  { created_at : string;
    window     : string;
    message    : string;
  }

let run () =

  let resolve cell =
    cell
    |> Pgx.Value.to_string
    |> Option.value ~default:"" in

  let to_record = function
    | [c;w;m] ->
       { created_at = resolve c;
         window     = resolve w;
         message    = resolve m; }
    | _ -> assert false
  in

  Pgx_unix.with_conn ~database ~user
    (fun dbh ->
      Pgx_unix.simple_query dbh query
      |> List.hd
      |> List.map to_record)
