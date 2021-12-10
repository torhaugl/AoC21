

lines = readlines("aoc/day10.txt") |> collect

set1 = ["(", "[", "{", "<"]
set2 = [")", "]", "}", ">"]
scores = [3, 57, 1197, 25137, 0]

function collapse(mat)
    size_before = Inf
    while length(mat) < size_before
        size_before = length(mat)
        row = 1
        col = 1
        while col < size(mat, 2)
            for row = 1:4
                if mat[row, col] == 1 &&  mat[row, col+1] == -1
                    mat = mat[:, setdiff(1:end, (col,col+1))]
                    col = 1
                end
            end
            col += 1
        end
    end
    return mat
end

function find_index(mat)
    mat = collapse(mat)
    return findfirst(==(-1), mat)
end

function solve1(lines)
    score = 0
    indices = []
    for (i, line) in enumerate(lines)
        println(line)
        cstring = [(x ∈ c1) - (x ∈ c2) for (c1, c2) in zip(set1, set2), x in line]
        index = find_index(cstring)
        if !isnothing(index)
            score += scores[index[1]]
        else
            append!(indices, i)
        end
    end
    return score, indices
end
_, indices = solve1(lines)


allowed_lines = lines[indices]
scores2 = [1, 2, 3, 4]
score_multiply = 5
tot_tot_score = []
for line in allowed_lines
    #line = "<{([{{}}[<[[[<>{}]]]>[]]"
    cstring = [(x ∈ c1) - (x ∈ c2) for (c1, c2) in zip(set1, set2), x in line]
    mat = collapse(cstring)
    display(mat)
    tot_score = 0
    for i = size(mat, 2):-1:1
        index1 = findfirst(==(1), mat[:, i])
        tot_score *= 5
        tot_score += scores2[index1]
    end
    append!(tot_tot_score, tot_score)
end
using Statistics
median(tot_tot_score) |> BigInt