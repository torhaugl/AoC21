using DelimitedFiles

nums = readdlm("aoc/day05.txt", ',', Int)
#nums = readdlm("aoc/day05_test.txt", ',', Int)

function solve1(nums)
    x1, y1, x2, y2 = nums[:,1] .+1, nums[:,2] .+1, nums[:,3] .+1, nums[:,4] .+1

    board = zeros(maximum(nums)+1, maximum(nums)+1)
    for i = 1:length(x1)
        a = min(x1[i], x2[i])
        b = max(x1[i], x2[i])
        c = min(y1[i], y2[i])
        d = max(y1[i], y2[i])
        if (a == b || c == d)
            board[a:b, c:d] .+= 1
        end
    end
    return count(>=(2), board)
end

function solve2(nums)
    x1, y1, x2, y2 = nums[:,1] .+1, nums[:,2] .+1, nums[:,3] .+1, nums[:,4] .+1

    board = zeros(maximum(nums)+1, maximum(nums)+1)
    for i = 1:length(x1)
        a = min(x1[i], x2[i])
        b = max(x1[i], x2[i])
        c = min(y1[i], y2[i])
        d = max(y1[i], y2[i])
        if (a == b)
            board[a:b, c:d] .+= 1
        elseif (c == d)
            board[a:b, c:d] .+= 1
        else
            if x1[i] < x2[i]
                xs = x1[i]:x2[i]
            else
                xs = x1[i]:-1:x2[i]
            end
            if y1[i] < y2[i]
                ys = y1[i]:y2[i]
            else
                ys = y1[i]:-1:y2[i]
            end

            for (i,j) in zip(xs, ys)
                board[i,j] += 1
            end
        end
    end
    return count(>=(2), board)
end

println(solve1(nums))
println(solve2(nums))