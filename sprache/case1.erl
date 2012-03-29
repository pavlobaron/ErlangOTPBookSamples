-module(case1).

-export([do_case/1]).

do_case(N) ->
	case is_integer(N) of
		true -> ok;
		false -> error
	end.