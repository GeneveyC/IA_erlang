-module(ia).

-export([foreach3/4]).
-export([jouer_pc/5]).
-export([jouer_pc_init/1]).
-export([algo_min/5, algo_max/5]).
-export([eval/1,nb_series/2, nb_pions/3]).
-export([nb_series_diag_mont/2,nb_series_diag_desc/2]).
-export([nb_series_ligne_horiz/6,nb_series_ligne_vert/6]).
-export([verifier/1]).
-export([return/1]).

foreach3(_, 0, _, L1) ->
	L1;	

%Fonction qui renvoit la liste des coups a jouer
foreach3(Grille, I, J, L1) ->
	case verifier(Grille) of
		{victoire, _} ->
			[];
		manque ->
			if J == 0 ->
				foreach3(Grille, I-1, 3, L1);
			true ->
				Id = (I-1)*3+J,
				if element(Id, Grille) == 0 ->
		            Coup = {0, I, J},
		            %Append list
		            L2 = [Coup|L1], 
		            foreach3(Grille, I, J-1, L2);
				true ->
					foreach3(Grille, I, J-1, L1)			
				end
			end
	end.

%Fonction qui retourne une Grille
return(Grille) ->
	Grille.

%Fonction de lancement de l'IA
jouer_pc_init(Grille) ->
	L1=foreach3(Grille, 3, 3, []),
	Coup = jouer_pc(Grille, L1, {0,0,0}, -1000, 1000),
	Joueur = x,
	Ligne = element(2, Coup),
	Colonne = element(3, Coup),

	NouvelleGrille = setelement((Ligne - 1) * 3 + Colonne, Grille, Joueur),
	%retourne la nouvelle grille
	return(NouvelleGrille).

%Retourne le meilleur coup a jouer
jouer_pc(_, [], Coup, _, _) ->
	Coup;

jouer_pc(Grille, L, Coup, Alpha, Beta) ->
	[L1|LR] = L,

	LVIDE = [],
	Joueur = x,
	Ligne = element(2, L1),
	Colonne = element(3, L1),
	
	% simuler le coup actuel
	NouvelleGrille = setelement((Ligne - 1) * 3 + Colonne, Grille, Joueur),

	%recherche des nouveaux coup a jouer
	L2 = foreach3(NouvelleGrille, 3, 3, LVIDE),
	Val = algo_min(NouvelleGrille, L2, 9, Alpha, Beta),

	if Alpha < Val ->
		Alpha2 = Val,
		Meilleur_coup = {Joueur, Ligne, Colonne};
	true ->
		Alpha2 = Alpha,
		Meilleur_coup = Coup
	end,

	jouer_pc(Grille, LR, Meilleur_coup, Alpha2, Beta).

algo_min(Grille, [], _,  _, Beta) ->
	case verifier(Grille) of
		{victoire, _} ->
			eval(Grille);
		manque ->
			Beta
	end;

algo_min(Grille, _, 0, _, _) ->
	eval(Grille);

algo_min(Grille, L, N, Alpha, Beta) -> 
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
			L2 = foreach3(NouvelleGrille, 3, 3, LVIDE),

			Val = algo_max(NouvelleGrille, L2, N-1, Alpha, Beta),

			if 
				Beta > Val ->
					algo_min(Grille, LR, N, Alpha, Val);
				Beta =< Alpha
					-> Beta;
				true ->
					algo_min(Grille, LR, N, Alpha, Beta)
			end
	end.

%Si tout les coups sont joué
algo_max(Grille, [], _, Alpha, _) ->
	case verifier(Grille) of
		{victoire, _} ->
			eval(Grille);
		manque ->
			Alpha
	end;

algo_max(Grille, _, 0, _, _) ->
	eval(Grille);

algo_max(Grille, L, N, Alpha, Beta) ->
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
			L2 = foreach3(NouvelleGrille, 3, 3, LVIDE),

			Val = algo_min(NouvelleGrille, L2, N-1, Alpha, Beta),

			if 
				Alpha < Val ->
					algo_max(Grille, LR, N, Val, Beta);				
				Beta =< Alpha ->
					Alpha;
				true ->
					algo_max(Grille, LR, N, Alpha, Beta)
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
