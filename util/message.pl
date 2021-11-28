msg_move('W', 'You moved North.').
msg_move('A', 'You moved West.').
msg_move('S', 'You moved South.').
msg_move('D', 'You moved East.').
msg_move('E', 'Please move in other direction.').

msg_not_start('Game belum dimulai. Silahkan cek \'help\' untuk melihat list command.').

msg_title :-
    write(' _   _                           _   '), nl,
    write('| | | | __ _ _ ____   _____  ___| |_ '), nl,
    write('| |_| |/ _` | \'__\\ \\ / / _ \\/ __| __|'), nl,
    write('|  _  | (_| | |   \\ V /  __/\\__ \\ |_ '), nl,
    write('|_| |_|\\__,_|_|    \\_/ \\___||___/\\__|'), nl.