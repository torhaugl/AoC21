graph = Dict(
    0 => [1],
    1 => [0, 1],
    2 => [1, 3, 21],
    21 => [2, 22],
    22 => [21],
    3 => [2, 4],
    4 => [3, 5, 41],
    41 => [4, 42],
    42 => [41],
    5 => [4, 6],
    6 => [5, 7, 61],
    61 => [6, 62],
    62 => [61],
    7 => [6, 8],
    8 => [7, 9, 81],
    81 => [8, 82],
    82 => [81],
    9 => [8, 10],
    10 => [9])

A_heuristic = Dict(
    0 => 4,
    1 => 3,
    2 => 2,
    21 => 1,
    22 => 0,
    3 => 3,
    4 => 4,
    41 => 5,
    42 => 6,
    5 => 5,
    6 => 6,
    61 => 7,
    62 => 8,
    7 => 7,
    8 => 8,
    81 => 9,
    82 => 10,
    9 => 9,
    10 => 10
)
B_heuristic = Dict(
    0 => 6,
    1 => 5,
    2 => 4,
    21 => 5,
    22 => 6,
    3 => 3,
    4 => 2,
    41 => 1,
    42 => 0,
    5 => 3,
    6 => 4,
    61 => 5,
    62 => 6,
    7 => 5,
    8 => 6,
    81 => 7,
    82 => 8,
    9 => 7,
    10 => 8
)
C_heuristic = Dict(
    0 => 8,
    1 => 7,
    2 => 6,
    21 => 7,
    22 => 8,
    3 => 5,
    4 => 4,
    41 => 5,
    42 => 6,
    5 => 3,
    6 => 2,
    61 => 1,
    62 => 0,
    7 => 3,
    8 => 4,
    81 => 5,
    82 => 6,
    9 => 5,
    10 => 6
)
D_heuristic = Dict(
    0 => 10,
    1 => 9,
    2 => 8,
    21 => 9,
    22 => 10,
    3 => 7,
    4 => 6,
    41 => 7,
    42 => 8,
    5 => 5,
    6 => 4,
    61 => 5,
    62 => 6,
    7 => 3,
    8 => 2,
    81 => 1,
    82 => 0,
    9 => 3,
    10 => 4
)

heuristic_dict = Dict(
    "A" => A_heuristic,
    "B" => B_heuristic,
    "C" => C_heuristic,
    "D" => D_heuristic
    )

start = Dict(  #test
    "A" => [22, 82],
    "B" => [21, 61],
    "C" => [41, 62],
    "D" => [42, 81],
)

cost = Dict(
    "A" => 1,
    "B" => 10,
    "C" => 100,
    "D" => 1000,
)

goal = Dict( 
    "A" => Set([21, 22]),
    "B" => Set([41, 42]),
    "C" => Set([61, 62]),
    "D" => Set([81, 82]),
)

function heuristic(status)
    h = 0
    for k in keys(status)
        h += heuristic_dict[k][status[k][1]] * cost[k]
        h += heuristic_dict[k][status[k][2]] * cost[k]
    end
    return h
end
heuristic(start)

occupied(status, x) = any(x ∈ v for v in values(status))

function moves(status) 
    all_moves = Dict{Int, Vector{Int}}()
    for node in status
        key, value = node
        for v in value
            legal = filter(x -> !occupied(status, x), graph[v])
            if !isempty(legal)
                all_moves[v] = legal
            end
        end
    end
    return all_moves
end

start
moves(start)

using DataStructures

function move!(status, from, to)
    for k in keys(status), i = 1:2
        if status[k][i] == from
            status[k][i] = to
            return cost[k]
        end
    end
    error("Did not find from $from to $to")
end

function neighbors(status)
    ns = Vector{Dict{String, Vector{Int}}}()
    costs = Vector{Int}()
    for (from, tos) in moves(status)
        for to in tos
            n = deepcopy(status)
            cost = move!(n, from, to)
            push!(ns, n)
            push!(costs, cost)
        end
    end
    return ns, costs
end

function gameover(status, goal)
    game = true
    for k in keys(status)
        game = game && (status[k] .|> (x -> x ∈ goal[k]) |> all)
    end
    return game
end

function djikstra(start, goal)
    dist = Dict(start => 0)
    Q = PriorityQueue(start => 0) #heuristic(start))
    inf = typemax(Int64)
    explored = Set{Dict{String, Vector{Int}}}()

    i = 0
    while !isempty(Q)
        i += 1
        u = dequeue!(Q)
        if gameover(u, goal)
            println("GAME OVER $i")
            return dist[u]
        end
        push!(explored, u)
        for (v, cost) in zip(neighbors(u)[1], neighbors(u)[2])
            alt = dist[u] + cost
            if v ∉ explored && v ∉ keys(Q)
                Q[v] = alt + heuristic(v)
            elseif v ∈ keys(Q) && Q[v] > alt
                Q[v] = alt + heuristic(v)
            end
            if haskey(dist, v) && alt < dist[v]
                dist[v] = alt
            elseif !haskey(dist, v)
                dist[v] = alt
            end
        end
        if i % 10000 == 0 println("d= $(dist[u]) h= $(heuristic(u)) g: $(dist[u] + heuristic(u)) u: $u") end
    end
end
start
djikstra(start, goal)