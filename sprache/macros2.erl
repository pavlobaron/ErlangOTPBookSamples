-module(macros2).
-export([sum/2]).

-define(SUM(X, Y), X + Y).

sum(X, Y) ->
    ?SUM(X, Y).
