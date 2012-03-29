-module(exeval_instance_supervisor).
-behaviour(supervisor).

-export([start_link/0, init/1]).

-export([fsm/1, available/1, server/1, occupy/1, evaluator/1]).

start_link() ->
  supervisor:start_link(?MODULE, []).

init(_Args) ->
    ServerSpec = {server,
		  {exeval_instance_server, start_link, [self()]},
		  transient, 2000, worker, [exeval_instance_server]},
    FSMSpec = {fsm,
	       {exeval_instance_fsm, start_link, []},
	       transient, 2000, worker, [exeval_instance_fsm]},
    EvaluatorModule = eval_module(),
    EvaluatorSpec = {evaluator,
		     {EvaluatorModule, start_link, []},
		     transient, 2000, worker, [EvaluatorModule]},
    {ok, {{one_for_one, 2, 10}, [ServerSpec, FSMSpec, EvaluatorSpec]}}.

eval_module() ->
    env_lib:get_env(instance, eval_module).

fsm(SupRef) ->
    sup_lib:child(SupRef, exeval_instance_fsm).

server(SupRef) ->
    sup_lib:child(SupRef, exeval_instance_server).

evaluator(SupRef) ->
    sup_lib:child(SupRef, eval_module()).

available(SupRef) ->
    {_, _, _,
     [_, _, _, _,
      [_, {_, [_, _, _,
	       {_, Step}]}, _]]} = sys:get_status(fsm(SupRef)),
    Step == ready.

occupy(SupRef) ->
    gen_fsm:send_event(sup_lib:child(SupRef, exeval_instance_fsm), occupy).
