-------------------------------
- BUILD (Compile, Test, Docs) -
-------------------------------
cd wechselkurs/src
erlc -I ../include -o ../ebin wk_build.erl
erl -pa ../ebin -eval "wk_build:all(), halt()."

-------------------------------
- Als Client/Server App       -
-------------------------------
Server:
(1) erl -sname server -eval "wechselkurs_server:start()."

Client:
(1) erl -sname client
(2) wechselkurs_client_rpc:kursinfo()
(3) wechselkurs_client_rpc:umrechnung()

