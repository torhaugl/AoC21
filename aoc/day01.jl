using DelimitedFiles
using Test

test_input = readdlm("aoc/day01_test.txt")
input = readdlm("aoc/day01.txt")

function solve1(x)
    return sum([x[i] > x[i-1] for i = 2:length(x)])
end

function solve2(x)
    return sum([x[i] > x[i-3] for i = 4:length(x)])
end

@test solve1(test_input) == 7
@test solve2(test_input) == 5
println(solve1(input))
println(solve2(input))