using DelimitedFiles
using Test

test_input = "aoc/day02_test.txt"
input = "aoc/day02.txt"

function solve1(fname)
    horizontal = 0
    depth = 0
    for line in eachline(fname)
        cmd, val = split(line)
        val = parse(Int, val)
        if (cmd == "forward")
            horizontal += val
        elseif (cmd == "down")
            depth += val
        elseif (cmd == "up")
            depth -= val
        end
    end
    return depth*horizontal
end

function solve2(fname)
    horizontal = 0
    depth = 0
    aim = 0
    for line in eachline(fname)
        cmd, val = split(line)
        val = parse(Int, val)
        if (cmd == "forward")
            horizontal += val
            depth += aim * val
        elseif (cmd == "down")
            aim += val
        elseif (cmd == "up")
            aim -= val
        end
    end
    return depth*horizontal
end

@test solve1(test_input) == 150
@test solve2(test_input) == 900
println(solve1(input))
println(solve2(input))