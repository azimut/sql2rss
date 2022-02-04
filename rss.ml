let now_string () =
  let now = Unix.localtime @@ Unix.time () in
  Printf.sprintf "%d-%02d-%02dT%02d:%02d:%02dZ"
    (now.tm_year + 1900)
    now.tm_mon
    now.tm_mday
    now.tm_hour
    now.tm_min
    now.tm_sec

let assoc_to_string assoc =
  assoc
  |> List.map (fun (x,y) -> x ^ "=\"" ^ y ^ "\"")
  |> String.concat " "

let block ?(attr=[]) name data =
  match attr with
  | [] -> Printf.printf "<%s>%s</%s>\n" name data name
  | _ -> Printf.printf "<%s %s>%s</%s>\n" name (assoc_to_string attr) data name

let print_author name =
  Printf.printf "<author><name>%s</name></author>" name

let print_header () =
  block "title" "Discord Jobs";
  block "id" "sql2rss:discord";
  block "link" "https://discord.com/channels/@me"
    ~attr:["href","https://discord.com/channels/@me"];
  block "updated" @@ now_string ()

let print_entry ( entry : Sql.t ) =
  let length = min 80 (String.length entry.message) in
  let title = String.sub entry.message 0 length in
  print_endline "<entry>";
  block "link" "https://discord.com/channels/@me"
    ~attr:["href","https://discord.com/channels/@me"];
  block "id" entry.created_at;
  block "content" entry.message;
  block "published" entry.created_at;
  block "title" title;
  print_author entry.window;
  print_endline "</entry>"

let print ( entries : Sql.t list ) =
  print_endline "<?xml version='1.0' encoding='utf-8'?>";
  print_endline "<feed xmlns='http://www.w3.org/2005/Atom'>";
  print_header ();
  List.iter print_entry entries;
  print_endline "</feed>"
