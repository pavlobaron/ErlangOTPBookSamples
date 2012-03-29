-module(wechselkurs_more_tests).
-include_lib("eunit/include/eunit.hrl").
-include("wechselkurs.hrl").

result() ->
    {ok, 
     #kursinfo{waehrung=eur,
	       zielwaehrung=usd, 
	       eroeffnungskurs = 1.32362, 
	       schlusskurs = 1.32545, 
	       tageshoch = 1.33220, 
	       tagestief = 1.31642, 
	       kursdatum= {10,12,2010},
	       wochentag = 6}}.
	
kursinfo_ok_test() ->
    ?assertEqual(result(), wechselkurs_server:kursinfo(eur, usd, {10,12,2010})).

kursinfo_not_found_test() ->
    ?assertMatch({error,_}, wechselkurs_server:kursinfo(eur, chf, {1,12,2013})).

kursinfo_ok_test_() ->
    [?_assertEqual(result(), wechselkurs_server:kursinfo(eur, usd, {10,12,2010}))].
