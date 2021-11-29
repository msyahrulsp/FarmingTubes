:- dynamic(gold/1).
:- dynamic(item/2).
:- dynamic(plantable/4).
:- dynamic(harvestable/2).

/* List Item, jumlah yang ada dalam inventory player */

/* Gold yang dimiliki player */
gold(0).

/* Jumlah item pada inventory, nama item */
item(1, 'Level 1 Shovel').
item(1, 'Level 1 Fishing Rod').
item(2, 'Carrot Seed').
item(1, 'Corn Seed').
item(0, 'Tomato Seed').
item(0, 'Potato Seed').
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
item(0, 'Sharshark').
item(0, 'Big Sharshark').
item(0, 'Super Big Sharshark').

/* Nama Item, Sell Price */
sellable('Carrot', 100).
sellable('Corn', 150).
sellable('Tomato', 125).
sellable('Potato', 80).
sellable('Egg', 100).
sellable('Wool Sack', 250).
sellable('Milk Bucket', 375).
sellable('Snelt', 50).
sellable('Rainbob', 100).
sellable('Arna', 175).
sellable('Sharshark', 250).
sellable('Big Sharshark', 350).
sellable('Super Big Sharshark', 500).

plantable('Carrot Seed', 'c', 2, 'C').
plantable('Corn Seed', 'n', 10, 'N').
plantable('Tomato Seed', 't', 8, 'T').
plantable('Potato Seed', 'a', 10, 'A').

harvestable('C', 'Carrot').
harvestable('N', 'Corn').
harvestable('T', 'Tomato').
harvestable('A', 'Potato').

/* Prosedur */

/* Prosedur buat ganti jumlah gold dan item */

giveGold(X) :-
	retract(gold(Y)),
	Z is Y + X,
	assertz(gold(Z)),
	(
		Z >= 20000
	->
		retractall(game_start(_)),
		retractall(game_on(_)),
		asserta(game_start(false)),
		asserta(game_on(false)),
		msg_win
	;
		true
	).
	
takeGold(X) :-
	retract(gold(Y)),
	Z is Y - X,
	assertz(gold(Z)).
	
addItem(Qty, Item) :- 
	retract(item(X, Item)),
	C is X + Qty,
	assertz(item(C, Item)).

removeItem(Qty, Item) :- 
	retract(item(X, Item)),
	C is X - Qty,
	assertz(item(C, Item)).
	
addAnimal(Qty, Animal) :- 
	retract(animal(X, Animal)),
	C is X + Qty,
	assertz(animal(C, Animal)), !.


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
	nl, write('[Enter 0 to Cancel]'), nl,
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


/* COMMAND market */
market :-
	(game_start(false) -> nl, msg_not_start(MSG), write(MSG), nl, !, fail; true),
	(
		onTile(marketplace)
	->
		write('What do you want to do?'), nl,
		write('1. Buy'), nl,
		write('2. Sell'), nl, nl,
        repeat,
        write('What will you do? (To exit enter "0" or "exit")'), nl,
        read(Pin), nl,
        (
            (Pin is 0; \+(integer(Pin)), toLower(Pin, In), atom_chars(In, Code), atom_chars(exit, Code))
		->
            write('You have exited the marketplace.'), nl, !
		;
			Pin == 1
		->
			buy, !
		;
			Pin == 2
		->
			sell, !
		;
			write('Wrong input number. (Enter numbers 1 or 2)'), nl, fail
		)
	;
        nl, write('You are not at the marketplace.'), nl, !, fail
	).


/* COMMAND buy */
buy :-
	(game_start(false) -> nl, msg_not_start(MSG), write(MSG), nl, !, fail; true),
	(
		onTile(marketplace)
	->
		write('Buy Menu:'), nl,
		write('1. Carrot Seed (50 golds)'), nl,
		write('2. Corn Seed (50 golds)'), nl,
		write('3. Tomato Seed (50 golds)'), nl,
		write('4. Potato Seed (50 golds)'), nl,
		write('5. Chicken (300 golds)'), nl,
		write('6. Sheep (650 golds)'), nl,
		write('7. Cow (900 golds)'), nl,
		write('8. Level 2 Shovel (300 golds)'), nl,
		write('9. Level 2 Fishing Rod (500 golds)'), nl,
		write('0. [Exit Shop]'), nl, nl,
		write('What do you want to buy? (Enter a Number) '), read(X), buySomething(X), !
	;
		nl, write('You are not at the marketplace.'), nl, !, fail
	).
buy :- buy.

buySomething(X) :- X is 1, cost(50, 'Carrot Seed').
buySomething(X) :- X is 2, cost(50, 'Corn Seed').
buySomething(X) :- X is 3, cost(50, 'Tomato Seed').
buySomething(X) :- X is 4, cost(50, 'Potato Seed').
buySomething(X) :- X is 5, cost(300, 'chicken').
buySomething(X) :- X is 6, cost(650, 'sheep').
buySomething(X) :- X is 7, cost(900, 'cow').
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
	writeDiaryEvent(4), addMarketTime,
	(
		(Z == 'chicken'; Z == 'sheep'; Z == 'cow')
	->
		addAnimal(I, Z)
	;
		addItem(I, Z)
	),
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
	(game_start(false) -> nl, msg_not_start(MSG), write(MSG), nl, !, fail; true),
	(
		onTile(marketplace)
	->
		write('Here are the items in your inventory:'), nl, !,
		\+(sellableInInven),
		repeat,
		nl, write('[Enter 0 to Cancel] '),
		nl, write('What do you want to sell? (Example: \'Item Name\'.) '), nl, read(I),
		(
			sellable(I, V)
		->
			item(X, I), X > 0,
			sellHowMuch(X, I, V)
		;
			(I \== 0)
		->
			nl, write('Wrong input. Please input a string.'), nl, fail
		;
			!
		)
	;
        nl, write('You are not at the marketplace.'), nl, !, fail
	).
sell :- sell.

sellableInInven :-
	\+ (item(X, Y), sellable(Y, _), X > 0),
	write('No sellable items in inventory.'), nl, nl, !.

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
	writeDiaryEvent(5), addMarketTime,
	removeItem(N, I),
	giveGold(C).
sellHowMuch(X, I, V) :- sellHowMuch(X, I, V).

addMarketTime :-
	getLevel(0, L, _),
	(
		(L >= 3)
	->
		addTime(1)
	;
		addTime(2)
	).