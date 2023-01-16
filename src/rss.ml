open Dateutil

let title = "Discord Jobs v1.4"

let id = "sql2rss:discord:1.4"

let link = "https://discord.com/channels/@me"

let tag ?(attr = []) name data =
  let plist_to_string plist =
    plist |> List.map (fun (x, y) -> Printf.sprintf "%s=\"%s\"" x y) |> String.concat " "
  in
  match attr with
  | [] -> Printf.printf "<%s>%s</%s>\n" name data name
  | _ -> Printf.printf "<%s %s>%s</%s>\n" name (plist_to_string attr) data name

let print_header () =
  tag "title" title ;
  tag "link" link ;
  print_endline @@ "<atom:link href=\"" ^ link ^ "\" rel=\"self\" type=\"application/rss+xml\" />" ;
  tag "lastBuildDate" @@ now ()

let print_entry (entry : Sql.t) =
  let anchorify (s : string) =
    let mapanchor w =
      if String.starts_with ~prefix:"http" w then Printf.sprintf "<a href='%s'>%s</a>" w w else w
    in
    s |> String.split_on_char ' ' |> List.map mapanchor |> String.concat " "
  in
  let print_author () = Printf.printf "<author><name>%s</name></author>\n" entry.window in
  let ntobr s = s |> String.split_on_char '\n' |> String.concat " <br> " in
  let sub s n = String.sub s 0 @@ min n @@ String.length s in
  print_endline "<item>" ;
  print_author () ;
  tag "title" @@ sub entry.message 80 ;
  tag "pubDate" @@ date entry.created_at ;
  tag "guid" ~attr:[("isPermaLink", "false")] @@ date entry.created_at ;
  tag "link" entry.window ~attr:[("href", Sql.find_channel entry.window)] ;
  tag "description" (Printf.sprintf "<![CDATA[\n%s\n]]>\n" (entry.message |> ntobr |> anchorify)) ;
  print_endline "</item>"

let print (entries : Sql.t list) =
  print_endline "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" ;
  print_endline
    "<rss version=\"2.0\" xmlns:discourse=\"http://www.discourse.org/\" \
     xmlns:atom=\"http://www.w3.org/2005/Atom\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" ;
  print_endline "<channel>" ;
  print_header () ;
  List.iter print_entry entries ;
  print_endline "</channel>" ;
  print_endline "</rss>"
