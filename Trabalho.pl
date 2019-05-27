
%Cria uma matriz MxN qualquer com um numero predefinido
%Nr é o número de linhas da matriz
%Nc é o número de colunas da matriz
%N é o número com que a matriz é preenchida
createMatrix(0,_,_,[]).
createMatrix(Nr,Nc,N,[R|Rtail]) :- createRow(Nc,N,R), Nx is Nr-1, createMatrix(Nx,Nc,N,Rtail).
createRow(0,_,[]).
createRow(Nc,N,[N|Aux]) :- Ncaux is Nc-1, createRow(Ncaux,N,Aux).

%Recupera um elemento da matriz
%R é a linha do elemento requerido
%C é a coluna do elemento requerido
%E é o retorno(Elemento posicionado em RC)
getElement(R,C,M,E) :- nth1(R,M,Row),nth1(C,Row,E).

%Verifica se a matriz ainda não alcançou o estado final
%Pr é a linha em que o marcador se encontra
%Pc é a coluna em que o marcador se encontra
%M é a matriz que se deseja avaliar
matrixVerify(Pr,Pc,M) :- matrixVerify(Pr,Pc,1,M).
matrixVerify(Pr,Pc,Pr,[R|_]) :- rowVerify(Pc,R),!.
matrixVerify(Pr,_,I,[R|_]) :- Pr =\= I, rowVerify(-1,R),!.
matrixVerify(Pr,Pc,I,[_|Rs]) :- Ni is I+1, matrixVerify(Pr,Pc,Ni,Rs).
rowVerify(Pc,R) :- rowVerify(Pc,1,R).
rowVerify(Pc,I,[R|_]) :- Pc =\= I, R =\= -1,!.
rowVerify(Pc,I,[_|Rs]):- Ni is I+1, rowVerify(Pc,Ni,Rs).

%Insere elemento na matriz na posição Pr,Pc e retorna a nova matriz resultante
%Parâmetros: (Elemento, Pr,Pc, Matriz, NovaMatriz)
insert_matrix(_,_,_,[],[]).
insert_matrix(Elem,1,1,[[_|Xs]|M1],[[Elem|Xs1]|M2]) :- !, insert_matrix(Elem,0,0,[Xs|M1],[Xs1|M2]).
insert_matrix(Elem,0,0,[[X]|Xs],[[X]|Xs1]) :- insert_matrix(Elem,0,0,Xs,Xs1), !.
insert_matrix(Elem,0,0,[[X|Xs]|M1],[[X|Xs1]|M2]) :- insert_matrix(Elem,0,0,[Xs|M1],[Xs1|M2]).
insert_matrix(Elem,1,Pc,[[X|Xs]|M1],[[X|Xs1]|M2]) :- PcAux is Pc-1, insert_matrix(Elem,1,PcAux,[Xs|M1],[Xs1|M2]). 
insert_matrix(Elem,Pr,Pc,[Xs|M1],[Xs|M2]) :- PrAux is Pr-1, insert_matrix(Elem,PrAux,Pc,M1,M2), !.

%Confere se a posição(Pr,Pc) é uma posição válida para a matriz
%Pr é a linha
%Pc é a coluna
%M é a matriz
isValidPosition(Pr,Pc,M) :- length(M,PrMax),
                            Pr =< PrMax,
                            Pr > 0,
                            nth1(1,M,FirstRow),
                            length(FirstRow,PcMax),
                            Pc =< PcMax,
                            Pc > 0,
                            getElement(Pr,Pc,M,Elem),
                            Elem >= 0.

%Move para baixo
moveDown(Pr,Pc,M,Cs) :- PrNext is Pr+1,
                        isValidPosition(PrNext,Pc,M),
                        getElement(Pr,Pc,M,Elem),  
                        Eaux is Elem - 1,    
                        insert_matrix(Eaux,Pr,Pc,M,Mod),!,
                        move(PrNext,Pc,Mod,Cs).
%Move para direita  
moveRight(Pr,Pc,M,Cs) :- PcNext is Pc+1,
                         isValidPosition(Pr,PcNext,M),
                         getElement(Pr,Pc,M,Elem),
                         Eaux is Elem - 1,    
                         insert_matrix(Eaux,Pr,Pc,M,Mod),!,
                         move(Pr,PcNext,Mod,Cs).
%Move para cima
moveUp(Pr,Pc,M,Cs) :- PrNext is Pr-1,
                      isValidPosition(PrNext,Pc,M),    
                      getElement(Pr,Pc,M,Elem),
                      Eaux is Elem - 1,    
                      insert_matrix(Eaux,Pr,Pc,M,Mod),!,
                      move(PrNext,Pc,Mod,Cs).
%Move para esquerda
moveLeft(Pr,Pc,M,Cs) :- PcNext is Pc-1,
                        isValidPosition(Pr,PcNext,M),
                        getElement(Pr,Pc,M,Elem),
                        Eaux is Elem - 1,    
                        insert_matrix(Eaux,Pr,Pc,M,Mod),!,                                 
                        move(Pr,PcNext,Mod,Cs).

move(Pr,Pc,M,["End"]) :- \+matrixVerify(Pr,Pc,M).
move(Pr,Pc,M,["Down"|C]) :- moveDown(Pr,Pc,M,C).
move(Pr,Pc,M,["Right"|C]) :- moveRight(Pr,Pc,M,C).
move(Pr,Pc,M,["Up"|C]) :- moveUp(Pr,Pc,M,C).
move(Pr,Pc,M,["Left"|C]) :- moveLeft(Pr,Pc,M,C).

%Predicado para iniciar o jogo
%R é o número de linhas da matriz
%C é o número de colunas da matriz
%N é o número com que a matriz inicial será preenchida
%Ri é a linha da posição inicial do jogador
%Ci é a coluna da posição inicial do jogador
%Ways são os caminhos encontrados

jogar(R,C,N,Ri,Ci,Ways) :- createMatrix(R,C,N,M),!,move(Ri,Ci,M,Ways).           