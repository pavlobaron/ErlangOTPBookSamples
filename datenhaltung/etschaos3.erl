-module(etschaos3).

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
    ets:safe_fixtable(chaos, true),
    iterate(ets:first(chaos)).

iterate('$end_of_table') ->
    ets:safe_fixtable(chaos, false);
iterate(E) ->
    io:format("reading: ~p~n", [E]),
    iterate(ets:next(chaos, E)).

delete() ->
    ets:safe_fixtable(chaos, true),
    delete(ets:first(chaos)).

delete('$end_of_table') ->
    ets:safe_fixtable(chaos, false);
delete(E) when E rem 2 == 0 ->
    io:format("deleting: ~p~n", [E]),
    N = ets:next(chaos, E),
    ets:delete(chaos, E),
    delete(N);
delete(E) ->
    delete(ets:next(chaos, E)).
