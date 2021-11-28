:- dynamic(map_object/3).

map_elmt(wall, '#').
map_elmt(default, '-').
map_elmt(player, 'P').
map_elmt(marketplace, 'M').
map_elmt(ranch, 'R').
map_elmt(house, 'H').
map_elmt(quest, 'Q').
map_elmt(water, 'o').
map_elmt(digged, '=').

map_size(10).

map_generate_water(NX, 0, _, Y) :- 
    NewY is Y - 1,
    map_generate_water(NX, 3, 1, NewY).

map_generate_water(0, _, _, _) :- !.

map_generate_water(NX, NY, X, Y) :-
    map_elmt(water, W),
    asserta(map_object(X, Y, W)),
    NewX is X + 1,
    NewNX is NX - 1,
    NewNY is NY - 1,
    map_generate_water(NewNX, NewNY, NewX, Y).

map_generate :-
    asserta(map_object(2, 1, 'M')),
    asserta(map_object(8, 5, 'R')),
    asserta(map_object(4, 4, 'H')),
    asserta(map_object(5, 7, 'Q')),
    map_size(M),
    map_generate_water(8, 3, 1, M).

% Border kiri
map_draw(X, Y) :-
    map_size(M), map_elmt(wall, W),
    X =:= 0, Y =< M + 1,
    write(W), write(' '),
    DX is X + 1,
    map_draw(DX, Y).

% Border kanan
map_draw(X, Y) :-
    map_size(M), map_elmt(wall, W),
    X =:= M + 1, Y =< M + 1,
    write(W), nl,
    DY is Y + 1,
    map_draw(0, DY).

% Border atas
map_draw(X, Y) :-
    map_size(M), map_elmt(wall, W),
    X < M + 1, Y =:= 0,
    write(W), write(' '),
    DX is X + 1,
    map_draw(DX, Y).

% Border bawah
map_draw(X, Y) :-
    map_size(M), map_elmt(wall, W),
    X < M + 1, Y =:= M + 1,
    write(W), write(' '),
    DX is X + 1,
    map_draw(DX, Y).

% Object
map_draw(X, Y) :-
    map_size(M), map_elmt(default, D),
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
    (
        game_start(true)
    ->
        nl, write('map:'), nl, nl,
        map_draw(0, 0)
    ;
        msg_not_start(MSG), write(MSG), nl
    ), !.

% Buat move
valid_move(DX, DY) :-
    map_elmt(player, P), map_object(X, Y, P), map_size(M), map_elmt(water, W),
    DisX is DX + X, DisY is DY + Y,
    DisX < M + 1, DisX > 0, DisY < M + 1, DisY > 0, 
    \+ (map_object(DisX, DisY, W)).

/* deprecated
% Buat Fishing
isNear(Obj) :-
    map_elmt(player, P), map_object(X, Y, P),
    DX is X - 1, map_object(DX, Y, Obj1),
    Obj == Obj1.

isNear(Obj) :-
    map_elmt(player, P), map_object(X, Y, P),
    DX is X + 1, map_object(DX, Y, Obj1),
    Obj == Obj1.

isNear(Obj) :-
    map_elmt(player, P), map_object(X, Y, P),
    DY is Y - 1, map_object(X, DY, Obj1),
    Obj == Obj1.

isNear(Obj) :-
    map_elmt(player, P), map_object(X, Y, P),
    DY is Y + 1, map_object(X, DY, Obj1),
    Obj == Obj1.
*/

% Locators
nearWater :-
    map_object(Px, Py, 'P'), map_object(Wx, Wy, 'o'),
    (Px == Wx + 1; Px == Wx - 1),
    (Py == Wy + 1; Py == Wy - 1).

onTile(Tile_name) :-
    map_elmt(player, P), map_object(X, Y, P), map_object(X, Y, Tile), map_elmt(Tile_name, Tile).