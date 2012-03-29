{application, wechselkurs, [
        {description, "Wechselkurs Application"},
        {vsn, "0.2"},
        {modules,
		[wechselkurs_client,
		wechselkurs_server,
		wechselkurs_db,
		wechselkurs_worker,
		wechselkurs_app]},
        {registered, []},
        {applications, [kernel, stdlib, sasl]},
	{mod, {wechselkurs_app, []}}
]}.
