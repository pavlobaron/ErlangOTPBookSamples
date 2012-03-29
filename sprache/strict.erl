-module(strict).
-export([strict_eval/1, print/0]).

print() ->
    io:format("I have been called, but what for?..").

strict_eval(X) ->
    5.
