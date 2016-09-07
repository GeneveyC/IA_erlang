-module(ia_gen).

-export([create_tree/1]).
-export([first_parse_file/1, parse_file/2, parse_file2/4, parse_data/1]).
-export([first_data_to_tree/1, data_to_tree/2, add_node_to_tree/2]).

create_tree(File) ->
	case file:read_file(File) of
		{ok, Data} ->
			first_parse_file(Data);
		{error, _} ->
			errorFile
	end.

first_parse_file(Data) ->
	case Data of
		%Si id = 1 && Valeur = 1
		<<Id:1/binary,":",Type:1/binary,"#",Value:1/binary, ".\n", Rest/binary>> ->
			Tree=first_data_to_tree({Id, Type, Value}),
			parse_file(Rest,Tree);
		%Si id = 2 && valeur = 1
		<<Id:2/binary,":",Type:1/binary,"#",Value:1/binary, ".\n", Rest/binary>> ->
			Tree=first_data_to_tree({Id, Type, Value}),
			parse_file(Rest,Tree);
		%Si id = 3 && valeur = 1
		<<Id:3/binary,":",Type:1/binary,"#",Value:1/binary, ".\n", Rest/binary>> ->
			Tree=first_data_to_tree({Id, Type, Value}),
			parse_file(Rest,Tree);
		%si id = 1 && valeur = 2
		<<Id:1/binary,":",Type:1/binary,"#",Value:2/binary, ".\n", Rest/binary>> ->
			Tree=first_data_to_tree({Id, Type, Value}),
			parse_file(Rest,Tree);
		%si id = 1 && valeur = 3
		<<Id:1/binary,":",Type:1/binary,"#",Value:3/binary, ".\n", Rest/binary>> ->
			Tree=first_data_to_tree({Id, Type, Value}),
			parse_file(Rest,Tree);
		%si id = 1 && valeur = 4
		<<Id:1/binary,":",Type:1/binary,"#",Value:4/binary, ".\n", Rest/binary>> ->
			Tree=first_data_to_tree({Id, Type, Value}),
			parse_file(Rest,Tree);
		%si id = 1 && valeur = 5
		<<Id:1/binary,":",Type:1/binary,"#",Value:5/binary, ".\n", Rest/binary>> ->
			Tree=first_data_to_tree({Id, Type, Value}),
			parse_file(Rest,Tree);
		%Si id = 2 && valeur = 2
		<<Id:2/binary,":",Type:1/binary,"#",Value:2/binary, ".\n", Rest/binary>> ->
			Tree=first_data_to_tree({Id, Type, Value}),
			parse_file(Rest,Tree);
		%Si id = 2 && valeur = 3
		<<Id:2/binary,":",Type:1/binary,"#",Value:3/binary, ".\n", Rest/binary>> ->
			Tree=first_data_to_tree({Id, Type, Value}),
			parse_file(Rest,Tree);
		%Si id = 2 && valeur = 4
		<<Id:2/binary,":",Type:1/binary,"#",Value:4/binary, ".\n", Rest/binary>> ->
			Tree=first_data_to_tree({Id, Type, Value}),
			parse_file(Rest,Tree);
		%Si id = 2 && valeur = 5
		<<Id:2/binary,":",Type:1/binary,"#",Value:5/binary, ".\n", Rest/binary>> ->
			Tree=first_data_to_tree({Id, Type, Value}),
			parse_file(Rest,Tree);
		%Si id = 3 && valeur = 3
		<<Id:3/binary,":",Type:1/binary,"#",Value:3/binary, ".\n", Rest/binary>> ->
			Tree=first_data_to_tree({Id, Type, Value}),
			parse_file(Rest,Tree);
		%Si id = 3 && valeur = 4
		<<Id:3/binary,":",Type:1/binary,"#",Value:4/binary, ".\n", Rest/binary>> ->
			Tree=first_data_to_tree({Id, Type, Value}),
			parse_file(Rest,Tree);
		%Si id = 3 && valeur = 5
		<<Id:3/binary,":",Type:1/binary,"#",Value:5/binary, ".\n", Rest/binary>> ->
			Tree=first_data_to_tree({Id, Type, Value}),
			parse_file(Rest,Tree);
		<<>> ->
			ok;
		_ ->
			io:format("Error : value_unknow (~p)~n",[Data]),
			error_unknow_value
	end.


parse_file(Data, Tree) ->
	case Data of
		%Si id = 1 && Valeur = 1
		<<Id:1/binary,":",Type:1/binary,"#",Value:1/binary, ".\n", Rest/binary>> ->
			New_tree=data_to_tree({Id, Type, Value}, Tree, Rest),
			parse_file(Rest,New_tree);
		%Si id = 2 && valeur = 1
		<<Id:2/binary,":",Type:1/binary,"#",Value:1/binary, ".\n", Rest/binary>> ->
			New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
			parse_file(Rest,New_tree);
		%Si id = 3 && valeur = 1
		<<Id:3/binary,":",Type:1/binary,"#",Value:1/binary, ".\n", Rest/binary>> ->
			New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
			parse_file(Rest,New_tree);
		%si id = 1 && valeur = 2
		<<Id:1/binary,":",Type:1/binary,"#",Value:2/binary, ".\n", Rest/binary>> ->
			New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
			parse_file(Rest,New_tree);
		%si id = 1 && valeur = 3
		<<Id:1/binary,":",Type:1/binary,"#",Value:3/binary, ".\n", Rest/binary>> ->
			New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
			parse_file(Rest,New_tree);
		%si id = 1 && valeur = 4
		<<Id:1/binary,":",Type:1/binary,"#",Value:4/binary, ".\n", Rest/binary>> ->
			New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
			parse_file(Rest,New_tree);
		%si id = 1 && valeur = 5
		<<Id:1/binary,":",Type:1/binary,"#",Value:5/binary, ".\n", Rest/binary>> ->
			New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
			parse_file(Rest,New_tree);
		%Si id = 2 && valeur = 2
		<<Id:2/binary,":",Type:1/binary,"#",Value:2/binary, ".\n", Rest/binary>> ->
			New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
			parse_file(Rest,New_tree);
		%Si id = 2 && valeur = 3
		<<Id:2/binary,":",Type:1/binary,"#",Value:3/binary, ".\n", Rest/binary>> ->
			New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
			parse_file(Rest,New_tree);
		%Si id = https://1fichier.com/?2tps5j85mw2 && valeur = 4
		<<Id:2/binary,":",Type:1/binary,"#",Value:4/binary, ".\n", Rest/binary>> ->
			New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
			parse_file(Rest,New_tree);
		%Si id = 2 && valeur = 5
		<<Id:2/binary,":",Type:1/binary,"#",Value:5/binary, ".\n", Rest/binary>> ->
			New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
			parse_file(Rest,New_tree);
		%Si id = 3 && valeur = 3
		<<Id:3/binary,":",Type:1/binary,"#",Value:3/binary, ".\n", Rest/binary>> ->
			New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
			parse_file(Rest,New_tree);
		%Si id = 3 && valeur = 4
		<<Id:3/binary,":",Type:1/binary,"#",Value:4/binary, ".\n", Rest/binary>> ->
			New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
			parse_file(Rest,New_tree);
		%Si id = 3 && valeur = 5
		<<Id:3/binary,":",Type:1/binary,"#",Value:5/binary, ".\n", Rest/binary>> ->
			New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
			parse_file(Rest,New_tree);
		<<>> ->
			Tree;
		_ ->
			io:format("Error : value_unknow (~p)~n",[Data]),
			error_unknow_value
	end.

parse_file2(Pid, Data, Tree, Noeud_courant) ->
	if
		(Id1==noeud:get_id(Noeud_courant)) and (Type1==noeud:get_type(Noeud_courant)) ->
			Pid ! {Data, Tree3};
		true ->
			N=noeud:create_node(Id1, Type1, Value1),
			case Data of
				%Si id = 1 && Valeur = 1
				<<Id:1/binary,":",Type:1/binary,"#",Value:1/binary, ".\n", Rest/binary>> ->
					New_tree=data_to_tree({Id, Type, Value}, Tree, Rest),
					parse_file2(self(), Rest, New_tree, Noeud_courant);
				%Si id = 2 && valeur = 1
				<<Id:2/binary,":",Type:1/binary,"#",Value:1/binary, ".\n", Rest/binary>> ->
					New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
					parse_file2(self(), Rest, New_tree, Noeud_courant);
				%Si id = 3 && valeur = 1
				<<Id:3/binary,":",Type:1/binary,"#",Value:1/binary, ".\n", Rest/binary>> ->
					New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
					parse_file2(self(), Rest, New_tree, Noeud_courant);
				%si id = 1 && valeur = 2
				<<Id:1/binary,":",Type:1/binary,"#",Value:2/binary, ".\n", Rest/binary>> ->
					New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
					parse_file2(self(), Rest, New_tree, Noeud_courant);
				%si id = 1 && valeur = 3
				<<Id:1/binary,":",Type:1/binary,"#",Value:3/binary, ".\n", Rest/binary>> ->
					New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
					parse_file2(self(), Rest, New_tree, Noeud_courant);
				%si id = 1 && valeur = 4
				<<Id:1/binary,":",Type:1/binary,"#",Value:4/binary, ".\n", Rest/binary>> ->
					New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
					parse_file2(self(), Rest, New_tree, Noeud_courant);
				%si id = 1 && valeur = 5
				<<Id:1/binary,":",Type:1/binary,"#",Value:5/binary, ".\n", Rest/binary>> ->
					New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
					parse_file2(self(), Rest, New_tree, Noeud_courant);
				%Si id = 2 && valeur = 2
				<<Id:2/binary,":",Type:1/binary,"#",Value:2/binary, ".\n", Rest/binary>> ->
					New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
					parse_file2(self(), Rest, New_tree, Noeud_courant);
				%Si id = 2 && valeur = 3
				<<Id:2/binary,":",Type:1/binary,"#",Value:3/binary, ".\n", Rest/binary>> ->
					New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
					parse_file2(self(), Rest, New_tree, Noeud_courant);
				%Si id = https://1fichier.com/?2tps5j85mw2 && valeur = 4
				<<Id:2/binary,":",Type:1/binary,"#",Value:4/binary, ".\n", Rest/binary>> ->
					New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
					parse_file2(self(), Rest, New_tree, Noeud_courant);
				%Si id = 2 && valeur = 5
				<<Id:2/binary,":",Type:1/binary,"#",Value:5/binary, ".\n", Rest/binary>> ->
					New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
					parse_file2(self(), Rest, New_tree, Noeud_courant);
				%Si id = 3 && valeur = 3
				<<Id:3/binary,":",Type:1/binary,"#",Value:3/binary, ".\n", Rest/binary>> ->
					New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
					parse_file2(self(), Rest, New_tree, Noeud_courant);
				%Si id = 3 && valeur = 4
				<<Id:3/binary,":",Type:1/binary,"#",Value:4/binary, ".\n", Rest/binary>> ->
					New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
					parse_file2(self(), Rest, New_tree, Noeud_courant);
				%Si id = 3 && valeur = 5
				<<Id:3/binary,":",Type:1/binary,"#",Value:5/binary, ".\n", Rest/binary>> ->
					New_tree=data_to_tree({Id, Type, Value},Tree, Rest),
					parse_file2(self(), Rest, New_tree, Noeud_courant);
				<<>> ->
					Tree;
				_ ->
					io:format("Error : value_unknow (~p)~n",[Data]),
					error_unknow_value
			end
	end.

%Function to primary process
add_node_to_tree(Noeud, Tree) ->
	noeud:add_pred(Tree, Noeud).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Function return tree build		%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
first_data_to_tree(Data) ->
	{Id1, Type1, Value1}=parse_data(Data),
	N=noeud:create_node(Id1, Type1, Value1),
	io:format("Node create : ~p~n",[N]),
	N.

%Spawn new process with Data+

%Presque OK !!!!!
data_to_tree(Data, Tree, Rest) ->

	{Id1, Type1, Value1}=parse_data(Data),
	Id2=noeud:get_id(Tree),

	if 
		%Processus primaire
		Id1>Id2 ->
			%Creation du nouveau noeud
			N=noeud:create_node(Id1, Type1, Value1),
			io:format("Node create : ~p~n",[N]),
			io:format("New node : Father~n"),
			Tree3=add_node_to_tree(N, Tree);

		%Processus secondaire
		Id1=<Id2 ->
			N=noeud:create_node(Id1, Type1, Value1),
			io:format("Node create : ~p~n",[N]),
			io:format("New node : Son~n"),
			Tree2=parse_file2(self(), Rest, Tree, N),
			Tree3=noeud:add_pred(Tree2, Tree)
	%Condition des process
%Spawn new process -> first_parse_file()
	end,
	Tree3.

%Ok, nickel
parse_data(Data) ->
	case Data of
		{Id, Type, Value} ->
			Id1=binary_to_list(Id),
			Id2=string:to_integer(Id1),
			Id3=element(1, Id2),

			Type1=binary_to_list(Type),

			case Type1 of
				"F" ->
					Type3=feuille;
				"N" ->
					Type3=min;
				"M" ->
					Type3=max;
				"R" ->
					Type3=racine
			end,

			Value1=binary_to_list(Value),
			Value2=string:to_integer(Value1),
			Value3=element(1, Value2),
			{Id3, Type3, Value3};
		_ ->
			error_unknow_data
	end.