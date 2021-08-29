type level = DEBUG | INFO | ERROR | WARN

let color l msg =
  let red = "\033[0;31;1m" in
  let yellow = "\033[0;33m" in
  let white = "\033[0;37m" in
  let cyan = "\033[0;36m" in
  let color_end = "\033[0m" in
  match l with
  | DEBUG -> Printf.sprintf "%s%s%s" cyan msg color_end
  | INFO -> Printf.sprintf "%s%s%s" white msg color_end
  | ERROR -> Printf.sprintf "%s%s%s" red msg color_end
  | WARN -> Printf.sprintf "%s%s%s" yellow msg color_end

class logger =
  object (self)
    val mutable lvl : level = DEBUG

    val mutable output : Stdlib.out_channel = stdout

    val mutable prefix = ""

    val mutable with_color = false

    val lk = Mutex.create ()

    method set_output out =
      Mutex.lock lk;
      output <- out;
      Mutex.unlock lk

    method set_prefix str =
      Mutex.lock lk;
      prefix <- str;
      Mutex.unlock lk

    method set_color b =
      Mutex.lock lk;
      with_color <- b;
      Mutex.unlock lk

    method write msg =
      Mutex.lock lk;
      let buf = Bytes.of_string (msg ^ "\n") in
      Unix.write (Unix.descr_of_out_channel output) buf 0 (Bytes.length buf)
      |> ignore;
      Mutex.unlock lk

    method now () =
      let t = Unix.time () in
      let local = Unix.localtime t in
      Printf.sprintf "%d-%02d-%02d %02d:%02d:%02d" (local.tm_year + 1900)
        local.tm_mon local.tm_mday local.tm_hour local.tm_min local.tm_sec

    method with_prefix_and_time str =
      Printf.sprintf "%s %s %s" (self#now ()) prefix str

    method set_level (l : level) =
      Mutex.lock lk;
      lvl <- l;
      Mutex.unlock lk

    method debug msg =
      match lvl with
      | DEBUG | WARN ->
          let full_msg = self#with_prefix_and_time msg in
          if with_color then full_msg |> color DEBUG |> self#write
          else full_msg |> self#write
      | _ -> ()

    method error msg =
      let full_msg = self#with_prefix_and_time msg in
      if with_color then full_msg |> color ERROR |> self#write
      else full_msg |> self#write

    method info msg =
      match lvl with
      | INFO | DEBUG | WARN ->
          let full_msg = self#with_prefix_and_time msg in
          if with_color then full_msg |> color INFO |> self#write
          else full_msg |> self#write
      | _ -> ()

    method warn msg =
      match lvl with
      | WARN ->
          let full_msg = self#with_prefix_and_time msg in
          if with_color then full_msg |> color WARN |> self#write
      | _ -> ()
  end
