let title = "Discord Jobs v1.4"
let id = "sql2rss:discord:1.4"
let link = "https://discord.com/channels/@me"

(* "Fri, 18 Mar 2022 18:49:10 +0000" *)
let date tm =
  let day =
    CalendarLib.(
      tm
      |> Date.from_unixtm
      |> Date.day_of_week
      |> Printer.short_name_of_day)
  in
  let month =
    CalendarLib.(
      tm.tm_mon
      |> Date.month_of_int
      |> Printer.short_name_of_month)
  in
  Printf.sprintf "%s, %d %s %d %02d:%02d:%02d +0000"
    day
    tm.tm_mday
    month
    (tm.tm_year + 1900)
    tm.tm_hour
    tm.tm_min
    tm.tm_sec

let now () = date @@ Unix.(localtime @@ time ())

let plist_to_string plist =
  plist
  |> List.map (fun (x,y) -> Printf.sprintf "%s=\"%s\"" x y)
  |> String.concat " "

let block ?(attr=[]) name data =
  match attr with
  | [] -> Printf.printf "<%s>%s</%s>\n" name data name
  | _ -> Printf.printf "<%s %s>%s</%s>\n" name (plist_to_string attr) data name

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
  block "pubDate" @@ date entry.created_at;
  block "guid" ~attr:["isPermaLink","false"] @@ date entry.created_at;
  block "link" link ~attr:["href",link];
  Printf.printf "<description><![CDATA[\n%s\n]]></description>\n" @@ ntobr entry.message;
  print_endline "</item>"

let print ( entries : Sql.t list ) =
  print_endline "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
  print_endline "<rss version=\"2.0\" xmlns:discourse=\"http://www.discourse.org/\" xmlns:atom=\"http://www.w3.org/2005/Atom\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\">";
  print_endline "<channel>";
  print_header ();
  List.iter print_entry entries;
  print_endline "</channel>";
  print_endline "</rss>"
