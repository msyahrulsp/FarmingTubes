/* Kelompok Farming Tubes */
/* 13520127 - Adzka Ahmadetya Zaidan */
/* 13520129 - Nathanael Santoso */
/* 13520152 - Muhammad Fahmi Irfan */
/* 13520161 - M Syahrul Surya Putra */

:- dynamic(game_on/1).
:- dynamic(game_start/1).

game_on(false).
game_start(false).

startGame :-
	retract(game_on(false)), !,
	asserta(game_on(true)),
	['./activity/fish.pl'],
	['./activity/house.pl'],
	['./activity/move.pl'],
	['./activity/ranching.pl'],
	['./game/inventory.pl'],
	['./game/items.pl'],
	['./game/map.pl'],
	['./game/player.pl'],
	['./game/time.pl'],
	['./util/message.pl'],
	msg_title,
	msg_help.

startGame :-
	msg_already_on(MSG), write(MSG), nl.

start :-
	game_on(true),
	retract(game_start(false)),
	asserta(game_start(true)),
	write('Welcome to Prolog Valley. Choose your job'), nl,
	write('1. Fisherman'), nl,
	write('2. Farmer'), nl,
	write('3. Rancher'), nl,
	% Add: Harus kasih if biar ga error
	read(X),
	jobSelect(X, Y),
	% End Add
	retract(job('-')),
	assertz(job(Y)),
	write('You chose '), write(Y), write(', let\'s start farming!'),
	retractall(menu(_)),
	assertz(menu(1)),
	!.

start :-
	game_start(true),
	msg_already_start(MSG), write(MSG), nl.

start :-
	game_start(false),
	write('Game belum menyala. Silahkan ketik \'startGame\' untuk menyalakan game.'), nl.

help :- msg_help.

exitGame :- halt(0).