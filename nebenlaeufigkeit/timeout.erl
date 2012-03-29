-module(timeout).

-export([start/0, loop/0]).

start() ->
    spawn(?MODULE, loop, []).

loop() ->
    receive
	_ -> ok
    after
	10000 -> io:format("timeout~n", [])
    end.
