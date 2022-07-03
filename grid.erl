-module(grid).
-export([build/3, draw/1]).

build(Xs, Ys, LivingPieces) ->
	[
	 [cell({X,Y}, LivingPieces) || X <- lists:seq(0, Xs - 1)]
	 || Y <- lists:seq(0, Ys - 1)
	].

draw(Grid) ->
	lists:foreach(fun(X) -> erlang:display(X) end, Grid).

cell(Position, LivingPieces) ->
	  	case lists:member(Position, LivingPieces) of
		true -> [x];
		false -> []
		end.
