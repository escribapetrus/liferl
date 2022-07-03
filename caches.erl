-module(caches).
-export([
         add_living_cell/2,
         create/0,
         get_pid/2,
         get_cells_positions/1,
         refresh_dead_cells/1,
         remove_living_cell/1
]).

create() ->
    #{
      living_cells => create_living_cells_table(),
      dead_cells => create_potential_spawns_table()
     }.

create_living_cells_table() ->
    ets:new(living_cells, [set, named_table]).

create_potential_spawns_table() ->
    ets:new(dead_cells, [set, named_table]).

add_living_cell(Position, Pid) ->
    ets:insert(living_cells, {Position, Pid}).

remove_living_cell(Position) ->
    ets:delete(living_cells, Position).

get_pid(Position, living_cell) ->
    [{living_cells, Position}] = ets:lookup(living_cells),
    Position;
get_pid(Position, dead_cell) ->
    [{dead_cells, Position}] = ets:lookup(dead_cells),
    Position.

get_cells_positions(Table) ->
    Cells = ets:tab2list(Table),
    lists:map(fun({Position, _}) -> Position end, Cells).

refresh_dead_cells(DeadCells) ->
    ets:delete_all_objects(dead_cells),
    lists:foreach(
     fun(X) -> ets:insert(dead_cells, {X, dead_cell}) end,
     DeadCells).
