% game_start belum di dynamic

w :-
    game_start(true),
w :- game_start(false), msg_not_start(MSG), write(MSG).

a :-
    game_start(true),
a :- game_start(false), msg_not_start(MSG), write(MSG).

s :-
    game_start(true),
s :- game_start(false), msg_not_start(MSG), write(MSG).

d :-
    game_start(true),
d :- game_start(false), msg_not_start(MSG), write(MSG).