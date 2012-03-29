-module(module1).

-export([doit/0]).

-include("include2.hrl").

doit() ->
    io:format("Div: ~p ~p ~p~n", [abdiv(5, 3), ?PAVLO, ?VOLKERT]).
