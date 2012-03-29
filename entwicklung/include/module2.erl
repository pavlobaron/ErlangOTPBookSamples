-module(module2).

-export([doit/0, abdiv/2]).

-include("include2.hrl").

doit() ->
    io:format("Sum: ~p ~p ~p~n", [absum(5, 3), ?PAVLO, ?VOLKERT]).
