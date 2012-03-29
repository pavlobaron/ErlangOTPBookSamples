-module(macros4).

-ifdef(no).

-export([shouldnt/0]).

shouldnt() ->
    "shouldn't be".

-else.

-export([should/0]).

should() ->
    "should be".

-endif.
