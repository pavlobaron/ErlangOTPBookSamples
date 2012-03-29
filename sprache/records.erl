-module(records).

-export([start/0, stop/1, step/1, check_state/2]).

-record(state,
       {
	 state = initial,
	 calls = 0,
	 lasttime
       }).

change_state(OldState, StateAtom) ->
    #state{
	    state = StateAtom,
	    calls = OldState#state.calls + 1,
	    lasttime = time()
	  }.

start() ->
    change_state(#state{}, start).

stop(State) ->
    change_state(State, stop).

step(State) ->
    change_state(State, step).

check_state(#state{state=StateAtom} = State, StateAtom) ->
    State.
