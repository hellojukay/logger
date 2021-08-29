type level = DEBUG | INFO | ERROR | WARN

class logger :
  object
    val mutable lvl : level

    val mutable output : Stdlib.out_channel

    val mutable prefix : string

    val mutable with_color : bool

    val lk : Mutex.t

    val set_output : Stdlib.out_channel -> unit

    val set_prefix : string -> unit

    val write : string -> unit

    val now : unit -> string

    val with_prefix_and_time : string -> string

    val set_level : level -> unit

    val debug : string -> unit

    val error : string -> unit

    val info : string -> unit

    val warn : string -> unit
  end
