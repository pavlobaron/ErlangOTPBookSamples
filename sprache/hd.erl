-module(hd).

-export([count1bits/1]).

count1bits(Bits) ->
    case is_binary(Bits) andalso bit_size(Bits) == 32 of
	true ->
	    docount(Bits, 1);
	_ -> {error, badarg}
    end.

docount(<<X:32>>, 32) ->
    X;
docount(Bits, Size) ->
    NewBits = << <<(X + Y):(Size * 2)>> || <<X:Size, Y:Size>> <= Bits >>,
    docount(NewBits, Size * 2).
