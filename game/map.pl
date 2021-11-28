:- dynamic(map_object/3).

map_wall('#').
map_default('-').
map_player('P').
map_marketplace('M').
map_ranch('R').
map_house('H').
map_quest('Q').
map_water('o').
map_digged('=').

map_size(10).

% Border kiri
map_draw(X, Y) :-
    map_size(M), map_wall(W),
    X =:= 0, Y =< S + 1,
    write(W),
    DX is X + 1,
    map_draw(DX, Y).

% Border kanan
map_draw(X, Y) :-
    map_size(M), map_wall(W),
    X =:= S + 1, Y =< S + 1,
    write(W),
    DX is X + 1,
    map_draw(DX, Y).

% Done map_draw
map_draw(_, _) :- true.

print_map :-
    map_default(X), write(X), nl, write(X).

valid_move(DX, DY) :-
    map_player(P), map_object(X, Y, P),
    TempX is DX + X, TempY is DY + Y,
    write(TempX), nl. 

map :- 
    game_playing(true),
    print_map.

map :-
    write('Belum mulai').

% Buat Fishing
isNear(Obj) :-
    map_player(P), map_object(X, Y, P),
    DX is X - 1, map_object(DX, Y, Obj1),
    Obj =:= Obj1.

isNear(Obj) :-
    map_player(P), map_object(X, Y, P),
    DX is X + 1, map_object(DX, Y, Obj1),
    Obj =:= Obj1.

isNear(Obj) :-
    map_player(P), map_object(X, Y, P),
    DY is Y - 1, map_object(X, DY, Obj1),
    Obj =:= Obj1.

isNear(Obj) :-
    map_player(P), map_object(X, Y, P),
    DY is Y + 1, map_object(X, DY, Obj1),
    Obj =:= Obj1.

isNear(Obj) :-
    map_player(P), map_object(X, Y, P),
    DX is X - 1, DY is Y - 1, map_object(DX, DY, Obj1),
    Obj =:= Obj1.

isNear(Obj) :-
    map_player(P), map_object(X, Y, P),
    DX is X - 1, DY is Y + 1, map_object(DX, DY, Obj1),
    Obj =:= Obj1.

isNear(Obj) :-
    map_player(P), map_object(X, Y, P),
    DX is X + 1, DY is Y - 1, map_object(DX, DY, Obj1),
    Obj =:= Obj1.

isNear(Obj) :-
    map_player(P), map_object(X, Y, P),
    DX is X + 1, DY is Y + 1, map_object(DX, DY, Obj1),
    Obj =:= Obj1.