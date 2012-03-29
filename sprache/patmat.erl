-module(patmat).

-export([mat/2]).

mat(X = {_, _}, [_, Y, _]) when is_integer(element(1, X)), is_integer(Y) ->
    element(1, X) + Y.
