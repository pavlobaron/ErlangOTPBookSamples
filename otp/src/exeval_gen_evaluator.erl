-module(exeval_gen_evaluator).
-export([behaviour_info/1]).

behaviour_info(callbacks) ->
    [{init, 1}, {handle_call, 3}];

behaviour_info(_Other) ->
    undefined.
