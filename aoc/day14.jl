function read_input(fname)
    lines = Iterators.Stateful(eachline(fname))

    input_line = popfirst!(lines)
    popfirst!(lines)

    rules = Dict(begin
        a, b = split(l, " -> ")
        string(a) => (a[1]*b[1], b[1]*a[2])
    end for l in lines)
    return input_line, rules
end

function input2pairs(input)
    pairs = Dict{String,Int}()
    for i = 1:length(input)-1
        key = input[i:i+1]
        pairs[key] = get(pairs, key, 0) + 1
    end
    return pairs
end

function iterate!(input_pairs, rules_new)
    output_pairs = Dict{String, Int}()

    for pair in keys(input_pairs)
        output_pairs[rules_new[pair][1]] = get(output_pairs, rules_new[pair][1], 0) + input_pairs[pair] 
        output_pairs[rules_new[pair][2]] = get(output_pairs, rules_new[pair][2], 0) + input_pairs[pair] 
        input_pairs[pair] = 0
    end

    for pair in keys(output_pairs)
        input_pairs[pair] = get(input_pairs, pair, 0) + output_pairs[pair]
    end
end

function pair2char(input_pairs, input)
    char_dict = Dict{Char, Int}()
    char_dict[input[1]] = 1
    char_dict[input[end]] = 1
    for k in keys(input_pairs)
        char_dict[k[1]] = get(char_dict, k[1], 0) + input_pairs[k]
        char_dict[k[2]] = get(char_dict, k[2], 0) + input_pairs[k]
    end
    for k in keys(char_dict)
        char_dict[k] = char_dict[k] ÷ 2
    end
    return char_dict
end

using BenchmarkTools
function solve2()
    input, rules = read_input("aoc/day14.txt")
    pairs = input2pairs(input)
    for i = 1:40
        iterate!(pairs, rules)
    end
    char_dict = pair2char(pairs, input)
    maximum(values(char_dict)) - minimum(values(char_dict))
end
@benchmark solve2()

solve2()