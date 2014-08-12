%%%----------------------------------------------------------------------------
%%% Equivalent to stdlib's orddict, but with a pretty (IMO), uniform interface.
%%%----------------------------------------------------------------------------
-module(hope_kv_list).

-behavior(hope_dictionary).

-export_type(
    [ t/2
    ]).

-export(
    [ empty/0
    , get/2
    , set/3
    , update/3
    , iter/2
    , map/2
    , filter/2
    , fold/3
    , of_kv_list/1
    , to_kv_list/1
    ]).


-type t(K, V) ::
    [{K, V}].


%% ============================================================================
%% API
%% ============================================================================

-spec empty() ->
    [].
empty() ->
    [].

get(T, K) ->
    case lists:keyfind(K, 1, T)
    of  false  -> none
    ;   {K, V} -> {some, V}
    end.

set(T, K, V) ->
    lists:keystore(K, 1, T, {K, V}).

update(T, K, F) ->
    V1Opt = get(T, K),
    V2 = F(V1Opt),
    % TODO: Eliminate the 2nd lookup.
    set(T, K, V2).

iter(T, F1) ->
    F2 = lift(F1),
    lists:foreach(F2, T).

map(T, F1) ->
    F2 = lift(F1),
    F3 = fun ({K, _}=X) -> {K, F2(X)} end,
    lists:map(F3, T).

filter(T, F1) ->
    F2 = lift(F1),
    lists:filter(F2, T).

fold(T, F1, Accumulator) ->
    F2 = fun ({K, V}, Acc) -> F1(K, V, Acc) end,
    lists:foldl(F2, T, Accumulator).

to_kv_list(T) ->
    T.

of_kv_list(List) ->
    % TODO: Decide if validation is to be done here. Do so if yes.
    List.


%% ============================================================================
%% Helpers
%% ============================================================================

lift(F) ->
    fun ({K, V}) -> F(K, V) end.
