
let now_string () =
  let now = Unix.localtime @@ Unix.time () in
  Printf.sprintf "%d-%02d-%02dT%02d:%02d:%02dZ"
    (now.tm_year + 1900)
    now.tm_mon
    now.tm_mday
    now.tm_hour
    now.tm_min
    now.tm_sec

let block ?(attr=[]) output name data =
    Xmlm.output output @@ `El_start (("",name) , attr);
    Xmlm.output output @@ `Data data;
    Xmlm.output output `El_end

let write_author output name =
  Xmlm.output output @@ `El_start (("","author"),[]);
  block output "name" name;
  Xmlm.output output `El_end

let write_header output =
  block output "updated" @@ now_string ();
  block output "id" "sql2rss";
  block output "link" "https://discord.com/channels/@me"
    ~attr:[("","href"),"https://discord.com/channels/@me"];
  block output "title" "Discord Jobs"

let write_entry output ( entry : Sql.t ) =
  Xmlm.output output @@ `El_start (("","entry"),[]);
  block output "link" "https://discord.com/channels/@me"
    ~attr:[("","href"),"https://discord.com/channels/@me"];
  block output "id" entry.created_at;
  block output "content" entry.message;
  block output "published" entry.created_at;
  write_author output entry.window;
  Xmlm.output output `El_end

let write_entries output ( entries : Sql.t list ) =
  List.iter (fun e -> write_entry output e)
    entries

let write_rss ( entries : Sql.t list ) =
  let feed = ("","feed"),[("","xlmns"),"http://www.w3.org/2005/Atom"] in
  let output = Xmlm.make_output ~indent:(Some 2)
                 (`Channel stdout) in
  Xmlm.output output @@ `Dtd None;
  Xmlm.output output @@ `El_start feed;
  write_header output;
  write_entries output entries;
  Xmlm.output output `El_end
