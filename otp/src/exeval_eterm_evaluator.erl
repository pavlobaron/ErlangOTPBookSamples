-module(exeval_eterm_evaluator).
-behavior(exeval_gen_evaluator).

-export([start_link/0, init/1]).

-export([handle_call/3]).

start_link() ->
    gen_server:start_link(?MODULE, [], []).

init(_Args) ->
    {ok, ""}.

handle_call(eval, _From, LVal) ->
    {reply, catch(eval(LVal)), ""};
handle_call({add, String}, _From, LVal) ->
    Ret = LVal ++ String,
    gen_event:notify(exeval_event_manager, {add, String, Ret}),
    {reply, ok, LVal ++ String}.

eval(LVal) ->
    {ok, S, _} = erl_scan:string(LVal),
    {ok, P} = erl_parse:parse_exprs(S),
    {value, Ret, _} = erl_eval:exprs(P, erl_eval:new_bindings()),
    gen_event:notify(exeval_event_manager, {eval, LVal, Ret}),
    Ret.
