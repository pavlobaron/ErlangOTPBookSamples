-module(closures).

-export([data/0, func/0]).

data() ->
    Closure1 = make_dclosure(1, 2),
    Closure2 = make_dclosure(3, 4),
    Closure1(3) + Closure2(5) + Closure1(4) + Closure2(6).

make_dclosure(Memory1, Memory2) ->
    fun(X) ->
	    Memory1 + Memory2 + X
    end.

func() ->
    Closure1 = make_fclosure(fun io:format/2),
    Closure2 = make_fclosure(fun lformat/2),
    Closure1("string to print"),
    Closure2("string 2 print"),
    Closure1(2),
    Closure2([1, 2, 3, 4, 5]).

make_fclosure(Memory) ->
    case is_function(Memory) of
	true -> fun(P) -> Memory("automatic log ~p~n", [P]) end;
	_ -> {error, badarg}
    end.

lformat(S, L) ->
    io:format(string:concat("Local ", S), L).
