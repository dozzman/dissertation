
let rec fib_seq stack n = 
  match n with
  | 0 -> 1
  | 1 -> 1
  | n -> let fib_left = (fib_seq ("left " :: stack) (n-1)) and fib_right = (fib_seq ("right " :: stack) (n-2)) in
        fib_left + fib_right



let rec fib_lwt stack n = 
  match n with
  | 0 -> Lwt.return 1
  | 1 -> Lwt.return 1
  | n -> let fib_left = (fib_lwt ("left " :: stack) (n-1)) and fib_right = (fib_lwt ("right " :: stack) (n-2)) in
    Lwt.bind (fib_left) (fun fib_left ->
      Lwt.bind (fib_right) (fun fib_right ->
        Lwt.return (fib_left + fib_right)))


let rec fib_async stack n = 
  match n with
    | 0 -> Lwt.return 1
    | 1 -> Lwt.return 1
    | n -> Lwt.bind (Lwt_main.yield ()) (fun () -> 
      let fib_left = (fib_async ("left " :: stack) (n-1)) and fib_right = (fib_async ("right " :: stack) (n-2)) in
        Lwt.bind (fib_left) (fun fib_left -> 
          Lwt.bind (fib_right) (fun fib_right -> 
            Lwt.return (fib_left + fib_right))))
