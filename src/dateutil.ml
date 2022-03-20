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
