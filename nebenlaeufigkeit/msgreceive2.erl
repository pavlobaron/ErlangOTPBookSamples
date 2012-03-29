-module(msgreceive2).

-export([start/0, send/1, loop/0]).

start() ->
    register(?MODULE, spawn(?MODULE, loop, [])).

send(Message) ->
    ?MODULE ! Message.

loop() ->
    receive
	stop -> ok;
	Msg ->
	    io:format("got message: ~p~n", [Msg]),
	    loop()
    end.
