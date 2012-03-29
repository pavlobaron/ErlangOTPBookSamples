-module(etschaos1).

-export([start/0, process/0]).

start() ->
    catch (ets:delete(chaos)),
    ets:new(chaos, [named_table, public]),
    add(100),

    spawn(?MODULE, process, []),
    delete().

add(0) -> ok;
add(N) ->
    ets:insert(chaos, {N, whatsoever}),
    add(N - 1).

process() ->
    iterate(ets:first(chaos)).

iterate('$end_of_table') -> ok;
iterate(E) ->
    io:format("reading: ~p~n", [E]),
    iterate(ets:next(chaos, E)).

delete() ->
    delete(ets:first(chaos)).

delete('$end_of_table') -> ok;
delete(E) when E rem 2 == 0 ->
    io:format("deleting: ~p~n", [E]),
    N = ets:next(chaos, E),
    ets:delete(chaos, E),
    delete(N);
delete(E) ->
    delete(ets:next(chaos, E)).
