type level = DEBUG | INFO | ERROR | WARN

val color : level -> string -> string

class logger :
  object
    val mutable lvl : level

    val mutable output : Stdlib.out_channel

    val mutable prefix : string

    val mutable with_color : bool

    val lk : Mutex.t

    method set_output : Stdlib.out_channel -> unit

    method set_prefix : string -> unit

    method write : string -> unit

    method now : unit -> string

    method with_prefix_and_time : string -> string

    method set_level : level -> unit

    method debug : string -> unit

    method error : string -> unit

    method info : string -> unit

    method warn : string -> unit
  end
