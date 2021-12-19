#addition. [1,2] + [[3,4],5] becomes [[1,2],[[3,4],5]].
#reduce 
#If any pair is nested inside four pairs, the leftmost such pair explodes.
#If any regular number is 10 or greater, the leftmost such regular number splits.
#To explode a pair, the pair's left value is added to the first regular number to the left of the exploding pair (if any),
# and the pair's right value is added to the first regular number to the right of the exploding pair (if any).
#Exploding pairs will always consist of two regular numbers.
#Then, the entire exploding pair is replaced with the regular number 0.

struct ShellfishPair
    nums
    depths
end

function ShellfishPair(str :: AbstractString)
    str1 = join(split(str, ['[', ']'])) #remove []
    nums_str = split(str1, ",")
    nums = parse.(Int, nums_str)

    depth_full_str = cumsum((c == '[') - (c == ']') for c in str)
    depth = zeros(Int, length(nums))

    i = 0
    for (j, num) in enumerate(nums_str)
        i = findnext(num, str, i+1)[end]
        depth[j] = depth_full_str[i]
    end
    return ShellfishPair(nums, depth)
end

function explode!(x::ShellfishPair)
    d = x.depths
    l = x.nums
    if (maximum(d) > 5) error("max > 5") end
    i = findfirst(==(5), d)
    exploded = false
    while !isnothing(i)
        exploded = true
        if i > 1
            l[i-1] += l[i]
        end
        if i < length(l) - 1
            l[i+2] += l[i+1]
        end
        popat!(l, i)
        popat!(d, i)
        l[i] = 0
        d[i] -= 1
        i = nothing #findfirst(==(5), d)
    end
    return exploded
end

function split!(x::ShellfishPair)
    d = x.depths
    l = x.nums
    i = findfirst(x -> x >= 10, l)
    splitted = false
    while !isnothing(i)
        splitted = true
        x = popat!(l, i)
        insert!(l, i, (x ÷ 2) + (x % 2))
        insert!(l, i, x ÷ 2)
        depth = popat!(d, i)
        insert!(d, i, depth + 1)
        insert!(d, i, depth + 1)
        i = nothing
    end
    return splitted
end

function reduce!(x::ShellfishPair)
    while true
        exploded = explode!(x)
        if !exploded
            splitted = split!(x)
        end

        if !exploded && !splitted
            break
        end
    end
    return x
end

import Base.+
function (+)(a::ShellfishPair, b::ShellfishPair)
    ShellfishPair(vcat(a.nums, b.nums), vcat(a.depths, b.depths) .+ 1) |> reduce!
end

function magnitude(x::ShellfishPair)
    l = x.nums
    d = x.depths
    while maximum(d) > 1
        i = findfirst(==(maximum(d)), d)
        popat!(d, i)
        d[i] -= 1
        a = popat!(l, i)
        l[i] = 3*a + 2*l[i]
    end
    return 3*l[1] + 2*l[2]
end

function solve1()
    x = ShellfishPair(readline("aoc/day18.txt"))
    for line in collect(eachline("aoc/day18.txt"))[2:end]
        x = x + ShellfishPair(line)
    end
    magnitude(x)
end

function solve2()
    all_nums = Int[]
    for line1 in collect(eachline("aoc/day18.txt"))
    for line2 in collect(eachline("aoc/day18.txt"))
        x = ShellfishPair(line1)
        x = x + ShellfishPair(line2)
        append!(all_nums, magnitude(x))
    end
    end
    maximum(all_nums)
end

solve1()
solve2()