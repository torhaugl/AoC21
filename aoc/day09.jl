using DSP

lines = collect(eachline("aoc/day09.txt"))
x = zeros(Int, length(lines)+2, length(lines[1])+2)
for (i, line) in enumerate(lines)
    for (j, c) in enumerate(line)
        x[i+1,j+1] = parse(Int, c)
    end
end
x
x[:, 1] .= 1000
x[:, end] .= 1000
x[1, :] .= 1000
x[end, :] .= 1000

x1 = x - circshift(x, ( 1, 0))
x2 = x - circshift(x, (-1, 0))
x3 = x - circshift(x, ( 0, 1))
x4 = x - circshift(x, ( 0,-1))

indexs = (x1 .< 0) .* (x2 .< 0) .* (x3 .< 0) .* (x4 .< 0)
indexs[:, 1] .= 0
indexs[:, end] .= 0
indexs[1, :] .= 0
indexs[end, :] .= 0
println(sum(x[indexs]) + sum(indexs))

x
x9 = copy(x)
x9[:, 1] .= 0
x9[:, end] .=0
x9[1, :] .=0
x9[end, :] .=0
x9[x9 .== 9] .= 0
x9
x_value = copy(x9)
x_value[x9 .> 0] .= 1
x1 = circshift(x_value, ( 1, 0))
x2 = circshift(x_value, (-1, 0))
x3 = circshift(x_value, ( 0, 1))
x4 = circshift(x_value, ( 0,-1))
x_value

function find_basin(x, list, i, j)
    # Infinite
    println(x[i, j], list, i, j)
    if x[i, j] == 0
        return
    elseif Pair(i,j) ∈ list
        return
    else
        if x[i,j+1] != 0 && Pair(i,j+1) ∉ list
            append!(list, Pair(i, j+1))
            find_basin(x, list, i, j+1)
        end
        if x[i,j-1] != 0 && Pair(i,j-1) ∉ list
            find_basin(x, list, i, j-1)
        end
        if x[i+1,j] != 0 && Pair(i+1,j) ∉ list
            find_basin(x, list, i+1, j)
        end
        if x[i-1,j] != 0 && Pair(i-1,j) ∉ list
            find_basin(x, list, i-1, j)
        end
    end
end
#list = []
#find_basin(x9, list, 2, 2)
#list

function group(x)
    #doesnt work
    xcopy = copy(x)
    x1 = circshift(x, ( 0,-1))
    x1[x1 .> 0] .= 1
    x2 = circshift(x, ( 0, 1))
    x2[x2 .> 0] .= 1
    x3 = circshift(x, (-1, 0))
    x3[x3 .> 0] .= 1
    x4 = circshift(x, ( 1, 0))
    x4[x4 .> 0] .= 1

    for i = 1:size(x1,1), j = 1:size(x1, 2)
        if x1[i, j] == 0
            x[i, j] += x[i, j+1]
        end
    end
end


function recursive_basin(x, pair::Pair, pairs = [pair])
    if x[pair[1], pair[2]] == 0
        return nothing
    end
    dpair = Pair(pair[1] + 1, pair[2])
    upair = Pair(pair[1] - 1, pair[2])
    lpair = Pair(pair[1], pair[2] - 1)
    rpair = Pair(pair[1], pair[2] + 1)
    for p in [rpair, dpair, lpair, upair]
        if (p ∉ pairs && x[p[1], p[2]] != 0)
            pairs = cat(pairs, p, dims=1)
            pairs = recursive_basin(x, p, pairs)
        end
    end
    return pairs
end

function all_basins(x)
    x
    x_value = copy(x)
    x_value[:, 1] .= 9
    x_value[:, end] .=9
    x_value[1, :] .=9
    x_value[end, :] .=9
    x_value[ 9 .> x_value ] .= 1
    x_value[x_value .== 9] .= 0
    display(x_value)

    all_pairs_so_far = [Pair(0,0)]
    basin_sizes = []
    for i = 2:size(x, 1)-1, j = 2:size(x,2)-1
        current_pair = Pair(i,j)
        if current_pair ∉ all_pairs_so_far && x_value[i,j] != 0
            basin_pairs = recursive_basin(x_value, current_pair, [current_pair])
            println(basin_pairs)
            if !isnothing(basin_pairs)
                append!(basin_sizes, length(basin_pairs))
                all_pairs_so_far = cat(all_pairs_so_far, basin_pairs, dims=1)
            end
        end
    end
    return basin_sizes
end

x_value
recursive_basin(x_value, Pair(2,7))
x_max3 = all_basins(x) |> sort
prod(x_max3[end-2:end])