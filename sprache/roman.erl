-module(roman).
-export([roman/1]).

roman(I) ->
    lists:flatten([do_roman(D, M) || {D, M} <- decompose(I, [], 10)]).

decompose(0, L, _M) ->
    L;
decompose(I, L, M) ->
    I2 = I rem M,
    decompose(I - I2, [{I2, M div 10}|L], M * 10).

g_3(C, I) ->
    string:sub_string(lists:duplicate(3, C), 1, I).

number_base(M) ->
    case M of
	1 -> {"V", "X", "I"};
	10 -> {"L", "C", "X"};
	100 -> {"D", "M", "C"}
    end.

do_roman(D, M) ->
    {Middle, Max, Var} = number_base(M),
    I = D div M,
    if
	I < 4 -> g_3(Var, I);
	I == 4 -> [Var, Middle];
	I == 5 -> Middle;
	I < 9 -> [Middle|g_3(Var, I - 5)];
	I == 9 -> [Var, Max];
	I == 10 -> Max
    end.
