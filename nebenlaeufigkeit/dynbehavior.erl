-module(dynbehavior).

-export([start/0, send/1, loop/1]).

f(Msg) ->
    fun() -> io:format("Last message was: ~p~n", [Msg]) end.

start() ->
    register(?MODULE, spawn(?MODULE, loop, [f("N/A")])).

send(Msg) ->
    ?MODULE ! Msg.

loop(F) ->
    receive
	Msg ->
	    F(),
	    loop(f(Msg))
    end.
