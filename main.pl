:- dynamic(day/1).
:- dynamic(hour/1).
:- dynamic(job/1).
:- dynamic(helpmenu/1).

helpmenu(0).

day(1).
hour(0).

/* Job Selection */
jobSelect(1, fisherman).
jobSelect(2, farmer).
jobSelect(3, rancher).

/* Status Player */

job('-').
level(1).
levelFarming(1).
expFarming(0).
levelFishing(1).
expFishing(0).
levelRanching(1).
expRanching(0).
experience(0, 300).
gold(0).

/* List Item, jumlah yang ada dalam inventory player */

item(carrot_seed, 0).
item(corn_seed, 0).
item(tomato_seed, 0).
item(potato_seed, 0).

/* Prosedur dan rule */

/* Dipanggil untuk menambah Day */
nextDay :-
	day(X),
	Z is X+1,
	retract(day(_)),
	asserta(day(Z)),
	retract(hour(_)),
	asserta(hour(0)).
	
addHour(NUM) :-
	retract(hour(X)),
	Y is X + NUM,
	assertz(hour(Y)).

/* Prosedur Command 'start' untuk memulai game */
start :-
	write('Welcome to Prolog Valley. Choose your job'), nl,
	write('1. Fisherman'), nl,
	write('2. Farmer'), nl,
	write('3. Rancher'), nl,
	read(X),
	jobSelect(X, Y),
	retract(job('-')),
	assertz(job(Y)),
	write('You chose '), write(Y), write(', let\'s start farming!'),
	retractall(helpmenu(A)),
	assertz(helpmenu(1),
	!.

status :-
	write('Your status:'), nl,
	job(A), write('Job: '), write(A), nl,
	level(B), write('Level: '), write(B), nl,
	levelFarming(C), write('Level Farming: '), write(C), nl,
	expFarming(D), write('Exp Farming: '), write(D), nl,
	levelFishing(E), write('Level Fishing: '), write(E), nl,
	expFishing(F), write('Exp Fishing: '), write(F), nl,
	levelRanching(G), write('Level Ranching: '), write(G), nl,
	expRanching(H), write('Exp Ranching: '), write(H), nl,
	experience(I, J), write('Exp: '), write(I), write('/'), write(J), nl,
	gold(K), write('Gold: '), write(K).

exitGame :- halt(0).

help :-
	help(X),
	X is 0,
	write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
	write('%                              ~Harvest Star~                                  %'), nl,
	write('% 1. start  : untuk memulai petualanganmu                                      %'), nl,
	write('% 2. map    : menampilkan peta                                                 %'), nl,
	write('% 3. status : menampilkan kondisimu terkini                                    %'), nl,
	write('% 4. w      : gerak ke utara 1 langkah                                         %'), nl,
	write('% 5. s      : gerak ke selatan 1 langkah                                       %'), nl,
	write('% 6. d      : gerak ke ke timur 1 langkah                                      %'), nl,
	write('% 7. a      : gerak ke barat 1 langkah                                         %'), nl,
	write('% 8. help   : menampilkan segala bantuan                                       %'), nl,
	write('% (status seharusnya hanya ada 1)                                              %'), nl,
	write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl.

help :-
	help(X),
	X is 1,
	write('|| 1. map         : menampilkan peta                                           ||'), nl,
	write('||    - w           : gerak ke utara 1 langkah                                 ||'), nl,
	write('||    - s           : gerak ke selatan 1 langkah                               ||'), nl,
	write('||    - d           : gerak ke ke timur 1 langkah                              ||'), nl,
	write('||    - a           : gerak ke barat 1 langkah                                 ||'), nl,
	write('|| 2. dig         : menggali tanah agar bisa ditanami                          ||'), nl,
	write('|| 3. plant       : menanam bibit pada lahan yang sudah digali                 ||'), nl,
	write('|| 4. harvest     : memanen tanaman yang sudah ditanam                         ||'), nl,
	write('|| 5. fish        : memancing ikan jika di dekat air                           ||'), nl,
	write('|| 6. ranch       : membuka menu ranching jika berada di tile ranch            ||'), nl,
	write('||    - chicken     : mengambil hasil ternak ayam                              ||'), nl,
	write('||    - sheep       : mengambil hasil ternak domba                             ||'), nl,
	write('||    - cow         : mengambil hasil ternak sapi                              ||'), nl,
	write('|| 7. marketplace : menampilkan menu marketplace                               ||'), nl,
	write('||    - buy         : membeli barang yang dijual pada marketplace              ||'), nl,
	write('||    - sell        : menjual hasil budidaya                                   ||'), nl,
	write('|| 8. house       : menampilkan menu pada rumah                                ||'), nl,
	write('||    - sleep       : tidur dan perpindah waktu menjadi keesokan hari          ||'), nl,
	write('||    - writeDiary  : menulis pada diary                                       ||'), nl,
	write('||    - readDiary   : membaca tulisan pada diary                               ||'), nl,
	write('|| 9. inventory   : menampilkan isi inventory                                  ||'), nl,
	write('||    - useItem     : menggunakan item tertentu yang bisa digunakan            ||'), nl,
	write('||    - throwItem   : membuang item tertentu                                   ||'), nl,
	write('|| 10. quest       : mengambil quest jika berada pada tile quest               ||'), nl,
	write('|| 11. help        : menampilkan segala bantuan                                ||'), nl,
	write('|| 12. exitGame    : keluar dari permainan                                     ||'), nl.
