-module(extstate).

-export([start/0, send/2, loop/0]).

start() ->
    register(?MODULE, spawn(?MODULE, loop, [])).

send(Message, N) ->
    ?MODULE ! {self(), N, Message},
    receive
	N2 -> N2
    after
	500 -> N
    end.

loop() ->
    receive
	{_, _, crash} -> 1/0;
	{From, N, _} ->
	    N2 = N + 1,
	    From ! N2,
	    io:format("received ~p messages~n", [N2]),
	    loop()
    end.
