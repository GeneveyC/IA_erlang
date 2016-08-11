-module(puissance4).

-export([gen_grid/0, jouer/0]).
-export([search_idx/3]).
-export([jouer/2]).

-export([getNbCasesVerticale_by_col/3]).
-export([getNbCasesVerticale/3]).

gen_grid() ->
	{{0,0,0,0,0,0},
	{0,0,0,0,0,0},
	{0,0,0,0,0,0},
	{0,0,0,0,0,0},
	{0,0,0,0,0,0},
	{0,0,0,0,0,0},
	{0,0,0,0,0,0}}.

jouer() ->
	io:format("~n"),
    io:format("*************************************************************~n"),
    io:format("* Puissance4 par Christophe                                 *~n"),
    io:format("* Pour jouer, il faut taper la commande [joueur,col]. 	   *~n"),
    io:format("* Par ex: [x,1]. -> place 'x' en colonne 1			       *~n"),
    io:format("* [o,3]. -> place 'o' en colonne 3...            		   *~n"),
    io:format("*************************************************************~n"),
    io:format("~n"),
    Grille = gen_grid(),
    jouer(Grille, manque).

search_idx(_, 0, _) ->
	1;

search_idx(_, Id, find) ->
	Id;

search_idx(Col, Id, manque) -> 
	case element(Id, Col) of
		0 ->
			search_idx(Col, Id-1, manque);
		_ ->
			search_idx(Col, Id+1, find)
	end.

jouer(Grille, manque) -> 
	io:format("~n"),
	{ok, [Joueur, Id]} = io:read("Entrez [joueur, col]. >"),
	%on recupere la colonne courante
	Colonne = element(Id, Grille),
	%on recupere la ligne
	Idx = search_idx(Colonne, 6, manque),
	%on modifie la colonne choisie
	Colonne_mod=setelement(Idx, Colonne, Joueur),
	%on modifie la grille courante
	Grille_mod=setelement(Id, Grille, Colonne_mod),
	io:format("Nouvelle Grille ~p~n",[Grille_mod]),
	{Nb_j1, Nb_j2} = getNbCasesVerticale(Grille_mod, 7, {0, 0}),
	io:format("Nb de pion verticale j1 : ~p~n",[Nb_j1]),
	io:format("Nb de pion verticale j2 : ~p~n",[Nb_j2]),
	jouer(Grille_mod, manque).

%A CHANGER
getNbCasesVerticale_by_col(_, 7, {Nb_j1, Nb_j2}) ->
	{Nb_j1, Nb_j2};

%A CHANGER
getNbCasesVerticale_by_col(Col, Id, {Nb_j1, Nb_j2}) ->
	case element(Id, Col) of
		o ->
			getNbCasesVerticale_by_col(Col, Id+1, {Nb_j1+1, 0});
		x -> 
			getNbCasesVerticale_by_col(Col, Id+1, {0, Nb_j2+1});
		_->
			getNbCasesVerticale_by_col(Col, Id+1, {Nb_j1, Nb_j2})
	end.

%A CHANGER
getNbCasesVerticale(_, 0, {Nb_j1, Nb_j2}) ->
	{Nb_j1, Nb_j2};

%A CHANGER
getNbCasesVerticale(Grille, Id, {Nb_j1, Nb_j2}) ->
	{Nb1, Nb2} = getNbCasesVerticale_by_col(element(Id, Grille), 1, {Nb_j1, Nb_j2}),
	getNbCasesVerticale(Grille, Id-1, {Nb1, Nb2}).