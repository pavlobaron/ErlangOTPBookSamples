-module(agserver).
-export([start/0,
	 stop/0,
	 connect/2,
	 loop/0]).

start() ->
    register(?MODULE,
	     spawn(?MODULE, loop, [])),
    ?MODULE ! {start}.

stop() ->
    ?MODULE ! {stop, self()}.

connect(Auctions, Node) ->
    do_connect(Auctions, Node, length(Auctions)).

do_connect([], _, N) ->
    connect_loop(N);
do_connect([Auction|T], Node, N) ->
    {?MODULE, Node} ! {connect,
		       self(), Auction},
    do_connect(T, Node, N).

connect_loop(0) ->
    ok;
connect_loop(N) ->
    receive
		{welcome, From} ->
			error_logger:info_msg(
			  "Welcome from ~p~n",
			  [From])
    after
		5000 ->
			error_logger:info_msg(
			  "No welcome, timeout~n")
    end,
    connect_loop(N - 1).

ensure_auction(Auction) ->
    Res = length(
	    [X || X <- registered(),
		  X =:= Auction]),
    if
		Res > 0 -> ok;
		true -> agauction:start(Auction)
    end.

loop() ->
    receive
		{start} ->
			error_logger:info_msg(
			  "Let's start.~n"),
			loop();
		{connect, From, Auction} ->
			ensure_auction(Auction),
			agauction:connect(Auction,
					  From),
			loop();
		{stop, _} ->
			error_logger:info_msg(
			  "We close. Bye-bye.~n"),
			exit(stop)
    end.
