-module(monitor).

-export([start/0, loop/0, loopproc/0,
	 stop/0, crash/0, self_kill/0,
	 ext_kill/0, normal/0, send/1]).

start() ->
    register(?MODULE, spawn(?MODULE, loop, [])).

msgproc(Msg) ->
    ?MODULE ! {doproc, Msg}.

prepproc() ->
    {Pid, Ref} = spawn_monitor(?MODULE, loopproc, []),
    register(process, Pid),
    io:format("started process ~p, monitoring ref: ~p", [Pid, Ref]).

stop() ->
    msgproc(stop).

crash() ->
    msgproc(crash).

self_kill() ->
    msgproc(kill).

ext_kill() ->
    msgproc(ext_kill).

normal() ->
    msgproc(normal).

send(Msg) ->
    msgproc(Msg).

loopproc() ->
    receive
	stop -> ok;
	crash ->
	    1/0;
	kill ->
	    exit(kill);
	normal ->
	    exit(normal);
	_ ->
	    exit(reason)
    end.

loop() ->
    receive
	{doproc, ext_kill} ->
	    prepproc(),
	    exit(whereis(process), kill);
	{doproc, Msg} ->
	    prepproc(),
	    process ! Msg;
	{'DOWN', Ref, process, Pid, Reason} ->
	    io:format("Process ~p is down, ref: ~p, reason: ~p~n",
		      [Pid, Ref, Reason])
    end,
    loop().
