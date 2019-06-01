mover(Linha,Coluna,Matriz,[".."]) :- \+verificaMatriz(Linha,Coluna,Matriz).
mover(Linha,Coluna,Matriz,["Embaixo"|C]) :- moverBaixo(Linha,Coluna,Matriz,C).
mover(Linha,Coluna,Matriz,["Direita"|C]) :- moverDireita(Linha,Coluna,Matriz,C).
mover(Linha,Coluna,Matriz,["Cima"|C]) :- moverCima(Linha,Coluna,Matriz,C).
mover(Linha,Coluna,Matriz,["Esquerda"|C]) :- moverEsquerda(Linha,Coluna,Matriz,C). 

%Recupera um elemento da matriz
%Elemento é o retorno(Elemento posicionado em LinhaColuna)
pegaElemento(Linha,Coluna,Matriz,Elemento) :- nth1(Linha,Matriz,ColunaAux),nth1(Coluna,ColunaAux,Elemento).

%Insere elemento na matriz na posição Linha,Coluna e retorna a nova matriz resultante
%Parâmetros: (Elemento, Linha,Coluna, Matriz, NovaMatriz)
inserirMatriz(_,_,_,[],[]).
inserirMatriz(Elemento,1,1,[[_|Cauda]|Matriz1],[[Elemento|CaudaAux]|Matriz2]) :- !, inserirMatriz(Elemento,0,0,[Cauda|Matriz1],[CaudaAux|Matriz2]).
inserirMatriz(Elemento,0,0,[[Cabeca]|Cauda],[[Cabeca]|CaudaAux]) :- inserirMatriz(Elemento,0,0,Cauda,CaudaAux), !.
inserirMatriz(Elemento,0,0,[[Cabeca|Cauda]|Matriz1],[[Cabeca|CaudaAux]|Matriz2]) :- inserirMatriz(Elemento,0,0,[Cauda|Matriz1],[CaudaAux|Matriz2]).
inserirMatriz(Elemento,1,Coluna,[[Cabeca|Cauda]|Matriz1],[[Cabeca|CaudaAux]|Matriz2]) :- ProximaNaColunaAux is Coluna-1, inserirMatriz(Elemento,1,ProximaNaColunaAux,[Cauda|Matriz1],[CaudaAux|Matriz2]). 
inserirMatriz(Elemento,Linha,Coluna,[Cauda|Matriz1],[Cauda|Matriz2]) :- ProximaNaLinhaAux is Linha-1, inserirMatriz(Elemento,ProximaNaLinhaAux,Coluna,Matriz1,Matriz2), !.


%Verifica se a matriz ainda não alcançou o estado final
%Linha é a linha em que o marcador se encontra
%Coluna é a coluna em que o marcador se encontra
verificaMatriz(Linha,Coluna,Matriz) :- verificaMatriz(Linha,Coluna,1,Matriz).
verificaMatriz(Linha,Coluna,Linha,[L|_]) :- verificaColuna(Coluna,L),!.
verificaMatriz(Linha,_,Indice,[L|_]) :- Linha =\= Indice, verificaColuna(-1,L),!.
verificaMatriz(Linha,Coluna,Indice,[_|Cauda]) :- ProximoIndice is Indice+1, verificaMatriz(Linha,Coluna,ProximoIndice,Cauda).
verificaColuna(Coluna,L) :- verificaColuna(Coluna,1,L).
verificaColuna(Coluna,Indice,[L|_]) :- Coluna =\= Indice, L =\= -1,!.
verificaColuna(Coluna,Indice,[_|Cauda]):- ProximoIndice is Indice+1, verificaColuna(Coluna,ProximoIndice,Cauda).

%Confere se a posição(Linha,Coluna) é uma posição válida para a matriz
posicaoValida(Linha,Coluna,Matriz) :- length(Matriz,PrMax),
                            Linha =< PrMax,
                            Linha > 0,
                            nth1(1,Matriz,FirstColuna),
                            length(FirstColuna,PcMax),
                            Coluna =< PcMax,
                            Coluna > 0,
                            pegaElemento(Linha,Coluna,Matriz,Elemento),
                            Elemento >= 0.

%mover para baixo
moverBaixo(Linha,Coluna,Matriz,Cs) :- ProximaPosicaoNaLinha is Linha+1,
                        posicaoValida(ProximaPosicaoNaLinha,Coluna,Matriz),
                        pegaElemento(Linha,Coluna,Matriz,Elemento),  
                        ElementoAuxiliar is Elemento - 1,    
                        inserirMatriz(ElementoAuxiliar,Linha,Coluna,Matriz,Modificado),!,
                        mover(ProximaPosicaoNaLinha,Coluna,Modificado,Cs).
%mover para direita  
moverDireita(Linha,Coluna,Matriz,Cs) :- ProximaPosicaoNaColuna is Coluna+1,
                         posicaoValida(Linha,ProximaPosicaoNaColuna,Matriz),
                         pegaElemento(Linha,Coluna,Matriz,Elemento),
                         ElementoAuxiliar is Elemento - 1,    
                         inserirMatriz(ElementoAuxiliar,Linha,Coluna,Matriz,Modificado),!,
                         mover(Linha,ProximaPosicaoNaColuna,Modificado,Cs).
%mover para cima
moverCima(Linha,Coluna,Matriz,Cs) :- ProximaPosicaoNaLinha is Linha-1,
                      posicaoValida(ProximaPosicaoNaLinha,Coluna,Matriz),    
                      pegaElemento(Linha,Coluna,Matriz,Elemento),
                      ElementoAuxiliar is Elemento - 1,    
                      inserirMatriz(ElementoAuxiliar,Linha,Coluna,Matriz,Modificado),!,
                      mover(ProximaPosicaoNaLinha,Coluna,Modificado,Cs).
%mover para esquerda
moverEsquerda(Linha,Coluna,Matriz,Cs) :- ProximaPosicaoNaColuna is Coluna-1,
                        posicaoValida(Linha,ProximaPosicaoNaColuna,Matriz),
                        pegaElemento(Linha,Coluna,Matriz,Elemento),
                        ElementoAuxiliar is Elemento - 1,    
                        inserirMatriz(ElementoAuxiliar,Linha,Coluna,Matriz,Modificado),!,                                 
                        mover(Linha,ProximaPosicaoNaColuna,Modificado,Cs).

executar(Matriz,LinhaI,ColunaI,Caminhos) :-
    soGravaEmArquivo((findall(Caminhos,mover(LinhaI,ColunaI,Matriz,Caminhos),C),
    !,
    length(C, T), 
    write(C), 
    write(T)),
    'novaMatriz.txt').

soGravaEmArquivo(Procedimento,'novaMatriz.txt') :-
    seeing(Fluxo),
    tell('novaMatriz.txt'),
    Procedimento,
    told,
    see(Fluxo).

/*
executar :- leArquivos('matriz.txt', 'novaMatriz.txt').

leArquivos(Entrada, Saida) :-
    seeing(Fluxo),
    see(Entrada),
    tell(Saida),
    repeat,
    read(Term),
    ( Term == end_of_file -> true ; Term, fail),
    seen,
    told,
    see(Fluxo).*/