-module(singleexit).

-export([start/0, loop/0, kill/0,
	 normal/0, stop/1, deny/0]).

start()->
    Pid = spawn(?MODULE, loop, []),
    register(?MODULE, Pid),
    Pid ! start,
    io:format("Starting process: ~p. Process ~p started~n",
	      [self(), Pid]).

kill() ->
    exit(whereis(?MODULE), kill).

normal() ->
    exit(whereis(?MODULE), normal).

deny() ->
    exit(whereis(?MODULE), deny).

stop(Msg) ->
    exit(whereis(?MODULE), Msg).

loop() ->
    receive
	start ->
	    process_flag(trap_exit, true),
	    loop();
	{'EXIT', Pid, deny} ->
	    io:format("Pid: ~p. Process ~p denied termination~n",
		      [Pid, self()]),
	    loop();
	{'EXIT', Pid, Reason} ->
	    io:format("Pid: ~p. Process ~p terminated, reason: ~p~n",
		      [Pid, self(), Reason])
    end.
