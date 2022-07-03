-module(liferl).
-export([run/1, run/2, mark_to_die/1, mark_to_spawn/2]).

run(init, Pattern) ->
    caches:create(),
    cell:create(Pattern),
    Grid = grid:build(50, 50, []),
    grid:draw(Grid),
    run(refresh).

run(refresh) ->
    LivingCells = caches:get_cells_positions(living_cells),
    DeadCells = caches:get_cells_positions(dead_cells),
    ToDie = mark_to_die(LivingCells),
    ToSpawn = mark_to_spawn(DeadCells, LivingCells),
    KillCell = lists:map(fun(X) -> caches:get_pid(X, living_cell) end, ToDie),
    cell:kill(KillCell),
    cell:create(ToSpawn),
    NewLivingCells = caches:get_cells_positions(living_cells),
    Grid = grid:build(50, 50, NewLivingCells),
    caches:refresh_dead_cells(dead_neighbours(NewLivingCells)),
    grid:draw(Grid),
    run(refresh).

mark_to_die(LivingCells) ->
    lists:filter(
        fun(X) ->
                N = length(living_neighbours(X, LivingCells)),
                (N < 2) or (N > 3) end,
        LivingCells).

mark_to_spawn(DeadCells, LivingCells) ->
    lists:filter(
      fun(X) ->
              length(living_neighbours(X, LivingCells)) == 3 end,
      DeadCells).

living_neighbours({X,Y}, LivingCells) ->
    lists:filter(
      fun(C) -> lists:member(C, LivingCells) end,
      [{X-1, Y-1}, {X, Y-1}, {X+1,Y-1},
       {X-1, Y}, {X+1, Y},
       {X-1, Y+1}, {X, Y+1}, {X+1, Y+1}]).

dead_neighbours(LivingCells) when is_list(LivingCells) ->
    lists:flatten(lists:uniq(lists:map(
      fun(X) -> dead_neighbours(X, LivingCells) end,
                               LivingCells))).
dead_neighbours({X,Y}, LivingCells) ->
    lists:filter(
      fun(C) -> not lists:member(C, LivingCells) end,
      [{X-1, Y-1}, {X, Y-1}, {X+1,Y-1},
       {X-1, Y}, {X+1, Y},
       {X-1, Y+1}, {X, Y+1}, {X+1, Y+1}]).
