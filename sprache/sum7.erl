-module(sum7).
-export([sum_redirect/2]).

-import(sum6, [sum/2]).

sum_redirect(X, Y) ->
    sum(X, Y).
