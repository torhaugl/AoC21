using Combinatorics

function solve1(input)
    filter2347(x) = filter(y -> y ∈ [2, 3, 4, 7], x)
    return [split(l, "|")[2] |> split .|> length |> filter2347 |> length for l in eachline(input)] |> sum
end

function solve2(input)
    # Doesn't work
    inp1 = [split(l, "|")[1] |> split for l in eachline(input)]
    inp2 = [split(l, "|")[2] |> split for l in eachline(input)]
    nums = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]
    for (line1, line2) in zip(inp1, inp2)
        global rline2 = line2
        for p in permutations(["a", "b", "c", "d", "e", "f", "g"])
            #global rline1 = [replace(l, p[1] => "a", p[2] => "b", p[3] => "c", p[4] => "d", p[5] => "e", p[6] => "f", p[7] => "g") for l in line1]
            #global rline1 = [replace(l, p[1] => "a", p[2] => "b", "b" => "c", p[4] => "d", p[5] => "e", "e" => "f", p[7] => "g") for l in line1]
            #println(p)
            #println(sort(rline1))
            println(sort(nums))
            #println([a == b for (a, b) in zip(sort(rline1), sort(nums))])
            break
            #if all([a == b for (a, b) in zip(sort(rline1), sort(nums)])
                #println("HEI")
                #global rline2 = replace(line2, p[1] => "a", p[2] => "b", p[3] => "c", p[4] => "d", p[5] => "e", p[6] => "f", p[7] => "g")
            #end
        end
        #println(rline1)
        #println(rline2)
        #[findfirst(==(word), nums)[1] for word in rline2]
        break
    end
    return
end
#solve2("aoc/day08_test.txt")

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