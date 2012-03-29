-module(lists2).

-export([map/1, filter/1, fold/1]).

map(L) ->
    F = fun(X) ->
        X * 10
	end,
    io:format("Map of ~p is ~p~n", [L, domap(L, F)]).

domap([], _) ->
    [];
domap([H|T], F) ->
    [F(H)|domap(T, F)].

filter(L) ->
    F = fun(X) ->
	X rem 2 == 0
	end,
    io:format("Filter of ~p is ~p~n", [L, dofilter(L, F)]).

dofilter([], _) ->
    [];
dofilter([H|T], F) ->
    case F(H) of
	true -> [H|dofilter(T, F)];
	_ -> dofilter(T, F)
    end.

fold(L) ->
    F = fun(X, Accumulator) ->
	Accumulator + X
	end,
    io:format("Fold of ~p is ~p~n", [L, dofold(L, F, 0)]).

dofold([], _, Accumulator) ->
    Accumulator;
dofold([H|T], F, Accumulator) ->
    dofold(T, F, F(H, Accumulator)).
