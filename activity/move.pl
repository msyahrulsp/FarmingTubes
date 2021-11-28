% game_start belum di dynamic

w :-
    game_start(true), valid_move(0, -1),
    map_player(P), map_object(X, Y, P), msg_move('W', MSG),
    Move is Y - 1,
    retract(map_object(X, Y, P)),
    asserta(map_object(X, Move, P)),
    write(MSG),
    !.

w :- game_start(true), \+valid_move(0, -1), msg_move('E', MSG), write(MSG), !.

w :- game_start(false), msg_not_start(MSG), write(MSG), !.

a :-
    game_start(true), valid_move(-1, 0),
    map_player(P), map_object(X, Y, P), msg_move('A', MSG),
    Move is X - 1,
    retract(map_object(X, Y, P)),
    asserta(map_object(Move, Y, P)),
    write(MSG),
    !.

a :- game_start(true), \+valid_move(-1, 0), msg_move('E', MSG), write(MSG), !.

a :- game_start(false), msg_not_start(MSG), write(MSG), !.

s :-
    game_start(true), valid_move(0, 1),
    map_player(P), map_object(X, Y, P), msg_move('S', MSG),
    Move is Y + 1,
    retract(map_object(X, Y, P)),
    asserta(map_object(X, Move, P)),
    write(MSG),
    !.

s :- game_start(true), \+valid_move(0, 1), msg_move('E', MSG), write(MSG), !.

s :- game_start(false), msg_not_start(MSG), write(MSG), !.

d :-
    game_start(true), valid_move(1, 0),
    map_player(P), map_object(X, Y, P), msg_move('D', MSG),
    Move is X + 1,
    retract(map_object(X, Y, P)),
    asserta(map_object(Move, Y, P)),
    write(MSG),
    !.

d :- game_start(true), \+valid_move(1, 0), msg_move('E', MSG), write(MSG), !.

d :- game_start(false), msg_not_start(MSG), write(MSG), !.