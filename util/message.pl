msg_move('W', 'You moved North.').
msg_move('A', 'You moved West.').
msg_move('S', 'You moved South.').
msg_move('D', 'You moved East.').
msg_move('E', 'Please move in other direction.').

msg_already_on('Game sudah menyala. Silahkan cek \'help\' untuk melihat list command.').
msg_already_start('Game sedang dimulai. Silahkan cek \'help\' untuk melihat list command.').
msg_not_start('Game belum dimulai. Silahkan cek \'help\' untuk melihat list command.').

msg_title :-
    write(' _   _                           _   '), nl,
    write('| | | | __ _ _ ____   _____  ___| |_ '), nl,
    write('| |_| |/ _` | \'__\\ \\ / / _ \\/ __| __|'), nl,
    write('|  _  | (_| | |   \\ V /  __/\\__ \\ |_ '), nl,
    write('|_| |_|\\__,_|_|    \\_/ \\___||___/\\__|'), nl.

msg_help :-
    game_start(false),
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

msg_help :-
    game_start(true),
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
	write('|| 10. quest      :  mengambil quest jika berada pada tile quest               ||'), nl,
	write('|| 11. help       :  menampilkan segala bantuan                                ||'), nl,
	write('|| 12. exitGame   :  keluar dari permainan                                     ||'), nl.