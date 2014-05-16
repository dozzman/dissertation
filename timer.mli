(* timer type *)
type timer

(* make new timer *)
val make : unit -> timer

(* start timer *)
val start : timer -> unit 

(* stop timer *)
val stop : timer -> unit

(* get time difference *)
val time_nanos : timer -> int64

(* get time difference *)
val time_micros : timer -> int64

(* get time difference *)
val time_millis : timer -> int64

(* get time difference *)
val time_secs : timer -> int64

(* reset timer *)
val reset : timer -> unit




