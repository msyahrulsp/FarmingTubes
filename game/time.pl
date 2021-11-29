:- dynamic(time/1).
:- dynamic(day/1).
:- dynamic(season/1).
:- dynamic(weather/1).

seasons(0, 'Spring').
seasons(1, 'Summer').
seasons(2, 'Autumn').
seasons(3, 'Winter').

weathers(0, clear).
weathers(1, sunny).
weathers(2, cloudy).
weathers(3, rainy).
weathers(4, stormy).

time(12).
day(1).
season(0).
weather(0).

/* Fungsi untuk menambah day saat tidur */
nextDay :-
	addDay(1),
	retract(time(_)), assertz(time(6)).

/* Fungsi untuk menambah day/time sejumlah NUM */
addTime(NUM) :-
	time(Time), Y is Time + NUM, Days is Y // 24, Rem is Y mod 24,
	(Days > 0 -> addDay(Days); true),
	retractall(time(_)), assertz(time(Rem)), !.

addDay(NUM) :-
	day(X), Z is X + NUM,
	writeDiaryDayEnd,
	retract(day(_)), assertz(day(Z)),
	changeWeather,
	writeDiaryDayStart,
	\+(cropAddTime),
	checkSeason, !.

/* Fungsi untuk mengganti weather */
changeWeather :-
	weather(X), random(1, 100, Rdm),
	(
		Rdm < 51, X == 0
	->
		Parity is Rdm mod 2,
		Z is 2 - Parity,
		retractall(weather(_)), assertz(weather(Z))
	;
		Rdm < 51, X == 2
	->
		retractall(weather(_)), assertz(weather(3))
	;
		Rdm < 51, X == 3
	->
		retractall(weather(_)), assertz(weather(4))
	;
		Rdm > 50
	->
		retractall(weather(_)), assertz(weather(0))
	;
		true
	).

/* Fungsi untuk mengganti season */
checkSeason :-
	day(X), season(S), seasons(S, Season),
	(
		X > 365 -> !, endGame;
		X > 274, S \== 3 -> retractall(season(_)), assertz(season(3)), seasons(3, NSeason), seasonalBonus,
		nl, write(Season), write(' has come and gone. Now it is '), write(NSeason), write('.'), nl, nl;
		X > 183, S \== 2 -> retractall(season(_)), assertz(season(2)), seasons(2, NSeason), seasonalBonus,
		nl, write(Season), write(' has come and gone. Now it is '), write(NSeason), write('.'), nl, nl;
		X > 92, S \== 1 -> retractall(season(_)), assertz(season(1)), seasons(1, NSeason), seasonalBonus,
		nl, write(Season), write(' has come and gone. Now it is '), write(NSeason), write('.'), nl, nl;
		true
	), !.

seasonalBonus :-
	true.

cropAddTime :-
	crop(X, Y, S, T), NewT is T - 1,
	retract(crop(X, Y, S, T)),
	(
		T == 1
	->
		retract(map_object(X, Y, S)),
		plantable(_, S, _, C),
		assertz(map_object(X, Y, C))
	;
		assertz(crop(X, Y, S, NewT))
	),
	fail.

endGame :-
	retractall(game_start(_)), retractall(game_on(_)),
	assertz(game_start(false)), assertz(game_on(false)),
	nl, write('As the day goes by you notice the first buds of Spring, and also a peculiar knocking on your fence.'), nl,
	write('As you peer through your window, you realize that the Loan Sharks have come to claim your land.'), nl, nl,
	write('You lost the game, try again next time'), nl, !, fail.