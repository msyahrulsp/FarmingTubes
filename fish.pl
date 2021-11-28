:- dynamic(miss/1).
:- dynamic(chance/2).

fish_type(1,'C fish').
fish_type(2,'B fish').
fish_type(3,'A fish').
fish_type(4,'S fish').

chance(1,0.5).
chance(2,0.1).
chance(3,0.05).
chance(4,0).

miss(0).

%sekalian jadi cheatcode
set_miss(X) :-
    retract(miss(_)),
    asserta(miss(X)).

fish :-
    random(R),
    (   miss(M), 
        chance(4,C),
        C > 0,
        M = 50
    ->  write('You got '),
        fish_type(4, Fish),
        write(Fish),
        nl,
        set_miss(0)
    ;(   chance(4,C), R =< C
    ->  write('You got '),
        fish_type(4, Fish),
        write(Fish),
        nl,
        set_miss(0)
    ;(  chance(3,C), R =< C
    ->  write('You got '),
        fish_type(3,Fish),
        write(Fish),
        nl,
        miss(X),
        Y is X+1,
        set_miss(Y)
    ;(  chance(2,C), R =< C
    ->  write('You got '),
        fish_type(2,Fish),
        write(Fish),
        nl,
        miss(X),
        Y is X+1,
        set_miss(Y)
    ;(  chance(1,C), R =< C
    ->  write('You got '),
        fish_type(1,Fish),
        write(Fish),
        nl,
        miss(X),
        Y is X+1,
        set_miss(Y)
    ;   write('You got nothing!'),nl,
        miss(X),
        Y is X+1,
        set_miss(Y)))))), 
        miss(A), 
        write('Missed S Fish : '), write(A). %ini ga perlu ditampilin ga sih?

% dipanggil kalo level fishing naik
increase_chance_level :-
    chance(1,C1),
    chance(2,C2),
    chance(3,C3),
    chance(4,C4),
    Chance1 is C1 + (1 - C1)*0.2,
    Chance2 is C2 + (1 - C2)*0.1,
    Chance3 is C3 + (1 - C3)*0.05,
    Chance4 is C4 + (1 - C4)*0.01,
    retractall(chance(_,_)),
    assertz(chance(1,Chance1)),
    assertz(chance(2,Chance2)),
    assertz(chance(3,Chance3)),
    assertz(chance(4,Chance4)),
    write('Chance C Fish increased from '), format('~2f',[C1]), write(' to '), format('~2f~n',[Chance1]),
    write('Chance B Fish increased from '), format('~2f',[C2]), write(' to '), format('~2f~n',[Chance2]),
    write('Chance A Fish increased from '), format('~2f',[C3]), write(' to '), format('~2f~n',[Chance3]),
    write('Chance S Fish increased from '), format('~2f',[C4]), write(' to '), format('~2f~n',[Chance4]).