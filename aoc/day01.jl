using DelimitedFiles

function main()
    data = readdlm("day01.txt")
    return sum([data[i] > data[i-1] for i = 2:length(data)])
end

function main2()
    data = readdlm("day01.txt")
    return sum([sum(data[i-2:i]) > sum(data[i-3:i-1]) for i = 4:length(data)])
end    

println(main())
println(main2())