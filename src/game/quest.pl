:- dynamic(q_done/1).
:- dynamic(q_ongoing/1).
:- dynamic(quests/6).

q_done(0).

/* List of Quests in order dalam format quest(nama_item, jumlah, nama_item, jumlah, nama_item, jumlah) */
quests('Carrot', 1, 'Rainbob', 1, 'Egg', 1).
quests('Carrot', 2, 'Snelt', 4, 'Egg', 2).
quests('Corn', 2, 'Arna', 2, 'Wool Sack', 1).
quests('Tomato', 4, 'Sharshark', 2, 'Wool Sack', 2).
quests('Potato', 7, 'Rainbob', 5, 'Milk Bucket', 2).
quests('Carrot', 6, 'Arna', 3, 'Milk Bucket', 2).
quests('Tomato', 7, 'Sharshark', 3, 'Egg', 8).
quests('Potato', 12, 'Big Sharshark', 3, 'Egg', 9).
quests('Tomato', 8, 'Big Sharshark', 3, 'Wool Sack', 4).
quests('Corn', 8, 'Super Big Sharshark', 2, 'Milk Bucket', 3).


/* Function to get quest:
   - Jika dipanggil di tile quest -> masuk getQuest
   - Jika tidak dipanggil di tile quest -> menjabarkan current quest
   */
quest :-
    (game_start(false) -> nl, msg_not_start(MSG), write(MSG), nl, !, fail; true),
    (onTile(quest) -> getQuest; displayQuest), !.

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
        jobSelect(0, Job), exp(Exp, Job), Inc is 100 * Qd, Exp_new is Inc + Exp,
        retractall(exp(_, Job)), assertz(exp(Exp_new, Job)),
        % Add money
        Get is 350 * Qd,
        % Success message
        write('You have given the required items to questgiver.'), nl, nl,
        write('Your base experience has risen by '), write(Inc), write('.'), nl,
        write('You recieved '), write(Get), write(' gold.'), nl,
        % Write diary
        giveGold(Get), writeDiaryEvent(0)
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

