#===========================================================
Este trabalho foi desenvolvido por:

- 2021031777 Bernardo do Nascimento Nunes
- 2021031769 Etelvina Costa Santos Sá Oliveira
- 2022425671 Igor Eduardo Martins Braga
- 2021031807 Indra Matsiendra Cardoso Dias Ribeiro

============================================================#

#=
------------
 DESCRIÇÃO:
------------
Neste projeto, implementamos um algoritmo para encontrar um conjunto independente máximo em um grafo, 
utilizando uma abordagem gulosa. O código inicia lendo um grafo a partir de um arquivo, onde o grafo é 
representado por uma estrutura de dados contendo o número de vértices e um dicionário de arestas para representar 
a lista de adjacências. 

A heurística empregada seleciona vértices com base em seus graus, priorizando aqueles com menor grau. Uma vez 
selecionado um vértice, ele é adicionado ao conjunto independente e todos os seus vizinhos são marcados como 
selecionados para evitar escolhas futuras. O processo continua até que todos os vértices sejam avaliados, 
resultando em um conjunto independente de tamanho máximo possível dado a estratégia gulosa.

=#

# Estrutura de dados para o grafo
mutable struct Grafo
    n::Int  # Número de vértices
    arestas::Dict{Int, Set{Int}}  # Lista de adjacência
end

function LerDadosDoGrafo(caminhoDoArquivo::String)::Grafo
    arestas = Dict{Int, Set{Int}}()
    n = 0
    open(caminhoDoArquivo, "r") do arquivo
        for linha in eachline(arquivo)
            elementos = split(linha)
            if elementos[1] == "n"
                n = parse(Int, elementos[2])
                for i in 1:n
                    arestas[i] = Set{Int}()
                end
            elseif elementos[1] == "e"
                v1 = parse(Int, elementos[2])
                v2 = parse(Int, elementos[3])
                push!(get(arestas, v1, Set{Int}()), v2)
                push!(get(arestas, v2, Set{Int}()), v1)
            end
        end
    end
    return Grafo(n, arestas)
end


# Função para calcular o grau ponderado de um vértice
function grauPonderado(grafo::Grafo, vertice::Int, marcados::Set{Int})
    # Pondera o grau do vértice pela quantidade de vizinhos que também não estão marcados
    return sum([!(vizinho in marcados) for vizinho in grafo.arestas[vertice]])
end

# Encontra um conjunto independente máximo usando uma heurística gulosa ponderada
function ConjuntoIndependenteGulosoPonderado(grafo::Grafo)::Set{Int}
    conjuntoIndependente = Set{Int}()
    marcados = Set{Int}()
    while length(marcados) < grafo.n
        # Escolhe o vértice com o menor grau ponderado
        verticeCandidato = -1
        grauPonderadoMinimo = typemax(Int)
        for v in 1:grafo.n
            if !(v in marcados)
                grauPond = grauPonderado(grafo, v, marcados)
                if grauPond < grauPonderadoMinimo
                    grauPonderadoMinimo = grauPond
                    verticeCandidato = v
                end
            end
        end
        # Se não encontrou nenhum vértice, então todos os vértices restantes estão marcados
        if verticeCandidato == -1
            break
        end
        # Adiciona o vértice ao conjunto independente e marca ele e seus vizinhos
        push!(conjuntoIndependente, verticeCandidato)
        union!(marcados, grafo.arestas[verticeCandidato])
        push!(marcados, verticeCandidato)
    end
    return conjuntoIndependente
end

# Carregar dados do grafo
grafo = LerDadosDoGrafo(ARGS[1])

# Encontra o conjunto independente máximo com a heurística gulosa ponderada
conjuntoIndependente = ConjuntoIndependenteGulosoPonderado(grafo)

# Imprime o conjunto independente encontrado
println("TP2 2022425671 = ", length(conjuntoIndependente))
println(join(sort(collect(conjuntoIndependente)), "\t"))