-module(cell).
-export([create/1, move/3, find/1, kill/1]).

create([]) -> ok;
create([H|T]) ->
	create(H),
	create(T);
create({X, Y}) ->
	Pid = spawn(fun() -> loop() end),
	move(Pid, X, Y),
	Pid.

%% toggle(Pid) -> client:rpc(Pid, toggle).
%% get_status(Pid) -> client:rpc(Pid, status).

move(Pid, X, Y) -> client:rpc(Pid, {move, X, Y}).

find(Pid) -> client:rpc(Pid, find).

kill(Pid) -> client:rpc(Pid, kill).

loop() ->
	receive
		{_Client, {move, X, Y}} ->
			%% put(status, 0),
			put(position, {X, Y}),
			loop();
		{Client, find} ->
			Client! {self(), get(position)},
			loop();
		{_Client, kill} ->
			exit(normal)
		%% {Client, status} ->
		%% 	Client! {self(), get(status)},
		%% 	loop();
		%% {_Client, toggle} ->
		%% 	case get(status) of
		%% 		0 ->
		%% 			put(status, 1),
		%% 			loop();
		%% 		1 ->
		%% 			put(status, 0),
		%% 			loop()
		%% 	end
	end.
