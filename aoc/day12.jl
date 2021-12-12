function parse_input(fname)
    edges = vcat([Pair(split(line, "-")...) for line in eachline(fname)], [Pair(split(line, "-")[2:-1:1]...) for line in eachline(fname)])
    nodes = Set{String}()
    for line in eachline(fname)
        push!(nodes, split(line, "-")...)
    end
    #nodes = Set(vcat(split.(split(read("aoc/day12_test1.txt", String), "\n"), "-")...)) #oneliner
    return edges, nodes
end

is_big(node) = [isuppercase(c) for c in node] |> all
is_small(node) = [islowercase(c) for c in node] |> all

function neighbors(node, edges)
    neighbors = []
    for edge in edges
        if edge[1] == node
            push!(neighbors, edge[2])
        end
    end
    return neighbors
end

function visit(node, nodes, edges, path, paths)
    for n in neighbors(node, edges)
        if n == "end"
            push!(path, n)
            push!(paths, copy(path))
            pop!(path)
        elseif n == "start"
            #donothing
        elseif n ∈ path && is_small(n)
            #donothing
        elseif (n ∈ path && is_big(n)) || n ∉ path
            push!(path, n)
            visit(n, nodes, edges, path, paths)
            pop!(path)
        else
            println("ERROR: ", n)
        end
    end
end

function count_max_unique(path)
    return values(Dict([(n,count(x->x==n,path)) for n in unique(path) if is_small(n)])) |> maximum
end

function num_max_unique(path)
    d = Dict([(n,count(x->x==n,path)) for n in unique(path) if is_small(n)])
    return count(>=(2), values(d))
end

function visit2(node, nodes, edges, path, paths)
    for n in neighbors(node, edges)
        push!(path, n)
        if n == "end"
            push!(paths, copy(path))
        elseif n == "start"
            #donothing
        elseif is_small(n)
            if count_max_unique(path) < 3 && num_max_unique(path) <= 1
                visit2(n, nodes, edges, path, paths)
            end
        else
            visit2(n, nodes, edges, path, paths)
        end
        pop!(path)
    end
end

function solve1(fname)
    edges, nodes = parse_input(fname)
    path = ["start"]
    paths = []
    visit("start", nodes, edges, path, paths)
    return paths
end

function solve2(fname)
    edges, nodes = parse_input(fname)
    path = ["start"]
    paths = []
    visit2("start", nodes, edges, path, paths)
    return paths
end

solve1("aoc/day12_test1.txt")
solve1("aoc/day12_test2.txt")
solve1("aoc/day12_test3.txt")
solve1("aoc/day12.txt")

join.(solve2("aoc/day12_test1.txt"), ",")
solve2("aoc/day12_test2.txt")
solve2("aoc/day12_test3.txt")
solve2("aoc/day12.txt")