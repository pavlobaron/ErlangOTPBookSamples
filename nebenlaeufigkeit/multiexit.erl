-module(multiexit).

-export([start/0, loop/0, cleanup/0,
	 stop/0, crash/0, self_kill/0,
	 ext_kill/0, normal/0, send/1]).

start()->
    register(p1, spawn(?MODULE, loop, [])),
    register(p2, spawn(?MODULE, loop, [])),
    register(p3, spawn(?MODULE, loop, [])),
    p1 ! start,
    io:format("Processes ~p,~p,~p started~n",
	      [whereis(p1), whereis(p2), whereis(p3)]).

stop() ->
    p2 ! stop.

crash() ->
    p3 ! crash.

self_kill() ->
    p1 ! kill.

ext_kill() ->
    exit(whereis(p2), kill).

normal() ->
    p3 ! normal.

send(Msg) ->
    p1 ! Msg.

loop() ->
    receive
	start ->
	    process_flag(trap_exit, true),
	    p1 ! {link, whereis(p2)},
	    p1 ! {link, whereis(p3)},
	    p3 ! {link, whereis(p2)},
	    loop();
	{link, Pid} ->
	    link(Pid),
	    loop();
	stop -> ok;
	crash ->
	    1/0;
	kill ->
	    exit(kill);
	normal ->
	    exit(normal);
	{'EXIT', Pid, Reason} ->
	    io:format("Process ~p terminated, reason: ~p~n",
		      [Pid, Reason]),
	    loop();
	_ ->
	    exit(reason)
    end.

cleanup() ->
    catch(exit(whereis(p1), kill)),
    catch(exit(whereis(p2), kill)),
    catch(exit(whereis(p3), kill)).
