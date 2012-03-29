-module(exeval_instance_server).
-behaviour(gen_server).

-export([start_link/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link(SupervisorPid) ->
    gen_server:start_link(?MODULE, [SupervisorPid], []).

init([SupervisorPid]) ->
    {ok, SupervisorPid}.

handle_call(eval, _From, SupervisorPid) ->
    FSMPid = exeval_instance_supervisor:fsm(SupervisorPid),
    Ret = send_evaluator(SupervisorPid, eval),
    gen_fsm:send_event(FSMPid, eval),
    {reply, Ret, SupervisorPid};
handle_call(Cmd, _From, SupervisorPid) ->
    Ret = send_evaluator(SupervisorPid, Cmd),
    {reply, Ret, SupervisorPid}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

send_evaluator(SupervisorPid, Cmd) ->
    EvaluatorPid = exeval_instance_supervisor:evaluator(SupervisorPid),
    gen_server:call(EvaluatorPid, Cmd).
