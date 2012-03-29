-module(recursion1).

-export([doit/1]).

doit(X) ->
    if
	is_integer(X) and (X > 0) ->
	    run(1, X);
	true -> {error, badarg}
    end.

run(X, X) ->
    io:format("~p~n", [X]);
run(I, X) ->
    io:format("~p~n", [I]),
    run(I + 1, X).
