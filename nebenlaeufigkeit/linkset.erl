-module(linkset).

-export([start/0, loop/0]).

start()->
    register(p1, spawn_link(?MODULE, loop, [])),
    register(p2, spawn(?MODULE, loop, [])),
    p1 ! {link, whereis(p2)}.

loop() ->
    receive
	{link, Pid} ->
	    link(Pid),
	    loop()
    end.
