-module(sup_lib).

-export([child/2, children/2, gen_id/1]).

child(SupRef, Module) ->
    L = children(SupRef, Module),
    if
	length(L) > 0 -> hd(L);
	true -> none
    end.

children(SupRef, Module) ->
    [X || {_, X, _, [M|_]} <- supervisor:which_children(SupRef), M == Module].

gen_id(Prefix) ->
    Hash = erlang:phash2(make_ref()),
    Id = list_to_atom(atom_to_list(Prefix) ++ "_" ++ integer_to_list(Hash)).
