-module(sum2).
-export([sum/2]).

sum(X, Y) ->
    Z = X + Y,
    Z + 100.
