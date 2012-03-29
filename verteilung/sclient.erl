-module(sclient).

-export([transfer/1]).

-include("sockets.hrl").

transfer(String) ->
    {ok, S} = gen_tcp:connect(net_adm:localhost(),
			      ?SPORT, ?BASICOPTS),
    ok = gen_tcp:send(S, String),
    ok = gen_tcp:close(S).
