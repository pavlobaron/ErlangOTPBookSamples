-module(hello_world_author).
-author("Peter Pan").
-export([start/0]).

start() ->
 io:format("Hello, World - With Author!~n").
