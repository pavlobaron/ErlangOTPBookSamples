%% @todo: Verfeinern
-type datum() :: {integer(), integer(), integer()}.
-type wochentag() :: 1 .. 7.
-type iso_waehrung_code() :: eur | chf | usd.

%% @type kursinfo() = #kursinfo{}.
%% ACHTUNG: Niemals Waehrungsbetraege als "Number" repraesentieren !!! 
-record(kursinfo, 
	{ waehrung :: iso_waehrung_code(),
	  zielwaehrung :: iso_waehrung_code(),
	  eroeffnungskurs :: number(),
	  schlusskurs :: number(),
	  tageshoch :: number(),
	  tagestief :: number(),
	  kursdatum :: datum(),
	  wochentag :: wochentag()}).

