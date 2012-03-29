-module(mnesia1).

-export([create/0, drop/0, create_list/2,
	 subscribe/4, unsubscribe/2]).

-include("mnesiarecs.hrl").

create() ->
    mnesia:create_table(list, [{attributes, record_info(fields, list)}]),
    mnesia:create_table(email, [{attributes, record_info(fields, email)}]),
    mnesia:create_table(e2l, [{type, bag},
			      {attributes, record_info(fields, e2l)}]).

drop() ->
    mnesia:delete_table(list),
    mnesia:delete_table(email),
    mnesia:delete_table(e2l).

create_list(Name, Description) ->
    mnesia:dirty_write(#list{name = Name,
			     description = Description}).

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
    mnesia:dirty_delete_object(#e2l{lname = List,
				    eaddress = Address}).
