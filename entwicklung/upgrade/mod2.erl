-module(mod2).

-export([start/0, stop/0, loop/0, calc1/2, calc2/2]).

-import(mod3, [calc/2]).

start() ->
    register(?MODULE, spawn(?MODULE, loop, [])).

stop() ->
    ?MODULE ! stop.

calc1(A, B) ->
    sendcalc(calc1, A, B).

calc2(A, B) ->
    sendcalc(calc2, A, B).

sendcalc(Tag, A, B) ->
    ?MODULE ! {Tag, self(), A, B},
    receive
	Res -> Res
    end.

loop() ->
    receive
	{calc1, From, A, B} -> From ! calc(A, B);
	{calc2, From, A, B} -> From ! mod3:calc(A, B);
	stop -> exit(stop)
    end,
    loop().
