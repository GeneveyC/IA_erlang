-module(puissance4).

-export([gen_grid/0, jouer/0]).
-export([return/1]).
-export([search_idx/3]).
-export([jouer/2]).

-export([getNbCasesVerticale_by_col/3,getNbCasesVerticale/4]).
-export([getNbCasesHorizontale_by_col/3,getNbCasesHorizontale/4]).

-export([getNbCasesDiagonale_by_col/3]).
-export([getNbCasesDiagonale1/4,getNbCasesDiagonale1_desc/4,getNbCasesDiagonale1_mont/4]).
-export([getNbCasesDiagonale2/4,getNbCasesDiagonale2_desc/4,getNbCasesDiagonale2_mont/4]).

-export([verifier/3]).
-export([blacksabbath/0, killingyourselftolive/0]).

gen_grid() ->
	{{0,0,0,0,0,0},
	{0,0,0,0,0,0},
	{0,0,0,0,0,0},
	{0,0,0,0,0,0},
	{0,0,0,0,0,0},
	{0,0,0,0,0,0},
	{0,0,0,0,0,0}}.

return({J1, J2}) ->
	{J1, J2}.

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

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                               %
%               Fonction jouer(_,{victoire,Joueur}):                                            %
%               lorsque celle-ci reçoit le tuple {victoire,Joueur}, et ce qq soit               %
%               le premier parametre, cela veut dire qu'un joueur a fait une combinaisons       % 
%               gagnante                                                                        %
%                                                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
jouer(_,{victoire,Joueur}) ->
    io:format("~n"),
    io:format("********************************~n"),
    io:format("Joueur ~p a remporte la partie !~n",[Joueur]),
    io:format("That's all folk !~n"),
    io:format("********************************~n"),
    io:format("~n"),
    killingyourselftolive();


jouer(Grille, manque) -> 
	io:format("~n"),
	{ok, [Joueur, Id]} = io:read("Entrez [joueur, col]. >"),
	%on recupere la colonne courante
	Colonne = element(Id, Grille),
	%on recupere la ligne
	Idx = search_idx(Colonne, 6, manque),
	io:format("Idx : ~p~n",[Idx]),
	%on modifie la colonne choisie
	Colonne_mod=setelement(Idx, Colonne, Joueur),
	%on modifie la grille courante
	Grille_mod=setelement(Id, Grille, Colonne_mod),
	io:format("Nouvelle Grille ~p~n",[Grille_mod]),
	%verifier(Grille_mod, Id, Idx),
	jouer(Grille_mod, verifier(Grille_mod, Id, Idx)).

%Ok, nickel
getNbCasesVerticale_by_col(_, 7, {Nb_j1, Nb_j2}) ->
	{Nb_j1, Nb_j2};

%Ok, nickel
%Peut etre ameliorer en disant que si on a une case 0 fin car c'est une pile,
%donc eleve des appel recursive
getNbCasesVerticale_by_col(Col, Id_ligne, {Nb_j1, Nb_j2}) ->
	case element(Id_ligne, Col) of
		o ->
			getNbCasesVerticale_by_col(Col, Id_ligne+1, {Nb_j1+1, 0});
		x -> 
			getNbCasesVerticale_by_col(Col, Id_ligne+1, {0, Nb_j2+1});
		_->
			{Nb_j1, Nb_j2}
	end.

%Ok, nickel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                               %
%               Fonction getNbCasesVerticale(Grille, Id, {Nb_j1, Nb_j2}):                       %
%               c'est la fonction qui retourne le nombre de point aligner en verticale 			%
%				de j1 et j2. 																	%
%				'Grille' est le parametres contenant la grille,									%
%				'Id_Col' est l'indice de la colonne      											%
%               {Nb_j1, Nb_j2} et le nombre de point de j1 et j2 aligné en verticale 			%
%                                                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getNbCasesVerticale(Grille, Id_Col, Id_ligne, {Nb_j1, Nb_j2}) ->
	getNbCasesVerticale_by_col(element(Id_Col, Grille), Id_ligne, {Nb_j1, Nb_j2}).

%Ok, Nickel
getNbCasesHorizontale_by_col(Col, Id_ligne, {Nb_j1, Nb_j2}) ->
	case element(Id_ligne, Col) of
		o ->
			{Nb_j1+1, 0};
		x ->
			{0, Nb_j2+1};
		_ -> 
			false
	end.

%Ok, Nickel
getNbCasesHorizontale(_, 7, _, {Nb_j1, Nb_j2}) ->
	{Nb_j1, Nb_j2};

%Ok, Nickel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                               %
%               Fonction getNbCasesHorizontale(Grille, Id_Col, Id_ligne, {Nb_j1, Nb_j2}):       %
%               c'est la fonction qui retourne le nombre de point aligner en horizontale 		%
%				de j1 et j2. 																	%
%				'Grille' est le parametres contenant la grille,									%
%				'Id_Col' est le nombre de colonne(qui s'incremente)								%
%				'Id_ligne' est l'indice de la ligne ou on a mis notre piont      				%
%               {Nb_j1, Nb_j2} et le nombre de point de j1 et j2 aligné en horizontale 			%
%                                                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getNbCasesHorizontale(Grille, Id_Col, Id_ligne, {Nb_j1, Nb_j2}) -> 
	Col = element(Id_Col, Grille),
	case getNbCasesHorizontale_by_col(Col, Id_ligne, {Nb_j1, Nb_j2}) of
		{Nbj1, Nbj2} ->			
			getNbCasesHorizontale(Grille, Id_Col+1, Id_ligne, {Nbj1, Nbj2});
		false ->
			{Nb_j1, Nb_j2}
	end.

%ok, Nickel
getNbCasesDiagonale_by_col(Col, Id_ligne, {Nb_j1, Nb_j2}) ->
	case element(Id_ligne, Col) of
		o ->
			{Nb_j1+1, 0};
		x ->
			{0, Nb_j2+1};
		_ ->
			false
	end.

%Ok, Nickel
getNbCasesDiagonale1_desc(_, _, 0, {Nb_j1, Nb_j2}) ->
	{Nb_j1, Nb_j2};

%Ok, Nickel
getNbCasesDiagonale1_desc(_, 0, _, {Nb_j1, Nb_j2}) ->
	{Nb_j1, Nb_j2};

%Ok, Nickel
getNbCasesDiagonale1_desc(Grille, Id_Col, Id_ligne, {Nb_j1, Nb_j2}) ->
	Col=element(Id_Col, Grille),
	case getNbCasesDiagonale_by_col(Col, Id_ligne, {Nb_j1, Nb_j2}) of
		{Nbj1, Nbj2} ->
			getNbCasesDiagonale1_desc(Grille, Id_Col-1, Id_ligne-1, {Nbj1, Nbj2});
		false ->
			{Nb_j1, Nb_j2}
	end.

%Ok, Nickel
getNbCasesDiagonale1_mont(_, _, 6, {Nb_j1, Nb_j2}) ->
	{Nb_j1, Nb_j2};

%Ok, Nickel
getNbCasesDiagonale1_mont(_, 7, _, {Nb_j1, Nb_j2}) ->
	{Nb_j1, Nb_j2};

%Ok, Nickel
getNbCasesDiagonale1_mont(Grille, Id_Col, Id_ligne, {Nb_j1, Nb_j2}) ->
	Col=element(Id_Col, Grille),
	case getNbCasesDiagonale_by_col(Col, Id_ligne, {Nb_j1, Nb_j2}) of
		{Nbj1, Nbj2} ->
			getNbCasesDiagonale1_mont(Grille, Id_Col+1, Id_ligne+1, {Nbj1, Nbj2});
		false ->
			{Nb_j1, Nb_j2}
	end.

%Ok, Nickel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                               %
%               Fonction getNbCasesDiagonale1(Grille, Id_Col, Id_ligne, {Nb_j1, Nb_j2}):       	%
%               c'est la fonction qui retourne le nombre de point aligner en diagonale(montante)%
%				de j1 et j2. 																	%
%				'Grille' est le parametres contenant la grille,									%
%				'Id_Col' est l'indice de colonne ou on a mis notre piont(qui s'incremente)		%
%				'Id_ligne' est l'indice de la ligne ou on a mis notre piont      				%
%               {Nb_j1, Nb_j2} et le nombre de point de j1 et j2 aligné en diagonale(montante)	%
%                                                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getNbCasesDiagonale1(Grille, Id_Col, Id_ligne, {Nb_j1, Nb_j2}) ->
	Col = element(Id_Col, Grille),
	{Nbj1, Nbj2}=getNbCasesDiagonale_by_col(Col, Id_ligne, {Nb_j1, Nb_j2}),
	%appel fonction desc
	{Nbj11, Nbj22}=getNbCasesDiagonale1_desc(Grille, Id_Col-1, Id_ligne-1, {Nbj1, Nbj2}),
	%appel fonction mont
	{Nb_j1f, Nb_j2f}=getNbCasesDiagonale1_mont(Grille, Id_Col+1, Id_ligne+1, {Nbj11, Nbj22}),
	return({Nb_j1f, Nb_j2f}).

getNbCasesDiagonale2_desc(_, _, 0, {Nb_j1, Nb_j2}) ->
	{Nb_j1, Nb_j2};

getNbCasesDiagonale2_desc(_, 7, _, {Nb_j1, Nb_j2}) ->
	{Nb_j1, Nb_j2};

getNbCasesDiagonale2_desc(Grille, Id_Col, Id_ligne, {Nb_j1, Nb_j2}) ->
	Col=element(Id_Col, Grille),
	case getNbCasesDiagonale_by_col(Col, Id_ligne, {Nb_j1, Nb_j2}) of
		{Nbj1, Nbj2} ->
			getNbCasesDiagonale2_desc(Grille, Id_Col+1, Id_ligne-1, {Nbj1, Nbj2});
		false ->
			{Nb_j1, Nb_j2}
	end.

getNbCasesDiagonale2_mont(_, _, 6, {Nb_j1, Nb_j2}) ->
	{Nb_j1, Nb_j2};

getNbCasesDiagonale2_mont(_, 0, _, {Nb_j1, Nb_j2}) ->
	{Nb_j1, Nb_j2};

getNbCasesDiagonale2_mont(Grille, Id_Col, Id_ligne, {Nb_j1, Nb_j2}) ->
	Col=element(Id_Col, Grille),
	case getNbCasesDiagonale_by_col(Col, Id_ligne, {Nb_j1, Nb_j2}) of
		{Nbj1, Nbj2} ->
			getNbCasesDiagonale2_mont(Grille, Id_Col-1, Id_ligne+1, {Nbj1, Nbj2});
		false ->
			{Nb_j1, Nb_j2}
	end.

getNbCasesDiagonale2(Grille, Id_Col, Id_ligne, {Nb_j1, Nb_j2}) ->
	Col = element(Id_Col, Grille),
	{Nbj1, Nbj2}=getNbCasesDiagonale_by_col(Col, Id_ligne, {Nb_j1, Nb_j2}),
	%appel fonction mont
	{Nbj11, Nbj22}=getNbCasesDiagonale2_mont(Grille, Id_Col-1, Id_ligne+1, {Nbj1, Nbj2}),
	%appel fonction desc
	{Nb_j1f, Nb_j2f}=getNbCasesDiagonale2_desc(Grille, Id_Col+1, Id_ligne-1, {Nbj11, Nbj22}),
	return({Nb_j1f, Nb_j2f}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                               %
%               Fonction Verifier(Grille, Id_Col, Id_ligne):       								%	
%               c'est la fonction qui retourne l'etait du jeux actuelle							% 																	%
%				'Grille' est le parametres contenant la grille,									%
%				'Id_Col' est l'indice de colonne ou on a mis notre piont(qui s'incremente)		%
%				'Id_ligne' est l'indice de la ligne ou on a mis notre piont      				%
%                En cas de fin de partie :														%
%					{victoire, Joueur} : retourne un tuple victoire puis le joueur				%
%                Sinon :																		%
%					manque                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
verifier(Grille, Id_Col, Id_ligne) ->
	{N1, N2} = getNbCasesVerticale(Grille, Id_Col, 1, {0, 0}),
	%io:format("Nb de pion verticale j1 : ~p~n",[N1]),
	%io:format("Nb de pion verticale j2 : ~p~n",[N2]),
	{N3, N4} = getNbCasesHorizontale(Grille, 1, Id_ligne, {0,0}),
	%io:format("Nb de pion horizontale j1 : ~p~n",[N3]),
	%io:format("Nb de pion horizontale j2 : ~p~n",[N4]),
	{N5, N6} = getNbCasesDiagonale1(Grille, Id_Col, Id_ligne, {0,0}),
	%io:format("Nb de pion diagonale1 j1 : ~p~n",[N5]),
	%io:format("Nb de pion diagonale1 j2 : ~p~n",[N6]),
	{N7, N8} = getNbCasesDiagonale2(Grille, Id_Col, Id_ligne, {0,0}),
	%io:format("Nb de pion diagonale2 j1 : ~p~n",[N7]),
	%io:format("Nb de pion diagonale2 j2 : ~p~n",[N8]),

	if
		N1>=4 -> {victoire, o};
		N2>=4 -> {victoire, x};
		N3>=4 -> {victoire, o};
		N4>=4 -> {victoire, x};
		N5>=4 -> {victoire, o};
		N6>=4 -> {victoire, x};
		N7>=4 -> {victoire, o};
		N8>=4 -> {victoire, x};
		true -> manque
	end.

killingyourselftolive() ->
    Pid = spawn (?MODULE, blacksabbath, []),
    Pid ! {self(),killingyourselftolive},
    receive
        {Pid, Msg} ->
            io:format("~w~n",[Msg])
    end,
    Pid ! stop.
     
blacksabbath() ->
    receive
        {From, Msg} ->
            From ! {self(),Msg},
            blacksabbath();
        stop ->
            true
    end.