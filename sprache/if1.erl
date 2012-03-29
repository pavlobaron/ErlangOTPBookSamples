-module(if1).

-export([do_if/1]).

do_if(N) ->
	if
	    is_integer(N) -> int;
	    is_atom(N) -> atom;
	    true -> unknown
	end.
