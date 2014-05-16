type 'a thread_state =
  | Return of 'a
      (* [Return v] a terminated thread which has successfully
         terminated with the value [v] *)
  | Fail of exn
      (* [Fail exn] a terminated thread which has failed with the
         exception [exn]. *)
  | Sleep of 'a sleeper
      (* [Sleep sleeper] is a sleeping thread *)
  | Repr of 'a thread_repr
      (* [Repr t] a thread which behaves the same as [t] *)

and 'a thread_repr = {
  mutable state : 'a thread_state;
  (* The state of the thread *)
}

and 'a sleeper = {
  mutable cancel : cancel;
  (* How to cancel this thread. *)
  mutable waiters : 'a waiter_set;
  (* All thunk functions. These functions are always called inside a
     enter_wakeup/leave_wakeup block. *)
  mutable removed : int;
  (* Number of waiter that have been disabled. When this number
     reaches [max_removed], they are effectively removed from
     [waiters]. *)
  mutable cancel_handlers : 'a cancel_handler_set;
  (* Functions to execute when this thread is canceled. Theses
     functions must be executed before waiters. *)
}
