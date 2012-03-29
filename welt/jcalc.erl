-module(jcalc).

-export([calc/1, docalc/0]).

-define(MAXNUM, 100000).

calc(0) -> done;
calc(ProcsNum) ->
    _Pid = spawn(?MODULE, docalc, []),
    calc(ProcsNum - 1).

docalc() ->
    random:seed(now()),
    A = random:uniform(?MAXNUM) / random:uniform(?MAXNUM div 3),
    B = random:uniform(?MAXNUM) / random:uniform(?MAXNUM div 50),
    {java, example@pbpc01} ! {self(), A, B},
    receive
	{_Pid, Result} -> io:format("calc: ~p~n", [Result])
    after
	5000 -> {error, timeout}
    end.
