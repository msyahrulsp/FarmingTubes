:- dynamic(exp/2).
:- dynamic(incExp/1).
:- dynamic(job/1).

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

/* Job Selection */
jobSelect(0, base).
jobSelect(1, fisherman).
jobSelect(2, farmer).
jobSelect(3, rancher).

job(base).
exp(0, base).
exp(0, fisherman).
exp(0, farmer).
exp(0, rancher).

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