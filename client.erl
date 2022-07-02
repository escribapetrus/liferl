-module(client).
-export([rpc/2]).

rpc(Pid, Message) ->
    Pid ! {self(), Message},
    receive
        {Pid, Response} -> Response
    after 2000 ->
            io:format("Timeout triggered.~n"),
            done
    end.
