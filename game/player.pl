:- dynamic(exp/2).
:- dynamic(job/1).

/* Job Selection */
jobSelect(0, base).
jobSelect(1, fisherman).
jobSelect(2, farmer).
jobSelect(3, rancher).

/* Experience */
exp(0, base).
exp(0, fisherman).
exp(0, farmer).
exp(0, rancher).

/* Function initialize player:
   Alur Umum:
   - Tampilkan pilihan -> Memilih -> Pilihan 1-3 -> job
   -                              -> Pilihan lain -> repeat */
player_init :-
	nl, write('Welcome to Harvest Star. Choose your job:'), nl,
	write('1. Fisherman'), nl,
	write('2. Farmer'), nl,
	write('3. Rancher'), nl, nl,
	pickJob.

pickJob :-
    repeat,
    write('Choose your job. (Numbers 1 - 3)'), nl,
    read(X),
    (
        jobSelect(X, Job), Job \== base
    ->
        assertz(job(Job)),
        nl, write('You chose the '), toCaps(Job, Jobc), write(Jobc), write(', let\'s start harvesting!'), nl, !
    ;
        nl, write('You chose the wrong job number (1 - 3)'), nl, fail
    ).

/* Funtion status:
   Alur Umum:
   - Game Start -> print status
   - Game not start -> msg not start */
status :-
    (game_start(false) -> nl, msg_not_start(MSG), write(MSG), nl, !, fail; true),
	nl, write('Your status:'), nl,
    write('============================================='), nl,
	job(A), write('Job                : '), toCaps(A, Ac), write(Ac), nl,
	gold(K), write('Gold               : '), write(K), nl,
	getLevel(0, B, I), write('Level              : '), write(B), nl,
	write('Total Exp          : '), write(I), write(' / 600'), nl,
	getLevel(1, C, D), write('Level Farming      : '), write(C), nl,
	write('Exp Farming        : '), write(D), write(' / 600'), nl,
	getLevel(2, E, F), write('Level Fishing      : '), write(E), nl,
	write('Exp Fishing        : '), write(F), write(' / 600'), nl,
	getLevel(3, G, H), write('Level Ranching     : '), write(G), nl,
	write('Exp Ranching       : '), write(H), write(' / 600'), nl,
    write('============================================='), nl, !.

/* Funtion add exp:
   Alur Umum:
   - Jika job sama dengan nomor job masukan -> Increment Exp * 2
   - Jika job \== Masukan -> Increment Exp biasa */
addJobExp(Job_number) :-
    job(X), jobSelect(Job_number, Job),
    (
        X == Job
    ->
        Inc is 200
    ;
        Inc is 100
    ), !,
    exp(Exp, Job),
    Added is Exp + Inc,
    retractall(exp(_, Job)),
    assertz(exp(Added, Job)),
    write('Your '), write(Job), write(' experience has increased by '), write(Inc), write('.'), nl, fishing_level_up.

/* Function get level of job:
   Alur umum:
   - Jika job sama dengan nomor job masukan dan job masukan bukan nol -> tampilkan level job
   - Jika nol -> Tampilkan level semua */
getLevel(Job_number, Level, Remainder) :-
    jobSelect(Job_number, Job),
    (
        Job == base
    ->
        findall(X, exp(X, _), List),
        sum_list(List, Exp)
    ;
        exp(Exp, Job)
    ),
    Level is Exp // 600 + 1,
    Remainder is Exp mod 600.