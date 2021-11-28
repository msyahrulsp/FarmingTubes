:- dynamic(time/1).
:- dynamic(day/1).

/* Dipanggil untuk menambah Day */
nextDay :-
	day(X),
	Z is X+1,
	retract(day(_)),
	asserta(day(Z)),
	retract(hour(_)),
	asserta(hour(0)).
	
addHour(NUM) :-
	NUM < 24,
	retract(hour(X)),
	Y is X + NUM,
	assertz(hour(Y)).

addHour(NUM) :-
	NUM >= 24,
	nextDay.