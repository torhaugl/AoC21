using Statistics

lines = readlines("aoc/day10.txt") |> collect
set1 = ['(', '[', '{', '<']
set2 = [')', ']', '}', '>']
scores1 = [3, 57, 1197, 25137]
scores2 = [1, 2, 3, 4]
scores2_dict = Dict('('=>1, '['=>2, '{'=>3, '<'=>4)
score_multiply = 5

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
        :string = [(x ∈ c1) - (x ∈ c2) for (c1, c2) in zip(set1, set2), x in line]
        index = find_index(cstring)
        if !isnothing(index)
            score += scores1[index[1]]
        else
            append!(indices, i)
        end
    end
    return score, indices
end

function solve2(allowed_lines)
    tot_tot_score = []
    for line in allowed_lines
        #line = "<{([{{}}[<[[[<>{}]]]>[]]"
        cstring = [(x ∈ c1) - (x ∈ c2) for (c1, c2) in zip(set1, set2), x in line]
        mat = collapse(cstring)
        tot_score = 0
        for i = size(mat, 2):-1:1
            index1 = findfirst(==(1), mat[:, i])
            tot_score *= 5
            tot_score += scores2[index1]
        end
        append!(tot_tot_score, tot_score)
    end
    return median(tot_tot_score) |> BigInt
end

sol1, indices = solve1(lines)
allowed_lines = lines[indices]
println(sol1)
println(solve2(allowed_lines))

using DataStructures
pairs = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>')
scores1_dict = Dict(')'=>3, ']'=>57, '}'=>1197, '>'=>25137)

function solve1_stack(lines)
    return [solve1_line(line) for line in lines] |> sum
end

function solve1_line(line) :: Int
    stack = Stack{Char}()
    call_error(x, c) = pairs[x] != c
    for c in line
        if isempty(stack) || c ∈ keys(pairs)
            push!(stack, c)
        elseif c ∈ values(pairs)
            x = pop!(stack)
            if call_error(x, c)
                return scores1_dict[c]
            end
        end
    end
    return 0
end

solve1_stack(lines)