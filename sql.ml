let database = "irclogs"
let user = "postgres"
let query = {|
select date_trunc('minute', created_at) as dt,
       logs.window                      as win,
       string_agg(
         regexp_replace(-- delete **SomeText**
           regexp_replace(-- delete discord emojis
             substr(message, 1+strpos(message, '>')), --delete nicks
             ':.+: <https://cdn.discordapp.com/emojis/.+.png>',
             ''),
             '\*\*.+\*\*',
             ''),
         '<br/>' order by created_at)   as msg
  from logs
 where logs.window in ('#avisos-laborales-deployar',
                       '#bolsa-de-trabajo-infochicas',
                       '#dev-ofertas',
                       '#job-search-ekoparty',
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
  { created_at : string;
    window     : string;
    message    : string;
  }

let resolve cell =
  cell
  |> Pgx.Value.to_string
  |> Option.value ~default:""

let to_record = function
  | [c;w;m] ->
     { created_at = resolve c;
       window     = resolve w;
       message    = resolve m; }
  | _ -> assert false

let entries () =
  Pgx_unix.with_conn ~database ~user
    (fun dbh ->
      Pgx_unix.simple_query dbh query
      |> List.hd
      |> List.map to_record)
