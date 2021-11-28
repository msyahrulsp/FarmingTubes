:- dynamic(diary/2).

diary_read_function :-
	diary(X, _),
	write('Day '), write(X), nl,
	fail.

house :-
	repeat,
	write('smth: '), nl,
	write(''), nl,
	write(''), nl,
	write(''), nl,
	write('input exit to get out of this menu'), nl,
	read(X),
	(
    	atom_codes(sleep, X)
	->
		write('have slept'), nl,
		nextDay,
		!, true
	;
    	atom_codes(writeDiary, X)
	->
		read(Y),
		day(Z),
		assertz(diary(Z, Y)),
		!, true
	;
    	atom_codes(readDiary, X)
	->
		\+ (diary_read_function),
		read(Y),
		day(Z),
		diary(Z, W),
		write(W),
		!, true
	;
    	atom_codes(exit, X)
	->
		!, true
	;
		write('wrong input u dumdum'), nl
	).