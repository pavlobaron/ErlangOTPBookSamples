-module(test_SUITE).

-compile(export_all).

-include_lib("common_test/include/ct.hrl").
-include("wechselkurs.hrl").

suite() ->
    [{timetrap, {seconds,30}}, {require, data}].

init_per_suite(Config) ->
    wechselkurs_db:start(),
    Data = wechselkurs_db:load_test_data(ct:get_config(data)),
    wechselkurs_server:start(),
    lists:append([{dataset, Data}], Config).

end_per_suite(Config) ->
    wechselkurs_db:unload_test_data(?config(dataset, Config)),
    wechselkurs_db:stop(),
    wechselkurs_server:stop(),
    ok.

all() -> 
    [kursinfo_test, umrechnung_test,
     kursinfo_error_test, umrechnung_error_test].

kursinfo_test(_Config) -> 
    dotest(kursinfo, [eur, usd, {10, 12, 2010}], resultOk()).

umrechnung_test(_Config) -> 
    dotest(umrechnung, [eur, 100, usd, {9, 12, 2010}], {ok, 132.362}).

kursinfo_error_test(_Config) ->
    dotest(kursinfo, [eur, usd, {1, 12, 2013}], resultOk()).

umrechnung_error_test(_Config) -> 
    dotest(umrechnung, [eur, 100, usd, {11, 12, 2010}], {ok, 132.362}).

dotest(Fun, Args, Check) ->
    case apply(wechselkurs_server, Fun, Args) of
	Check -> ok;
	_ -> exit(error)
    end.

resultOk() ->
    {ok, #kursinfo{waehrung=eur,
		   zielwaehrung=usd, 
		   eroeffnungskurs = 1.32362, 
		   schlusskurs = 1.32545, 
		   tageshoch = 1.33220, 
		   tagestief = 1.31642, 
		   kursdatum= {10,12,2010},
		   wochentag = 6}}.
