-module(funs2).

-export([create_sum1/1, create_sum2/0, create_sum3/0, create_sum4/0]).

create_sum1(Y) ->
    fun(X) -> X + Y end.

create_sum2() ->
    {sum1, sum}.

create_sum3() ->
    fun sum1:sum/2.

create_sum4() ->
    fun create_sum1/1.
