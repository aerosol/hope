-module(hope_dictionary).

-export_type(
    [ t/2
    ]).


-type t(_Key, _Value) ::
    term().


-callback empty() ->
    t(_K, _V).

-callback get(t(K, V), K) ->
    hope_option:t(V).

-callback set(t(K, V), K, V) ->
    t(K, V).

-callback update(t(K, V), K, fun((hope_option:t(V)) -> V)) ->
    t(K, V).

-callback map(t(K, V), fun((K, V) -> V)) ->
    t(K, V).

-callback filter(t(K, V), fun((K, V) -> boolean())) ->
    t(K, V).

-callback fold(t(K, V), fun((K, V, Acc) -> Acc), Acc) ->
    Acc.

-callback iter(t(K, V), fun((K, V) -> ok)) ->
    ok.

-callback of_kv_list([{K, V}]) ->
    t(K, V).

-callback to_kv_list(t(K, V)) ->
    [{K, V}].
