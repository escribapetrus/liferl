-module(grid).
-export([build/2, draw/1]).

build(Xs, Ys) ->
	[
	 [{X, Y} || X <- lists:seq(0, Xs - 1)]
	 || Y <- lists:seq(0, Ys - 1)
	].

draw(Grid) ->
	lists:foreach(fun(X) -> erlang:display(X) end, Grid).
