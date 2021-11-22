:- dynamic(day/1).
:- dynamic(hour/1).
:- dynamic(job/1).

day(1).
hour(0).

/* Job Selection */
jobSelect(1, 'Fisherman').
jobSelect(2, 'Farmer').
jobSelect(3, 'Rancher').

/* Status Player */

job('-').
level(1).
levelFarming(1).
expFarming(0).
levelFishing(1).
expFishing(0).
levelRanching(1).
expRanching(0).
experience(0, 300).
gold(0).

/* List Item, jumlah yang ada dalam inventory player */

item(carrot_seed, 0).
item(corn_seed, 0).
item(tomato_seed, 0).
item(potato_seed, 0).

/* Prosedur dan rule */

/* Dipanggil untuk menambah Day */
nextDay :-
	day(X),
	Z is X+1,
	asserta(day(Z)),
	retract(day(X)),
	retract(hour(Y)),
	asserta(hour(0)).
	
addHour(NUM) :-
	retract(hour(X)),
	Y = X+NUM,
	assertz(hour(Y)).

/* Prosedur Command 'start' untuk memulai game */
start :-
	write('Welcome to Prolog Valley. Choose your job'), nl,
	write('1. Fisherman'), nl,
	write('2. Farmer'), nl,
	write('3. Rancher'), nl,
	read(X),
	jobSelect(X, Y),
	retract(job('-')),
	assertz(job(Y)),
	write('You chose '), write(Y), write(', let\'s start farming!'),
	!.
start :- start.

status :-
	write('Your status:'), nl,
	job(A), write('Job: '), write(A), nl,
	level(B), write('Level: '), write(B), nl,
	levelFarming(C), write('Level Farming: '), write(C), nl,
	expFarming(D), write('Exp Farming: '), write(D), nl,
	levelFishing(E), write('Level Fishing: '), write(E), nl,
	expFishing(F), write('Exp Fishing: '), write(F), nl,
	levelRanching(G), write('Level Ranching: '), write(G), nl,
	expRanching(H), write('Exp Ranching: '), write(H), nl,
	experience(I, J), write('Exp: '), write(I), write('/'), write(J), nl,
	gold(K), write('Gold: '), write(K).