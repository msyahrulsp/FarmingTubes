msg_move('W', 'You moved North.').
msg_move('A', 'You moved West.').
msg_move('S', 'You moved South.').
msg_move('D', 'You moved East.').
msg_move('E', 'Can\'t move there! Please pick another direction.').

msg_on('Game sudah menyala. Silahkan cek \'help\' untuk melihat list command.').
msg_not_on('Game belum menyala. Silahkan cek \'startGame\' untuk melihat list command.').
msg_start('Game sedang dimulai. Silahkan cek \'help\' untuk melihat list command.').
msg_not_start('Game belum dimulai. Silahkan cek \'help\' untuk melihat list command.').

msg_fish_not_near('Kamu sedang tidak dekat kolam. Silahkan pergi ke dekat kolam terlebih dahulu.').

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
	write('% 1. startGame : untuk initialisasi modul game                                 %'), nl,
	write('% 2. exitGame  : mematikan game (harus initialisasi ulang)                     %'), nl,
	write('% 3. start     : untuk memulai petualanganmu                                   %'), nl,
	write('% 3. quit      : untuk keluar dari permainan                                   %'), nl,
	write('% 4. help      : menampilkan segala bantuan                                    %'), nl,
	write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl.

msg_help :-
    game_start(true),
	write('+-------------------------------------------------------------------------------+'), nl,
	write('|+-----------------------------------------------------------------------------+|'), nl,
	write('||                              ~Harvest Star~                                 ||'), nl,
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
	write('|| 12. quit       :  keluar dari permainan                                     ||'), nl,
	write('|+-----------------------------------------------------------------------------+|'), nl,
	write('+-------------------------------------------------------------------------------+'), nl.