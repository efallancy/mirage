open Functoria
open Mirage_impl_misc

type random = RANDOM
let random = Type RANDOM

let random_conf = object
  inherit base_configurable
  method ty = random
  method name = "random"
  method module_name = "Mirage_crypto_rng"
  method! packages =
    Mirage_key.(if_ is_unix)
      [ package ~sublibs:["unix"] "mirage-crypto-rng" ]
      [ package "mirage-crypto-rng" ;
        package ~min:"1.0.0" "mirage-entropy" ]
  method! connect i _ _ =
    match get_target i with
    | #Mirage_key.mode_unix ->
      "Lwt.return (Mirage_crypto_rng_unix.initialize ())"
    | _ ->
      (* here we could use the boot argument to select the RNG! *)
      "Entropy.connect (module Mirage_crypto_rng.Fortuna)"
end

let default_random = impl random_conf

let nocrypto = Functoria_app.noop
