-module(exeval_application).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
    exeval_supervisor:start_link().

stop(_State) -> ok.
