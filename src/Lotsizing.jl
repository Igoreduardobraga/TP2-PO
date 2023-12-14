#===========================================================
Este trabalho foi feito por:

- 2021031777 Bernardo do Nascimento Nunes
- 2021031769 Etelvina Costa Santos Sá Oliveira
- 2022425671 Igor Eduardo Martins Braga
- 2021031807 Indra Matsiendra Cardoso Dias Ribeiro

============================================================#

#=
------------
 DESCRIÇÃO:
------------
Nunca se produz, estoca e paga multa para a mesma demanda di, pois, ou ela é produzida no mesmo dia e, assim, 
completamnete consumida; ou ela pode ser feita com antecedência num dia j pagando-se o preço de produzir em j
mais o preço de estocar em cada um dos dias de j até i; ou ela pode 

Vale ressaltar que, se vale mais a pena produzir uma unidade da demanda di no dia j ao invés de i, então vale
a pena produzir todas as unidades nesse dia, ou seja, nunca vai ter um caso em que uma demanda é parcialmente
produzida em um dia e a outra parte em outro dia.

É importante destacar, também, que pode ser que uma demanda do dia i seja passada pro dia j, e a do dia j para 
outro dia k, mas ainda com a demanda i sendo produzida em j, ou seja, não é porque a demanda dj é produzida em 
k que não vale a pena produzir nada em j. Isso é possível porque os custos de produção em i podem ser tão altos
que valha mais a pena produzir em j pagando multa, mas se passasse para k a multa ficaria tão grande que não 
valeria mais a pena.

Portanto, nossa solução O(n²) foi comparar cada dia i com todos os demais dias verificando qual era o melhor dia
para produzir a demanda di. Uma vez atribuído o dia não é necessário reavaliar caso mais coisas sejam postas para
produção naquele mesmo dia, conforme explicado no paragrafo 3 acima.

=#

mutable struct LotsizingComBacklogData
    n::Int #número de vértices do grafo
    c::Array{Float64} #custo de produção no dia i
    d::Array{Float64} #demanda no dia i
    s::Array{Float64} #custo de armazenamento no dia i para o dia i+1
    p::Array{Float64} #penalidade/multa pelo atraso por unidade do produto não entregue no dia i para o dia i+1
end

function readData(file)
	n = 0
	c = []
	d = []
	s = []
	p = []
	for l in eachline(file)
		q = split(l, '\t')
		num = parse(Int64, q[2])
		if q[1] == "n"
			n = num
			c = [0.0 for i=1:n]
			d = [0.0 for i=1:n]
			s = [0.0 for i=1:n]
			p = [0.0 for i=1:n]
		elseif q[1] == "c"
			c[num] = parse(Float64, q[3])
		elseif q[1] == "d"
			d[num] = parse(Float64, q[3])
		elseif q[1] == "s"
			s[num] = parse(Float64, q[3])
		elseif q[1] == "p"
			p[num] = parse(Float64, q[3])
		end
	end
	return LotsizingComBacklogData(n,c,d,s,p)
end

function printSolutionDetails(data, p)
	for i = 1:data.n
            println("Produção no periodo $i: $(trunc(Int,p[i]))") 
	end
end

function printCertificate(p)
	for prod in p 
		print("$(prod)\t")
	end
	println()
end

file = open(ARGS[1], "r")

data = readData(file)

production = [0.0 for i=1:data.n]
total_cost = 0.0

#verifica para cada um dos dias com demanda di se valia mais a pena suprir a demanda desse dia produzindo antes, e 
#assim estocando, ou depois, pagando a multa pra cada dia atrasado, ou no próprio dia i 
for i=1:data.n
	s_cost = 0.0
	p_cost = data.p[i]
	cur_cost = data.d[i]*data.c[i]
	day = i
	#escolhendo se vale a pena estocar
	if i>1
		for j=i-1:-1:1
			s_cost += data.s[j]
			if cur_cost >= data.d[i]*data.c[j] + data.d[i]*s_cost
				cur_cost = data.d[i]*data.c[j] + data.d[i]*s_cost
				day = j
			end
		end
	end

	#escolhendo se vale a pena atrasar
	if i<data.n
		for j=i+1:data.n
			if cur_cost > data.d[i]*data.c[j]+data.d[i]*p_cost
				cur_cost = data.d[i]*data.c[j]+data.d[i]*p_cost
				day = j
			end
			p_cost+=data.p[j]
		end
	end

	global production[day] += data.d[i]
	global total_cost += cur_cost
end



println("TP2 2022425671 = ", total_cost)
printCertificate(production)


#printSolutionDetails(data, production)