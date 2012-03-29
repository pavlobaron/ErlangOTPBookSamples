-module(wechselkurs_client).

-export([kursinfo/0, umrechnung/0, dummy/0]).

kursinfo() -> 
    wechselkurs_server:kursinfo(eur, usd, {9,12,2010}).

umrechnung() ->
    wechselkurs_server:umrechnung(eur, 100, usd, {9,12,2010}).

dummy() ->
    io:format("I'm a bloody dummy").
