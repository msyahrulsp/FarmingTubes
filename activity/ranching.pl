:- dynamic(animal/2).
:- dynamic(produce/3).

animal(2, 'chicken').
animal(1, 'cow').
animal(1, 'sheep').

produce('chicken', 'Egg', 1).
produce('cow', 'Milk Bucket', 1).
produce('sheep', 'Wool Sack', 1).

/* Ranch function
   Alur umum:
   - tidak berada di ranch -> tampilin pesan not in ranch
   - berada di ranch -> tampilin binatang -> harvest/exit */
ranch :-
    % Add: Add a verification if player is at ranch position
    write('Welcome to the ranch, you have:'), nl,
    \+(listAnimals), nl,
    write('Which animal will you harvest? (To exit enter "0" or "exit")'), nl,
    read(Pin), nl,
    (
        (Pin is 0; toLower(Pin, In), atom_chars(In, Code), atom_chars(exit, Code))
    ->
        write('You have exited the ranch.'), nl, !
    ;
    	toLower(Pin, In), animalHarvest(In), !
	;
		write('You tried to find the animal "'), write(In), write('", but you couldn\'t find it.'), nl,
        !, fail
	).

/* Function to list animals
   Alur umum:
   - Tidak ada binatang -> pesan tidak ada binatang
   - Ada binatang -> tampilin semua dengan metode failure driven */
listAnimals :-
    \+ (animal(Num, _), Num \== 0),
    nl, write('You have no animals yet, buy them from the shop'), !.

listAnimals :-
    animal(X, Y), X > 0,
    write(X), write(' '),
    (X > 1 -> plural(Y, Ys), write(Ys); write(Y)), nl,
    fail.

/* Function to harvest animal produce
   Alur umum:
   - Tidak ada binatang -> pesan tidak ada binatang
   - Cooldown -> pesan cooldown
   - Ada binatang -> tambahkan item yang diasosiasikan dengan binatang sebanyak jumlah binatang -> Ubah cooldown binatang */
animalHarvest(In) :-
    animal(Num, X), day(Day), produce(X, Y, Cooldown),
    (In == X; plural(X, In)),
    (
        % Jika ada tapi belum cooldown
        Num > 0, Day < Cooldown
    ->
        plural(X, Xs),
        Diff is Cooldown - Day,
        write(Xs), write(' don\'t have any produce yet. Try again '),
        (
            % Jika cooldown masih lebih dari 2 hari
            Diff > 1
        ->
            write('in '), write(Diff), write(' days.')
        ;
            % Jika cooldown besok
            write('tomorrow.')
        ), nl
    ;
        % Jika ada dan sudah tidak cooldown
        Num > 0
    ->
        item(Jumlah, Y),
        Sum is Jumlah + Num,
        retractall(item(_, Y)), assertz(item(Sum, Y)),
        write('You have successfully harvested '), write(Num), write(' '),
        (
            % Jika harvest lebih dari satu
            Num > 1
        ->
            plural(Y, Ys), plural(X, Xs),
            write(Ys), write(' from your '), write(Xs)
        ;
            % Jika harvest hanya satu
            write(Y), write(' from your '), write(X)
        ), write('.'), nl, nl,
        cooldown(X),
        addExp(3)
    ;
        % Jika tidak ada
        plural(X, Xs), 
        write('You don\'t have any '), write(Xs), write('.'), nl
    ),
    !.

/* Funtion cooldown:
   Alur Umum:
   - Jika job sama dengan nomor job masukan -> Increment Exp * 2
   - Jika job \== Masukan -> Increment Exp biasa */
cooldown(Animal) :-
    produce(Animal, Product, Cd),
    getLevel(3, Level),
    Cd_new is Cd + 5 - Level,
    retractall(produce(Animal, _, _)), assertz(produce(Animal, Product, Cd_new)).

/* Lowercase Conversion */
toLower(X, Y) :-
    atom_chars(X, List),
    lowerCase(List, Lower), !,
    atom_chars(Y, Lower).
lowerCase([], []).
lowerCase([Head| Tail], [Lower| Ltail]) :-
    lower_upper(Lower, Head),
    lowerCase(Tail, Ltail).

/* Pluralization */
plural(X, Y) :-
    atom_chars(X, List),
    addPlur(List, Plur), !,
    atom_chars(Y, Plur).
addPlur([], ['s']).
addPlur([Head| Tail], [Head| Ptail]) :-
    addPlur(Tail, Ptail).