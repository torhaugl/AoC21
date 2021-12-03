using DelimitedFiles
using Test

test_input = readdlm("aoc/day03_test.txt", String)
input = readdlm("aoc/day03.txt", String)

strings2bitarray(a) = BitArray(parse(Int, a[i][j]) == 1 for i=1:length(a), j=1:length(a[1]))
bitarr2int(b) = parse(Int, b .|> Int .|> string |> prod, base=2)

function solve1(input)
    b = strings2bitarray(input)

    cond(x) = count(==(1), x) >= count(==(0), x)
    γ_rate = BitArray(cond(b[:,j]) for j=1:size(b,2)) |> bitarr2int
    ϵ_rate = BitArray(!cond(b[:,j]) for j=1:size(b,2)) |> bitarr2int
    return γ_rate*ϵ_rate
end

function solve2(input)
    b = strings2bitarray(input)
    cond(x) = count(==(1), x) >= count(==(0), x)

    function rating(cond, bitarray)
        c = copy(bitarray)
        for j = 1:size(c,2)
            c = cond(c[:,j]) ? c[c[:,j] .== 1,:] : c[c[:,j] .== 0,:]
            if (size(c,1) == 1) break end
        end
        return c |> bitarr2int
    end

    o2_generator_rating = rating(cond, b)
    co2_scrubber_rating = rating(!cond, b)
    return o2_generator_rating * co2_scrubber_rating
end

@test solve1(test_input) == 198
println(solve1(input))
@test solve2(test_input) == 230
println(solve2(input))