-module(lists1).

-export([first/1, print/1, sum/1, filter/1]).

first([H|_]) ->
    H.

print([]) -> ok;
print([H|T]) ->
    io:format("~p~n", [H]),
    print(T).

sum(L) ->
    dosum(L, 0).

dosum([], Sum) ->
    io:format("Sum: ~p~n", [Sum]);
dosum([H|T], Sum) ->
    dosum(T, Sum + H).

filter(L) ->
    dofilter(L, []).

dofilter([], L) ->
    io:format("Filtered list: ~p~n", [lists:reverse(L)]);
dofilter([H|T], L) when H rem 2 == 0 ->
    dofilter(T, [H|L]);
dofilter([_|T], L) ->
    dofilter(T, L).
