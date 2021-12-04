using DelimitedFiles

nums = readdlm("aoc/day04_numbers.txt", ',', Int)
boards = readdlm("aoc/day04_boards.txt", Int)'
boards = reshape(boards, 5, 5, :)

bingo_arr(x, v) = x .∈ (v,)
isbingo(x) = any(sum(x, dims=1) .== 5) || any(sum(x, dims=2) .== 5)
bitflip(x) = BitArray(!a for a in x)

function solve1(boards, nums)
    for i = 1:length(nums)
        for j = 1:size(boards, 3)
            b = boards[:,:,j]
            barr = bingo_arr(b, nums[1:i])
            if isbingo(barr)
                return sum(b[bitflip(barr)]) * nums[i]
            end
        end
    end
end

function solve1_v2(bo, nums)
    boards = map(x -> findfirst(==(x), nums)[2], bo)
    index = 0
    val = Inf
    for j = 1:size(boards,3)
        if val > min(minimum(maximum(boards[:,:,j], dims=1)), minimum(maximum(boards[:,:,j], dims=2)))
            index = j
            val = min(minimum(maximum(boards[:,:,j], dims=1)), minimum(maximum(boards[:,:,j], dims=2)))
        end
    end
    b = bo[:,:,index]
    return sum(b[boards[:,:,index] .> val]) * nums[val]
end

function solve2(boards, nums)
    curr_max = 0
    for i = 1:length(nums)
        x = []
        for j = 1:size(boards, 3)
            b = boards[:,:,j]
            barr = bingo_arr(b, nums[1:i])
            if isbingo(barr)
                curr_max = sum(b[bitflip(barr)]) * nums[i]
                append!(x, j)
            end
        end
        boards = boards[:,:,setdiff(1:end, x)]
    end
    return curr_max
end

println(solve1(boards, nums))
println(solve1_v2(boards, nums))
println(solve2(boards, nums))