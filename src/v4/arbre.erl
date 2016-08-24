-module(arbre).

-export([arbreVide/0, arbreCons/3]).
-export([arbreEstVide/1,racine/1, arbreGauche/1, arbreDroit/1]).
-export([rechercheTDA/2,nbNoeuds/1]).
-export([prefix/1]).
-export([create_example/0,create_example2/0]).
-export([serialization/2,deserialization/1]).
-export([generation_arbre/0]).

create_example2() ->
	arbreCons(z, 
				arbreCons(z, 
					arbreCons(5, arbreVide(), arbreVide()), 
					arbreCons(2, arbreVide(), arbreVide())),
				arbreCons(7, arbreVide(), arbreVide())).

create_example() ->
	arbreCons(5, 
		arbreCons(12, 
			arbreCons(21, 
				arbreCons(8, arbreVide(), arbreVide()),
					arbreVide()), arbreVide()), 
	arbreCons(7,
			arbreCons(29,
				arbreVide(), arbreVide()), arbreCons(13, arbreVide(), arbreCons(88, arbreVide(), arbreVide())))).

arbreVide() ->
	{arbre}.

arbreCons(Elem, Ag, Ad) ->
	{arbre, Elem, Ag, Ad}.

arbreEstVide({arbre}) ->
	true;

arbreEstVide({arbre, _, _, _}) ->
	false.

racine({arbre, Elem, _, _}) ->
	Elem;

racine({arbre}) ->
	errorVide.

arbreDroit({arbre, _, _, Ad}) ->
	Ad;

arbreDroit({arbre}) ->
	errorVide.

arbreGauche({arbre, _, Ag, _}) ->
	Ag;

arbreGauche({arbre}) ->
	errorVide.

rechercheTDA(Elem, Arbre) ->
	case arbreEstVide(Arbre) of
			true ->
				false;
			false ->
				case racine(Arbre) of
					Elem ->
						true;
					_ ->
						rechercheTDA(Elem, arbreGauche(Arbre))
						orelse rechercheTDA(Elem, arbreDroit(Arbre))
				end
	end.

nbNoeuds(Arbre) ->
	case arbreEstVide(Arbre) of
		true ->
			0;
		false ->
			1 + nbNoeuds(arbreGauche(Arbre))
				+ nbNoeuds(arbreDroit(Arbre))
	end.

prefix({arbre}) ->
	io:format("");

prefix({arbre, Elem, Ag, Ad}) ->
	io:format("~p ",[Elem]),
	prefix(Ag),
	prefix(Ad).

serialization(Arbre, File) ->
	Data = term_to_binary(Arbre),
	file:write_file(File, Data).

deserialization(File) ->
	case file:read_file(File) of
		{ok, Data} ->
			binary_to_term(Data);
		{error, _} ->
			error
	end.

generation_arbre() ->
	ok.