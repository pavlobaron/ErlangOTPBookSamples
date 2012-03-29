-module(msgsend).

-export([start/0, send/1, loop/0]).

start() ->
    register(?MODULE, spawn(?MODULE, loop, [])).

send(Message) ->
    ?MODULE ! Message.

loop() ->
    loop().
