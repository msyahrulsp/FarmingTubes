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

map_generate_water :-
    !.

map_generate :-
    asserta(map_object(1, 1, 'M')),
    asserta(map_object(8, 5, 'R')),
    asserta(map_object(4, 4, 'H')),
    asserta(map_object(5, 7, 'Q')),
    map_generate_water.

% Border kiri
map_draw(X, Y) :-
    map_size(M), map_wall(W),
    X =:= 0, Y =< M + 1,
    write(W), write(' '),
    DX is X + 1,
    map_draw(DX, Y).

% Border kanan
map_draw(X, Y) :-
    map_size(M), map_wall(W),
    X =:= M + 1, Y =< M + 1,
    write(W), nl,
    DY is Y + 1,
    map_draw(0, DY).

% Border atas
map_draw(X, Y) :-
    map_size(M), map_wall(W),
    X < M + 1, Y =:= 0,
    write(W), write(' '),
    DX is X + 1,
    map_draw(DX, Y).

% Border bawah
map_draw(X, Y) :-
    map_size(M), map_wall(W),
    X < M + 1, Y =:= M + 1,
    write(W), write(' '),
    DX is X + 1,
    map_draw(DX, Y).

% Object
map_draw(X, Y) :-
    map_size(M), map_default(D),
    X < M + 1, Y < M + 1,
    (\+ map_object(X, Y, _)),
    write(D), write(' '),
    DX is X + 1,
    map_draw(DX, Y).

map_draw(X, Y) :-
    map_size(M),
    X < M + 1, Y < M + 1,
    map_object(X, Y, Obj),
    write(Obj), write(' '),
    DX is X + 1,
    map_draw(DX, Y).

% Done map_draw
map_draw(_, _) :- !.

map :- 
    % game_playing(true),
    map_generate,
    map_draw(0, 0).

% map :-
%     write('Belum mulai').

% Buat move
valid_move(DX, DY) :-
    map_player(P), map_object(X, Y, P), map_size(M), map_water(W),
    DisX is DX + X, DisY is DY + Y,
    DisX < M + 1, DisX > 0, DisY < M + 1, DisY > 0,
    map_object(DisX, DisY, Obj),
    Obj \= W.

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