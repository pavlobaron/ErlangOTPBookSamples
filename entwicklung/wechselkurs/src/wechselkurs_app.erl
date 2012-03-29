-module(wechselkurs_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
    wechselkurs_server:start(),
    {ok, whereis(wechselkurs_server)}.

stop(_State) ->
    wechselkurs_server:stop(),
    ok.
