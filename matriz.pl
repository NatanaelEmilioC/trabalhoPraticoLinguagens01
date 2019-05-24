ler_txt(Filename) :-  open(Filename,read,OS), get_char(OS,C), txt_to_list(C,L,OS), close(OS), print(L).

    txt_to_list(_,[],OS)  :-  at_end_of_stream(OS).
    txt_to_list(' ',L,OS)  :-  get_char(OS,Q), txt_to_list(Q,L,OS).
    txt_to_list('\n',L,OS)  :-  get_char(OS,Q), txt_to_list(Q,L,OS).
    txt_to_list(C,[C|L],OS) :- get_char(OS,Q), txt_to_list(Q,L,OS).

    posicao(0,N,[Cabeca|_],E) :- posicao_lista(N,Cabeca,E).
    posicao(M,N,[_|Cauda],E) :- M1 is M - 1, posicao(M1,N,Cauda,E).

    posicao_lista(0,[X|_],X).
    posicao_lista(N,[_|R],X) :- N1 is N - 1, posicao_lista(N1,R,X).

    /* Chegar de A a Z, retornando caminho percorrido P,comecando de um caminho vazio*/
path(A,Z,P) :- path1(A,Z,[],P).

    /* Se ja' cheguei ao destino, parar a busca e incluir destino na lista contendo o caminho percorrido */
path1(Z,Z,L,[Z|L]).

    /* Se ainda nao cheguei no destino, encontrar caminho parcial de A para Y, verificar se este caminho
   e' valido (isto e', ja' passei por Y antes?). Se for um caminho valido, adicionar `a lista contendo o
   caminho parcial e continuar a busca a partir de Y */

path1(A,Z,L,P) :- (conectado(A,Y);                  /* encontra caminho parcial */
conectado(Y,A)),                 /* de A para Y ou de Y para A */
\+ member(Y,L),                    /* verifica se ja passei por Y */
path1(Y,Z,[Y|L],P).             /* encontra caminho parcial de Y a Z */

