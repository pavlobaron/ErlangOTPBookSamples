-module(exeval_instance_fsm).
-behaviour(gen_fsm).

-export([start_link/0, init/1, ready/2, busy/2]).

start_link() ->
    gen_fsm:start_link(?MODULE, [], []).

init(_Args) ->
    {ok, busy, ok}.

ready(_, _) ->
    {next_state, busy, ok}.

busy(_, _) ->
    {next_state, ready, ok}.
