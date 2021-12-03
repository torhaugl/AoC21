using DelimitedFiles
using Test

test_input = readdlm("aoc/day03_test.txt", String)
input = readdlm("aoc/day03.txt", String)

function solve1(input)
    x = zeros(Int32, length(input[:]), length(input[1][:]))
    y = zeros(Int32, length(input[1][:]))
    z = zeros(Int32, length(input[1][:]))
    for i = 1:length(input[:])
    for j = 1:length(input[1][:])
        x[i,j] = parse(Int, input[i][j])
    end
    end
    count1(y) = ((sum(y)*2 - length(y)) > 0)
    count2(y) = ((sum(y)*2 - length(y)) < 0)
    for j = 1:length(input[1][:])
        y[j] = count1(x[:,j])
        z[j] = count2(x[:,j])
    end
    gamma = parse(Int, prod(string.(y)), base=2)
    epsilon = parse(Int, prod(string.(z)), base=2)
    return gamma*epsilon
end

function solve2(input)
    x = zeros(Int32, length(input[:]), length(input[1][:]))
    y = zeros(Int32, length(input[1][:]))
    z = zeros(Int32, length(input[1][:]))
    for i = 1:length(input[:])
    for j = 1:length(input[1][:])
        x[i,j] = parse(Int, input[i][j])
    end
    end
    count1(y) = ((sum(y)*2 - length(y)) >= 0)
    count2(y) = ((sum(y)*2 - length(y)) < 0)
    o2_criteria_index = [i for i = 1:length(input[:])]
    co2_criteria_index = [i for i = 1:length(input[:])]
        println(o2_criteria_index, " o2")
    for j = 1:length(input[1][:])
        y[j] = count1(x[o2_criteria_index,j])
        if y[j] == 1
            for i = 1:length(input[:])
                if (x[i,j] == 0)
                filter!(y -> !(y==i), o2_criteria_index)
                end
            end
        else
            for i = 1:length(input[:])
                if (x[i,j] == 1)
                filter!(y -> !(y==i), o2_criteria_index)
                end
            end
        end
        println(o2_criteria_index, " o2")
        if length(o2_criteria_index) == 1
            break
        end
    end

    println(co2_criteria_index, " co2")
    for j = 1:length(input[1][:])
        y[j] = count2(x[co2_criteria_index,j])
        if y[j] == 0
            for i = 1:length(input[:])
                if (x[i,j] == 1)
                filter!(y -> !(y==i), co2_criteria_index)
                end
            end
        else
            for i = 1:length(input[:])
                if (x[i,j] == 0)
                filter!(y -> !(y==i), co2_criteria_index)
                end
            end
        end
        println(co2_criteria_index, " co2")
        if length(co2_criteria_index) == 1
            break
        end
    end
    gamma = parse(Int, prod(string.(x[o2_criteria_index,:])), base=2)
    epsilon = parse(Int, prod(string.(x[co2_criteria_index,:])), base=2)
    println(gamma, " ", epsilon)
    println(gamma*epsilon)
end

#@test solve1(test_input[:,1], test_input[:,2]) == 150
#@test solve2(test_input[:,1], test_input[:,2]) == 900
println(solve1(test_input))
println(solve1(input))
println()
println(solve2(test_input))
println(solve2(input))
#println(solve2(test_input, test_input[:,2]))
#println(solve2(input[:,1], input[:,2]))