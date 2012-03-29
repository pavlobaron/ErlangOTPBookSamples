-module(funs1).

-export([create_add/0, create_sub/0, create_mul/0, create_div/0]).
-export([do_op/3]).

do_op(Par1, Par2, F) ->
    F(Par1, Par2).

create_add() ->
    fun(X, Y) -> X + Y end.

create_sub() ->
    fun(X, Y) -> X - Y end.

create_mul() ->
    fun(X, Y) -> X * Y end.

create_div() ->
    fun(X, Y) when Y /= 0 ->
	    X / Y;
       (_X, _Y) -> crash end.

