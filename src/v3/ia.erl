-module(ia).

-export([gen_grid/0, jouer/0]).
-export([jouer/2]).

gen_grid() ->
	{{0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0}}.

jouer() ->
	io:format("~n"),
    io:format("*************************************************************~n"),
    io:format("* Puissance4 par Christophe                                 *~n"),
    io:format("* Pour jouer, il faut taper la commande [joueur,col]. 	   *~n"),
    io:format("* Par ex: [x,1]. -> place 'x' en colonne 1			       *~n"),
    io:format("* [o,3]. -> place 'o' en colonne 3...            		   *~n"),
    io:format("*************************************************************~n"),
    io:format("~n").

jouer(Grille, manque).