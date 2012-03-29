-module(sum4).
-export([sum/2]).

sum(X, Y) ->
    Z = X + Y,
    Z + 100;
sum(0, 0) ->
    "unberechenbar".
