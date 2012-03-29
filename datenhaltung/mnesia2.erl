-module(mnesia2).

-export([create/0, drop/0, create_list/2,
	 subscribe/4, unsubscribe/2, get_list/1]).

-include("mnesiarecs.hrl").

node_list() ->
    [node()|nodes()].

create() ->
    mnesia:create_table(list, [{attributes, record_info(fields, list)},
			       {disc_only_copies, node_list()}]),
    mnesia:create_table(email, [{attributes, record_info(fields, email)},
			       {disc_only_copies, node_list()}]),
    mnesia:create_table(e2l, [{type, bag},
			      {attributes, record_info(fields, e2l)},
			      {disc_only_copies, node_list()}]).

drop() ->
    mnesia:delete_table(list),
    mnesia:delete_table(email),
    mnesia:delete_table(e2l).

create_list(Name, Description) ->
    T = fun() ->
		mnesia:write(#list{name = Name,
				   description = Description})
	end,
    {atomic, Res} =  mnesia:transaction(T),
    Res.

subscribe(Address, Fname, Sname, List) ->
    T = fun() ->
		case mnesia:read({email, Address}) of
		    [] -> mnesia:write(#email{address = Address,
					      fname = Fname,
					      sname = Sname});
		    [_|_] -> ok
		end,
		mnesia:write(#e2l{lname = List,
				  eaddress = Address})
	end,
    {atomic, Res} = mnesia:transaction(T),
    Res.

unsubscribe(Address, List) ->
    T = fun() ->
		mnesia:delete_object(#e2l{lname = List,
					  eaddress = Address})
	end,
    {atomic, Res} =  mnesia:transaction(T),
    Res.

get_list(List) ->
    T = fun() ->
		mnesia:read({e2l, List})
	end,
    {atomic, Res} =  mnesia:transaction(T),
    Res.
