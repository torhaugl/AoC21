using DelimitedFiles

function main()
    data = readdlm("day01.txt")
    return sum([data[i] > data[i-1] for i = 2:length(data)])
end

println(main())