/* Kelompok Farming Tubes */
/* 13520127 - Adzka Ahmadetya Zaidan */
/* 13520129 - Nathanael Santoso */
/* 13520152 - Muhammad Fahmi Irfan */
/* 13520161 - M Syahrul Surya Putra */

:- include('./util/message.pl').
:- dynamic(game_on/1).
:- dynamic(game_start/1).

game_on(false).
game_start(false).

startGame :-
	(
		game_on(false)
	->
		% initialisasi ulang modul, sama dengan consult ulang tapi lebih gampang, jadi tinggal exitGame -> startGame
		['main.pl'],
		['./activity/fish.pl'],
		['./activity/house.pl'],
		['./activity/move.pl'],
		['./activity/ranching.pl'],
		['./game/inventory.pl'],
		['./game/items.pl'],
		['./game/map.pl'],
		['./game/player.pl'],
		['./game/quest.pl'],
		['./game/time.pl'],
		retractall(game_on(_)),
		asserta(game_on(true)),
		nl, msg_title, nl,
		msg_help
	;
		nl, msg_on(MSG), write(MSG), nl
	), !.


start :-
	game_on(On), game_start(Start),
	(
		Start == true
	->
		nl, msg_start(MSG), write(MSG), nl
	;
		On == false
	->
		nl, msg_not_on(MSG), write(MSG), nl
	;
		retract(game_start(false)),
		assertz(game_start(true)),
		player_init, asserta(map_object(1, 1, 'P')),
		map_generate
	), !.

help :- msg_help, !.

exitGame :-
	(
		game_on(true)
	->
		nl, write('Do you want to turn off the game? (input exit to continue)'), nl,
		read(X), atom_chars(X, Chars),
		(
			atom_chars(exit, Chars)
		->
			retractall(game_on(_)),
			retractall(game_start(_)),
			assertz(game_on(false)),
			assertz(game_start(false)),
			nl, write('You have exited the game.')
		;
			nl, write('You did not exit the game.')
		)
	;
		nl, msg_not_on(MSG), write(MSG)
	), nl, !.

quit :-
	(
		game_start(true)
	->
		nl, write('Do you want to quit the game? (input quit to continue)'), nl,
		read(X), atom_chars(X, Chars),
		(
			atom_chars(quit, Chars)
		->
			retractall(game_start(_)),
			assertz(game_start(false)),
			nl, write('You have quit the game.')
		;
			nl, write('You did not quit the game.')
		)
	;
		nl, msg_not_start(MSG), write(MSG)
	), nl, !.