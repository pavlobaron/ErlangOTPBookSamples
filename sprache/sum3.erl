-module(sum3).
-export([sum/2]).

sum(0, 0) ->
    "unberechenbar";
sum(X, Y) ->
    Z = X + Y,
    Z + 100.
