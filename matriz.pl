principal:-
    open('C:/Users/natan/OneDrive/Documents/GitHub/trabalhoPraticoLinguagens01/casas.txt',read,F),
    read(F,C1),
    read(F,C2),  
    read(F,C3),
    read(F,C4),
    close(F),
    write([C1,C2,C3,C4]), nl.


programa :-
open('casas.txt', read, X),
current_input(Stream),
set_input(X),
codigo_propriamente_dito,
set_input(Stream),
close(X).
