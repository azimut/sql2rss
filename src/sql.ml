type t = {created_at: Unix.tm; window: string; message: string}

module Chans = Map.Make (String)

let database_name = "irclogs"

let database_user = "postgres"

let channels_alist =
  [ ("#avisos-laborales-deployar", "https://discord.com/channels/712042571245027438/726231396628168734")
  ; ("#bolsa-de-trabajo-infochicas", "https://discord.com/channels/722479605814001766/722481989864652870")
  ; ("#job-search-ekoparty", "https://discord.com/channels/727291328915832914/763602718668619786")
  ; ("#ofertas-de-empleos", "https://discord.com/channels/768278151435386900/793661563705360394")
  ; ("#ofertas-senior-leader", "https://discord.com/channels/594363964499165194/759056592648798229")
  ; ("#ofertas-semi-senior", "https://discord.com/channels/594363964499165194/757967606815916174")
  ; ("#ofertas-trainee", "https://discord.com/channels/594363964499165194/757967541170733257")
  ; ("#ofertas-junior", "https://discord.com/channels/594363964499165194/757967571302482050")
  ; ("#vacantes-laborales", "https://discord.com/channels/920046149300265000/920098509196230676")
  ; ("#nim-jobs", "https://discord.com/channels/371759389889003530/845770858470965258") ]

let channels_map = channels_alist |> List.to_seq |> Chans.of_seq

let find_channel chan = Chans.find chan channels_map

let query =
  channels_alist |> List.map fst
  |> List.map (fun s -> "'" ^ s ^ "'")
  |> String.concat ","
  |> Printf.sprintf
       {|
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
 where logs.window in (%s)
   and created_at > current_date - interval '7 days'
 group by dt, win
 order by dt desc
 limit 20;
|}

let to_record = function
  | [c; w; m] ->
      let module P = Pgx.Value in
      { created_at= c |> P.to_float_exn |> Unix.localtime
      ; window= w |> P.to_string_exn
      ; message= m |> P.to_string_exn }
  | _ -> assert false

let entries () =
  Pgx_unix.with_conn ~ssl:`No ~database:database_name ~user:database_user (fun dbh ->
      Pgx_unix.simple_query dbh query |> List.hd |> List.map to_record
      |> List.filter (fun r -> r.message <> "") )
