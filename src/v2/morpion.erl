%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Jeux de Morpion par Pascal06                                            %
%                       Intelligence artificille par Christophe Genevey                         %
%                       ecrit pour Erlang OTP17                                                 %
%                       15/04/2014                                                              %
%                                                                                               %
% REMARQUE : ce programme ne propose aucun affichage graphique ou une quelconque mise en forme  %
% les joueurs sont obligé de jouer à tour de rôle sur la même machine. A l'avenir il serait bien%
% de proposer une version multiposte avec l'utilsations de "processus"                          %
% de plus, il n'y a aucune verification de mauvaise saisie, ni de vérification de coup déjà placé,%
% c'est à dire qu'un joueur peut écraser le coup de l'autre joueur                              %
%                                                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                               %
%                       Definition des fonctions a exporter                                     %
%                                                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
-module(morpion).
 
-export([jouer/2]).
-export([jouer/0]).

-export([verifier/1]).
-export([blacksabbath/0, killingyourselftolive/0]).
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                       %
%       Fonction jouer(): sans parametres, elle permet de lancer le jeux                %
%                                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
jouer() ->
    io:format("~n"),
    io:format("*************************************************************~n"),
    io:format("* Morpion par Pascal06                                      *~n"),
    io:format("* Pour jouer, il faut taper la commande [joueur,col,lign].  *~n"),
    io:format("* Par ex: [x,1,2]. -> place 'x' en colonne 1, ligne 2       *~n"),
    io:format("* [o,3,1]. -> place 'o' en colonne 3, ligne 1...            *~n"),
    io:format("*************************************************************~n"),
    io:format("~n"),
    jouer({0,0,0,0,0,0,0,0,0},manque).
    % On lance ici la routine principale avec une grille mise à 0. 
    % La grille est modélisée par un tuple de la maniere suivante:
    % {L1C1,L1C2,L1C3,L2C1,L2C2,L2C3,L3C1,L3C2,L3C3}
    % avec L1C1 = Ligne 1, Colonne 1
    % L'atome "manque" indique a celle-ci qu'il n'y a pour l'instant aucune combinaison gagnante
 
 
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
 
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                               %
%               Fonction jouer(Grille,manque):                                                  %
%               c'est la routine principale du programme. 'Grille' est le parametres            %
%               contenant la grille, 'manque' est un atome indiquant qu'aucune combinaison      %
%               gagnante n'est realisee pour le moment                                          %
%                                                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
jouer(Grille,manque) ->
     
    io:format("~n"),
    % saut de ligne
         
    {ok,[Joueur,Colonne,Ligne]}=io:read("Entrez [joueur,col,lign]. >"),
    % fonction standard de lecture. Elle retourne un tuple, avec l'atome 'ok' en premier,
    % suivie de la commande validée par l'utilisateur. Dans notre cas c'est la liste
    % [joueur,col,lign]. 
     
    io:format("Joueur ~p a joue en position Colonne=~p, Ligne=~p~n",[Joueur,Colonne,Ligne]),
    % on affiche le coup joué
     
    NouvelleGrille = setelement((Ligne - 1) * 3 + Colonne, Grille, Joueur),
    % Explication de la fonction setelement:
    % setelement(Index, Tuple1, Valeur) -> Tuple2
    %
    % Retourne le 'Tuple2' qui est la copie de l'argument 'Tuple1', dans lequel l'élément désigné par l'argument 'Index' est remplacé par la valeur de
    % l'argument 'Valeur'
    % ex:
    % > setelement(3, {10, chats, noirs}, blancs).
    % {10,chats,blancs}
    %
    % Dans notre cas, on calcule l'index avec la formule (Ligne - 1) * 3 + Colonne
     
    %io:format("Nouvelle Grille ~p~n",[NouvelleGrille]),
    % On affiche la nouvelle grille

    NouvelleGrille2 = test:jouer_pc_init(NouvelleGrille),

    io:format("Nouvelle Grille ~p~n",[NouvelleGrille2]),

    %jouer(setelement((Ligne - 1) * 3 + Colonne, NouvelleGrille, Joueur),verifier(NouvelleGrille)).
    jouer(NouvelleGrille2, verifier(NouvelleGrille2)).
    % Ici, on appelle donc récursivement la fonction jouer avec comme 1er argument la nouvelle grille.
    % Le deuxième argument est donné par la fonction verifier(Grille).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                               %
%               Fonction verifier(Grille):                  %
%               celle-ci va comparer l'argument Grille avec chacune des     %
%               combinaisons possibles, et retourne un tuple {victoire, joueur} %
%               dans le cas d'une combinaison gagnante, ou l'atome 'manque' dans le%
%               cas contraire                           %
%                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


verifier(Grille) ->
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