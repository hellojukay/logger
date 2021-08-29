type level = DEBUG | INFO | ERROR | WARN

val color : level -> Bytes.t -> Bytes.t

class logger :
  object
    val mutable lvl : level

    val mutable output : Stdlib.out_channel

    val mutable prefix : string

    val mutable with_color : bool

    val lk : Mutex.t

    method set_output : Stdlib.out_channel -> unit

    method set_prefix : string -> unit

    method set_color : bool -> unit

    method write : Bytes.t -> unit

    method now : unit -> string

    method with_prefix_and_time : string -> Bytes.t

    method set_level : level -> unit

    method debug : string -> unit

    method error : string -> unit

    method info : string -> unit

    method warn : string -> unit
  end
