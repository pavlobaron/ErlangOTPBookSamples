-module(exeval_supervisor).
-behaviour(supervisor).

-export([start_link/0, init/1]).

-export([start_eval/0]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
    gen_event:start_link({local, exeval_event_manager}),
    gen_event:add_sup_handler(exeval_event_manager, exeval_logger, []),
    ServerSpec = {server,
		  {exeval_server, start_link, []},
		  transient, 2000, worker, [exeval_server]},
    {ok, {{one_for_one, 2, 10}, [ServerSpec]}}.

start_eval() ->
    gen_event:notify(exeval_event_manager, start_eval),
    case available() of
	none ->
	    InstanceSpec = {sup_lib:gen_id(instance),
			    {exeval_instance_supervisor, start_link, []},
			    transient, 2000, supervisor, [exeval_instance_supervisor]},
	    {ok, Pid} = supervisor:start_child(?MODULE, InstanceSpec),
	    exeval_instance_supervisor:server(Pid);
	Pid ->
	    exeval_instance_supervisor:occupy(Pid),
	    exeval_instance_supervisor:server(Pid)
    end.

available() ->
    L = [Pid || Pid <- sup_lib:children(?MODULE, exeval_instance_supervisor),
		exeval_instance_supervisor:available(Pid) == true],
    if
	length(L) > 0 -> hd(L);
	true -> none
    end.
