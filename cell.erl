-module(cell).
-export([create/1, move/3, find/1, kill/1]).

create(Positions) when is_list(Positions) ->
	lists:foreach(fun(X) -> create(X) end, Positions);
create({X, Y}) ->
	Pid = spawn(fun() -> loop() end),
	move(Pid, X, Y),
	Pid.

move(Pid, X, Y) -> client:rpc(Pid, {move, X, Y}).

find(Pid) -> client:rpc(Pid, find).

kill(Pids) when is_list(Pids) ->
	lists:foreach(fun(X) -> kill(X) end);
kill(Pid) -> client:rpc(Pid, kill).

loop() ->
	receive
		{_Client, {move, X, Y}} ->
			caches:add_living_cell({X, Y}, self()),
			put(position, {X, Y}),
			loop();
		{Client, find} ->
			Client! {self(), get(position)},
			loop();
		{_Client, kill} ->
			Position = get(position),
			caches:remove_living_cell(Position),
			exit(normal)
	end.
