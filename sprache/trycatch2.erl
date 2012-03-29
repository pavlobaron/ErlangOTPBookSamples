-module(trycatch2).

-export([vartry/1, varcatch_wrong/1, varcatch_right/1]).

vartry(X) ->
    Res = try X * 2 > 0 of
        true when is_integer(X) -> integer;
	true when is_float(X) -> float;
	false -> negative
    catch
	_:Reason -> Reason
    end,
    io:format("done: ~p~n", [Res]).

varcatch_wrong(X) ->
    try X of
        X when is_integer(X) -> throw(integer);
	X when is_float(X) -> exit(float);
	_ -> error(unknown)
    catch
	error:_ -> error;
	_ -> throw;
	_:_ -> exit
    end.

varcatch_right(X) ->
    F = fun(Y) ->
	case Y of
	    Y when is_integer(Y) -> throw(integer);
	    Y when is_float(Y) -> exit(float);
	    _ -> error(unknown)
	end
    end,
    try F(X) of
	_ -> impossible
    catch
	error:_ -> error;
	_ -> throw;
	_:_ -> exit
    end.
