# input with padded 0
input = zeros(Int, 12,12)
input[2:11, 2:11] = [8 2 7 1 6 5 3 8 3 6
                     7 5 6 7 6 2 6 7 7 5
                     2 3 1 5 7 1 3 3 1 6
                     6 5 4 2 6 5 5 3 1 5
                     2 4 5 3 6 3 7 3 3 3
                     1 2 4 7 2 6 4 3 2 8
                     2 3 2 5 1 4 6 6 1 4
                     2 1 1 5 8 4 3 1 7 1
                     6 1 8 2 3 7 6 2 8 2
                     2 3 8 4 7 3 8 6 7 5]

neighbor(x) = [ CartesianIndex(x[1] + i, x[2] + j) for i =-1:1 for j = -1:1]
    
function step!(m)
    m .+= 1
    popped = falses(size(m))
    indices = findall(x -> x > 9, m)
    while length(indices) > 0
        for index in indices
            popped[index] = true
            m[index] = 0
            for n in neighbor(index)
                if !popped[n]
                    m[n] += 1
                end
            end
        end
        indices = findall(x -> x > 9, m)
    end
    m[:, 1] .= 0
    m[:, end] .= 0
    m[1, :] .= 0
    m[end, :] .= 0
    return count(popped)
end

function solve1(input)
    m = copy(input)
    return [step!(m) for _=1:100] |> sum
end

function solve2(input)
    m = copy(input)
    iterate = 1
    while step!(m) != 100
        iterate += 1
    end
    return iterate
end

println(solve1(input))
println(solve2(input))