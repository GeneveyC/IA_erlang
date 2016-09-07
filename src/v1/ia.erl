-module(ia).

-export([foreach/4]).
-export([jouer_pc/4]).
-export([jouer_pc_init/1]).
-export([algo_min/5, algo_max/5]).
-export([eval/1,nb_series/2, nb_pions/3]).
-export([nb_series_diag_mont/2,nb_series_diag_desc/2]).
-export([nb_series_ligne_horiz/6,nb_series_ligne_vert/6]).
-export([verifier/1]).
-export([return/1]).

%Fonction qui renvoit la liste des coups a jouer
foreach(_, 0, _, L1) ->
	L1;	

foreach(Grille, I, J, L1) ->
	case verifier(Grille) of
		{victoire, _} ->
			[];
		manque ->
			if J == 0 ->
				foreach(Grille, I-1, 3, L1);
			true ->
				Id = (I-1)*3+J,
				if element(Id, Grille) == 0 ->
		            Coup = {0, I, J},
		            L2 = [Coup|L1], 
		            foreach(Grille, I, J-1, L2);
				true ->
					foreach(Grille, I, J-1, L1)			
				end
			end
	end.

%Fonction qui retourne une Grille
return(Grille) ->
	Grille.

%Fonction de lancement de l'IA
jouer_pc_init(Grille) ->
	L1=foreach(Grille, 3, 3, []),
	Coup = jouer_pc(Grille, L1, {0,0,0}, -1000),
	Joueur = x,
	Ligne = element(2, Coup),
	Colonne = element(3, Coup),

	NouvelleGrille = setelement((Ligne - 1) * 3 + Colonne, Grille, Joueur),
	%retourne la nouvelle grille
	return(NouvelleGrille).

%Retourne le meilleur coup a jouer
jouer_pc(_, [], Coup, _) ->
	Coup;

jouer_pc(Grille, L, Coup, Max_val) ->
	[L1|LR] = L,

	LVIDE = [],
	Joueur = x,
	Ligne = element(2, L1),
	Colonne = element(3, L1),
	
	% simuler le coup actuel
	NouvelleGrille = setelement((Ligne - 1) * 3 + Colonne, Grille, Joueur),

	%recherche des nouveaux coup a jouer
	L2 = foreach(NouvelleGrille, 3, 3, LVIDE),
	Val = algo_min(NouvelleGrille, L2, 9, 1000, -1000),

	if Val > Max_val ->
		Max_val2 = Val,
		Meilleur_coup = {Joueur, Ligne, Colonne};
	true ->
		Max_val2 = Max_val,
		Meilleur_coup = Coup
	end,

	jouer_pc(Grille, LR, Meilleur_coup, Max_val2).

algo_min(Grille, [], _, Min_val, _) ->
	case verifier(Grille) of
		{victoire, _} ->
			eval(Grille);
		manque ->
			Min_val
	end;

algo_min(Grille, _, 0, _, _) ->
	eval(Grille);

algo_min(Grille, L, N, Min_val, Max_val) -> 
	case verifier(Grille) of 
		{victoire, _} ->
				eval(Grille);
		manque ->
			[L1|LR] = L,

			LVIDE = [],
			Joueur = o,
			Ligne = element(2, L1),
			Colonne = element(3, L1),
		
			%simuler le coup
			NouvelleGrille = setelement((Ligne - 1) * 3 + Colonne, Grille, Joueur),
			L2 = foreach(NouvelleGrille, 3, 3, LVIDE),

			Val = algo_max(NouvelleGrille, L2, N-1, Min_val, Max_val),

			if Val < Min_val ->
				algo_min(Grille, LR, N, Val, Max_val);
			true ->
				algo_min(Grille, LR, N, Min_val, Max_val)
			end
	end.

%Si tout les coups sont joué
algo_max(Grille, [], _, _, Max_val) ->
	case verifier(Grille) of
		{victoire, _} ->
			eval(Grille);
		manque ->
			Max_val
	end;

algo_max(Grille, _, 0, _, _) ->
	eval(Grille);

algo_max(Grille, L, N, Min_val, Max_val) ->
	case verifier(Grille) of
		{victoire, _} ->
			eval(Grille);
		manque ->
			[L1|LR] = L,

			LVIDE = [],
			Joueur = x,
			Ligne = element(2, L1),
			Colonne = element(3, L1),
			
			%simuler le coup
			NouvelleGrille = setelement((Ligne - 1) * 3 + Colonne, Grille, Joueur),
			L2 = foreach(NouvelleGrille, 3, 3, LVIDE),

			Val = algo_min(NouvelleGrille, L2, N-1, Min_val, Max_val),

			if Val > Max_val ->
				algo_max(Grille, LR, N, Min_val, Val);				
			true ->
				algo_max(Grille, LR, N, Min_val, Max_val)
			end
	end.

nb_pions(_, 0, Nb) ->
	Nb;

%Ok
nb_pions(Grille, Id, Nb) ->
	case element(Id, Grille) of
		0 ->
			nb_pions(Grille, Id-1, Nb);
		_ ->
			nb_pions(Grille, Id-1, Nb+1)
	end.

%Ok
eval(Grille) ->
	case verifier(Grille) of
		{victoire, x} ->
			2000 - nb_pions(Grille, 9, 0);
		{victoire, o} ->
			-2000 + nb_pions(Grille, 9, 0);
		{victoire, _} ->
			0;
		manque ->
			nb_series(Grille, x) - nb_series(Grille, o)
	end.

%Decoupage du nb de series
nb_series(Grille, Joueur) ->
	nb_series_diag_mont(Grille, Joueur) +
		nb_series_diag_desc(Grille, Joueur) + 
			nb_series_ligne_horiz(Grille, Joueur, 3, 3, 0, 0) + 
				nb_series_ligne_vert(Grille, Joueur, 3, 3, 0, 0).

nb_series_diag_mont(Grille, J) ->
	case Grille of
		{_, _, J,
         _, J, _,
         J, _, _} -> 2;

		{_, _, _,
         _, J, _,
         J, _, _} -> 1;

        {_, _, J,
         _, J, _,
         _, _, _} -> 1;

        {_, _, _,
         _, _, _,
         _, _, _} -> 0;

         true -> 0
	end.

nb_series_diag_desc(Grille, J) ->
	case Grille of
		{J, _, _,
         _, J, _,
         _, _, J} -> 2;

		{J, _, _,
         _, J, _,
         _, _, _} -> 1;

         {_, _, _,
         _, J, _,
         _, _, J} -> 1;

         {_, _, _,
         _, _, _,
         _, _, _} -> 0;

         true -> 0
    end.

%Ok, marche NICKEL !!!!
nb_series_ligne_horiz(_, _, 0, _, Count, Nb) ->
	if Count == 2 ->
		Nb+1;
	true ->
		Nb
	end;

%Ok, marche NICKEL !!!!!!
nb_series_ligne_horiz(Grille, Joueur, I, J, Count, Nb) ->
	if Count == 2 ->
		Nb2 = Nb+1;
	true ->
		Nb2 = Nb
	end,

	if J == 0 ->
		nb_series_ligne_horiz(Grille, Joueur, I-1, 3, 0, Nb2);
	true ->
		Id = (I-1)*3+J,
		if element(Id, Grille) == Joueur ->
     		nb_series_ligne_horiz(Grille, Joueur, I, J-1, Count+1, Nb2);
		true ->
			nb_series_ligne_horiz(Grille, Joueur, I, J-1, 0, Nb2)
		end
	end.

%Ok, marche NICKEL !!!!
nb_series_ligne_vert(_, _, _, 0, Count, Nb) ->
	if Count == 2 ->
		Nb+1;
	true ->
		Nb
	end;

%Ok, marche NICKEL !!!!!
nb_series_ligne_vert(Grille, Joueur, I, J, Count, Nb) ->
	if Count == 2 ->
		Nb2 = Nb+1;
	true ->
		Nb2 = Nb
	end,

	if I == 0 ->
		nb_series_ligne_vert(Grille, Joueur, 3, J-1, 0, Nb2);
	true ->
		Id = (3*I)-(3-J),
		if element(Id, Grille) == Joueur ->
     		nb_series_ligne_vert(Grille, Joueur, I-1, J, Count+1, Nb2);
		true ->
			nb_series_ligne_vert(Grille, Joueur, I-1, J, 0, Nb2)
		end
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                               												%
%               Fonction verifier(Grille):                  									%
%               celle-ci va comparer l'argument Grille avec chacune des     					%
%               combinaisons possibles, et retourne un tuple {victoire, joueur} 				%
%               dans le cas d'une combinaison gagnante, ou l'atome 'manque' dans le 			%
%               cas contraire                           										%
%                                               												%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verifier(Grille) ->
 	case nb_pions(Grille, 9, 0) of
 		9 ->
 			{victoire, 0};
 		_ ->
 	case Grille of
	    {x, x, x,
	     _, _, _,
	     _, _, _} -> {victoire, x};
	 
	    {_, _, _,
	     x, x, x,
	     _, _, _} -> {victoire, x};
	 
	    {_, _, _,
	     _, _, _,
	     x, x, x} -> {victoire, x};
	 
	    {x, _, _,
	     x, _, _,
	     x, _, _} -> {victoire, x};
	 
	    {_, x, _,
	     _, x, _,
	     _, x, _} -> {victoire, x};
	 
	    {_, _, x,
	     _, _, x,
	     _, _, x} -> {victoire, x};
	 
	    {x, _, _,
	     _, x, _,
	     _, _, x} -> {victoire, x};
	 
	    {_, _, x,
	     _, x, _,
	     x, _, _} -> {victoire, x};
	 
	    {o, o, o,
	     _, _, _,
	     _, _, _} -> {victoire, o};
	 
	    {_, _, _,
	     o, o, o,
	     _, _, _} -> {victoire, o};
	 
	    {_, _, _,
	     _, _, _,
	     o, o, o} -> {victoire, o};
	 
	    {o, _, _,
	     o, _, _,
	     o, _, _} -> {victoire, o};
	 
	    {_, o, _,
	     _, o, _,
	     _, o, _} -> {victoire, o};
	 
	    {_, _, o,
	   	 _, _, o,
	     _, _, o} -> {victoire, o};
	 
	   	{o, _, _,
	    _, o, _,
	    _, _, o} -> {victoire, o};
	 
	   {_, _, o,
	    _, o, _,
	    o, _, _} -> {victoire, o};
	 
	        {A, B, Colonne,
	         D, E, F,
	         G, H, I} when A =/= undefined, B =/= undefined, Colonne =/= undefined,
	                       D =/= undefined, E =/= undefined, F =/= undefined,
	                       G =/= undefined, H =/= undefined, I =/= undefined ->
	            manque;
	 
	        _ -> ok
		end
	end.
