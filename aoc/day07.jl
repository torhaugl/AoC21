using DelimitedFiles
using Test
using Statistics

nums = readdlm("aoc/day07.txt", ',', Int)
nums_test = readdlm("aoc/day07_text.txt", ',', Int)

solve1(x) = x .- median(x) .|> ceil .|> abs |> sum |> Int
sum_one_to_n(n) = n*(n+1)÷2
solve2(x) = x .- mean(x) .|> round .|> abs .|> sum_one_to_n |> sum |> Int

@test solve1(nums_test) == 37
println(solve1(nums))

@test solve2(nums_test) == 168
display(solve2(nums))