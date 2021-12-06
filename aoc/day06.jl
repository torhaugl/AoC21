using DelimitedFiles
using OffsetArrays
using Test

nums = readdlm("aoc/day06.txt", ',', Int)
nums_test = readdlm("aoc/day06_test.txt", ',', Int)

function solve(nums, days)
    fish = [count(==(i), nums) for i = 0:8]
    fish = OffsetArray(fish, 0:8)
    for _ = 1:days
        fish = circshift(fish, -1)
        fish[6] += fish[end]
    end
    return sum(fish)
end

@test solve(nums_test, 18) == 26
println(solve(nums, 80))
println(solve(nums, 256))