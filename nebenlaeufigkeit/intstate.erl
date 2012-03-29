-module(intstate).

-export([start/0, send/1, loop/1]).

start() ->
    register(?MODULE, spawn(?MODULE, loop, [0])).

send(Message) ->
    ?MODULE ! Message.

loop(N) ->
    receive
	crash -> 1/0;
	_ ->
	    io:format("received ~p messages~n", [N + 1]),
	    loop(N + 1)
    end.
