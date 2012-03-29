-module(wmcalcclient).

-export([calc/2]).

calc(A, B) ->
    inets:start(),
    {ok, {_, _, Res}} =
	httpc:request(io_lib:format("http://localhost:8000/calc?A=~p&B=~p", [A, B])),
    list_to_float(Res).
