-module(msgreceive).

-export([start/0, send/1, loop/0]).

start() ->
    register(?MODULE, spawn(?MODULE, loop, [])).

send(Message) ->
    ?MODULE ! Message.

loop() ->
    receive
	Msg -> io:format("got message: ~p~n", [Msg])
    end,
    loop().
