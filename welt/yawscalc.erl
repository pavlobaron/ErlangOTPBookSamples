-module(yawscalc).

-export([callback/4]).

-include("/tmp/calc.hrl").

callback(_, [#'p:Calc'{'A' = A, 'B' = B}], _, _) ->
    error_logger:info_msg("A = ~p, B = ~p", [A, B]),
    {ok, undefined, calc_soap(A, B)}.

calc(A, B) ->
    A + B.

calc_soap(A, B) ->
    Res = float_to_list(calc(list_to_float(A), list_to_float(B))),
    Response =
    #'p:CalcResponse'{anyAttribs = [], 'Res' = Res},
    [Response].
