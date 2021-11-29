dig :-
    canDig, map_object(X, Y, 'P'),
    assertz(map_object(X, Y, '=')), !.

plant :-
    canPlant,
    \+(plantableInv),
    write('What do you want to plant? '), nl, read(I), nl,
    item(X, I), X > 0, plantable(I, S),
    NewX is X - 1,
    retract(item(X, I)),
    assertz(item(NewX, I)),
    map_object(X, Y, 'P'),
    retract(map_object(X, Y, '=')),
    assertz(map_object(X, Y, S)),
    !.

% plant :-
%     msg_plant_cant(MSG), write(MSG), nl.

% harvest :-

plantableInv :-
    item(X, Y), plantable(Y, _), X > 0,
    write('- '), write(X), write(' '), write(Y), nl,
    fail.