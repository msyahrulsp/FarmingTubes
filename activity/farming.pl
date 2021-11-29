:- dynamic(crop/4).

dig :-
    canDig, map_object(X, Y, 'P'),
    assertz(map_object(X, Y, '=')), 
    msg_dig(MSG), write(MSG), nl,
    add_farming_exp(45),
    digTime,
    !.

plant :-
    canPlant,
    \+(plantableInv),
    write('What do you want to plant? '), nl, read(I), nl,
    item(X, I), X > 0, plantable(I, S, T, _),
    NewX is X - 1,
    retract(item(X, I)),
    assertz(item(NewX, I)),
    map_object(PosX, PosY, 'P'),
    retract(map_object(PosX, PosY, '=')),
    assertz(map_object(PosX, PosY, S)),
    asserta(crop(PosX, PosY, S, T)),
    msg_plant(MSG), write(MSG), write(I), nl,
    add_farming_exp(65),
    addTime(2),
    !.

plant :-
    msg_plant_cant(MSG), write(MSG), nl.

drop_rate(Rate) :-
    getLevel(2, L, _),
    (
        L == 1 -> Max is 45;
        L == 2 -> Max is 35;
        L == 3 -> Max is 15;
        L == 4 -> Max is 8;
        L >= 5 -> Max is 3
    ),
    random(1, Max, Num),
    (
        Num == 1
    ->
        Rate is 2
    ;
        Rate is 1
    ).

harvest :-
    canHarvest, map_object(X, Y, Obj), harvestable(Obj, Name),
    retract(map_object(X, Y, Obj)),
    item(N, Name), retract(item(N, Name)),
    drop_rate(Rate),
    getLevel(2, L, _),
    (
        L >= 5 -> assertz(map_object(X, Y, '='))
    ;
        !
    ),
    (
        Name == 'Carrot' -> Yield is 1 * Rate;
        Name == 'Corn' -> Yield is 2 * Rate;
        Name == 'Tomato' -> Yield is 2 * Rate;
        Name == 'Potato' -> Yield is 3 * Rate
    ),
    NewN is N + Yield,
    asserta(item(NewN, Name)),
    msg_harvest(MSG), write(MSG), write(Yield), write(' '), write(Name), nl,
    add_farming_exp(80),
    addTime(4),
    !.

plantableInv :-
    item(X, Y), plantable(Y, _, _, _), X > 0,
    write('- '), write(X), write(' '), write(Y), nl,
    fail.

digTime :-
    item(L1, 'Level 1 Shovel'),
    item(L2, 'Level 2 Shovel'),
    (
        L2 > 0
    ->
        addTime(1)
    ; (
        L1 > 0
    -> 
        addTime(2)
    ; 
        addTime(4)
    )),
    !.

add_farming_exp(N) :-
    exp(X, farmer),
    (
        job(farmer)
    ->
        NewN is N * 2
    ;
        NewN is N
    ),
    NewExp is X + NewN,
    retract(exp(X, farmer)), asserta(exp(NewExp, farmer)), 
    write('Your Farming Experience has increased by '), write(NewN), write('.'), nl,
    !.