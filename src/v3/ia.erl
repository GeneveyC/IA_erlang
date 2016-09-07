-module(ia).

-export([foreach_init/1,foreach/5,getValues_by_line/2,return/1]).
-export([jouer_pc_init/1,jouer_pc/4]).
-export([algo_min/7,algo_max/7]).
-export([evaluation/2, evaluer/1, eval/4]).

-export([joueur_suivant/1]).

getValues_by_line(_, 0) ->
	false;

getValues_by_line(Col, Id_ligne) -> 
	case element(Id_ligne, Col) of
		0 ->
			true;
		_->
			getValues_by_line(Col, Id_ligne-1)
	end.

%Ok, nickel
foreach_init(Grille) ->
	foreach(Grille, 7, 6, [], manque).

foreach(_, 0, 6, L1, _) ->
	L1;	

%Ok, Nickel
%Fonction qui renvoit la liste des coups a jouer
foreach(Grille, Id_Colonne, Id_ligne, L1, Etat) ->
	case Etat of
		{victoire, _} ->
			[];
		manque ->
			Col = element(Id_Colonne, Grille),
			case getValues_by_line(Col, Id_ligne) of
				true ->
					Coup={Id_Colonne},
					L2 = [Coup|L1];
				false ->
					L2 = L1
			end,
			foreach(Grille, Id_Colonne-1, 6, L2, Etat)
	end.

%Fonction qui retourne une Grille
return(Grille) ->
	Grille.

jouer_pc_init(Grille) ->

	%On recupere la liste des coups a jouer
	L1=foreach_init(Grille),
	
	%On recupere la meilleur (Coup)colonne a jouer
	Coup = jouer_pc(Grille, L1, {0}, -1000),
	
	Joueur = x,

	%On recupere l'id de la colonne(du meilleur coup)
	Id_Col = element(1, Coup),
	Colonne = element(Id_Col, Grille),

	%On recherche la ligne a changer
	Idx = puissance4:search_idx(Colonne, 6, manque),

	%On modifie la ligne dans la colonne
	Colonne_mod=setelement(Idx, Colonne, Joueur),

	%On modifier la colone de la grille
	Grille_mod = setelement(Id_Col, Grille, Colonne_mod),
	io:format("Nouvelle Grille ~p~n",[Grille_mod]),

	%On fait jouer l'humain
	puissance4:jouer(Grille_mod, puissance4:verifier(Grille_mod, Id_Col, Idx)).

%Retourne le meilleur coup a jouer
jouer_pc(_, [], Coup, _) ->
	Coup;

%Ok, Nickel
jouer_pc(Grille, L, Coup, Max_val) ->
	
	[L1|LR] = L,
	Joueur = x,

	%On recupere l'indice de la colonne de la liste des coups
	Id_Col = element(1, L1),
	
	%On recupere la colonne
	Colonne = element(Id_Col, Grille),

	%On recupere l'indice de la ligne
	Idx = puissance4:search_idx(Colonne, 6, manque),

	%On modifie la colonne
	Colonne_mod=setelement(Idx, Colonne, Joueur),

	%On modifie la grille (simulatation du coup)
	Grille_mod=setelement(Id_Col, Grille, Colonne_mod),

	%recherche des nouveaux coup a jouer
	L2 = foreach_init(Grille_mod),

	%On recupere l'etat du jeux
	Etat = puissance4:verifier(Grille_mod, Id_Col, Idx),

	Val = algo_min(Grille_mod, joueur_suivant(Joueur), L2, 6, 1000, -1000, Etat),
	io:format("[Val] : ~p~n",[Val]),

	if Val > Max_val ->
		Max_val2 = Val,
		Meilleur_coup = {Id_Col};
	true ->
		Max_val2 = Max_val,
		Meilleur_coup = Coup
	end,

	jouer_pc(Grille, LR, Meilleur_coup, Max_val2).


algo_min(Grille, Joueur, _, _, _, _, {victoire, _}) ->
	evaluation(Grille, Joueur);

algo_min(_, _, [], _, Min_val, _, manque) ->
	Min_val;

algo_min(Grille, Joueur, [], _, _, _, {victoire, _}) ->
	evaluation(Grille, Joueur);

algo_min(Grille, Joueur, _, 0, _, _, _) ->
	evaluation(Grille, Joueur);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                               %
%               Fonction algo_min(Grille, L, N, Min, MAx, {victoire,Joueur}):                   %                        %
%               la fonction de l'algo min :														%
%					param :																		%
%						Grille -> la grille de jeux												%
%						Joueur : Joueur courant
%						L : liste des coups a jouer 											%
%						N : Profondeur du jeux													%
%						Min: Valeur mininmale													%
%						Max: Valeur maximale
%						Etat: Etat du jeux actuel													%
%					return :																	%
%						retourne la plus petit valeur de ces fils                               %
%                                                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
algo_min(Grille, Joueur, L, N, Min_val, Max_val, Etat) -> 
	case Etat of 
		{victoire, _} ->
				evaluation(Grille, Joueur);
		manque ->
			[L1|LR] = L,
			Joueur = o,
			
			%Ligne = element(2, L1),
			Id_Col = element(1, L1),

			%On recupere la colonne
			Colonne = element(Id_Col, Grille),

			%On recupere l'indice de la ligne
			Idx = puissance4:search_idx(Colonne, 6, manque),

			%On modifie la colonne
			Colonne_mod=setelement(Idx, Colonne, Joueur),

			%On modifie la grille (simulatation du coup)
			Grille_mod=setelement(Id_Col, Grille, Colonne_mod),

			%recherche des nouveaux coup a jouer
			L2 = foreach_init(Grille_mod),

			%On recupere l'etat du jeux
			Etat2 = puissance4:verifier(Grille_mod, Id_Col, Idx),

			Val = algo_max(Grille_mod, joueur_suivant(Joueur), L2, N-1, Min_val, Max_val, Etat2),

			if Val < Min_val ->
				algo_min(Grille, Joueur, LR, N, Val, Max_val, Etat);
			true ->
				algo_min(Grille, Joueur, LR, N, Min_val, Max_val, Etat)
			end
	end.

algo_max(Grille, Joueur, _, _, _, _, {victoire, _}) ->
	evaluation(Grille, Joueur);

algo_max(_, _, [], _, _, Max_val, manque) ->
	Max_val;

algo_max(Grille, Joueur, [], _, _, _, {victoire, _}) ->
	evaluation(Grille, Joueur);

algo_max(Grille, Joueur, _, 0, _, _, _) ->
	evaluation(Grille, Joueur);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                               %
%               Fonction algo_max(Grille, L, N, Min, MAx, {victoire,Joueur}):                   %                        %
%               la fonction de l'algo min :														%
%					param :																		%
%						Grille -> la grille de jeux												%
%						Joueur : Joueur courant
%						L : liste des coups a jouer 											%
%						N : Profondeur du jeux													%
%						Min: Valeur mininmale													%
%						Max: Valeur maximale													%	
%						Etat: Etat du jeux courant												%
%					return :																	%
%						retourne la plus grande valeur de ces fils                              %
%                                                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
algo_max(Grille, Joueur, L, N, Min_val, Max_val, Etat) ->
	case Etat of
		{victoire, _} ->
			evaluation(Grille, Joueur);
		manque ->
			[L1|LR] = L,

			Joueur = x,
			Id_Col = element(1, L1),
			
			%On recupere la colonne
			Colonne = element(Id_Col, Grille),

			%On recupere l'indice de la ligne
			Idx = puissance4:search_idx(Colonne, 6, manque),

			%On modifie la colonne
			Colonne_mod=setelement(Idx, Colonne, Joueur),

			%On modifie la grille (simulatation du coup)
			Grille_mod=setelement(Id_Col, Grille, Colonne_mod),

			%recherche des nouveaux coup a jouer
			L2 = foreach_init(Grille_mod),

			%On recupere l'etat du jeux
			Etat2 = puissance4:verifier(Grille_mod, Id_Col, Idx),

			Val = algo_min(Grille_mod, joueur_suivant(Joueur), L2, N-1, Min_val, Max_val, Etat2),

			if Val > Max_val ->
				algo_max(Grille, Joueur, LR, N, Min_val, Val, Etat);				
			true ->
				algo_max(Grille, Joueur, LR, N, Min_val, Max_val, Etat)
			end
	end.

eval(_, 8, _, Res) ->
	Res;

eval(Grille, Id_Col, Id_ligne, {Res_j1, Res_j2}) ->
	case Id_ligne of
		7 ->
			eval(Grille, Id_Col+1, 1, {Res_j1, Res_j2});
		_ ->
			{Nb_j1, Nb_j2} = puissance4:verifier_total(Grille, Id_Col, Id_ligne),
			eval(Grille, Id_Col, Id_ligne+1, {Res_j1+Nb_j1, Res_j2+Nb_j2})
	end.

evaluation(Grille, Joueur) ->
	{O, X} = evaluer(Grille),
	case Joueur of
		o ->
			return(O-X);
		x ->
			return(X-O)
	end.

evaluer(Grille) ->
	{Nb_o, Nb_x} = eval(Grille, 1, 1, {0, 0}),
	return({Nb_o, Nb_x}).

joueur_suivant(Joueur) ->
	case Joueur of
		o ->
			x;
		x ->
			o
	end.