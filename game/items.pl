:- dynamic(gold/1).
:- dynamic(item/2).
:- dynamic(plantable/2).

/* List Item, jumlah yang ada dalam inventory player */

/* Gold dan prosedur untuk menunjukkan jumlah gold yang dimiliki */
gold :- gold(X), write('Gold: '), write(X).
gold(0).

/* Jumlah item pada inventory, nama item */
item(1, 'Level 1 Shovel').
item(1, 'Level 1 Fishing Rod').
item(2, 'Carrot Seed').
item(1, 'Corn Seed').
item(0, 'Tomato Seed').
item(0, 'Potato Seed').
item(1, 'Chicken').
item(0, 'Sheep').
item(0, 'Cow').
item(0, 'Level 2 Shovel').
item(0, 'Level 2 Fishing Rod').

/* Sellable Items - dipisah supaya lebih mudah melihat barang apa yang dapat dijual vs barang apa yang tidak bisa dijual. */
item(1, 'Carrot').
item(0, 'Corn').
item(0, 'Tomato').
item(0, 'Potato').
item(0, 'Egg').
item(0, 'Wool Sack').
item(0, 'Milk Bucket').
item(0, 'Snelt').
item(0, 'Rainbob').
item(0, 'Arna').
item(0, 'Sharkshark').
item(0, 'Big Sharkshark').
item(0, 'Super Big Sharkshark').

/* Nama Item, Sell Price */
sellable('Carrot', 100).
sellable('Corn', 150).
sellable('Tomato', 125).
sellable('Potato', 80).
sellable('Egg', 100).
sellable('Wool Sack', 250).
sellable('Milk Bucket', 375).
sellable('Snelt', 75).
sellable('Rainbob', 125).
sellable('Arna', 225).
sellable('Sharkshark', 350).

plantable('Carrot Seed', 'c').
plantable('Corn Seed', 'n').
plantable('Tomato Seed', 't').
plantable('Potato Seed', 'a').

harvestable('C').
harvestable('N').
harvestable('T').
harvestable('A').

/* Prosedur */

/* Prosedur buat ganti jumlah gold dan item */

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


/* COMMAND inventory */
inventory :-
	write('Your Inventory:'), nl,
    % Dikasih not biar yes akhirnya karena pasti kembaliin no
	\+(inInven).

inInven :-
	item(X, Y), X > 0,
	write(X), write(' '), write(Y), nl,
    % Dikasih fail untuk maksa backtracking
	fail.


/* COMMAND throwItem */
throwItem :-
	inventory,
	nl, write('[Enter 0 to Exit Shop]'), nl,
	nl, write('What do you want to throw? (Example: \'Item Name\'.) '), read(I),
	(
		(I \== 0)
	->
		item(X, I),
		X > 0,
		throwHowMuch(X, I)
	;
		% [Cancel Throwing]
		!
	).
throwItem :- throwItem.

throwHowMuch(X, I) :- 
	write('You have '), write(X), write(' '), write(I) ,write('. How many do you want to throw? '), read(N),
	N >= 0,
	X >= N, !, nl,
	write('You threw away '), write(N), write(' '), write(I), write('.'), nl,
	removeItem(N, I).
throwHowMuch(X, I) :- throwHowMuch(X, I).


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
	write('What do you want to buy? (Enter a Number) '), read(X), buySomething(X), !.
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

% [Exit Shop]
buySomething(X) :- X is 0.

cost(X, Z) :-
	write('How many do you want to buy? '),
	read(I), I >= 0, nl, !, 
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

checkIfEnough(X, _, I) :-
	gold(G),
	C is I * X,
	G < C,
	write('Not enough gold.'), nl, nl, !,
	buy.
	

/* COMMAND sell */	
/* kondisi yang perlu ditambahkan: player harus sedang berada di dalam market */
sell :-
    % cutnya pada gw ilangin kurang penting
	write('Here are the items in your inventory'), nl,
    % Diganti jadi negasi karena failure driven
	\+(sellableInInven),
	write('What do you want to sell? '), read(I), nl,
    % ini mending dikasih if aja sih, tapi terserah km implementnya gimana
    % If tuh ky: (Kondisi(X) -> Something; Kondisi(Y) -> Smth)
	item(X, I), X > 0, sellable(I, V),
	sellHowMuch(X, I, V).
sell :- sell.

sellableInInven :-
	item(X, Y), sellable(Y, _), X > 0,
	write('- '), write(X), write(' '), write(Y), nl,
    % Dikasih fail buat enforced backtracking
	fail.
	
sellHowMuch(X, I, V) :- 
	write('How many do you want to sell? '), read(N),
	N >= 0,
	X >= N, !,
	C is N * V, nl,
	write('You have sold '), write(N), write(' '), write(I), write('.'), nl,
	write('You received '), write(C), write(' golds.'), nl, nl,
	removeItem(N, I),
	giveGold(C).
sellHowMuch(X, I, V) :- sellHowMuch(X, I, V).