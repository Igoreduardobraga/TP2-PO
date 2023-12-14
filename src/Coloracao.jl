#===========================================================
Este trabalho foi feito por:

- 2021031777 Bernardo do Nascimento Nunes
- 2021031769 Etelvina Costa Santos Sá Oliveira
- 2022425671 Igor Eduardo Martins Braga
- 2021031807 Indra Matsiendra Cardoso Dias Ribeiro

============================================================#

# Para a implementação resolução do problema de busca local foi implementada a heurística de busca local, 
# que realiza permutações na soluções inicial dada por algoritmo guloso. Desse modo foi definido um número fixo 
# de 1000 iterações e a cada uma delas trocamos as cores de dois vértices escolhidos aleatóriamente 
# e verificamos se a nova solução encontrada é valida e se é melhor ou igual a solução atual.


mutable struct ColoracaoGrafosData
	n::Int # número de vértices
	ng::Array{Array{Int}} # lista de adjacencias
end

function readData(file)
	n = 0
	arestas = [[]]
       
	for l in eachline(file) 
		q = split(l, "\t")
		if q[1] == "n"
			n = parse(Int64, q[2])
			arestas = [[] for i=1:n]
		elseif q[1] == "e"
			u = parse(Int64, q[2])
			v = parse(Int64, q[3])
			push!(arestas[v], u)
			push!(arestas[u], v)
		end
	end

	return ColoracaoGrafosData(n, arestas)

end

# algoritmo para fornecer a solução inicial da busca local
function algoritmoGuloso(data)
  coloracao = [0 for i in 1:data.n]

  for v in 1:data.n
    coloracaoVizinhos = [coloracao[u] for u in data.ng[v]]
    cor = 1

    while cor in coloracaoVizinhos
      cor+=1
    end

    coloracao[v] = cor
  end
  
  return coloracao
end

# criação das permutações alterando a coloração de dois vértices por vez
function swap(coloracao, data)
  novaColoracao = copy(coloracao)

  v1 = rand(1:data.n)
  v2 = rand(1:data.n)

  while v1 == v2
    v2 = rand(1:data.n)
  end

  novaCor1 = rand(1:maximum(coloracao))
  novaCor2 = rand(1:maximum(coloracao))

  novaColoracao[v1] = novaCor1
  novaColoracao[v2] = novaCor2

  while (novaColoracao in solucoesAvaliadas) && !(isValid(novaColoracao, data))
    novaCor1 = rand(1:maximum(coloracao))
    novaCor2 = rand(1:maximum(coloracao))
  
    novaColoracao[v1] = novaCor1
    novaColoracao[v2] = novaCor2
  end

  return novaColoracao
end

function isValid(coloracao, data)
  for i in data.n 
    for j in data.ng[i]
      if coloracao[i] == coloracao[j]
        return false
      end
    end
  end

  return true
end

function avaliaSolucao(coloracao)
  coresDistintas = unique(coloracao)
  numeroCores = length(coresDistintas)

  return numeroCores
end

function buscaLocal(data, iteracoes)
  coloracao = algoritmoGuloso(data)

  avaliacaoAtual = avaliaSolucao(coloracao)

  push!(solucoesAvaliadas, coloracao)

  for i in 1:iteracoes
    novaColoracao = swap(coloracao, data)
    novaAvaliacao = avaliaSolucao(coloracao)

    if novaAvaliacao <= avaliacaoAtual
      coloracao = copy(novaColoracao)
      avaliacaoAtual = novaAvaliacao
      push!(solucoesAvaliadas, coloracao)
    end
  end

  return coloracao, avaliacaoAtual
end

function certificado(coloracao, avaliacao)
  print("TP2 2022425671 = ")
  println("$(avaliacao)")
  for i in 1:avaliacao
    for j in 1:data.n
      if coloracao[j] == i
        print("$(j)\t")
      end
    end
    println("")
  end
end

file = open(ARGS[1], "r")

solucoesAvaliadas = []

data = readData(file)

coloracao, avaliacao = buscaLocal(data, 1000)

certificado(coloracao, avaliacao)