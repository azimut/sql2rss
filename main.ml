
let now_string () =
  let now = Unix.localtime @@ Unix.time () in
  Printf.sprintf "%d-%02d-%02dT%02d:%02d:%02dZ"
    (now.tm_year + 1900)
    now.tm_mon
    now.tm_mday
    now.tm_hour
    now.tm_min
    now.tm_sec

let genrss ~id ~link ~title =
  let tag n = ("",n),[] in
  let o = Xmlm.make_output ~nl:true ~indent:(Some 2)
          @@ `Channel stdout in
  let out = Xmlm.output o in
  let o_el n d =
    out @@ `El_start (tag n);
    if d <> "" then
      out @@ `Data d;
    out `El_end
  in
  let rss_header () =
    o_el "id" id;
    o_el "link" link;
    o_el "title" title;
    o_el "updated" @@ now_string ()
  in
  let rss_element ~link ~author ~content =
    out @@ `El_start (tag "element");
    (* o_el "id" ?? *)
    (* o_el "published" ??; *)
    o_el "link" link;
    o_el "author" author;
    o_el "content" content;
    out `El_end
  in
  out @@ `Dtd None;
  out @@ `El_start (tag "feed");
  rss_header ();
  rss_element
    ~link:"http"
    ~author:"channel"
    ~content:"somecontent" ;
  out `El_end

let _ =
  genrss
    ~id:"sql2rss"
    ~link:"https://discord.com/channels/@me"
    ~title:"Discord Jobs"
