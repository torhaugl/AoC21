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

    c = copy(b)
    j = 0
    while size(c,1) > 1
        j += 1
        c = cond(c[:,j]) ? c[c[:,j] .== 1,:] : c[c[:,j] .== 0,:]
    end

    d = copy(b)
    j = 0
    while size(d,1) > 1
        j += 1
        d = !cond(d[:,j]) ? d[d[:,j] .== 1,:] : d[d[:,j] .== 0,:]
    end

    o2_generator_rating = c |> bitarr2int
    co2_scrubber_rating = d |> bitarr2int
    return o2_generator_rating * co2_scrubber_rating
end

@test solve1(test_input) == 198
println(solve1(input))
@test solve2(test_input) == 230
println(solve2(input))