-module(ip).

-export([ip/1]).

-define(MINIHL, 5).

ip(<<Version:4,
     IHL:4,
     _TOS:8,
     _TotalLength:16,
     _Identification:16,
     _Flags:3,
     _FragmentOffset:13,
     _TTL:8,
     _Protocol:8,
     _HeaderChecksum:16,
     SA1:8, SA2:8, SA3:8, SA4:8,
     DA1:8, DA2:8, DA3:8, DA4:8,
     Rest/binary>>) when Version == 4 ->
    OpsSize = ((IHL - ?MINIHL) * 32),
    <<_OptionsAndPadding:OpsSize/bitstring, Payload/binary>> = Rest,
    io:format("IP-Packet from ~p.~p.~p.~p to ~p.~p.~p.~p, payload: ~p~n",
	      [SA1, SA2, SA3, SA4,
	       DA1, DA2, DA3, DA4,
	       Payload]).
