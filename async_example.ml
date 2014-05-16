open Concurrent

let atomic_int = AtomicInt64.make (0L)
let seq_array = Array.make 20 ""

(* repeat determines whether atomic_int <= 19, then it sets seq_array [atomic_int] to it's thread name. This creates an ordering in seq_array of the threads access *)
let rec repeat () = 
let x = AtomicInt64.increment_and_get atomic_int in
  if (Int64.compare x 19L) <= 0 then begin
    Array.set seq_array (Int64.to_int x) (Thread.get_name (Thread.current_thread ()));
    Lwt.bind (Lwt_main.yield ()) repeat
  end
  else
    Lwt.return ()
                        
(* main function starts the first iteration of the repeat function *)
let () =
  Lwt_main.run (Lwt.bind (Lwt_main.yield ()) repeat);
  Array.iter (fun x -> print_endline x) seq_array  
