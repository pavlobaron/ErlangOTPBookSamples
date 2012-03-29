-module(wechselkurs_db).

-export([start/0, stop/0, find_kursinfo/3, find_kurs/3, test_kurs/0]).
-export([test_ok/0, test_not_found/0, load_test_data/1, unload_test_data/1]).

-include("wechselkurs.hrl").

start() ->
    ok.

stop() ->
    ok.

wait() ->
    timer:sleep(random:uniform(2000)).

-spec find_kursinfo(Waehrung::iso_waehrung_code(), Zielwaehrung::iso_waehrung_code(), Kursdatum::datum()) ->
			   {ok, #kursinfo{}} | {error, string()}.			   
find_kursinfo(Waehrung, Zielwaehrung, Kursdatum) ->
    wait(), % dummy Wartezeit
    Result = [Kurse || Kurse=#kursinfo{waehrung=W, zielwaehrung=ZW, kursdatum=Datum} <-dummy_db(),
		       Waehrung =:= W, Zielwaehrung =:= ZW, Datum =:= Kursdatum ],
    case Result of
	[] ->
	    {error, "Kursinfo nicht gefunden!!"};
	[Info|_] ->
	    {ok, Info}
    end.

find_kurs(Waehrung, Zielwaehrung, Kursdatum) ->
    wait(),
    case find_kursinfo (Waehrung, Zielwaehrung, Kursdatum) of
	{error, Grund} -> {error, Grund};
	{ok, #kursinfo{schlusskurs=Kurs}} -> {ok, Kurs}
    end.

dummy_db() ->
    [ #kursinfo{waehrung=eur, 
		zielwaehrung=usd, 
		eroeffnungskurs = 1.33309, 
		schlusskurs = 1.32362, 
		tageshoch = 1.132797, 
		tagestief = 1.31799, 
		kursdatum = {9,12,2010},
		wochentag = 5},
      #kursinfo{waehrung=eur,
		zielwaehrung=usd, 
		eroeffnungskurs = 1.32362, 
		schlusskurs = 1.32545, 
		tageshoch = 1.33220, 
		tagestief = 1.31642, 
		kursdatum= {10,12,2010},
		wochentag = 6},
      #kursinfo{waehrung=eur,
		zielwaehrung=usd, 
		eroeffnungskurs = 1.35362, 
		schlusskurs = 1.35545, 
		tageshoch = 1.35220, 
		tagestief = 1.35642, 
		kursdatum= {9,12,2011},
		wochentag = 4}
    ].

load_test_data(Set) ->
    error_logger:info_msg("Load Testdata ~p ~n", [Set]),
    Set.
unload_test_data(Set) ->
    error_logger:info_msg("Unload Testdata ~p ~n", [Set]),
    Set.

%

test_ok() ->
    find_kursinfo(eur, usd, {10,12,2010}).

test_not_found() ->
    find_kursinfo(chf, usd, {13,12,2012}).

test_kurs() ->
    find_kurs(eur, usd, {09,12,2010}).
