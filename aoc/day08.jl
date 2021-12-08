x = collect(eachline("aoc/day08.txt"))
y = [split(x, "|") for x in x]
z = [x[2] for x in y]
d = [split(x, " ") for x in z]
e = [length(x[j]) for x in d for j=1:length(d[1])]
println(count(==(2), e))
println(count(==(3), e))
println(count(==(4), e))
println(count(==(7), e))

test = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab"
nums = "cdfeb fcadb cdfeb cdbaf"
test = split(test, " ")
nums = split(nums, " ")

function line2nums(line, nums)
    line = [join(sort(collect(l))) for l in line]
    nums = [join(sort(collect(l))) for l in nums]

    one   = line[findall(x -> length(x) == 2, line)]
    four  = line[findall(x -> length(x) == 4, line)]
    seven = line[findall(x -> length(x) == 3, line)]
    eight = line[findall(x -> length(x) == 7, line)]

    right = one[1]
    top = replace(replace(seven[1], right[1] => ""), right[2] => "")
    middleleft = replace(replace(four[1], right[1] => ""), right[2] => "")
    bottom = replace(replace(replace(replace(replace(eight[1], right[1] => ""),
                                                               right[2] => ""),
                                                               top[1] => ""),
                                                               middleleft[1] => ""),
                                                               middleleft[2] => "")
    #println(top)
    #println(middleleft)
    #println(bottom)

    two = line[findall(x -> (length(x) == 5 &&
                    !(right[1] ∈ x && right[2] ∈ x) &&
                    !(middleleft[1] ∈ x && middleleft[2] ∈ x) &&
                    (bottom[1] ∈ x && bottom[2] ∈ x) &&
                    top[1] ∈ x), line)]
    three = line[findall(x -> (length(x) == 5 &&
                    right[1] ∈ x && right[2] ∈ x &&
                    !(middleleft[1] ∈ x && middleleft[2] ∈ x) &&
                    !(bottom[1] ∈ x && bottom[2] ∈ x) &&
                    top[1] ∈ x), line)]
    five = line[findall(x -> (length(x) == 5 &&
                    x != two[1] && x != three[1]), line)]
    six = line[findall(x -> (length(x) == 6 && !(right[1] ∈ x && right[2] ∈ x)), line)]
    nine = line[findall(x -> (length(x) == 6 && !(bottom[1] ∈ x && bottom[2] ∈ x)), line)]
    zero = line[findall(x -> (length(x) == 6 && x != six[1] && x != nine[1]), line)]

    map2num = Dict(one[1] => 1, 
                   two[1] => 2,
                   three[1] => 3,
                   four[1] => 4,
                   five[1] => 5,
                   six[1] => 6,
                   seven[1] => 7,
                   eight[1] => 8,
                   nine[1] => 9,
                   zero[1] => 0)
    return ([get(map2num, num, 110000000000) for num in nums])
end
line2nums(test, nums)

x = collect(eachline("aoc/day08.txt"))
y = [split(x, "|") for x in x]
lines = [split(x[1], " ") for x in y]
numss = [split(x[2], " ") for x in y]
d = [line2nums(line, nums[2:end]) for (line, nums) in zip(lines, numss)];
println([v * 10^(4 - i) for (i, v) in enumerate(sum(d))] |> sum)