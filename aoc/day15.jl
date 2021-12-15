using DelimitedFiles
#test = zeros(12,12)
#test[2:11,2:11] = [1 1 6 3 7 5 1 7 4 2
#        1 3 8 1 3 7 3 6 7 2
#        2 1 3 6 5 1 1 3 2 8
#        3 6 9 4 9 3 1 5 6 9
#        7 4 6 3 4 1 7 1 1 1
#        1 3 1 9 1 2 8 1 3 7
#        1 3 5 9 9 1 2 4 2 1
#        3 1 2 5 4 2 1 6 3 9
#        1 2 9 3 1 3 8 5 2 1
#        2 3 1 1 9 4 4 5 8 1]
data = readdlm("aoc/day15.txt")
test = zeros(502,502)
for i = 0:4, j=0:4
    test[(2:101) .+ 100i, (2:101) .+ 100j] = data .+ i .+ j
end
test
for i = 1:size(test,1), j=1:size(test,2)
    if test[i,j] > 9
        test[i,j] -= 9
    end
end
test[:,1] .= 10000
test[:,end] .= 10000
test[1,:] .= 10000
test[end,:] .= 10000
test

neighbors(x) = [CartesianIndex(x[1] + y[1], x[2] + y[2]) for y in [[1,0], [0,1], [-1,0], [0,-1]]]

using DataStructures
# init
Q = PriorityQueue{CartesianIndex,Int}()
d = zeros(size(test))
prev = Dict{CartesianIndex,CartesianIndex}()
huge = 10000
for i = 2:size(test,1)-1, j=2:size(test,1)-1
    push!(Q, CartesianIndex(i,j) => huge)
end
for i = 1:size(test,1), j=1:size(test,1)
    d[i,j] = huge
end
source = CartesianIndex(2,2)
d[source] = 0
Q[source] = 0

#djikstra

function djikstra()
    while !isempty(Q) && u != CartesianIndex(501,501)
        u = dequeue!(Q)
        for n in neighbors(u)
            alt = d[u] + test[n]
            if alt < d[n]
                d[n] = alt
                prev[n] = u
                Q[n] = alt
            end
        end
    end
    return d, prev
end
using BenchmarkTools
@btime djikstra()
prev
d