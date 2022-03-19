let title = "Discord Jobs v1.4"
let id = "sql2rss:discord:1.4"
let link = "https://discord.com/channels/@me"

(* block "LatBuildDate" "Fri, 18 Mar 2022 18:49:10 +0000" *)
let now () =
  let t = Unix.(localtime @@ time ()) in
  Printf.sprintf "Fri, %d Mar %d %02d:%02d:%02d +0000"
    t.tm_mday
    (t.tm_year + 1900)
    t.tm_hour
    t.tm_min
    t.tm_sec

let assoc_to_string assoc =
  assoc
  |> List.map (fun (x,y) -> x ^ "=\"" ^ y ^ "\"")
  |> String.concat " "

let block ?(attr=[]) name data =
  match attr with
  | [] -> Printf.printf "<%s>%s</%s>\n" name data name
  | _ -> Printf.printf "<%s %s>%s</%s>\n" name (assoc_to_string attr) data name

let print_header () =
  block "title" title;
  block "link" link;
  print_endline @@ "<atom:link href=\"" ^ link ^ "\" rel=\"self\" type=\"application/rss+xml\" />";
  block "lastBuildDate" @@ now ()

let print_entry ( entry : Sql.t ) =
  let sub s n = String.sub s 0 @@ min n @@ String.length s in
  let print_author () = Printf.printf "<author><name>%s</name></author>\n" entry.window in
  let ntobr s = s |> String.split_on_char '\n' |> String.concat "<br>" in
  print_endline "<item>";
  print_author ();
  block "title" @@ sub entry.message 80;
  block "pubDate" entry.created_at;
  block "guid" entry.created_at ~attr:["isPermaLink","false"];
  block "link" link ~attr:["href",link];
  Printf.printf "<description><![CDATA[\n DOWN %s\n]]></description>\n" @@ ntobr entry.message;
  print_endline "</item>"

let print ( entries : Sql.t list ) =
  print_endline "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
  print_endline "<rss version=\"2.0\" xmlns:discourse=\"http://www.discourse.org/\" xmlns:atom=\"http://www.w3.org/2005/Atom\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\">";
  print_endline "<channel>";
  print_header ();
  List.iter print_entry entries;
  print_endline "</channel>";
  print_endline "</rss>"
