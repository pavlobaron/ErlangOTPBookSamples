-module(wechselkurs_worker).

-export([spawn_worker/1, main/0, test1/0, test2/0]).

%%
%% Interface Funktionen
%%
spawn_worker(Job) ->
    Pid = spawn(?MODULE, main,[]),
    Pid ! Job.

main() ->
    receive
	{umrechnen, {Waehrung, Zielwaehrung, Betrag, Kursdatum}, Sender} ->
	    case wechselkurs_db:find_kurs(Waehrung, Zielwaehrung, Kursdatum) of
		{ok, Wechselkurs} -> Sender ! {ok, Wechselkurs * Betrag};
		{error, Grund} -> Sender ! {error, Grund}
	    end;
	{kursinfo, {Waehrung, Zielwaehrung, Kursdatum}, Sender} ->
	    case wechselkurs_db:find_kursinfo(Waehrung, Zielwaehrung, Kursdatum) of
		{ok, Info} -> Sender ! {ok, Info};
		{error, Grund} -> Sender ! {error, Grund}
	    end;
	_ -> 
	    io:format("Unknown Jobtype\n")
    end.

%
% Tests
%    
test1() ->
    spawn_worker({umrechnen, {eur, usd, 1000, {12,12,2001}}, self()}),
    receive Result ->
	    Result
    end.

test2() ->
    spawn_worker({kursinfo, {eur, usd, {12,12,2001}}, self()}),
    receive Result ->
	    Result
    end.
