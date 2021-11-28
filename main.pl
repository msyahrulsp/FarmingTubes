/* Kelompok Farming Tubes */
/* 13520127 - Adzka Ahmadetya Zaidan */
/* 13520129 - Nathanael Santoso */
/* 13520152 - Muhammad Fahmi Irfan */
/* 13520161 - M Syahrul Surya Putra */

:- dynamic(day/1).
:- dynamic(hour/1).
:- dynamic(job/1).
:- dynamic(menu/1).
:- dynamic(diary/2).
:- dynamic(item/2).
:- dynamic(exp/2).
:- dynamic(incExp/1).

incExp(100).

diary(0, 'text 1').
diary(1, 'text 2').
diary(3, 'text 3').

menu(0).

day(1).
hour(0).

/* Job Selection */
jobSelect(0, base).
jobSelect(1, fisherman).
jobSelect(2, farmer).
jobSelect(3, rancher).

/* Status Player */

job(base).
exp(0, base).
exp(0, fisherman).
exp(0, farmer).
exp(0, rancher).
% level(1). -> Ini diubah jadi fungsi aja
% levelRanching(1). ^
% levelFarming(1).  ^
% levelFishing(1).  ^ 
gold(0).

/* Funtion add exp:
   Alur Umum:
   - Jika job sama dengan nomor job masukan -> Increment Exp * 2
   - Jika job \== Masukan -> Increment Exp biasa */
addExp(Job_number) :-
    job(X), jobSelect(Job_number, Job),
    (
        X == Job
    ->
        exp(Exp, Job), incExp(Get),
        % Add: Formula same job sementara
        Inc is Get + Get
    ;
        exp(Exp, Job), incExp(Inc)
    ), !,
    Added is Exp + Inc,
    retractall(exp(_, Job)),
    assertz(exp(Added, Job)),
    write('Your '), write(Job), write(' experience has increased by '), write(Inc), write('.'), nl.

/* Function get level of job:
   Alur umum:
   - Jika job sama dengan nomor job masukan dan job masukan bukan nol -> tampilkan level job
   - Jika nol -> Tampilkan level semua */
getLevel(Job_number, Level) :-
    jobSelect(Job_number, Job),
    (
        Job == base
    ->
        findall(X, exp(X, _), List),
        sumlist(List, Exp)
    ;
        exp(Exp, Job)
    ),
    % Add: Level Formula, berikut yang sementara
    Level is Exp // 300 + 1.

/* List Item, jumlah yang ada dalam inventory player */

item(1, 'Carrot Seed').
item(0, 'Corn Seed').
item(3, 'Tomato Seed').
item(2, 'Potato Seed').

/* Prosedur dan rule */

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

/* Prosedur Command 'start' untuk memulai game */
start :-
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

% Add: Harus di Rewrite ini, deprecated
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

exitGame :- halt(0).