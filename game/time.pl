:- dynamic(time/1).
:- dynamic(day/1).

day(1).
time(12).

/* Fungsi untuk menambah day saat tidur */
nextDay :-
	day(X), Z is X + 1,
	retract(day(_)), assertz(day(Z)),
	retract(time(_)), assertz(time(6)).

/* Fungsi untuk menambah day/time sejumlah NUM */
addDay(NUM) :-
	day(X), Z is X + NUM,
	retract(day(_)), assertz(day(Z)).

addTime(NUM) :-
	time(Time), Y is Time + NUM, Days is Y // 24, Rem is Y mod 24,
	(Days > 0 -> addDay(Days); true),
	retractall(time(_)), assertz(time(Rem)).
