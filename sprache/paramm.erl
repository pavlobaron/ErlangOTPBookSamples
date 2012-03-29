-module(paramm, [Id, Name]).

-export([get_name/0, get_id/0, ping/0]).

get_id() ->
    Id.

get_name() ->
    Name.

ping() ->
    pong.
