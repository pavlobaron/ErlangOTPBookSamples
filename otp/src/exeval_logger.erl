-module(exeval_logger).
-behaviour(gen_event).

-export([init/1, handle_event/2, terminate/2]).

init(_Args) ->
    {ok, F} = file:open(env_lib:get_env(logger, file), write),
    {ok, F}.

handle_event(start_eval, F) ->
    io:format(F, "---- Starting ----~n", []),
    {ok, F};
handle_event({add, String, LVal}, F) ->
    io:format(F, "---- Added: ~p, new l-value: ~p ----~n", [String, LVal]),
    {ok, F};
handle_event({eval, LVal, Res}, F) ->
    io:format(F, "---- Evaluated: ~p, result: ~p ----~n", [LVal, Res]),
    {ok, F}.

terminate(_Args, F) ->
    file:close(F).
