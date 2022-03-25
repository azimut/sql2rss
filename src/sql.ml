let database = "irclogs"
let user = "postgres"
let query = {|
select extract(epoch from
         date_trunc('minute', created_at)) as dt,
       logs.window                         as win,
       regexp_replace(-- trim at the beggining
         string_agg(
           regexp_replace(-- delete **SomeText**
             regexp_replace(-- delete discord emojis
               substr(message, 2+strpos(message, '>')), --delete nicks
               ':.+: <https://cdn.discordapp.com/emojis/.+>', ''),
               '\*\*.+\*\*', ''),
           chr(10) order by created_at), '^\s+', '')   as msg
  from logs
 where logs.window in ('#avisos-laborales-deployar',
                       '#bolsa-de-trabajo-infochicas',
                       '#dev-ofertas',
                       '#job-search-ekoparty',
                       '#ofertas-de-empleos',
                       '#ofertas-senior-leader',
                       '#ofertas-semi-senior',
                       '#ofertas-trainee',
                       '#ofertas-junior')
   and created_at > current_date - interval '7 days'
 group by dt, win
 order by dt desc
 limit 20;
|}

type t =
  { created_at : Unix.tm;
    window     : string;
    message    : string;
  }

let to_record = function
  | [c;w;m] ->
     let module P = Pgx.Value in
     { created_at = c |> P.to_float_exn |> Unix.localtime;
       window     = w |> P.to_string_exn;
       message    = m |> P.to_string_exn; }
  | _ -> assert false

let entries () =
  Pgx_unix.with_conn ~database ~user
    (fun dbh ->
      Pgx_unix.simple_query dbh query
      |> List.hd
      |> List.map to_record
      |> List.filter (fun r -> r.message <> ""))
