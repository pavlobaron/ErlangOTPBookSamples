-module(yawscalcclient).

-export([calc/2]).

-include("/tmp/calc.hrl").

calc(A, B) ->
    inets:start(),
    {_, _, [#'p:CalcResponse'{'Res' = Res}]} = yaws_soap_lib:call(
						 "file:///tmp/calc.wsdl",
						 "Calc",
						 [float_to_list(A),
						  float_to_list(B)]),
    list_to_float(Res).
