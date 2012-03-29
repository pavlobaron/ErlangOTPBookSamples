-module(trycatch).

-export([doit/2]).

doit(A, B) ->
    if
	is_number(A) and is_number(B) and (A > B * 10) and (B > 0) ->
	    try A / B of
		Res -> Res
	    catch
		_:badarith -> typeerror;
		_:_ -> unknownerror
	    end;
	true -> generalerror
    end.
