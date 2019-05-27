executar :- readFileSee('matriz.txt', 'novaMatriz.txt').

readFileSee(InputFile, OutputFile) :-
    seeing(OldStream),
    see(InputFile),
    tell(OutputFile),
    repeat,
    read(Term),
    ( Term == end_of_file -> true ; write(Term), fail),
    seen,
    told,
    see(OldStream).

file_to_list(FILE,LIST) :-
    see(FILE),
    inquire([],R), % gather terms from file
    reverse(R,LIST),
    seen.

inquire(IN,OUT):-
    read(Data),
    (Data == end_of_file ->   % done
    OUT = IN ;    % more
    inquire([Data|IN],OUT)).