%% ----------------------------------------------------------------------
%% @copyright 2011 Volkert Barr
%% @author Volkert <volkert@nivoba.de> [http://www.erlang-dach.org/]
%% @version 1.0
%%
%% @doc Der Wechselkurs Server ist eine Demo-Applikation, anhand der 
%% die Verwendung unterschiedlicher Erlang/OTP Werkzeuge gezeigt wird.
%% @end
%% Dieser Kommentar einscheint nicht mehr !!!
%% ----------------------------------------------------------------------

%% @TODO: Error Logger einbauen.
%% @TODO: ACHTUNG: Niemals Waehrungsbetraege als "Number" repraesentieren !!! 

-module(wechselkurs_server).

-export([start/0, stop/0, loop/0, umrechnung/4, kursinfo/3]).

%% @headerfile "wechselkurs.hrl"

-include("wechselkurs.hrl").

%%
%% Unterhaltsfunktionen Server
%%

%% ----------------------------------------------------------------------
%% @doc Startet den Wechselkursserver.
%% @end
%% ----------------------------------------------------------------------
-spec start() -> ok.
start() ->
    register(?MODULE, spawn(?MODULE, loop, [])),
    io:format("server started \n").

%% ----------------------------------------------------------------------
%% @doc Stoppt den Wechselkursserver.
%% @end
%% ----------------------------------------------------------------------
-spec stop() -> ok.
stop() ->
    ?MODULE ! {stop, self()},
    receive
	stopped ->
	    io:format("server stopped \n")
    end.    

%%
%% Interface Funktionen
%%

%% ----------------------------------------------------------------------
%% @doc Die Funktion berechnet fuer einen Betrag in der Waehrung einen 
%% entsprechenden Betrag in der Zielwaehrung zum am Kursdatum gueltigen
%% Wechselkurs. 
%%
%% Fuer reine Kursinformationen sollte die Funktion {@link kursinfo/3} 
%% verwendet werden.
%%
%% @see kursinfo/3
%%
%% @end
%% ----------------------------------------------------------------------
%% @todo Error Logger einbauen.
%% @todo Bessere Beschreibung erstellen.

-spec umrechnung(Waehrung::iso_waehrung_code(), Betrag::number(), Zielwaehrung::iso_waehrung_code(), Kursdatum::datum()) 
		-> {ok, number()} | {error, string()}.
umrechnung(Waehrung, Betrag, Zielwaehrung, Kursdatum) ->
    ?MODULE ! {umrechnen, {Waehrung, Zielwaehrung, Betrag, Kursdatum}, self()},
    receive
	{ok, Result} ->
	    {ok, Result};
	{error, Grund} ->
	    {error, Grund}
    end.

%% -----------------------------------------------------------------------
%% @doc Die Funktion <it>kursinfo</it> liefert die Kursinformationen 
%% zur angebenen Waehrung und Kursdatum.
%% @end
%% -----------------------------------------------------------------------
-spec kursinfo(Waehrung::iso_waehrung_code(), Zielwaehrung::iso_waehrung_code(), Kurddatum::datum()) 
	      -> {ok, #kursinfo{}} | {error, string()}.
kursinfo(Waehrung, Zielwaehrung, Kursdatum) ->
    ?MODULE ! {kursinfo, {Waehrung, Zielwaehrung, Kursdatum}, self()},
    receive
	{ok, Result} ->
	    {ok, Result};	
	{error, Grund} ->
	    {error, Grund}
    end.

%% ----------------------------------------------------------------------
%% @doc Dispatcher Process-Loop
%% @end
%% ----------------------------------------------------------------------
-spec loop() -> stopped.
loop() ->
    receive
	{umrechnen, {Waehrung, Zielwaehrung, Betrag, Kursdatum}, Sender} ->
	   % io:format("Auftrag: Umrechnen ~p in ~p am ~p, Betrag ~p ~n \n", [Waehrung, Zielwaehrung, Kursdatum, Betrag]),
	    wechselkurs_worker:spawn_worker({umrechnen, {Waehrung, Zielwaehrung, Betrag, Kursdatum}, Sender}),
	    loop();
	{kursinfo, {Waehrung, Zielwaehrung, Kursdatum}, Sender} ->
	   % io:format("Auftrag: Kursinfo ~p in ~p vom ~p ~n \n", [Waehrung, Zielwaehrung, Kursdatum]),
	    wechselkurs_worker:spawn_worker({kursinfo, {Waehrung, Zielwaehrung, Kursdatum}, Sender}),
	    loop();
	{stop, Sender} ->
	    Sender ! stopped;
	_ ->
	    io:format("illegal message ~n \n"),
	    loop()
    end.



