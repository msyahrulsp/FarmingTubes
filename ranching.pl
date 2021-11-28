:- dynamic(animal/2).
:- dynamic(item/2).
:- dynamic(day/1).

day(1).

animal(2, 'chicken', 1).
animal(0, 'cow', 1).
animal(1, 'sheep', 1).

produce('chicken', 'Egg').
produce('cow', 'Milk Bucket').
produce('sheep', 'Wool Sack').

item(0, 'Egg').
item(0, 'Milk Bucket').
item(0, 'Wool Sack').

listAnimals :-
    animal(X, Y, _), X > 0,
    write(X), write(' '), write(Y),
    (X > 1 -> write('s'); true), nl,
    fail.

animalHarvest(In) :-
    animal(Num, X, Cooldown), day(Day),
    (In == X; plural(X, In)),
    (
        Num > 0, Day < Cooldown
    ->
        plural(X, Xs),
        Diff is Cooldown - Day,
        write(Xs), write(' don\'t have any produce yet. Try again '),
        (
            Diff > 1
        ->
            write('in '), write(Diff), write(' days.')
        ;
            write('tomorrow.')
        ), nl
    ;
        Num > 0
    ->
        produce(X, Y), item(Jumlah, Y),
        Sum is Jumlah + Num,
        retractall(item(_, Y)), assertz(item(Sum, Y)),
        write('You have successfully harvested '), write(Num), write(' '),
        (
            Num > 1
        ->
            plural(Y, Ys), plural(X, Xs),
            write(Ys), write(' from your '), write(Xs), write('.'), nl
        ;
            write(Y), write(' from your '), write(X), write('.'), nl
        )
    ;
        plural(X, Xs), 
        write('You don\'t have any '), write(Xs), write('.'), nl
    ),
    !.

ranch :-
    write('Welcome to the ranch, you have:'), nl,
    \+(listAnimals), nl,
    write('Which animal will you harvest?'), nl,
    read(Pin), nl, toLower(Pin, In),
    (
    	animalHarvest(In), !
	;
		write('You tried to find the animal "'), write(In), write('", but you couldn\'t find it.'), nl,
        !, fail
	).

% Lowercase Conversion
toLower(X, Y) :-
    atom_chars(X, List),
    lowerCase(List, Lower), !,
    atom_chars(Y, Lower).
lowerCase([], []).
lowerCase([Head| Tail], [Lower| Ltail]) :-
    lower_upper(Lower, Head),
    lowerCase(Tail, Ltail).
% End Lowercase Conversion
plural(X, Y) :-
    atom_chars(X, List),
    addPlur(List, Plur), !,
    atom_chars(Y, Plur).
addPlur([], ['s']).
addPlur([Head| Tail], [Head| Ptail]) :-
    addPlur(Tail, Ptail).