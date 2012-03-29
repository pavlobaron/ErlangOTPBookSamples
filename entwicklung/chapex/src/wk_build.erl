-module(wk_build).
-export([all/0, compile/0, dialyzer/0, test1/0, test2/0, doc/0]).

all() ->
    compile(),
    dialyzer(),
    test1(),
    test2(),
    doc(),
    cprof(),
   % perf_kursinfo1(),
   % perf_kursinfo2(),
    cover().

files() -> 
    ["wechselkurs_server.erl" ,
     "wechselkurs_client.erl",
     "wechselkurs_client_rpc.erl",
     "wechselkurs_worker.erl",
     "wechselkurs_tests.erl",  
     "wechselkurs_more_tests.erl",
     "wechselkurs_db.erl"].

doc_files() -> 
    ["wechselkurs_server.erl" ,
     "wechselkurs_worker.erl",
     "wechselkurs_db.erl"].
    
compile() ->
    io:format("COMPILE MODULES ...\n"),
    lists:foreach(fun(File) -> c:c(File, [debug_info]), io:format("Module ~p compiled \n", [File]) end, files()),
    io:format("...\n\n\n").

dialyzer() ->
    os:cmd("dialyzer --src -r .").

test1() ->
    io:format("RUN TESTS ...\n"),
    eunit:test(wechselkurs_tests, [verbose]),
    io:format("...\n\n\n").

test2() ->
    io:format("RUN MORE TESTS ...\n"),
    wechselkurs_server:start(),
    eunit:test(wechselkurs_more_tests, [verbose]),
    wechselkurs_server:stop(),
    io:format("...\n\n\n").

doc() ->
    io:format("CREATE DOCS ...\n"),
    edoc:files(doc_files(), [{dir, "../doc"}, {todo, true}]),
    io:format("...\n\n\n").

perf_kursinfo1() -> 
    io:format("FPROF ...\n"),
    wechselkurs_server:start(),
    fprof:trace(start),
    wechselkurs_client:kursinfo(),
    fprof:trace(stop),
    wechselkurs_server:stop(),
    fprof:profile(),
    fprof:analyse(), 
    io:format("...\n\n\n").
    
perf_kursinfo2() ->
    io:format("FPROF ...\n"),
    wechselkurs_server:start(),
    [ fprof:apply(wechselkurs_client, kursinfo, []) || _P <- lists:seq(1,50)],
    wechselkurs_server:stop(),
    fprof:profile(),
    fprof:analyse(),
    io:format("...\n\n\n").

cprof() ->
    io:format("CPROF ...\n"),
    wechselkurs_server:start(),
    cprof:start(wechselkurs_server, kursinfo, 3),
    [ wechselkurs_client:kursinfo() || _P <- lists:seq(1,50)],
    cprof:pause(),
    Result=cprof:analyse(wechselkurs_server),
    cprof:stop(),
    wechselkurs_server:stop(),
    io:format("~p \n", [Result]),
    io:format("...\n\n\n").
	
cover() ->
    io:format("COVER ... \n"),
    cover:start(),
    cover:compile(wechselkurs_server),
    wechselkurs_server:start(),
    [ wechselkurs_client:kursinfo() || _P <- lists:seq(1,10)],
    [ wechselkurs_client:umrechnung() || _P <- lists:seq(1,10)],
    cover:analyse_to_file(wechselkurs_server),
    wechselkurs_server:stop(),
    cover:stop(),
    io:format("...\n\n\n").


