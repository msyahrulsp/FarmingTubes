:- dynamic(time/1).
:- dynamic(day/1).
:- dynamic(season/1).
:- dynamic(weather/1).

seasons(0, spring).
seasons(1, summer).
seasons(2, autumn).
seasons(3, winter).

weathers(0, clear).
weathers(1, sunny).
weathers(2, cloudy).
weathers(3, precipitation).
weathers(4, storm).

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
	retractall(time(_)), assertz(time(Rem)).

addDay(NUM) :-
	day(X), Z is X + NUM,
	retract(day(_)), assertz(day(Z)),
	% changeWeather,
	checkSeason.

/* Fungsi untuk mengganti weather */
% changeWeather :-
% 	weather(X),
% 	(
% 		X == 0
% 	->

% 	)

/* Fungsi untuk mengganti season */
checkSeason :-
	day(X), season(S),
	(
		X > 365 -> endGame;
		X > 274, S \== 3 -> retractall(season(_)), assertz(season(3));
		X > 183, S \== 2 -> retractall(season(_)), assertz(season(2));
		X > 92, S \== 1 -> retractall(season(_)), assertz(season(1))
	).
