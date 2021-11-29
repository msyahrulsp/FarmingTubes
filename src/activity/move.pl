w :-
    move_player('W'), !.

a :-
    move_player('A'), !.

s :-
    move_player('S'), !.

d :-
    move_player('D'), !.

move_player(Mov) :-
    (
        game_start(true)
    ->
        map_elmt(player, P), map_object(X, Y, P), getDisplacement(Mov, Dx, Dy),
        (
            valid_move(Dx, Dy)
        ->
            Mx is X + Dx, My is Y + Dy,
            retract(map_object(X, Y, P)), asserta(map_object(Mx, My, P)),
            msg_move(Mov, MSG), write(MSG),
            addTime(1)
        ;
            msg_move('E', MSG), write(MSG)
        )
    ;
        msg_not_start(MSG), write(MSG)
    ).

getDisplacement(Mov, Dx, Dy) :-
    (
        Mov == 'W' -> Dx is 0, Dy is -1;
        Mov == 'A' -> Dx is -1, Dy is 0;
        Mov == 'S' -> Dx is 0, Dy is 1;
        Mov == 'D' -> Dx is 1, Dy is 0
    ), !.

/* Funtion Fairy:
   Alur Umum:
   - random > 90 - 10 * level -> teleport
   -                          -> nothing */
fairy :-
    random(0, 100, X), getLevel(0, Level, _), Chance is 95 - 5 * Level,
    (
        X >= Chance
    ->
        nl, write('You have been visited by the sleep fairy, choose a tile to move to.'), nl,
        repeat,
        nl, write('X coordinates: '), nl, 
        getCoord(Cx),
        nl, write('Y coordinates: '), nl,
        getCoord(Cy),
        (
            \+ (map_object(Cx, Cy, 'o'))
        ->
            nl, write('With a flick of her wand, you have been teleported to ('), write(Cx), write(', '), write(Cy), write(').'), nl,
            retractall(map_object(_, _, 'P')), asserta(map_object(Cx, Cy, 'P')), 
            writeDiaryEvent(9), !
        ;
            nl, write('You can\'t teleport into the water.'), nl, fail
        )
    ;
        true
    ), !.

getCoord(X) :-
    map_size(M),
    repeat,
    read(X),
    (
        integer(X), X > 0, X =< M -> !
    ;
        nl, write('Wrong coordinate input, (please input 1 - '), write(M), write(')'), nl, fail
    ).