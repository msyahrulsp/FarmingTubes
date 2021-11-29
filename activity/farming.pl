dig :-
    canDig, map_object(X, Y, 'P'),
    assertz(map_object(X, Y, '=')), 
    msg_dig(MSG), write(MSG), nl, !.

plant :-
    canPlant,
    \+(plantableInv),
    write('What do you want to plant? '), nl, read(I), nl,
    item(X, I), X > 0, plantable(I, S, T1),
    NewX is X - 1,
    retract(item(X, I)),
    assertz(item(NewX, I)),
    map_object(PosX, PosY, 'P'),
    retract(map_object(PosX, PosY, '=')),
    assertz(map_object(PosX, PosY, S)),
    asserta(crop(PosX, PosY, I, T1)),
    msg_plant(MSG), write(MSG), write(I), nl.
    !.

plant :-
    msg_plant_cant(MSG), write(MSG), nl.

harvest :-
    canHarvest, map_object(X, Y, Obj), harvestable(Obj, Name),
    retract(map_object(X, Y, Obj)),
    msg_harvest(MSG), write(MSG), write(Name), nl,
    item(N, Name), retract(item(N, Name)),
    NewN is N + 1,
    asserta(item(NewN, Name)),
    !.

plantableInv :-
    item(X, Y), plantable(Y, _, _), X > 0,
    write('- '), write(X), write(' '), write(Y), nl,
    fail.