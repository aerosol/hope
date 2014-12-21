-module(hope_option_SUITE).

%% Callbacks
-export(
    [ all/0
    , groups/0
    ]).

%% Test cases
-export(
    [ t_of_result/1
    , t_put/1
    , t_get/1
    , t_map/1
    , t_iter/1
    , t_pipe/1
    ]).


-define(GROUP, option).


%% ============================================================================
%% Common Test callbacks
%% ============================================================================

all() ->
    [ {group, ?GROUP}
    ].

groups() ->
    Tests =
        [ t_of_result
        , t_put
        , t_get
        , t_map
        , t_iter
        , t_pipe
        ],
    Properties = [parallel],
    [ {?GROUP, Properties, Tests}
    ].


%% =============================================================================
%%  Test cases
%% =============================================================================

t_put(_Cfg) ->
    IsFoo = fun (foo) -> true; (_) -> false end,
    {some, foo} = hope_option:put(foo, IsFoo),
    none        = hope_option:put(bar, IsFoo).

t_get(_Cfg) ->
    foo = hope_option:get({some, foo}, bar),
    bar = hope_option:get(none       , bar).

t_map(_Cfg) ->
    FooToBar = fun (foo) -> bar end,
    {some, bar} = hope_option:map({some, foo}, FooToBar),
    none        = hope_option:map(none       , FooToBar).

t_iter(_Cfg) ->
    Key = key,
    Put = fun (Val) -> _ = put(Key, Val), ok end,
    Get = fun () -> get(Key) end,
    Val = foo,
    ok = hope_option:iter(none       , Put),
    undefined = Get(),
    ok = hope_option:iter({some, Val}, Put),
    Val = Get().

t_of_result(_Cfg) ->
    Foo = foo,
    Bar = bar,
    ResultOk = {ok, Foo},
    ResultError = {error, Bar},
    {some, Foo} = hope_option:of_result(ResultOk),
    none        = hope_option:of_result(ResultError).

t_pipe(_Cfg) ->
    Steps =
        [ fun (0) -> hope_option:return(1); (_) -> none end
        , fun (1) -> hope_option:return(2); (_) -> none end
        , fun (2) -> hope_option:return(3); (_) -> none end
        ],
    {some, 3} = hope_option:pipe(Steps, 0),
    none      = hope_option:pipe(Steps, 1),
    none      = hope_option:pipe(Steps, 2),
    none      = hope_option:pipe(Steps, 3).
