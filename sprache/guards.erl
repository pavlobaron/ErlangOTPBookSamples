-module(guards).

-export([guards/1]).

guards(N) when is_number(N) ->
    case N > 0 of
	true when is_integer(N) -> integer;
	true when is_float(N) -> float;
	false -> unknown
    end;
guards(N) when is_atom(N) ->
    atom;
guards(N) ->
    unknown.
