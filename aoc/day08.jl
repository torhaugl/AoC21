using Random
using Combinatorics
using OffsetArrays

function solve1(input)
    filter2347(x) = filter(y -> y ∈ [2, 3, 4, 7], x)
    return [split(l, "|")[2] |> split .|> length |> filter2347 |> length for l in eachline(input)] |> sum
end

function solve2_permute(input)
    # DOesnt work
    inp1 = [split(l, "|")[1] |> split for l in eachline(input)]
    inp2 = [split(l, "|")[2] |> split for l in eachline(input)]
    nums = Dict("abcefg" => 0, "cf" => 1, "acdeg" => 2, "acdfg" => 3, "bcdf" => 4, "abdfg" => 5, "abdefg" => 6, "acf" => 7, "abcdefg" => 8, "abcdfg" => 9)
    tonum(x) = get(nums, x, nothing)
    isnum(x) = !isnothing(tonum(x))

    function lines2num(left, right)
        #for p in permutations(0:9)
        for p in [collect(permutations(1:10))[1]]
            println(p)
            permuted_left = copy(left)
            println(permuted_left)
            permuted_left = [permute!(collect(word), p) |> join for word in permuted_left]
            println(permuted_left)
            if all(isnum, permuted_left)
                println("JIPPI")
                permuted_right = [permute!(word, p) for word in right]
                return parse(Int, map(tonum, permuted_right) |> join)
            end
        end
    end

    return [lines2num(left, right) for (left, right) in zip(inp1, inp2)] |> sum
end
#solve2_permute("aoc/day08_test.txt")

function line2nums(line, nums)
    line = [join(sort(collect(l))) for l in line]
    nums = [join(sort(collect(l))) for l in nums]

    one   = line[findfirst(x -> length(x) == 2, line)]
    four  = line[findfirst(x -> length(x) == 4, line)]
    seven = line[findfirst(x -> length(x) == 3, line)]
    eight = line[findfirst(x -> length(x) == 7, line)]

    right = one
    top = filter(c -> c ∉ right, seven)
    middleleft = filter(c -> c ∉ right, four)
    bottom = filter(c -> c ∉ right * top * middleleft, eight)

    two = line[findfirst(x -> (
                              length(x) == 5 &&
                              !(right[1] ∈ x && right[2] ∈ x) &&
                              !(middleleft[1] ∈ x && middleleft[2] ∈ x) &&
                              (bottom[1] ∈ x && bottom[2] ∈ x) &&
                              top[1] ∈ x
                              ), line)]
    three = line[findfirst(x -> (
                                length(x) == 5 &&
                                right[1] ∈ x && right[2] ∈ x &&
                                !(middleleft[1] ∈ x && middleleft[2] ∈ x) &&
                                !(bottom[1] ∈ x && bottom[2] ∈ x) &&
                                top[1] ∈ x
                                ), line)]
    five = line[findfirst(x -> (length(x) == 5 && x != two && x != three), line)]

    six = line[findfirst(x -> (length(x) == 6 && !(right[1] ∈ x && right[2] ∈ x)), line)]
    nine = line[findfirst(x -> (length(x) == 6 && !(bottom[1] ∈ x && bottom[2] ∈ x)), line)]
    zero = line[findfirst(x -> (length(x) == 6 && x != six && x != nine), line)]

    map2num = Dict(one => 1, 
                   two => 2,
                   three => 3,
                   four => 4,
                   five => 5,
                   six => 6,
                   seven => 7,
                   eight => 8,
                   nine => 9,
                   zero => 0)
    return ([getindex(map2num, num) for num in nums])
end

function solve2(input)
    inp1 = [split(l, "|")[1] |> split for l in eachline(input)]
    inp2 = [split(l, "|")[2] |> split for l in eachline(input)]
    d = [line2nums(line, nums) for (line, nums) in zip(inp1, inp2)];
    return [v * 10^(4 - i) for (i, v) in enumerate(sum(d))] |> sum
end

println(solve1("aoc/day08.txt"))
println(solve2("aoc/day08.txt"))


nums_b = [1 1 1 0 1 1 1  #0
          0 1 0 0 1 0 0  #1
          1 0 1 1 1 0 1  #2
          1 1 0 1 1 0 1  #3
          0 1 0 1 1 1 0  #4
          1 1 0 1 0 1 1  #5
          1 1 1 1 0 1 1  #6
          0 1 0 0 1 0 1  #7
          1 1 1 1 1 1 1  #8
          1 1 0 1 1 1 1] #9

bit = BitArray(nums_b)

row4 = bit[findfirst(==(4), sum(bit, dims=2))[1], :]
row7 = bit[findfirst(==(3), sum(bit, dims=2))[1], :]

sbitpl = vcat(bit, [row4'; row4'; row7'; row7'; row7'])
sbit = bit[:, sortperm(vec(sum(sbitpl, dims=1)))]



randbit = bit[:, shuffle(1:end)]

row4 = randbit[findfirst(==(4), sum(randbit, dims=2))[1], :]
row7 = randbit[findfirst(==(3), sum(randbit, dims=2))[1], :]

rsbitpl = vcat(randbit, [row4'; row4'; row7'; row7'; row7'])
rsbit = randbit[:, sortperm(vec(sum(rsbitpl, dims=1)))]
sum(rsbitpl, dims=1)
rsbit - sbit
