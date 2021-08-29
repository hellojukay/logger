type level = DEBUG | INFO | ERROR | WARN

class logger =
  object (self)
    val mutable lvl : level = DEBUG

    val mutable output : Stdlib.out_channel = stdout

    val mutable prefix = ""

    val lk = Mutex.create ()

    method set_output out =
      Mutex.lock lk;
      output <- out;
      Mutex.unlock lk

    method set_prefix str =
      Mutex.lock lk;
      prefix <- str;
      Mutex.unlock lk

    method write msg =
      Mutex.lock lk;
      let buf = Bytes.of_string msg in
      Unix.write (Unix.descr_of_out_channel output) buf 0 (Bytes.length buf)
      |> ignore;
      Mutex.unlock lk

    method now () =
      let t = Unix.time () in
      let local = Unix.localtime t in
      Printf.sprintf "%d-%02d-%02d %02d:%02d:%02d" (local.tm_year + 1900)
        local.tm_mon local.tm_mday local.tm_hour local.tm_min local.tm_sec

    method with_prefix_and_time str =
      Printf.sprintf "%s %s %s\n" (self#now ()) prefix str |> self#write

    method set_level (l : level) =
      Mutex.lock lk;
      lvl <- l;
      Mutex.unlock lk

    method debug msg =
      match lvl with DEBUG | WARN -> self#with_prefix_and_time msg | _ -> ()

    method error msg = self#with_prefix_and_time msg

    method info msg =
      match lvl with INFO -> self#with_prefix_and_time msg | _ -> ()

    method warn msg =
      match lvl with WARN -> self#with_prefix_and_time msg | _ -> ()
  end