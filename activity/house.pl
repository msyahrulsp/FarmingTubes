:- dynamic(diary/3).

/* Diary Entry Default */
diary(1, 11, 'I am an hour away from the ranch. This is the start of my journey.').
diary(1, 12, 'I arrived at the ranch.').

house :-
    (game_start(false) -> nl, msg_not_start(MSG), write(MSG), nl, !, fail; true),
	(
		onTile(house)
	->
		nl, write('You have entered your house.'), nl, nl,
		write('1. sleep'), nl,
		write('2. read diary'), nl,
		write('3. write diary'), nl,
		repeat,
		nl, write('What will you do? (To exit enter "0" or "exit")'), nl,
		read(X),
		(
            (X is 0; \+(integer(X)), toLower(X, In), atom_chars(In, Code), atom_chars(exit, Code))
        ->
            nl, write('You have exited your house.'), nl, !
		;
			X == 1
		->
			nl, write('You slept soundly for the rest of the day and woke up early in the morning.'),
			writeDiaryEvent(8),
			nextDay, 
			nl, fairy, !
		;
			X == 2
		->
			nl, write('Here are your diary entries: '), nl,
			listEntryDays(1, 5, 5),
			readDiary, !
		;
			X == 3
		->
			nl, write('You flip to the last entry of your diary and begin writing.'), nl,
			writeDiary, !
		;
			nl, write('Wrong input number. (Enter numbers 1 - 3)'), nl, fail
		)
	;
        nl, write('You are not at your house.'), nl, !, fail
	).

/* Function List Entry Days */
listEntryDays(Count, Range, Inc) :-
	(Count == 1 -> nl, write('Page 1:'), nl; true),
	(
		diary(Count, Time, _), \+ (diary(Count, Ptime, _), Ptime > Time),
		write('Day '), write(Count), nl
	;
		true
	),
	Ncount is Count + 1,
	(
		\+ (diary(Day, _, _), Day > Count)
	->
		write('End of diary'), nl
	;
		Ncount =< Range
	->
		listEntryDays(Ncount, Range, Inc)
	;
		nl, write('To go to the next page, input "next". Otherwise, enter anything.'), nl,
		read(X),
		(
            X == next
        ->
			Nrange is Range + Inc,
			Page is Nrange // Inc,
			nl, write('Page '), write(Page), write(':'), nl,
            listEntryDays(Ncount, Nrange, Inc)
		;
			true
		)
	), !.

readDiary :-
	repeat, 
	nl, write('Which day do you want to read about? (To exit enter "0" or "exit")'), nl,
	read(X),
	(
		(X == 0; \+(integer(X)), toLower(X, In), atom_chars(In, Code), atom_chars(exit, Code))
	->
		nl, write('You closed your diary.'), nl, !
	;
		diary(X, _, _)
	->
		nl, write('You opened your diary to day '), write(X), write(' and started reading.'), nl,
		\+(listEntry(X)), fail
	;
		nl, write('There are no entries on day '), write(X), write('.'), nl, fail
	).

listEntry(X) :-
	diary(X, Y, Z),
	write(Y), write(' o\'clock: '), write(Z), nl, fail.

writeDiary :-
	day(X), time(Y),
	repeat,
	nl, write('Please enter it in \'string\' form. (Surround text with "\'")'), nl, 
	read(Input),
	(
		atom(Input)
	->
		assertz(diary(X, Y, Input)), !
	;
		fail
	).

writeDiaryEvent(Event) :-
	day(X), time(Y),
	(
		Event == 0
	->
		String = 'I finished a quest.'
	;
		Event == 1
	->
		String = 'I dug some farm land.'
	;
		Event == 2
	->
		String = 'I planted some crops.'
	;
		Event == 3
	->
		String = 'I harvested some crops.'
	;
		Event == 4
	->
		String = 'I went to the market and bought some things.'
	;
		Event == 5
	->
		String = 'I went to the market and sold some things.'
	;
		Event == 6
	->
		String = 'I collected some animal produce.'
	;
		Event == 7
	->
		String = 'I went fishing.'
	;
		Event == 8
	->
		String = 'I slept the rest of the day.'
	;
		Event == 9
	->
		String = 'A fairy came and teleported me to my destination.'
	),
	(
		diary(X, Y, Prev)
	->
		atom_concat(' After that, ', String, StringA),
		atom_concat(Prev, StringA, EndString)
	;
		EndString = String
	),
	retractall(diary(X, Y, _)),
	assertz(diary(X, Y, EndString)).

writeDiaryDayEnd :-
	day(X),
	String = 'That\'s all I did today. I hope I can do well too tomorrow.',
	(
		diary(X, 23, Prev)
	->
		atom_concat(Prev, ' ', Prevs),
		atom_concat(Prevs, String, EndString)
	;
		EndString = String
	),
	retractall(diary(X, 23, _)),
	assertz(diary(X, 23, EndString)).

writeDiaryDayStart :-
	day(X), time(T), weather(W), weathers(W, Y),
	(
		T >= 6
	->
		S1 = 'Today I woke up and the weather was ',
		S2 = '. I got ready to go outside.'
	;
		S1 = 'Today I worked through the night and when I noticed, the weather was ',
		S2 = '. I got done with my work quickly and left.'
	),
	atom_concat(S1, Y, SY),
	atom_concat(SY, S2, EndString),
	retractall(diary(X, T, _)),
	assertz(diary(X, T, EndString)).
