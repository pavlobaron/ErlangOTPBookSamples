-module(portcalc).

-export([init/0, loop/1, calc/2, stop/0]).

-define(MAX, 255).

init() ->
    Prog = "C:/Dokumente und Einstellungen/pb/Eigene Dateien/Visual Studio 2010/Projects/erlang/Debug/calc.exe",
    Port = open_port({spawn_executable, Prog},
		    [binary, {line, ?MAX}, use_stdio]),
    Pid = spawn(?MODULE, loop, [Port]),
    register(?MODULE, Pid),
    port_connect(Port, Pid).

loop(Port) ->
    receive
	{calc, A, B} ->
	    Port ! {self(), {command, term_to_binary({A, B})}},
	    Port ! {self(), {command, <<"\n">>}},
	    loop(Port);
	{_CMD} ->
	    Port ! {self(), {command, term_to_binary({_CMD})}},
	    Port ! {self(), {command, <<"\n">>}},
	    port_close(Port);
	{Port, {data, {_, Data}}} ->
	    T = binary_to_term(Data),
	    case T of
		{error, R} -> error_logger:info_msg("port error: ~p~n", [R]);
		{_, R} ->
		    D = list_to_float(R),
		    error_logger:info_msg("result: ~p~n", [D])
	    end,
	    loop(Port)
    end.

calc(A, B) ->
    ?MODULE ! {calc, A, B}.

stop() ->
    ?MODULE ! {stop}.
