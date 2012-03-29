-module(sserver).

-export([start/0, server/0, accept/1]).

-include("./sockets.hrl").

start() ->
    spawn(?MODULE, server, []).

server() ->
    {ok, Listen} = gen_tcp:listen(?SPORT,
				  [{active, false}|?BASICOPTS]),
    accept(Listen).

accept(Listen) ->
    {ok, S} = gen_tcp:accept(Listen),
    Pid = spawn(?MODULE, accept, [Listen]),
    gen_tcp:controlling_process(Listen, Pid),
    read(S, []).

read(S, L) ->
    case gen_tcp:recv(S, 0) of
	{ok, Bin} -> read(S, [L, Bin]);
        {error, closed} -> data(list_to_binary(L))
    end.

data(Bin) ->
    error_logger:info_msg("result: ~p~n", [Bin]).
