using DelimitedFiles
using Test
using Statistics

nums = readdlm("aoc/day07.txt", ',', Int)
nums_test = readdlm("aoc/day07_text.txt", ',', Int)

solve1(x) = x .- median(x) .|> abs |> sum

function solve2(x)
    cost(v) = map(n -> sum(1:abs(n)), v) |> sum |> Int
    return [cost(x .- i) for i = minimum(x):maximum(x)] |> minimum
end

@test solve1(nums_test) == 37
println(solve1(nums))

@test solve2(nums_test) == 168
display(solve2(nums))