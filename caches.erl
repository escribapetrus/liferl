-module(caches).
-export([create/0]).

create() ->
    LivingPieces = living_pieces(),
    PotentialSpawns = potential_spawns(),
    #{
      living_pieces => LivingPieces,
      potential_spawns => PotentialSpawns
     }.

living_pieces() ->
    ets:new(living_pieces, [ordered_set]).

potential_spawns() ->
    ets:new(potential_spawns, [ordered]).
