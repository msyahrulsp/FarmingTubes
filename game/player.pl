:- dynamic(exp/2).
:- dynamic(job/1).

status :-
	write('Your status:'), nl,
    write('============================================='), nl,
	job(A), write('Job: '), write(A), nl,
	getLevel(0, B, I), write('Level: '), write(B), nl,
	getLevel(1, C, D), write('Level Farming: '), write(C), nl,
	write('Exp Farming: '), write(D), write(' / 300'), nl,
	getLevel(2, E, F), write('Level Fishing: '), write(E), nl,
	write('Exp Fishing: '), write(F), write(' / 300'), nl,
	getLevel(3, G, H), write('Level Ranching: '), write(G), nl,
	write('Exp Ranching: '), write(H), write(' / 300'), nl,
	write('Total Exp: '), write(I), write(' / 300'), nl,
	gold(K), write('Gold: '), write(K),
    write('============================================='), nl.

/* Job Selection */
jobSelect(0, 'Base').
jobSelect(1, 'Fisherman').
jobSelect(2, 'Farmer').
jobSelect(3, 'Rancher').

job('Base').
exp(0, 'Base').
exp(0, 'Fisherman').
exp(0, 'Farmer').
exp(0, 'Rancher').

player_init :-
	write('Welcome to Prolog Valley. Choose your job'), nl,
	write('1. Fisherman'), nl,
	write('2. Farmer'), nl,
	write('3. Rancher'), nl,
	% Add: Harus kasih if biar ga error
	read(X),
	jobSelect(X, Y),
	% End Add
	retractall(job(_)),
	asserta(job(Y)),
	write('You chose '), write(Y), write(', let\'s start farming!').

/* Funtion add exp:
   Alur Umum:
   - Jika job sama dengan nomor job masukan -> Increment Exp * 2
   - Jika job \== Masukan -> Increment Exp biasa */
addExp(Job_number) :-
    job(X), jobSelect(Job_number, Job),
    (
        X == Job
    ->
        % Add: Formula same job sementara
        Inc is 200
    ;
        Inc is 100
    ), !,
    exp(Exp, Job),
    Added is Exp + Inc,
    retractall(exp(_, Job)),
    assertz(exp(Added, Job)),
    write('Your '), write(Job), write(' experience has increased by '), write(Inc), write('.'), nl.

/* Function get level of job:
   Alur umum:
   - Jika job sama dengan nomor job masukan dan job masukan bukan nol -> tampilkan level job
   - Jika nol -> Tampilkan level semua */
getLevel(Job_number, Level, Remainder) :-
    jobSelect(Job_number, Job),
    (
        Job == 'Base'
    ->
        findall(X, exp(X, _), List),
        sumlist(List, Exp)
    ;
        exp(Exp, Job)
    ),
    % Add: Level Formula, berikut yang sementara
    Level is Exp // 600 + 1,
    Remainder is Exp mod 600.