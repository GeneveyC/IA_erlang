-module(ia_gen2).

-export([parse_line/1]).

-export([create_tree/1]).
-export([search_root/1]).
-export([number_of_root/1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Structure du fichier dans test9.txt		%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-export([open_file/1, close_file/1, read_lines/2]).

open_file(File) ->
	{ok, Device} = file:open(File, [read, binary]),
	Device.

close_file(Device) ->
	ok = file:close(Device).

read_lines(Device, L) ->
	case io:get_line(Device, L) of
		eof ->
			close_file(Device),
			lists:reverse(L);
		Data ->
			parse_line(Data),
			read_lines(Device, [Data| L])
	end.

create_tree(File) ->
	Device = open_file(File),
	L1=read_lines(Device, []),
	L1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Pour la convertion:						%
%		[L1|LR] = L,						%
%											%
%		Id1= binary_to_list(Id),			%
%		Id = string:to_integer(Id1),		%
%											%
%		Type=binary_to_list(Type),			%
%											%
%		Value1=binary_to_list(Value),		%
%		Value=string:to_integer(Value1),	%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parse_data(Data) ->
	case Data of 
		{Id, Type, Value} ->
			;
		_ ->
			error_unknow_value
	end.
	
parse_line(Data) ->
	case Data of
		%Si id = 1 && Valeur = 1
		<<Id:1/binary,":",Type:1/binary,"#",Value:1/binary, ".\n">> ->
			io:format("~p ~p ~p~n",[Id, Type, Value]),
			{Id, Type, Value};
		%Si id = 2 && valeur = 1
		<<Id:2/binary,":",Type:1/binary,"#",Value:1/binary, ".\n">> ->
			io:format("~p ~p ~p~n",[Id, Type, Value]),
			{Id, Type, Value};
		%Si id = 3 && valeur = 1
		<<Id:3/binary,":",Type:1/binary,"#",Value:1/binary, ".\n">> ->
			io:format("~p ~p ~p~n",[Id, Type, Value]),
			{Id, Type, Value};
		%si id = 1 && valeur = 2
		<<Id:1/binary,":",Type:1/binary,"#",Value:2/binary, ".\n">> ->
			io:format("~p ~p ~p~n",[Id, Type, Value]),
			{Id, Type, Value};
		%si id = 1 && valeur = 3
		<<Id:1/binary,":",Type:1/binary,"#",Value:3/binary, ".\n">> ->
			io:format("~p ~p ~p~n",[Id, Type, Value]),
			{Id, Type, Value};
		%si id = 1 && valeur = 4
		<<Id:1/binary,":",Type:1/binary,"#",Value:4/binary, ".\n">> ->
			io:format("~p ~p ~p~n",[Id, Type, Value]),
			{Id, Type, Value};
		%si id = 1 && valeur = 5
		<<Id:1/binary,":",Type:1/binary,"#",Value:5/binary, ".\n">> ->
			io:format("~p ~p ~p~n",[Id, Type, Value]),
			{Id, Type, Value};
		%Si id = 2 && valeur = 2
		<<Id:2/binary,":",Type:1/binary,"#",Value:2/binary, ".\n">> ->
			io:format("~p ~p ~p~n",[Id, Type, Value]),
			{Id, Type, Value};
		%Si id = 2 && valeur = 3
		<<Id:2/binary,":",Type:1/binary,"#",Value:3/binary, ".\n">> ->
			io:format("~p ~p ~p~n",[Id, Type, Value]),
			{Id, Type, Value};
		%Si id = 2 && valeur = 4
		<<Id:2/binary,":",Type:1/binary,"#",Value:4/binary, ".\n">> ->
			io:format("~p ~p ~p~n",[Id, Type, Value]),
			{Id, Type, Value};
		%Si id = 2 && valeur = 5
		<<Id:2/binary,":",Type:1/binary,"#",Value:5/binary, ".\n">> ->
			io:format("~p ~p ~p~n",[Id, Type, Value]),
			{Id, Type, Value};
		%Si id = 3 && valeur = 3
		<<Id:3/binary,":",Type:1/binary,"#",Value:3/binary, ".\n">> ->
			io:format("~p ~p ~p~n",[Id, Type, Value]),
			{Id, Type, Value};
		%Si id = 3 && valeur = 4
		<<Id:3/binary,":",Type:1/binary,"#",Value:4/binary, ".\n">> ->
			io:format("~p ~p ~p~n",[Id, Type, Value]),
			{Id, Type, Value};
		%Si id = 3 && valeur = 5
		<<Id:3/binary,":",Type:1/binary,"#",Value:5/binary, ".\n">> ->
			io:format("~p ~p ~p~n",[Id, Type, Value]),
			{Id, Type, Value};
		_ ->
			io:format("Error : value_unknow (~p)~n",[Data]),
			error_unknow_value
	end.

search_root(Data) ->
	case Data of
		<<_:4/binary, Type:1/binary, ":", _:4/binary, ".", Rest/binary>> ->
			case Type of
				<<"R">> ->
					true;
				_ ->
					search_root(Rest)
			end;
		<<>> ->
			io:format("Error : root not found!~n",[]),
			false
	end.

number_of_root(Data) ->
		case Data of
			<<_:1/binary, Type:1/binary, ":", _:1/binary, ".", Rest/binary>> ->
				case Type of
					<<"R">> ->
						1+number_of_root(Rest);
					_ ->
						number_of_root(Rest)
				end;
			<<>> ->
				0
		end.