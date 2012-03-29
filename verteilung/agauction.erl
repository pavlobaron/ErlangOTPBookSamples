-module(agauction).
-export([start/1, connect/2, loop/2, bid/3]).

start(Name) ->
    register(Name, spawn_link(?MODULE,
			      loop,
			      [dict:new(),
			       {none, {self(), 0}}])),
    Name ! {start}.

connect(Name, From) ->
    Name ! {connect, From}.

connect_client(From, Bids) ->
    Node = node(From),
    Res = dict:find(Node, Bids),
    NewBids = if
		is_tuple(Res) andalso (element(1, Res) == ok) ->
		      log("reconnected from: ~p~n", [Node]),
			Bids;
		true ->
		      log("connected from: ~p~n", [Node]),
		      dict:store(Node, {From, 0}, Bids)
    end,
    erlang:monitor(process, From),
    From ! {welcome, self()},
    NewBids.

bid(Name, Node, Money, From) ->
    {Name, Node} ! {bid, Money, From},
    receive
	{Res, _} -> error_logger:info_msg("bid status: ~p~n", [Res])
    after
	5000 -> error_logger:info_msg("no bid status, timeout~n")
    end.

bid(Name, Node, Money) ->
    bid(Name, Node, Money, self()).

do_bid(From, Money, Bids, CurrentBid) ->
    Node = node(From),
    {_, {_, LastMoney}} = CurrentBid,
    if
	(LastMoney < Money) ->
	    log("client ~p bids ~p~n", [Node, Money]),
	    NewBids = dict:store(Node, {From, Money}, Bids),
	    From ! {bidok, self()},
	    loop(NewBids, {<<1:2>>, {From, Money}});
	true ->
	    log("client ~p bids not enough: ~p~n", [Node, Money]),
	    From ! {bidnotok, self()},
	    loop(Bids, CurrentBid)
    end.

log(String, Params) ->
    {_, Name} = process_info(self(), registered_name),
    error_logger:info_msg(string:concat("~p: ", String), [Name|Params]).

loop(Bids, Bid) ->
    receive
	{start} ->
	    process_flag(trap_exit, true),
	    loop(Bids, Bid);
	{connect, From} ->
	    loop(connect_client(From, Bids), Bid);
	{bid, Money, From} ->
	    do_bid(From, Money, Bids, Bid);
	{'DOWN', _Ref, process, Pid, Reason} ->
	    log("client disconnected: ~p, ~p~n", [node(Pid), Reason]),
	    loop(Bids, Bid);
	{'EXIT', _Pid, stop} -> log("Quitting. Bye.~n", [])
    after
	15000 ->
	    case Bid of
		{none, _} -> loop(Bids, Bid);
		{<<B:2>>, {From, Money}} when is_number(Money) and (B /= 3)->
		    log("~p bid ~p, ~p. More?~n", [B, node(From), Money]),
		    loop(Bids, {<<(B + 1):2>>, {From, Money}});
		{<<3:2>>, {From, Money}} when is_number(Money) ->
		    log("winner: ~p, ~p~n", [node(From), Money])
	    end
    end.
