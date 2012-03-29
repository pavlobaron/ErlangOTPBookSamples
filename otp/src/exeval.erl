-module(exeval).

-export([start_eval/1, eval/1, add/2]).

start_eval(Node) ->
    gen_server:call({exeval_server, Node}, start_eval).

eval(Pid) ->
    gen_server:call(Pid, eval).

add(Pid, String) ->
    gen_server:call(Pid, {add, String}).
