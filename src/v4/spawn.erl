-module(spawn).

-export([start/3, start2/3]).

-export([test/3]).

test(A, B, C) ->
	if
		(A==B) and (B==C) ->
			io:format("Toute les donnée sont valide~n",[]);
		true ->
			io:format("Donnee invalide~n",[])
	end.

start(_, _, 0) ->
	ok; 

start(Pid, Data, N)->
	spawn(spawn, start2, [Pid, Data, N-1]),
	receive
		{Data2, N} ->
			io:format("receivde data : ~p ~p~n",[Data2, N]),
			start(Pid, Data, N-1)
	end.

start2(Pid, Data, N) ->
	io:format("msg : ~p~n",[Data]),
	Pid ! {Data, N+1}.