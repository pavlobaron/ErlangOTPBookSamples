-module(last).
-export([run/0]).

-define(DAYS, 439).
-define(HOURS, 14).
-define(DEFSEC, 60).
-define(HITSPERMIN, 6).

run() ->
    {Res, H} = file:open("sup.log", read),
    if
	Res == ok ->
	    Dict = dict:new(),
	    {ok, Re1} = re:compile("^(.*?:) login user (.*?) from"),
	    {ok, Re2} = re:compile("^(.*?:) logout user (.*)"),
	    {ok, Re3} = re:compile("^(.*?) (.*?) (.*?) (.*?):(.*?):(.*?):"),
	    NewDict = do_line(H, Dict, Re1, Re2, Re3),
	    file:close(H),
	    M1 = static_min(),
	    M2 = count_stats(NewDict),
	    R = (M2 div M1) * ?HITSPERMIN,
	    io:format("Gross minutes: ~p, net minutes: ~p, Hits per minute: ~p~n", [M1, M2, R])
    end.

count_stats(Dict) ->
    F = fun(_Key, Val, Acc) ->
	    case Val of
		_T when is_integer(_T) -> Acc + Val;
		_ -> Acc + ?DEFSEC
	    end
	end,
    Acc = dict:fold(F, 0, Dict),
    Acc div 60.

static_min() ->
    ?DAYS * ?HOURS * 60.

do_line(H, Dict, Re1, Re2, Re3) ->
    L = io:get_line(H, ''),
    if
	L /= eof ->
	    NewDict = store_dict(L, Dict, Re1, Re2, Re3),
	    do_line(H, NewDict, Re1, Re2, Re3);
	true ->
	    Dict
    end.

store_dict(S, Dict, Re1, Re2, Re3) ->
    T1 = re:run(S, Re1, [{capture, [1, 2], list}]),
    if
	is_tuple(T1) and (element(1, T1) == match) ->
	    Key = lists:nth(2, element(2, T1)),
	    NewVal = calc_dt(lists:nth(1, element(2, T1)), Re3),
	    if
		is_integer(NewVal) ->
		    Dict;
		true ->
		    T3 = dict:find(Key, Dict),
		    if
			is_tuple(T3) and (element(1, T3) == ok) ->
			    OldVal = element(2, T3),
			    dict:store(Key, calc_sec(OldVal, NewVal), Dict);
			true ->
			    dict:store(Key, NewVal, Dict)
		    end
	    end;
	true ->
	    T2 = re:run(S, Re2, [{capture, [1, 2], list}]),
	    if
		is_tuple(T2) and (element(1, T2) == match) ->
		    Key = lists:nth(2, element(2, T2)),
		    NewVal = calc_dt(lists:nth(1, element(2, T2)), Re3),
		    if
			is_integer(NewVal) ->
			    Dict;
			true ->
			    T3 = dict:find(Key, Dict),
			    if
				is_tuple(T3) and (element(1, T3) == ok) ->
				    OldVal = element(2, T3),
				    dict:store(Key, calc_sec(OldVal, NewVal), Dict);
				true ->
				    Dict
			    end
		     end;
		true ->
		    Dict
	    end
    end.

calc_sec(Old, New) ->
    Sec = (catch calendar:datetime_to_gregorian_seconds(New)),
    Sec2 = if
	is_tuple(Sec) ->
	    0;
	true ->
	    Sec
    end,
    case Old of
	_T when is_tuple(_T) ->
	    Sec1 = calendar:datetime_to_gregorian_seconds(Old),
	    if
		Sec2 /= 0 ->
		    Sec2 - Sec1;
		true ->
		    ?DEFSEC
	    end;
	Sec1 ->
	    if
		Sec2 /= 0 ->
		    calendar:gregorian_seconds_to_datetime(Sec2 - Sec1);
		true -> Sec1
	    end
    end.

calc_dt(S, Re) ->
    T = re:run(S, Re, [{capture, [1, 2, 3, 4, 5, 6], list}]),
    if
	is_tuple(T) and (element(1, T) == match) ->
	    D = (catch list_to_integer(lists:nth(1, element(2, T)))),
	    M = calc_month(lists:nth(2, element(2, T))),
	    Y = (catch list_to_integer(lists:nth(3, element(2, T)))),
	    H = (catch list_to_integer(lists:nth(4, element(2, T)))),
	    Mi = (catch list_to_integer(lists:nth(5, element(2, T)))),
	    Se = (catch list_to_integer(lists:nth(6, element(2, T)))),
	    if
		is_atom(D) or is_atom(Y) or is_atom(H) or is_atom(Mi) or is_atom(Se) -> 0;
		true -> {{Y, M, D}, {H, Mi, Se}}
	    end;
	true ->
	    0
    end.

find_ix([], _S, _I) ->
    0;
find_ix([H|T], S, I) ->
    if
	H == S ->
	    I;
	true ->
	    find_ix(T, S, I + 1)
    end.

calc_month(S) ->
    L = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
    find_ix(L, S, 1).
