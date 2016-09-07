-module(noeud).

-include("noeud.hrl").

-export([estFeuille/1, estRacine/1, estMax/1, estMin/1]).
-export([noeud_max/2, noeud_min/2, noeud_feuille/2, noeud_racine/2]).
-export([create_node/3, create_Succ/1, add_Succ/2, getFirstSucc/1, getOtherSucc/1, set_Succ/2, maj_Succ/2]).
-export([add_Pred/2]).
-export([getId/1, getType/1, getElement/1, maj_Element/2]).
-export([nbNoeuds/1, nbNoeuds2/1]).
-export([serialization/2, deserialization/1]).
-export([affichage_noeud/1, affichage_lists/1]).

create_node(Id, Type, Value) ->
	N = #noeud{id=Id,
				type=Type,
				value=Value,
				succ=[]},
	N.
















estRacine({_, feuille, _}) ->
	false;

estRacine({_, Type, _, _}) ->
	case Type of
		racine ->
			true;
		_ ->
			false
	end.

estFeuille({ _, _, _, _}) ->
	false;

estFeuille({_, feuille, _}) ->
	true.

estMax({_, feuille, _}) ->
	false;

estMax({_, Type, _, _}) ->
	case Type of
		max ->
			true;
		_ ->
			false
	end.



estMin({_, feuille, _}) ->
	false;

estMin({_, Type, _, _}) ->
	case Type of
		min ->
			true;
		_ ->
			false
	end.



create_node(Id, Type, Elem) ->
	{Id, Type, Elem, []}.

noeud_max(Id, Elem) ->
	{Id, max, Elem, []}.

noeud_min(Id, Elem) ->
	{Id, min, Elem, []}.

noeud_feuille(Id, Elem) ->
	{Id, feuille, Elem}.

noeud_racine(Id, Elem) ->
	{Id, racine, Elem, []}.






create_Succ(Noeuds) ->
	[Noeuds].

getFirstSucc({_, racine, _, [N1|_]}) ->
	N1;

getFirstSucc({_, _, _, [N1|_]}) ->
	N1. 

getOtherSucc({_, racine, _, [_|NR]}) ->
	NR;

getOtherSucc({_, _, _, [_|NR]}) ->
	NR.

set_Succ({_, _, _, Succ}, Noeud_succ) ->
	lists:append(Succ, Noeud_succ).

maj_Succ({Id, Type, Elem, Succ}, Noeud_succ) ->
	{Id, Type, Elem, set_Succ({Id, Type, Elem, Succ}, Noeud_succ)}.

add_Succ(Noeud_courant, Noeud_succ) ->
	maj_Succ(Noeud_courant, create_Succ(Noeud_succ)).

add_Pred(Noeud_courant, Noeud_Pred) ->
	add_Succ(Noeud_Pred, Noeud_courant).


%GetId pour le noeud feuille
getId({Id, feuille, _}) ->
	Id;

%GetId pour les autres noeud
getId({Id, _, _, _}) ->
	Id.

%GetType pour les noeud feuille
getType({_, feuille, _}) ->
	feuille;

%GetType pour les noeud max et min
getType({_, Type, _, _}) ->
	Type.



%GetElement pour le noeud feuille
getElement({_, feuille, Elem}) ->
	Elem;

%GetElement pour le noeud max et min
getElement({_, _, Elem, _}) ->
	Elem.

maj_Element({Id, Type, _, Succ}, Elem) ->
	{Id, Type, Elem, Succ}.	



%le noeud courant n'a pas de successeurs
nbNoeuds([]) ->
	0;

%le noeud courant a des successeurs
nbNoeuds(Noeuds) ->
	case estFeuille(Noeuds) of
		true ->
			1;
		false ->
			1 + nbNoeuds(getFirstSucc(Noeuds)) 
				+ nbNoeuds2(getOtherSucc(Noeuds))
	end.

%la liste des successeur est vide
nbNoeuds2([]) ->
	0;

%La liste des successeur est pas vide
nbNoeuds2([N1|NR]) ->
	nbNoeuds(N1) + 
		nbNoeuds2(NR); 

%la liste contiens 1 sucesseur
nbNoeuds2(N1) ->
	nbNoeuds(N1).

%Fonction de serialization de l'arbre
serialization(Noeuds, File) ->
	Data = term_to_binary(Noeuds),
	file:write_file(File, Data).

%Fonctione de deserialization de l'arbre
deserialization(File) ->
	case file:read_file(File) of
		{ok, Data} ->
			binary_to_term(Data);
		{error, _} ->
			error
	end.

%affichage d'un noeud "feuille"
affichage_noeud({_, feuille, Elem}) ->
	io:format("~p ",[Elem]);

%affichage d'un noeud "max, min ou racine"
affichage_noeud(Noeuds) ->
	io:format("~p ",[getElement(Noeuds)]),
	affichage_noeud(getFirstSucc(Noeuds)),
	affichage_lists(getOtherSucc(Noeuds)).

%affichage d'une lists vide
affichage_lists([]) ->
	io:format("");

%affichage d'une liste de successeur
affichage_lists([N1|NR]) ->
	affichage_noeud(N1),
	affichage_lists(NR);

%affichage d'une liste de successeur
affichage_lists(N1) ->
	affichage_noeud(N1).