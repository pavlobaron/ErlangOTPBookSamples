-module(trycatch3).

-export([doit/1]).

doit(X) ->
    try 5/X of
	Result -> Result
    catch
	error:Error -> Error
    after
	io:format("I'm here in any case~n")
    end.
