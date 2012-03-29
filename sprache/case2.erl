-module(case2).

-export([do_case/1]).

do_case(N) ->
	case N of
		{1, 2, 3} -> tuple;
		[1, 2, 3] -> list;
		"string" -> string;
		{variable, X} -> X;
		_ -> whatever
	end.