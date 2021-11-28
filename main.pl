/* Kelompok Farming Tubes */
/* 13520127 - Adzka Ahmadetya Zaidan */
/* 13520129 - Nathanael Santoso */
/* 13520152 - Muhammad Fahmi Irfan */
/* 13520161 - M Syahrul Surya Putra */

:- include('./activity/fish.pl').
:- include('./activity/house.pl').
:- include('./activity/move.pl').
:- include('./activity/ranching.pl').
:- include('./game/inventory.pl').
:- include('./game/items.pl').
:- include('./game/map.pl').
:- include('./game/player.pl').
:- include('./game/quest.pl').
:- include('./game/time.pl').
:- include('./util/message.pl').

:- dynamic(game_on/1).
:- dynamic(game_start/1).

game_on(false).
game_start(false).

startGame :-
	retract(game_on(false)), !,
	asserta(game_on(true)),
	msg_title, nl,
	msg_help, !.

startGame :-
	msg_already_on(MSG), write(MSG), nl.

start :-
	game_on(true),
	retract(game_start(false)),
	asserta(game_start(true)),
	player_init, asserta(map_object(1, 1, 'P')),
	map_generate,
	!.

start :-
	game_start(true),
	msg_already_start(MSG), write(MSG), nl.

start :-
	game_start(false),
	write('Game belum menyala. Silahkan ketik \'startGame\' untuk menyalakan game.'), nl.

help :- msg_help.

exitGame :- halt(0).