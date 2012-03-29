-module(macros1).
-export([sum/1]).

-define(CONST, 123).

sum(X) ->
    X + ?CONST.
