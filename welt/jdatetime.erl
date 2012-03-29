-module(jdatetime).

-export([date/2]).

date(Date, Format) ->
    {java, example@pbpc01} ! {self(), Date, Format},
    receive
	{_Pid, DateTime} -> erlang:display(DateTime)
    after
	5000 -> {error, timeout}
    end.
