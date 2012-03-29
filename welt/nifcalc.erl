-module(nifcalc).

-export([calc/2]).

-on_load(auto/0).

auto() ->
    Path = "C:/Users/pb/Documents/Visual Studio 2008/Projects/e_nif_example/Debug/nifcalc",
    erlang:load_nif(Path, 0).

calc(_, _) ->
    {error, not_loaded}.
