-module(noeud).

-include("noeud.hrl").

-export([create_node/3, create_node_succ/1]).
-export([get_id/1, get_type/1, get_first_succ/1, get_other_succ/1]).
-export([add_pred/2, add_succ/2]).
-export([print_tree/1, print_succ/1]).

create_node(Id, Type, Value) ->
	case Type of
		racine ->
			#root{id=Id,
				value=Value};
		max ->
			#max{id=Id,
			value=Value};
		min ->
			 #min{id=Id,
			value=Value};
		feuille ->
			#sheet{id=Id,
				value=Value};
		_ ->
			error_node_unknow
	end.

create_node_succ(Noeud) ->
	[Noeud].


get_id(Noeud) ->
	case Noeud of
		{root, Id, _, _} ->
			Id;
		{max,  Id, _, _} ->
			Id;
		{min,  Id, _, _} ->
			Id;
		{sheet, Id, _} ->
			Id
	end.

get_type(Noeud) ->
	case Noeud of
		{root, _, _, _} ->
			root;
		{max,  _, _, _} ->
			max;
		{min,  _, _, _} ->
			min;
		{sheet, _, _} ->
			sheet
	end.

get_first_succ(Noeud) ->
	case Noeud of
		{root, _, _, [N1|_]} ->
			N1;
		{max, _, _, [N1|_]} ->
			N1;
		{min, _, _, [N1|_]} ->
			N1
	end.

get_other_succ(Noeud) ->
	case Noeud of
		{root, _, _, [_|NR]} ->
			NR;
		{max, _, _, [_|NR]} ->
			NR;
		{min, _, _, [_|NR]} ->
			NR
	end.

add_pred(Noeud, Noeud_pred) ->
	add_succ(Noeud_pred, Noeud).

add_succ(Noeud, Noeud_succ) ->
	Noeud_succ2 = create_node_succ(Noeud_succ),
	case Noeud of
		{root, _, _, Succ} ->
			L=lists:append(Succ, Noeud_succ2),
			Noeud#root{succ=L};
		{max, _, _, Succ} ->
			L=lists:append(Succ, Noeud_succ2),
			Noeud#max{succ=L};
		{min, _, _, Succ} ->
			L=lists:append(Succ, Noeud_succ2),
			Noeud#min{succ=L}
	end.

print_tree(Noeud) ->
	case Noeud of
		{sheet, _, Value} ->
			io:format("~p ",[Value]);
		{root, _, Value, _} ->
			io:format("~p ",[Value]),
			print_tree(get_first_succ(Noeud)),
			print_succ(get_other_succ(Noeud));
		{max, _, Value, _} ->
			io:format("~p ",[Value]),
			print_tree(get_first_succ(Noeud)),
			print_succ(get_other_succ(Noeud));
		{min, _, Value, _} ->
			io:format("~p ",[Value]),
			print_tree(get_first_succ(Noeud)),
			print_succ(get_other_succ(Noeud))
	end.


print_succ([]) ->
	ok;

print_succ([N1|NR]) ->
	print_tree(N1),
	print_succ(NR);

print_succ(N1) ->
	print_tree(N1).