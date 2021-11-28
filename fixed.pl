sellableInInven(Y) :-
	item(X, Y), sellable(Y, _), X > 0,
	write('- '), write(X), write(' '), write(Y), nl,
    % Dikasih fail buat enforced backtracking
	fail.

sell :-
    % cutnya pada gw ilangin kurang penting
	write('Here are the items in your inventory'), nl,
    % Diganti jadi negasi karena failure driven
	\+(sellableInInven(Y)),
	write('What do you want to sell? '), read(I), nl,
    % ini mending dikasih if aja sih, tapi terserah km implementnya gimana
    % If tuh ky: (Kondisi(X) -> Something; Kondisi(Y) -> Smth)
	item(X, I), X > 0, sellable(I, V),
	sellHowMuch(X, I, V).

% Ini juga sama
inInven(Y) :-
	item(X, Y), X > 0,
	write(X), write(' '), write(Y), nl,
    % Dikasih fail untuk maksa backtracking
	fail.

inventory :-
	write('Your Inventory:'), nl,
    % Dikasih not biar yes akhirnya karena pasti kembaliin no
	\+(inInven(Y)).
