using DelimitedFiles
using Test

test_input = readdlm("aoc/day02_test.txt")
input = readdlm("aoc/day02.txt")

function solve1(commands, values)
    boat = [0,0]
    for (cmd, val) in zip(commands, values)
        if (cmd == "forward")
            boat += [val, 0]
        elseif (cmd == "down")
            boat += [0, val]
        elseif (cmd == "up")
            boat += [0, -val]
        end
    end
    return prod(boat)
end

function solve2(commands, values)
    boat = [0,0,0]
    for (cmd, val) in zip(commands, values)
        if (cmd == "forward")
            boat += [val, boat[3]*val, 0]
        elseif (cmd == "down")
            boat += [0, 0, val]
        elseif (cmd == "up")
            boat += [0, 0, -val]
        end
    end
    return boat[1] * boat[2]
end

@test solve1(test_input[:,1], test_input[:,2]) == 150
@test solve2(test_input[:,1], test_input[:,2]) == 900
println(solve1(input[:,1], input[:,2]))
println(solve2(input[:,1], input[:,2]))