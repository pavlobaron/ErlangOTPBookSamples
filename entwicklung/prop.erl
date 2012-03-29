-module(prop).

-export([fibo_prop1_/0, fibo_prop2_/0, trap_prop_/0, log_prop_/0]).

-include("proper.hrl").

fibo_prop1_() ->
    ?FORALL(X, integer(1, 100), fibo(X) >  0).

fibo_prop2_() ->
    ?FORALL(X, integer(0, 4), fibo(X) == lists:nth(X + 1, [0, 1, 1, 2, 3])).

trap_prop_() ->
    ?FORALL(X, int(),
	    ?TRAPEXIT(
	       begin
		   Pid = spawn_link(fun proc/0),
		   Pid ! {X, self()},
		   receive
		       _ -> true
		   after
		       100 -> false
		   end
	       end
	      )).

log_prop_() ->
    ?FORALL({X, Y}, {int(), int()}, ?WHENFAIL(io:format("called with ~p and ~p~n", [X, Y]), X > Y)).

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
    Pre1;
run(X, 1, _, _) ->
    run(X, 2, 1, 0);
run(X, I, Pre1, Pre2) ->
    run(X, I + 1, Pre1 + Pre2, Pre1).

proc() ->
    receive
	{X, F} -> F ! 5/X
    end,
    proc().
