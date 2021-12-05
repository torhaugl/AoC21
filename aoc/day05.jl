using DelimitedFiles
using Test

nums = readdlm("aoc/day05.txt", ',', Int)
nums_test = readdlm("aoc/day05_test.txt", ',', Int)

function iter(i,j) 
    sign(x) = (x >= 0) ? 1 : -1
    if i == j
        Iterators.repeated(i)
    else
        i:sign(j - i):j
    end
end

function solve1(nums)
        x1, y1, x2, y2 = nums[:,1] .+1, nums[:,2] .+1, nums[:,3] .+1, nums[:,4] .+1

    board = zeros(maximum(nums)+1, maximum(nums)+1)
    for (a,b,c,d) = zip(x1, x2, y1, y2)
        if (a == b || c == d)
            for (i,j) in zip(iter(a,b), iter(c,d))
                board[i,j] += 1
            end
        end
    end
    return count(>=(2), board)
end

function solve2(nums)
    x1, y1, x2, y2 = nums[:,1] .+1, nums[:,2] .+1, nums[:,3] .+1, nums[:,4] .+1

    board = zeros(maximum(nums)+1, maximum(nums)+1)
    for (a,b,c,d) = zip(x1, x2, y1, y2)
        for (i,j) in zip(iter(a,b), iter(c,d))
            board[i,j] += 1
        end
    end
    return count(>=(2), board)
end

@test solve1(nums_test) == 5
println(solve1(nums))
@test solve2(nums_test) == 12
println(solve2(nums))