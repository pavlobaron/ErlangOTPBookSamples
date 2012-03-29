-module(trycatch1).

-export([doerror/0, dothrow/0, doexit/0]).

docatch(F) ->
    L = try F() of
        _ -> [unusual, situation]
    catch
	Class:Reason -> [Class, Reason]
    end,
    io:format("Caught ~p: ~p~n", L).

doerror() ->
    docatch(fun() -> 5/0  end).

dothrow() ->
    docatch(fun() -> throw(gone_fishing) end).

doexit() ->
    docatch(fun() -> exit(thx_for_all_the_fish) end).
