:- dynamic(chicken/1).
:- dynamic(cow/1).
:- dynamic(sheep/1).
:- dynamic(cdchicken/1).
:- dynamic(cdcow/1).
:- dynamic(cdsheep/1).

chicken(2).
cow(1).
sheep(1).

ranch :-
    chicken(X), cow(Y), sheep(Z),
    write('Welcome to the ranch, you have:'), nl,
    write(X), write(' chicken'), nl,
    write(Y), write(' cow'), nl,
    write(Z), write(' sheep'), nl, nl,
    write('Which animal will you harvest?'), nl,
    read_atom(Pin), toLower(Pin, In),
    (
    	(In == chicken; In == chickens)
	->
		write('func chicken'), nl,
		!, true
    ;
    	(In == cow; In == cows)
	->
		write('func cow'), nl,
		!, true
	;
    	(In == sheep; In == sheeps)
	->
		write('func sheep'), nl,
		!, true
	;
		write('You tried to find the animal "'), write(In), write('", but you couldn\'t find it.'), nl
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