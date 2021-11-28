:- dynamic(gold/1).
:- dynamic(item/2).

/* List Item, jumlah yang ada dalam inventory player */

gold(0).

item(1, 'Level 1 Shovel').
item(1, 'Level 1 Fishing Rod').
item(0, 'Carrot Seed').
item(0, 'Corn Seed').
item(1, 'Tomato Seed').
item(0, 'Potato Seed').
% Ini udh diganti jadi animal, aneh ga sih kalo binatang jadi item, bebas sih
% item(0, 'Chicken').
% item(0, 'Sheep').
% item(0, 'Cow').
item(0, 'Level 2 Shovel').
item(0, 'Level 2 Fishing Rod').

/* Sellable Items */

item(1, 'Carrot').
item(3, 'Corn').
item(0, 'Tomato').
item(1, 'Potato').
item(0, 'Egg').
item(0, 'Milk Bucket').
item(0, 'Wool Sack').

/* Nama Item, Harga */
sellable('Carrot', 100).
sellable('Corn', 100).
sellable('Tomato', 100).
sellable('Potato', 100).
sellable('Egg', 100).
sellable('Milk Bucket', 100).
sellable('Wool Sack', 100).

/* Prosedur */

/* Gmnhow biar 2 prosedur dibawah ini selalu return true? */

inInven(Y) :-
	item(X, Y),
	X > 0,
	write(X), write(' '), write(Y), nl,
	inInven(\+ Y).

sellableInInven(Y) :-
	item(X, Y),
	sellable(Y, _),
	X > 0,
	write('- '), write(X), write(' '), write(Y), nl,
	sellableInInven(\+ Y).

/* COMMAND inventory */
inventory :-
	write('Your Inventory:'), nl,
	inInven(Y).

/* COMMAND throwItem */
throwItem :-
	inventory, nl,
	write('What do you want to throw? '), read(I), nl.
/* WIP blm dilanjut */

/* Dipanggil saat masuk Market */
marketMenu :-
	write('What do you want to do?'), nl,
	write('1. Buy'), nl,
	write('2. Sell').

/* COMMAND buy */
/* kondisi yang perlu ditambahkan: player harus sedang berada di dalam market */
buy :-
	write('1. Carrot Seed (50 golds)'), nl,
	write('2. Corn Seed (50 golds)'), nl,
	write('3. Tomato Seed (50 golds)'), nl,
	write('4. Potato Seed (50 golds)'), nl,
	write('5. Chicken (500 golds)'), nl,
	write('6. Sheep (1000 golds)'), nl,
	write('7. Cow (1500 golds)'), nl,
	write('8. Level 2 Shovel (300 golds)'), nl,
	write('9. Level 2 Fishing Rod (500 golds)'), nl,
	write('0. [Exit Shop]'), nl, nl,
	write('What do you want to buy? '), read(X), buySomething(X), !.
buy :- buy.
	
buySomething(X) :- X is 1, cost(50, 'Carrot Seed').
buySomething(X) :- X is 2, cost(50, 'Corn Seed').
buySomething(X) :- X is 3, cost(50, 'Tomato Seed').
buySomething(X) :- X is 4, cost(50, 'Potato Seed').
buySomething(X) :- X is 5, cost(500, 'Chicken').
buySomething(X) :- X is 6, cost(1000, 'Sheep').
buySomething(X) :- X is 7, cost(1500, 'Cow').
buySomething(X) :- X is 8, cost(300, 'Level 2 Shovel').
buySomething(X) :- X is 9, cost(500, 'Level 2 Fishing Rod').
buySomething(X) :- X is 0.

cost(X, Z) :-
	write('How many do you want to buy? '),
	read(I), I > 0, nl, !, 
	checkIfEnough(X, Z, I).
cost(X, Z) :- cost(X, Z).
	
checkIfEnough(X, Z, I) :-
	gold(G),
	C is I * X,
	G >= C,
	write('You have bought '), write(I), write(' '), write(Z), write('.'), nl,
	write('You are charged '), write(C), write(' golds.'), nl, nl,
	addItem(I, Z),
	takeGold(C), !,
	buy.

checkIfEnough(X, Z, I) :-
	gold(G),
	C is I * X,
	G < C,
	write('Not enough gold.'), nl, nl, !,
	buy.

/* Prosedur memudahkan hidup */

/* CHEAT giveGold */
giveGold(X) :-
	retract(gold(Y)),
	Z is Y + X,
	assertz(gold(Z)).
takeGold(X) :-
	retract(gold(Y)),
	Z is Y - X,
	assertz(gold(Z)).
	
addItem(A, B) :- 
	retract(item(X, B)),
	C is X + A,
	assertz(item(C, B)).
	
removeItem(A, B) :- 
	retract(item(X, B)),
	C is X - A,
	assertz(item(C, B)).

/* COMMAND sell */	
/* kondisi yang perlu ditambahkan: player harus sedang berada di dalam market */
sell :-
	write('Here are the items in your inventory'), nl, !,
	sellableInInven(Y), !,
	write('What do you want to sell? '), read(I), nl,
	item(X, I),
	X > 0,
	sellable(I, V),
	!, sellHowMuch(X, I, V).
sell :- sell.

sellHowMuch(X, I, V) :- 
	write('How many do you want to sell? '), read(N), nl,
	N >= 0,
	X >= N, !,
	write('You have sold '), write(N), write(' '), write(I), write('.'), nl,
	write('You received '), write(C), write(' golds.'), nl, nl,
	removeItem(N, I),
	C is N * V,
	giveGold(C),
	sell.
sellHowMuch(X, I) :- sellHowMuch(X, I).