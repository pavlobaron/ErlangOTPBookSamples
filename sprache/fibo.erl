-module(fibo).

-export([fibo/1]).

fibo(X) ->
    if
	is_integer(X) and (X >= 0) ->
	    case X >= 2 of
		true -> run(X, 0, 0, 0);
		false -> run(X, X, X, 0)
	    end;
	true -> {error, badarith}
    end.

run(X, I, Pre1, _) when I == X + 1 ->
    io:format("Fibonacci of ~p is ~p~n", [X, Pre1]);
run(X, 1, _, _) ->
    run(X, 2, 1, 0);
run(X, I, Pre1, Pre2) ->
    run(X, I + 1, Pre1 + Pre2, Pre1).
