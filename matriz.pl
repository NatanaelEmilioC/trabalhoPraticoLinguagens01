%Recupera um elemento da matriz
%R é a linha do elemento requerido
%C é a coluna do elemento requerido
%E é o retorno(Elemento posicionado em RC)
pegaElemento(R,C,Matriz,E) :- nth1(R,Matriz,Coluna),nth1(C,Coluna,E).

%Verifica se a matriz ainda não alcançou o estado final
%Linha é a linha em que o marcador se encontra
%Coluna é a coluna em que o marcador se encontra

verificaMatriz(Linha,Coluna,Matriz) :- verificaMatriz(Linha,Coluna,1,Matriz).
verificaMatriz(Linha,Coluna,Linha,[R|_]) :- verificaColuna(Coluna,R),!.
verificaMatriz(Linha,_,I,[R|_]) :- Linha =\= I, verificaColuna(-1,R),!.
verificaMatriz(Linha,Coluna,I,[_|Rs]) :- Ni is I+1, verificaMatriz(Linha,Coluna,Ni,Rs).
verificaColuna(Coluna,R) :- verificaColuna(Coluna,1,R).
verificaColuna(Coluna,I,[R|_]) :- Coluna =\= I, R =\= -1,!.
verificaColuna(Coluna,I,[_|Rs]):- Ni is I+1, verificaColuna(Coluna,Ni,Rs).

%Insere elemento na matriz na posição Linha,Coluna e retorna a nova matriz resultante
%Parâmetros: (Elemento, Linha,Coluna, Matriz, NovaMatriz)
inserirMatriz(_,_,_,[],[]).
inserirMatriz(Elemento,1,1,[[_|Xs]|M1],[[Elemento|Xs1]|M2]) :- !, inserirMatriz(Elemento,0,0,[Xs|M1],[Xs1|M2]).
inserirMatriz(Elemento,0,0,[[X]|Xs],[[X]|Xs1]) :- inserirMatriz(Elemento,0,0,Xs,Xs1), !.
inserirMatriz(Elemento,0,0,[[X|Xs]|M1],[[X|Xs1]|M2]) :- inserirMatriz(Elemento,0,0,[Xs|M1],[Xs1|M2]).
inserirMatriz(Elemento,1,Coluna,[[X|Xs]|M1],[[X|Xs1]|M2]) :- PcAux is Coluna-1, inserirMatriz(Elemento,1,PcAux,[Xs|M1],[Xs1|M2]). 
inserirMatriz(Elemento,Linha,Coluna,[Xs|M1],[Xs|M2]) :- PrAux is Linha-1, inserirMatriz(Elemento,PrAux,Coluna,M1,M2), !.

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
moverBaixo(Linha,Coluna,Matriz,Cs) :- PrNext is Linha+1,
                        posicaoValida(PrNext,Coluna,Matriz),
                        pegaElemento(Linha,Coluna,Matriz,Elemento),  
                        Eaux is Elemento - 1,    
                        inserirMatriz(Eaux,Linha,Coluna,Matriz,Mod),!,
                        mover(PrNext,Coluna,Mod,Cs).
%mover para direita  
moverDireita(Linha,Coluna,Matriz,Cs) :- PcNext is Coluna+1,
                         posicaoValida(Linha,PcNext,Matriz),
                         pegaElemento(Linha,Coluna,Matriz,Elemento),
                         Eaux is Elemento - 1,    
                         inserirMatriz(Eaux,Linha,Coluna,Matriz,Mod),!,
                         mover(Linha,PcNext,Mod,Cs).
%mover para cima
moverCima(Linha,Coluna,Matriz,Cs) :- PrNext is Linha-1,
                      posicaoValida(PrNext,Coluna,Matriz),    
                      pegaElemento(Linha,Coluna,Matriz,Elemento),
                      Eaux is Elemento - 1,    
                      inserirMatriz(Eaux,Linha,Coluna,Matriz,Mod),!,
                      mover(PrNext,Coluna,Mod,Cs).
%mover para esquerda
moverEsquerda(Linha,Coluna,Matriz,Cs) :- PcNext is Coluna-1,
                        posicaoValida(Linha,PcNext,Matriz),
                        pegaElemento(Linha,Coluna,Matriz,Elemento),
                        Eaux is Elemento - 1,    
                        inserirMatriz(Eaux,Linha,Coluna,Matriz,Mod),!,                                 
                        mover(Linha,PcNext,Mod,Cs).

mover(Linha,Coluna,Matriz,[".."]) :- \+verificaMatriz(Linha,Coluna,Matriz).
mover(Linha,Coluna,Matriz,["Embaixo"|C]) :- moverBaixo(Linha,Coluna,Matriz,C).
mover(Linha,Coluna,Matriz,["Direita"|C]) :- moverDireita(Linha,Coluna,Matriz,C).
mover(Linha,Coluna,Matriz,["Cima"|C]) :- moverCima(Linha,Coluna,Matriz,C).
mover(Linha,Coluna,Matriz,["Esquerda"|C]) :- moverEsquerda(Linha,Coluna,Matriz,C). 

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