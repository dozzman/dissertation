(* Mutable integer record type *)
type mut_int = {mutable data : int}

(* Immutable helper functions *)
let rec take l num = match l with
  | x::xs -> if num > 0 then x::(take xs (num-1)) else []
  | [] -> []

let rec drop l num = match l with
  | x::xs as xlist -> if num > 0 then (drop xs (num-1)) else xlist
  | [] -> []

let rec len l = match l with
  | [] -> 0
  | x::xs -> 1 + (len xs)

(* largest array size to perform linear sort *)
let sort_limit = ref (1000)

(* function generates a random array of integers *)
let rand_array n max =
  Random.self_init ();
  Array.init n (fun _ -> Random.int max)

(* Merge sort with immutable datastructures *)
let rec merge_sort_imm l = 
  let rec merge a b = match (a,b) with
    | ( x::xs as xlist , (y::ys as ylist) ) -> if x < y then x::(merge xs ylist) else y::(merge xlist ys)
    | ( [] , ylist ) -> ylist
    | ( xlist, [] ) -> xlist
  in
    match l with
      | [] -> []
      | x::[] as xlist -> xlist
      | _ as xs ->
          let length = (len xs) in let half_length = length / 2 in
            merge (merge_sort_imm (take xs half_length)) (merge_sort_imm (drop xs (length - half_length)))

(* imperative merge function (to be reused) *)
let merge a p q r = 
  let n1 = q - p + 1 in
  let n2 = r - q in
  let lhs = Array.sub a p n1 in
  let rhs = Array.sub a (q+1) n2 in
  let i = { data = 0 } in
  let j = { data = 0 } in
  let k = { data = p } in
    while (i.data < n1) && (j.data < n2) do
      let lhs_elem = Array.get lhs i.data in
      let rhs_elem = Array.get rhs j.data in
        if lhs_elem <= rhs_elem then begin
          Array.set a k.data lhs_elem;
          i.data <- i.data + 1;
          k.data <- k.data + 1;
        end
        else begin
          Array.set a k.data rhs_elem;
          j.data <- j.data + 1;
          k.data <- k.data + 1;
        end
    done;
    if i.data < n1 then
      for t = i.data to (n1 - 1) do
        let lhs_elem = Array.get lhs t in
        Array.set a k.data lhs_elem;
        k.data <- k.data + 1;
      done
    else if j.data < n2 then
      for t = i.data to (n2 - 1) do
        let rhs_elem = Array.get rhs t in
        Array.set a k.data rhs_elem;
        k.data <- k.data + 1;
      done

(* Merge sort with mutable datastructures *)
let rec mergesort l i_start i_end  =
  match (i_end - i_start + 1)  with
  | 0 -> ()
  | 1 -> ()
  | _ as len -> 
    if len > !sort_limit then begin
      let i_mid = (i_start+i_end)/2 in
        mergesort l i_start i_mid;
        mergesort l (i_mid+1) i_end;
        merge l i_start i_mid i_end
    end
    else begin
      let new_array = Array.sub l i_start len in
        Array.sort (fun a -> fun b -> if a > b then 1 else if a = b then 0 else -1) new_array;
        Array.blit new_array 0 l i_start len
    end

(* Merge sort with LWT *)
let rec lwt_mergesort l i_start i_end  =
  match (i_end - i_start + 1)  with
  | 0 -> Lwt.return ()
  | 1 -> Lwt.return ()
  | _ as len ->
    if len > !sort_limit then begin
      let i_mid = (i_start+i_end)/2 in
        Lwt.bind (lwt_mergesort l i_start i_mid) (fun () ->
          Lwt.bind (lwt_mergesort l (i_mid+1) i_end) (fun () ->
            Lwt.return (merge l i_start i_mid i_end)))
    end
    else begin
      let new_array = Array.sub l i_start len in
        Array.sort (fun a -> fun b -> if a > b then 1 else if a = b then 0 else -1) new_array;
        Array.blit new_array 0 l i_start len;
        Lwt.return ()
    end

(* Asynchronous mergesort with LWT *)
let rec async_lwt_mergesort l i_start i_end  =
  match (i_end - i_start + 1)  with
  | 0 -> Lwt.return ()
  | 1 -> Lwt.return ()
  | _ as len -> 
    if len > !sort_limit then begin
      let i_mid = (i_start+i_end)/2 in
        let t1 = Lwt.bind (Lwt_main.yield ()) (fun () -> async_lwt_mergesort l i_start i_mid) in
        let t2 = Lwt.bind (Lwt_main.yield ()) (fun () -> async_lwt_mergesort l (i_mid+1) i_end) in
          Lwt.bind (Lwt.join [t1;t2]) (fun () -> Lwt.return (merge l i_start i_mid i_end))
    end else begin
      let new_array = Array.sub l i_start len in
        Array.sort (fun a -> fun b -> if a > b then 1 else if a = b then 0 else -1) new_array;
        Array.blit new_array 0 l i_start len;
        Lwt.return ()
    end
