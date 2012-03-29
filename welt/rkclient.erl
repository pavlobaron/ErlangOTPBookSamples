-module(rkclient).

-export([start/0, loop/1]).

-define(RIAK, 'riak@127.0.0.1').
-define(WQUORUM, 1).
-define(RQUORUM, 1).

start() ->
    case riak:client_connect(?RIAK) of
	{ok, C} -> register(erlang, spawn(?MODULE, loop, [C]));
	_ -> error
    end.

loop(C) ->
    receive
	{Java, Msg} ->
	    Java ! {self(), process(C, Msg)},
	    loop(C)
    after
	60000 -> {error, timeout}
    end.

process(C, {put, Bucket, Key, Value}) ->
    R = case C:get(Bucket, Key, ?RQUORUM) of
	{ok, RR} ->
		io:format("updating value ~p~n", [Value]),
		riak_object:update_value(RR, Value);
	_ ->
		io:format("putting new value ~p~n", [Value]),
		riak_object:new(Bucket, Key, Value)
    end,
    C:put(R, ?WQUORUM);
process(C, {get, Bucket, Key}) ->
    case C:get(Bucket, Key, ?RQUORUM) of
	{ok, RR} -> riak_object:get_value(RR);
	_ -> error
    end;
process(C, {delete, Bucket, Key}) ->
    C:delete(Bucket, Key, ?WQUORUM).
