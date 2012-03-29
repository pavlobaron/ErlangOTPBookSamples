{application, exeval, [
        {description, "ExEval Application"},
        {vsn, "0.1"},
        {modules,
		[exeval,
		env_lib,
		exeval_application,
		exeval_eterm_evaluator,
		exeval_gen_evaluator,
		exeval_instance_fsm,
		exeval_instance_server,
		exeval_instance_supervisor,
		exeval_logger,
		exeval_server,
		exeval_supervisor,
		sup_lib]},
        {registered, []},
        {applications, [kernel, stdlib]},
	{mod, {exeval_application, []}},
	{env, [
	      {instance, [{eval_module, exeval_eterm_evaluator}]},
	      {logger, [{file, "c:/Users/pb/exeval_logger.txt"}]}
	      ]}
]}.
