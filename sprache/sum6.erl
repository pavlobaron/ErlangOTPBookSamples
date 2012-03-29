-module(sum6).
-export([sum/2, sum/3]).

sum(0, 0) ->
    "unberechenbar";
sum(X, Y) ->
    Z = X + Y,
    Z + 100;
sum(_, _) ->
    "unklar".

sum(X, Y, Z) ->
    sum(X, Y) + Z.
