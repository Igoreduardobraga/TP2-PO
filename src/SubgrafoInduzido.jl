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
Neste projeto, desenvolvemos um algoritmo para encontrar um subgrafo 
induzido de peso máximo em um grafo, adotando uma estratégia gulosa. 
O algoritmo começa com um conjunto de todos os vértices e, iterativamente,
remove vértices de maneira a maximizar o peso total das arestas no subgrafo
induzido restante.

A abordagem otimizada foca em ajustes incrementais do peso total, evitando
recálculos desnecessários e garantindo uma execução mais rápida, especialmente
para grafos grandes.

=#

function LerDadosDoGrafo(caminhoDoArquivo)
    arestas = Dict()
    conjuntoDeVertices = Set()
    open(caminhoDoArquivo, "r") do f
        for linha in eachline(f)
            if startswith(linha, "n")
                continue
            elseif startswith(linha, "e")
                dados = split(linha)
                v1, v2, peso = parse(Int, dados[2]), parse(Int, dados[3]), parse(Float64, dados[4])
                arestas[(v1, v2)] = peso
                push!(conjuntoDeVertices, v1)
                push!(conjuntoDeVertices, v2)
            end
        end
    end
    return arestas, conjuntoDeVertices
end

function CalcularPesoTotal(verticesDoSubgrafo, arestas)
    pesoTotal = 0.0
    for ((v1, v2), peso) in arestas
        if v1 in verticesDoSubgrafo && v2 in verticesDoSubgrafo
            pesoTotal += peso
        end
    end
    return pesoTotal
end

function PesoAssociadoAoVertice(vertice, verticesDoSubgrafo, arestas)
    pesoAssociado = 0.0
    for ((v1, v2), peso) in arestas
        if v1 == vertice && v2 in verticesDoSubgrafo
            pesoAssociado += peso
        elseif v2 == vertice && v1 in verticesDoSubgrafo
            pesoAssociado += peso
        end
    end
    return pesoAssociado
end

function SubgrafoDePesoMaximo(arestas, vertices)
    verticesDoSubgrafo = copy(vertices)
    pesoTotal = CalcularPesoTotal(verticesDoSubgrafo, arestas)

    melhorando = true

    while melhorando
        melhorando = false
        melhorPeso = pesoTotal
        verticeParaRemover = nothing
        pesoParaRemover = 0.0

        for vertice in verticesDoSubgrafo
            pesoAssociado = PesoAssociadoAoVertice(vertice, verticesDoSubgrafo, arestas)
            novoPeso = pesoTotal - pesoAssociado
            if novoPeso > melhorPeso
                melhorPeso = novoPeso
                verticeParaRemover = vertice
                pesoParaRemover = pesoAssociado
                melhorando = true
            end
        end

        if melhorando
            verticesDoSubgrafo = setdiff(verticesDoSubgrafo, [verticeParaRemover])
            pesoTotal -= pesoParaRemover  # Apenas subtrai o peso do vértice removido
        end
    end

    return pesoTotal, verticesDoSubgrafo
end

arestas, todosOsVertices = LerDadosDoGrafo(ARGS[1]) # Lendo os dados do arquivo e obtendo o conjunto de vértices

pesoMaximo, verticesDoSubgrafo = SubgrafoDePesoMaximo(arestas, todosOsVertices) # Encontrando o maior subgrafo induzido

println("TP2 2022425671 = $pesoMaximo")

verticesOrdenados = sort(collect(verticesDoSubgrafo))
for vertice in verticesOrdenados
    print(vertice, "\t")
end
println()