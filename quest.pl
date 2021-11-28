:- dynamic(item/2).
:- dynamic(quests/6).
:- dynamic(q_ongoing/1).
:- dynamic(q_done/1).
:- dynamic(exp/2).
:- dynamic(gold/1).
:- dynamic(quest/2).

gold(0).

jobSelect(0, base).
jobSelect(1, fisherman).
jobSelect(2, farmer).
jobSelect(3, rancher).

job(base).
exp(0, base).
exp(0, fisherman).
exp(0, farmer).
exp(0, rancher).

q_done(0).
player(1, 1).
quest(1, 1).

item(2, 'corn').
item(1, 'nila').
item(1, 'egg').

/* List of Quests in order dalam format quest(nama_item, jumlah, nama_item, jumlah, nama_item, jumlah) */
quests('corn', 2, 'nila', 1, 'egg', 1).
quests('corn', 2, 'nila', 2, 'egg', 2).


/* Function to get quest:
   - Jika dipanggil di tile quest -> masuk getQuest
   - Jika tidak dipanggil di tile quest -> menjabarkan current quest
   */
quest :-
    (isQuest -> getQuest; displayQuest), !.

/* Funtion to get new Quest
   Alur Umum:
   - Sudah Menerima Quest -> Belum mendapatkan item -> Pesan belum selesai
   - Sudah Menerima Quest -> Sudah mendapatkan item -> Reward
   - Belum menerima quest -> Menerima Quest Baru */
getQuest :-
    (
        \+(q_ongoing(_))
    ->
        write('You have recieved a quest!'), nl, nl,
        q_done(X), Y is X + 1, assertz(q_ongoing(Y)),
        displayQuest, !
    ;
        questComplete, !
    ).

questComplete :-
    quests(Farm, NumFarm, Fish, NumFish, Produce, NumProduce),
    item(X, Farm), item(Y, Fish), item(Z, Produce),
    A is X - NumFarm, B is Y - NumFish, C is Z - NumProduce,
    (
        X >= NumFarm, Y >= NumFish, Z >= NumProduce
    ->
        % ubah jadi tidak sedang quest dan q_done + 1
        q_done(Q), Qd is Q + 1,
        retractall(q_ongoing(_)), retractall(q_done(_)), assertz(q_done(Qd)),
        % hapus quest dari questlist
        retractall(quests(Farm, NumFarm, Fish, NumFish, Produce, NumProduce)),
        % Decrease items from inventory
        retractall(item(_, Farm)), retractall(item(_, Fish)), retractall(item(_, Produce)),
        assertz(item(A, Farm)), assertz(item(B, Fish)), assertz(item(C, Produce)),
        % Add Exp to base
        jobSelect(0, Job), exp(Exp, Job), Inc is 100 * Qd, Exp_new is Inc + X,
        retractall(exp(_, Y)), assertz(exp(Exp_new, Y)),
        % Add money
        gold(Gold), Get is 1000 * Qd, New_Gold is Get + Gold,
        retractall(gold(_)), assertz(gold(New_Gold)),
        % Success message
        write('You have given the required items to questgiver.'), nl, nl,
        write('Your base experience has risen by '), write(Inc), write('.'), nl,
        write('You recieved '), write(Get), write(' gold.'), nl
    ;
        % Fail message
        write('You tried to submit your items, but...'), nl, nl,
        write('You still require: '), nl,
        (A < 0 -> I is 0 - A, write(I), write(' '), write(Farm), nl; true),
        (B < 0 -> J is 0 - B, write(J), write(' '), write(Fish), nl; true),
        (C < 0 -> K is 0 - C, write(K), write(' '), write(Produce), nl; true)
    ), !.

/* Funtion to display Quest
   Alur Umum:
   - Sudah Menerima Quest -> Print isi quest
   - Belum menerima quest -> Pesan belum mengambil quest */
displayQuest :-
    (
        q_ongoing(_)
    ->
        quests(Farm, NumFarm, Fish, NumFish, Produce, NumProduce),
        write('Items you need to collect:'), nl,
        write(NumFarm), write(' '), write(Farm), nl,
        write(NumFish), write(' '), write(Fish), nl,
        write(NumProduce), write(' '), write(Produce), !
    ;
        nl, write('You have not activated any quests, try going to the Questgiver to get a quest'), nl, nl
    ), !.

/* Funtion to verify tile */
% Add: Tile Verification Dibawah sementara
isQuest :-
    player(X, Y), quest(X, Y).
