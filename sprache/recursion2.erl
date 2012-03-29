-module(recursion2).

-export([doit/1]).

doit(X) ->
    if
	is_integer(X) and (X > 0) ->
	    run(X);
	true -> {error, badarith}
    end.

run(1) ->
    io:format("1~n");
run(I) ->
    io:format("~p~n", [I]),
    run(I - 1).
