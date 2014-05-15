(* Function needs to lock the yielded list, pick up a sleeping thread and call 'wakeup' on it,
    then rinse and repeat *)
let run_thread () =
    while not (Thread.interrupted ()) do
        Lwt_sequence.lock yielded;
        let t = Lwt_sequence.take_first_l (fun t -> Lwt.try_lock_wakener t) yielded in
          Lwt_sequence.unlock yielded;
          match t with
           | None -> () (* just spin round and try it again *)
           | Some wakener ->
             wakeup wakener ();
             Lwt.unlock_wakener wakener
    done
