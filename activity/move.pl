% game_start belum di dynamic
/* deprecated
w :-
    game_start(true), valid_move(0, -1),
    map_elmt(player, P), map_object(X, Y, P), msg_move('W', MSG),
    Move is Y - 1,
    retract(map_object(X, Y, P)),
    asserta(map_object(X, Move, P)),
    write(MSG),
    !.

w :- game_start(true), \+valid_move(0, -1), msg_move('E', MSG), write(MSG), !.

w :- game_start(false), msg_not_start(MSG), write(MSG), !.

a :-
    game_start(true), valid_move(-1, 0),
    map_elmt(player, P), map_object(X, Y, P), msg_move('A', MSG),
    Move is X - 1,
    retract(map_object(X, Y, P)),
    asserta(map_object(Move, Y, P)),
    write(MSG),
    !.

a :- game_start(true), \+valid_move(-1, 0), msg_move('E', MSG), write(MSG), !.

a :- game_start(false), msg_not_start(MSG), write(MSG), !.

s :-
    game_start(true), valid_move(0, 1),
    map_elmt(player, P), map_object(X, Y, P), msg_move('S', MSG),
    Move is Y + 1,
    retract(map_object(X, Y, P)),
    asserta(map_object(X, Move, P)),
    write(MSG),
    !.

s :- game_start(true), \+valid_move(0, 1), msg_move('E', MSG), write(MSG), !.

s :- game_start(false), msg_not_start(MSG), write(MSG), !.

d :-
    game_start(true), valid_move(1, 0),
    map_elmt(player, P), map_object(X, Y, P), msg_move('D', MSG),
    Move is X + 1,
    retract(map_object(X, Y, P)),
    asserta(map_object(Move, Y, P)),
    write(MSG),
    !.

d :- game_start(true), \+valid_move(1, 0), msg_move('E', MSG), write(MSG), !.

d :- game_start(false), msg_not_start(MSG), write(MSG), !.
*/

getDisplacement(Mov, Dx, Dy) :-
    (
        Mov == 'W' -> Dx is 0, Dy is -1;
        Mov == 'A' -> Dx is -1, Dy is 0;
        Mov == 'S' -> Dx is 0, Dy is 1;
        Mov == 'D' -> Dx is 1, Dy is 0
    ), !.

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
            msg_move(Mov, MSG), write(MSG)
        ;
            msg_move('E', MSG), write(MSG)
        )
    ;
        msg_not_start(MSG), write(MSG)
    ).

w :-
    move_player('W'), !.

a :-
    move_player('A'), !.

s :-
    move_player('S'), !.

d :-
    move_player('D'), !.