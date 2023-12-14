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
Escolhemos a seguinte heurística: ordenar os objetos e pegar sempre os maiores para por nas caixas, sempre 
avaliamos da caixa mais ocupada até a menos ocupada, se tem alguma que caiba o objeto. Ao acharmos, ele é 
posto lá, senão utiliza-se uma caixa nova. 
Mantemos um registro das caixas e dos objetos nelas da seguinte forma:

boxes[i] = caixa i = [ peso total, [id dos items]]

=#

mutable struct EmpacotamentoData
    n::Int #numero de objetos
    w::Array{Tuple{Float64, Int}} #peso de cada objeto e seu ID
end

function readData(file)
	n = 0
	w = []
	for l in eachline(file)
		q = split(l, '\t')
		num = parse(Int64, q[2])
		if q[1] == "n"
			n = num
			w = [(0.0, 0) for i=1:n]
		elseif q[1] == "o"
			num = parse(Int64, q[2]) + 1 # +1 porque as instâncias de entrada são dadas com id 0 based mas julia é 1 based
			w[num] = (parse(Float64, q[3]), parse(Int64, q[2]))
		end
	end
	return EmpacotamentoData(n,w)
end

function printSolutionDetails(data, o, c)
	for i = 1:data.n
        if value(c[i]) > 0.0
            println("caixa $i: $(value.(o[:, i]))") 
        end
	end
	println()
end

function printCertificate(b)
	for box in b
		for item in box[2]
			print("$(item)\t")
		end
		println()
	end
end

file = open(ARGS[1], "r")

data = readData(file)

sorted_objects = sort(data.w)

#boxes[i] = caixa i = [ peso total, [id dos items]]
num_boxes = 0 
boxes = [[0, []]]

while !isempty(sorted_objects)
    o = pop!(sorted_objects)
	alocated = false
	for box in boxes
		if 20 - box[1] >= o[1]
			box[1] += o[1]
			push!(box[2], o[2])
			alocated = true
			break
		end
	end
	if !alocated
		push!(boxes, [o[1],[o[2]]])
	end
end

sol = length(boxes)
println("TP2 2022425671 = ", sol)
printCertificate(boxes)

#printSolutionDetails(data, o, c)
