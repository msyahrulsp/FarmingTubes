:- dynamic(miss/1).
:- dynamic(chance/2).
:- dynamic(bonus_chance/1).
:- dynamic(fishing_time/1).
:- dynamic(fishing_level/1).

fish_type(1,'Snelt','C').
fish_type(2,'Rainbob','B').
fish_type(3,'Arna','A').
fish_type(4,'Sharkshark','S').
fish_type(5,'Big Sharkshark','SS').
fish_type(6,'Super Big Sharkshark','SSR').

chance(6,0).
chance(5,0).
chance(4,0).
chance(3,0.05).
chance(2,0.1).
chance(1,0.5).

bonus_chance(0).

miss(0).

fishing_level(1).

fishing_time(3).

set_miss(X) :-
% untuk set nilai miss
    retract(miss(_)),
    asserta(miss(X)).

fish :-
/* I.S. Game sedang berjalan, command 'fish' dimasukkan user
   F.S. Berhasil memancing, ikan yang didapat ialah bergantung pada nilai R
   Proses :
   R akan digenerate secara random
   Jika M >= 50, maka R akan dikali 0.01 (dijamin dapat minimal S jika chance S > 0)
   R akan dibandingkan mulai dari Chance ikan yang paling langka ke yang paling umum
   Jika ada jenis ikan yang Chance-nya lebih besar dari R, maka pemain mendapatkan ikan tersebut
   Jika tidak ada, maka pemain tidak mendapatkan ikan,
   Jika pemain mendapatkan ikan >=S, nilai miss akan direset, jika tidak miss akan bertambah
   Jika pemain mendapatkan ikan apapun, akan ada kemungkinan mendapatkan ikan tambahan
   KAMUS
   R = nilai random yang menentukan ikan yang diperoleh
   BC = Bonus Chance dari Fishing Rod
   M = miss (pity); Jumlah ikan tidak spesial berturut-turut yang diperoleh
   C = Chance mendapatkan ikan (semakin tinggi level fishing akan semakin tinggi)
   */
    (game_start(false) -> nl, msg_not_start(MSG), write(MSG), nl, !, fail; true),
    nearWater,
    haveFishingRod(L),
    L > 0,
    random(R),
    bonus_chance(BC),
    BonusChance is 1 + BC,
    (   miss(M), 
        chance(4,C),
        C > 0,
        M >= 50
    ->  R * 0.01
    ;   R is R),
    chance(X,C), 
    R =< C * BonusChance,!,
    write('You got '),
    fish_type(X,Fish,Rarity),
    write(Fish),
    write('! (Rarity : '),
    write(Rarity),
    write(')'),nl,
    (   X >= 4
    ->  set_miss(0)
    ;   miss(M),
        M1 is M+1,
        set_miss(M1)),
    miss(A),
    write('Missed Special Fish : '), write(A),nl,
    addItem(1,Fish),

    /* DOUBLE FISH! */
    random(Double),
    (
        Double =< 0.001
    ->
        nl, write('===DOUBLE FISH==='), nl, write(' YOU ARE ON FIRE!!'), nl, fish
    ;
        true,
        writeDiaryEvent(7),
        fishing_time(Time),
        addTime(Time)
    ),!.

fish :-
    nearWater,
    haveFishingRod(L),
    L > 0,
    write('You got nothing!'), nl,
    miss(M),
    M1 is M+1,
    set_miss(M1),
    write('Missed Special Fish : '), write(M1),!,
    writeDiaryEvent(7),
    fishing_time(Time),
    addTime(Time),!.

fish :-
    nearWater,
    msg_have_no_fishing_rod(MSG),
    write(MSG), nl, !.

fish :-
    msg_fish_not_near(MSG), write(MSG), nl.

increase_chance_level :-
/* I.S. Level Fishing terdefinisi
   F.S. Naik Level Fisihing, Chance dapet ikan juga naik
   Proses :
   Chance baru = Chance + (1 - Chance)*(Persentase Kenaikan Chance)
   Persentase kenaikan chance semakin kecil untuk ikan yang langka
   KAMUS 
   C1,C2,...,C6 = Chance ikan 1..6 sebelum naik level
   Chance1,Chance2,...,Chance6 = Chance ikan 1..6 setelah naik level
*/
    chance(1,C1),
    chance(2,C2),
    chance(3,C3),
    chance(4,C4),
    chance(5,C5),
    chance(6,C6),
    Chance1 is C1 + (1 - C1)*0.2,
    Chance2 is C2 + (1 - C2)*0.1,
    Chance3 is C3 + (1 - C3)*0.05,
    Chance4 is C4 + (1 - C4)*0.01,
    Chance5 is C5 + (1 - C5)*0.001,
    Chance6 is C6 + (1 - C6)*0.0001,
    retractall(chance(_,_)),
    asserta(chance(1,Chance1)),
    asserta(chance(2,Chance2)),
    asserta(chance(3,Chance3)),
    asserta(chance(4,Chance4)),
    asserta(chance(5,Chance5)),
    asserta(chance(6,Chance6)),
    write('Chance '), fish_type(1,Fish1,_), write(Fish1), write(' increased from '), format('~2f',[C1]), write(' to '), format('~2f~n',[Chance1]),
    write('Chance '), fish_type(2,Fish2,_), write(Fish2), write(' increased from '), format('~2f',[C2]), write(' to '), format('~2f~n',[Chance2]),
    write('Chance '), fish_type(3,Fish3,_), write(Fish3), write(' increased from '), format('~2f',[C3]), write(' to '), format('~2f~n',[Chance3]),
    write('Chance '), fish_type(4,Fish4,_), write(Fish4), write(' increased from '), format('~2f',[C4]), write(' to '), format('~2f~n',[Chance4]).

bonus_chance_fishing_rod :-
/* KAMUS
  Level = Level Fishing Road 
  Ch = Bonus Chance kalau pake Fishing Road level >1 */
    haveFishingRod(Level),
    Level > 0,
    Ch is float(Level-1)*0.005,
    retract(bonus_chance(_)),
    asserta(bonus_chance(Ch)).

haveFishingRod(Level) :-
    % Level = level minimal fishing rod, 0 jika tidak punya
    item(L1,'Level 1 Fishing Rod'),
    item(L2,'Level 2 Fishing Rod'),
    (
        L2 > 0
    ->
        Level is 2,
        retract(fishing_time(_)),
        asserta(fishing_time(2))
    ;(
        L1 > 0
    -> 
        Level is 1,
        retract(fishing_time(_)),
        asserta(fishing_time(3))
    ; 
        Level is 0
    )).

fishing_level_up :-
    /* Alur:
        Jika level naik, chance naik
        Jika level tidak naik, tidak terjadi apa-apa
    */
    fishing_level(Level),
    getLevel(1,UpdatedLevel,_),
    (
        UpdatedLevel > Level
    ->
        NewLevel is Level+1,
        retract(fishing_level(_)),
        asserta(fishing_level(NewLevel)),
        write('Fishing Level Up! Chance Increased!'),nl,
        increase_chance_level,nl,nl,
        fishing_level_up
    ;
        true
    ).