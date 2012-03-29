-module(wechselkurs_client_rpc).

-export([kursinfo/0, umrechnung/0]).

kursinfo() -> 
    rpc:call('server@Mittelerde', wechselkurs_server, kursinfo, [eur, usd, {10,12,2010}]).

umrechnung() ->
    rpc:call('server@Mittelerde', wechselkurs_server, umrechnung, [eur, 100, usd, {9,12,2010}]).



