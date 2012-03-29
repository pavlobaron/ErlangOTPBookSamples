-module(cnodecalc).

-export([init/0, loop/0, calc/2, stop/0]).

-define(MAX, 255).
-define(CNODE, 'c5@pbpc01').

init() ->
    register(?MODULE, spawn(?MODULE, loop, [])).

loop() ->
    receive
	{calc, A, B} ->
	    {c, ?CNODE} ! {self(), A, B},
	    loop();
	{_CMD} ->
	    {c, ?CNODE} ! {self(), _CMD};
	{error, S} ->
	    error_logger:info_msg("C node error: ~p~n", [S]),
	    loop();
	{result, R} ->
	    error_logger:info_msg("C node result: ~p~n", [list_to_float(R)]),
	    loop()
    end.

calc(A, B) ->
    ?MODULE ! {calc, A, B}.

stop() ->
    ?MODULE ! {stop}.
