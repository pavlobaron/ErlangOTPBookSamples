-module(misc).
-compile(export_all).

-type wochentage() :: 1..7.
-type mailer_state() :: init | connecting | connected | closed.
-type ampelfarben() :: rot | gelb | gelbrot | gruen.
-type datum() :: {1..31, 1..12, 1901 .. 2299}.

-record(person,
	{name :: string(),
	 vorname :: string(),
	 geburtstag :: datum()}).

-type personenliste() :: [#person{}].

-spec id(any()) -> any().
id(A) -> A.

-spec double(number()) -> number().
double(X) -> 2 * X.

-spec naechstertag(Wochentag::wochentage()) -> wochentage().
naechstertag(Wochentag) -> (Wochentag + 1) rem 7.

-spec find_person(List::personenliste(), Name::string()) -> #person{}.
find_person(Liste, Name) -> [ P || P=#person{name=N} <- Liste,  N =:= Name].

-spec fac(integer()) -> integer().
fac(0) -> 1;
fac(N) -> N * fac(N-1).
