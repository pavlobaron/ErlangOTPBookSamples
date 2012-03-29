-module(macros3).
-export([print/1]).

-define(PRINT(X), string:concat(string:concat(??X, " = "), integer_to_list(X))).

print(0) ->
    ?PRINT(0);
print(1) ->
    ?PRINT(1 + 2);
print(XYZ) ->
    ?PRINT(XYZ).
