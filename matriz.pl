/*
Natanael Emilio da Costa 16.1.8298
Trabalho Prático I - Linguagens de Programação*/

/*
- Para executar o programa basta chamar o cláusula executar([[],[]] , X , Y). 
passando uma matriz ,  uma posicao inicial dada por X = linha e Y = coluna.

- O programa irá gerar um arquivo chamado 'saida.txt' ,  onde salvará todos os caminhos possivel para a matriz
passada como termo. Caso o arquivo já exista ele irá sobrescrever.

- Será apresentado no terminal o numero de caminhos encontrado para verificação da acertividade do algoritmo.
*/

%cláusula principal para executar a aplicação recebendo:
%uma matriz ,  a linha inicial ,  a coluna inicial e retornando em um vetor com os passos
executar(Matriz , LinhaI , ColunaI) :-
    verificaArquivo('saida.txt') ,          %verifica se o arquivo de saida já existe
    gravaEmArquivo((findall(Caminhos , mover(LinhaI , ColunaI , Matriz , Caminhos) , C) , ! ,    %constroi um vetor com todas as possibilidades de caminho
    length(C ,  T) ,                        %pega o tamanho do vetor ,  contabilizando a quantidade de caminhos resultantes
    escreveLista(C)) ,                      %escreve no arquivo o vetor contendo todos os caminhos
    'saida.txt') ,                          %passa o arquivo a ser escrito
    write('Quantidade de caminhos encontrada: ') , 
    write(T).

%cláusula que receber a cláusula principal do programa e um arquivo de saida para ser escrito 
gravaEmArquivo(ExecusaoPrincipal ,  Arquivo) :-
    seeing(Fluxo) ,               %fecha o fluxo atual
    tell(Arquivo) ,               %abre o arquivo
    ExecusaoPrincipal ,           %executa a cláusula principal
    told ,                        %fecha o fluxo de escrita
    see(Fluxo).                   %reabre o fluxo anterior 

%cláusulas para movimentar na matriz verificando as possilidades de caminho
mover( _ , _ , Matriz , [".."]) :- 
    verificaFinal(Matriz).      %verifica se a matriz apresenta estado final.
mover(Linha , Coluna , Matriz , ["Direita"|Caminho]) :- 
    moverDireita(Linha , Coluna , Matriz , Caminho).
mover(Linha , Coluna , Matriz , ["Embaixo"|Caminho]) :- 
    moverBaixo(Linha , Coluna , Matriz , Caminho).
mover(Linha , Coluna , Matriz , ["Esquerda"|Caminho]) :- 
    moverEsquerda(Linha , Coluna , Matriz , Caminho). 
mover(Linha , Coluna , Matriz , ["Cima"|Caminho]) :- 
    moverCima(Linha , Coluna , Matriz , Caminho).

% verifica o estado da matriz, 
% sendo que o estado final pode ser representado como a soma dos elementos da matriz -1
% comparado com o tamanho da matriz negativado ((linhas * colunas) * -1).
verificaFinal([M|Matriz]) :- 
    somaMatriz([M|Matriz], Valor) , 
    length([M|Matriz], NLinhas) , 
    length(M, NColunas),
    TamanhoMatriz is NColunas*NLinhas,
    Valor is ((TamanhoMatriz-1)*(-1)).

%calcula a soma dos elementos de uma matriz
somaMatriz([] , 0).
somaMatriz([M|Matriz] , Valor) :- somaMatriz(Matriz, V1) , somaLinha(M, V2) , Valor is V1+V2. 

%calcula a soma dos elementos de uma linha
somaLinha([] , 0).
somaLinha([X|Xs], R) :- somaLinha(Xs, V) , R is X+V.

%Recupera um elemento da matriz que é o retorno(Elemento posicionado em Linha/Coluna)
pegaElemento(Linha , Coluna , Matriz , Elemento) :- 
    verificaPosicao(Linha , Matriz , ColunaAux) , 
    verificaPosicao(Coluna , ColunaAux , Elemento).

%Da verdadeiro caso o elemento pertenca a lista contando apartir da posição 1.
verificaPosicao(1 , [Elemento|_] , Elemento) :- !.
verificaPosicao(Indice , [_|Lista] , Elemento) :-
    Indice > 1 , 
    Indice1 is Indice-1 , 
    verificaPosicao(Indice1 , Lista , Elemento).

%Insere elemento na matriz na posição Linha , Coluna e retorna a nova matriz sendo os parâmetros: (Elemento ,  Linha , Coluna ,  Matriz ,  NovaMatriz)
inserirMatriz(_ , _ , _ , [] , []).
inserirMatriz(Elemento , 1 , 1 , [[_|Cauda]|Matriz1] , [[Elemento|CaudaAux]|Matriz2]) :- ! ,  
    inserirMatriz(Elemento , 0 , 0 , [Cauda|Matriz1] , [CaudaAux|Matriz2]).
inserirMatriz(Elemento , 0 , 0 , [[Cabeca]|Cauda] , [[Cabeca]|CaudaAux]) :- 
    inserirMatriz(Elemento , 0 , 0 , Cauda , CaudaAux) ,  !.
inserirMatriz(Elemento , 0 , 0 , [[Cabeca|Cauda]|Matriz1] , [[Cabeca|CaudaAux]|Matriz2]) :- 
    inserirMatriz(Elemento , 0 , 0 , [Cauda|Matriz1] , [CaudaAux|Matriz2]).
inserirMatriz(Elemento , 1 , Coluna , [[Cabeca|Cauda]|Matriz1] , [[Cabeca|CaudaAux]|Matriz2]) :- 
    ProximaNaColunaAux is Coluna-1 ,  
    inserirMatriz(Elemento , 1 , ProximaNaColunaAux , [Cauda|Matriz1] , [CaudaAux|Matriz2]). 
inserirMatriz(Elemento , Linha , Coluna , [Cauda|Matriz1] , [Cauda|Matriz2]) :- 
    ProximaNaLinhaAux is Linha-1 ,  
    inserirMatriz(Elemento , ProximaNaLinhaAux , Coluna , Matriz1 , Matriz2) ,  !.

%Verifica se a posição linha/coluna está dentro dos limites da matriz
posicaoValida(Linha , Coluna , Matriz) :- 
                            length(Matriz , PrMax) , 
                            Linha =< PrMax , 
                            Linha > 0 , 
                            nth1(1 , Matriz , FirstColuna) , 
                            length(FirstColuna , PcMax) , 
                            Coluna =< PcMax , 
                            Coluna > 0 , 
                            pegaElemento(Linha , Coluna , Matriz , Elemento) , 
                            Elemento >= 0.

%cláusula para mover para cima
moverCima(Linha , Coluna , Matriz , Resposta) :- 
                        ProximaPosicaoNaLinha is Linha-1 , 
                        posicaoValida(ProximaPosicaoNaLinha , Coluna , Matriz) ,     
                        pegaElemento(Linha , Coluna , Matriz , Elemento) , 
                        ElementoAuxiliar is Elemento - 1 ,     
                        inserirMatriz(ElementoAuxiliar , Linha , Coluna , Matriz , Modificado) , 
                        ! , 
                        mover(ProximaPosicaoNaLinha , Coluna , Modificado , Resposta).

%cláusula para mover para esquerda
moverEsquerda(Linha , Coluna , Matriz , Resposta) :- 
                        ProximaPosicaoNaColuna is Coluna-1 , 
                        posicaoValida(Linha , ProximaPosicaoNaColuna , Matriz) , 
                        pegaElemento(Linha , Coluna , Matriz , Elemento) , 
                        ElementoAuxiliar is Elemento - 1 ,     
                        inserirMatriz(ElementoAuxiliar , Linha , Coluna , Matriz , Modificado) , 
                        ! ,                                  
                        mover(Linha , ProximaPosicaoNaColuna , Modificado , Resposta).

%cláusula para mover para direita  
moverDireita(Linha , Coluna , Matriz , Resposta) :- 
                        ProximaPosicaoNaColuna is Coluna+1 , 
                        posicaoValida(Linha , ProximaPosicaoNaColuna , Matriz) , 
                        pegaElemento(Linha , Coluna , Matriz , Elemento) , 
                        ElementoAuxiliar is Elemento - 1 ,     
                        inserirMatriz(ElementoAuxiliar , Linha , Coluna , Matriz , Modificado) , 
                        ! , 
                        mover(Linha , ProximaPosicaoNaColuna , Modificado , Resposta).

%cláusula para mover para baixo
moverBaixo(Linha , Coluna , Matriz , Resposta) :- 
                        ProximaPosicaoNaLinha is Linha+1 , 
                        posicaoValida(ProximaPosicaoNaLinha , Coluna , Matriz) , 
                        pegaElemento(Linha , Coluna , Matriz , Elemento) ,   
                        ElementoAuxiliar is Elemento - 1 ,     
                        inserirMatriz(ElementoAuxiliar , Linha , Coluna , Matriz , Modificado) , 
                        ! , 
                        mover(ProximaPosicaoNaLinha , Coluna , Modificado , Resposta).

%cláusula para escrever a lista em arquivo incluindo espaço entre os elementos
escreveLista([]).
escreveLista([Cabeca|Cauda]):- 
    write(Cabeca) ,  nl ,  
    escreveLista(Cauda).

%verifica se o arquivo de saida existe caso não exista ele cria um novo
verificaArquivo(Arquivo):- 
    exists_file(Arquivo) ; 
    append('saida.txt').

%cláusula para testar o programa
executarTeste :- executar([[2 , 3, 1 ] , [1 , 1, 1 ],[1 , 1, 1 ] ] , 1 , 1).
