/* Kelompok Farming Tubes */
/* 13520127 - Adzka Ahmadetya Zaidan */
/* 13520129 - Nathanael Santoso */
/* 13520152 - Muhammad Fahmi Irfan */
/* 13520161 - M Syahrul Surya Putra */

:- include('./util/message.pl').
:- dynamic(game_on/1).
:- dynamic(game_start/1).
:- initialization(startGame).

game_on(false).
game_start(false).

/* Function start game:
   Alur Umum:
   - game tidak on -> reload semua modul -> game on -> message init
   - game on -> message on */
startGame :-
	(
		game_on(false)
	->
		% initialisasi ulang modul, sama dengan consult ulang tapi lebih gampang, jadi tinggal exit -> startGame
		['./activity/farming.pl'],
		['./activity/fish.pl'],
		['./activity/house.pl'],
		['./activity/move.pl'],
		['./activity/ranching.pl'],
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

/* Function start :
   Alur Umum:
   - game start -> message sudah start
   - game tidak on -> message tidak on
   - game tidak start -> tidak ada job -> initialize pertama -> game start
   - game tidak start -> ada job -> game start (continued) */
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
		\+ (job(_))
	->
		startPrompt,
		retract(game_start(false)),
		assertz(game_start(true)),
		player_init,
		map_generate
	;
		retract(game_start(false)),
		assertz(game_start(true)),
		nl, write('Continued from previous game state.'), nl
	), !.

/* Function help:
   Alur Umum:
   - game start -> help ingame
   - game not start -> help menu */
help :- msg_help, !.

/* Function exit game:
   Alur Umum:
   - game on -> input exit/0 -> game terexit, harus reload modul (untuk reset game, atau reset modul)
   - game on -> not exit/0 -> message game tidak exit
   - game tidak on -> message game tidak on */
exit :-
	(
		game_on(true)
	->
		nl, write('Do you want to turn off the game? (input "exit" or "0" to exit)'), nl,
		read(X),
		(
            (X is 0; toLower(X, In), atom_chars(In, Code), atom_chars(exit, Code))
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

/* Function quit game:
   Alur Umum:
   - game start -> input quit/0 -> game terquit
   - game start -> not quit/0 -> message game tidak quit
   - game tidak start -> message game tidak start */
quit :-
	(
		game_start(true)
	->
		nl, write('Do you want to quit the game? (input "quit" or "0" to quit)'), nl,
		read(X),
		(
            (X is 0; toLower(X, In), atom_chars(In, Code), atom_chars(quit, Code))
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
