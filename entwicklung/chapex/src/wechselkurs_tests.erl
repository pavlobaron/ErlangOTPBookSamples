-module(wechselkurs_tests).
%-define(NOTEST, true).
-include_lib("eunit/include/eunit.hrl").
-include("wechselkurs.hrl").

-export([setup/0, cleanup/1]).

setup() ->
    cover:start(),
    cover:compile(wechselkurs_server),
    wechselkurs_db:start(),
    wechselkurs_db:load_test_data(dataset_1),
    wechselkurs_server:start(),
    dataset_1.

cleanup(Context) ->
    wechselkurs_db:unload_test_data(Context),
    wechselkurs_db:stop(),
    wechselkurs_server:stop(),
    cover:analyse_to_file(wechselkurs_server).

resultOk() ->
    {ok, #kursinfo{waehrung=eur,
		   zielwaehrung=usd, 
		   eroeffnungskurs = 1.32362, 
		   schlusskurs = 1.32545, 
		   tageshoch = 1.33220, 
		   tagestief = 1.31642, 
		   kursdatum= {10,12,2010},
		   wochentag = 6}}.

kursinfo_test_() ->     
    {setup, 
     fun setup/0,
     fun cleanup/1,
     [?_assertEqual(resultOk(), wechselkurs_server:kursinfo(eur, usd, {10,12,2010})),
      ?_assertMatch({error,_}, wechselkurs_server:kursinfo(eur, usd, {1,12,2013}))
     ]}.

umrechnung_test_() ->
   {setup, 
    fun setup/0,
    fun cleanup/1, 
    % ACHTUNG: Bitte so keine Vergleiche von Float durchfuehren.
    ?_assertMatch({ok, 132.362}, wechselkurs_server:umrechnung(eur, 100, usd, {9,12,2010}))}.




