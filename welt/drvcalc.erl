-module(drvcalc).

-export([init/0, loop/1, calc/2, stop/0]).

-define(MAX, 255).
-define(DRV, "calcdrv").

init() ->
    Path = "C:/Dokumente und Einstellungen/pb/Eigene Dateien/Visual Studio 2010/Projects/erlang/Debug",
    case erl_ddll:load(Path, ?DRV) of
	ok ->
	    Drv = open_port({spawn_driver, ?DRV}, [binary]),
	    Pid = spawn(?MODULE, loop, [Drv]),
	    register(?MODULE, Pid),
	    port_connect(Drv, Pid);
	Error -> Error
    end.

loop(Drv) ->
    receive
	{calc, A, B} ->
	    Drv ! {self(), {command, term_to_binary({A, B})}},
	    loop(Drv);
	{_CMD} ->
	    Drv ! {self(), {command, term_to_binary({_CMD})}},
	    port_close(Drv);
	{Drv, {data, Data}} ->
	    T = binary_to_term(Data),
	    case T of
		{error, R} -> error_logger:info_msg("driver error: ~p~n", [R]);
		{_, R} ->
		    D = list_to_float(R),
		    error_logger:info_msg("result: ~p~n", [D])
	    end,
	    loop(Drv)
    end.

calc(A, B) ->
    ?MODULE ! {calc, A, B}.

stop() ->
    ?MODULE ! {stop},
    erl_ddll:unload(?DRV).
