using Random
using StaticArrays

function parseinput(fname)
    scanner = 1
    scanners = Vector{SVector{3,Int}}[]
    scan = SVector{3,Int}[]
    for line in eachline(fname)
        if line == "" 
            push!(scanners, scan)
            scan = SVector{3,Int}[]
            scanner += 1
        elseif line[1:3] == "---"
            continue
        else
            nums = SVector{3,Int}([parse(Int, num) for num in split(line, ',')])
            push!(scan, nums)
        end
    end
    push!(scanners, scan)
    return scanners
end

function all_rotations(scanner)
    scanners = Vector{Vector{SVector{3,Int}}}(undef, 6*8)
    x = copy(scanner)
    n = 0
    for perm in [[1,2,3], [2,3,1], [3,1,2], [1,3,2], [3,2,1], [2, 1, 3]]
        for sign in [(1,1,1), (1,1,-1), (1,-1,1), (-1,1,1), (1,-1,-1), (-1,1,-1), (-1,-1,1), (-1,-1,-1)]
            for i in eachindex(x)
                x[i] = @SVector [scanner[i][perm[1]] * sign[1], scanner[i][perm[2]] * sign[2], scanner[i][perm[3]] * sign[3]]
            end
            n += 1
            scanners[n] = copy(x)
        end
    end
    return scanners
end

function distdist_matrix(scanner)
    N = length(scanner)
    v = zeros(Int, N*(N-1)÷2)
    n = 0
    for i = 1:N, j = i+1:N
        n += 1
        v[n] = sum((scanner[i] .- scanner[j]).^2)
    end
    return v
end

function screening(s1, s2)
    A1 = distdist_matrix(s1)
    A2 = distdist_matrix(s2)
    eq = 0
    for x in A1
        if x ∈ A2
            eq += 1
        end
    end
    return eq < 12 * (12-1) ÷ 2
end

function find_overlap(ref_scanner, scanner)
    # Screening
    if screening(ref_scanner, scanner)
        return SVector{3,Int}[], []
    end

    # Find overlap
    N = size(ref_scanner, 1)
    M = size(scanner, 1)
    position = [0, 0, 0]
    for new_scanner in all_rotations(scanner)
        cscan = copy(new_scanner)
        for i = 1:N-11, j = 1:M-11
            sub = new_scanner[j] - ref_scanner[i]
            for k in eachindex(new_scanner)
                new_scanner[k] -= sub
            end

            beacons = 0
            for l in new_scanner
                for k in ref_scanner
                    beacons += k == l
                end
            end

            if beacons >= 12
                return new_scanner, ref_scanner[i] - cscan[j]
            end
        end
    end

    return SVector{3,Int}[], []
end

manhattan_distance(x, y) = sum(abs, x - y)

function part1()
    scanners = parseinput("aoc/day19.txt")
    ref_scanner = scanners[1]
    todo = collect(2:length(scanners))
    positions = SVector{3,Int}[]
    push!(positions, SVector{3,Int}([0,0,0]))

    println("Map now contains $(size(ref_scanner,1)) beacons. $(length(todo)) scanners left.")
    while !isempty(todo)
        n = rand(todo)
        moved_scanner, position = find_overlap(ref_scanner, scanners[n])
        if !isempty(moved_scanner)
            ref_scanner = vcat(ref_scanner, moved_scanner)
            ref_scanner = unique(ref_scanner)
            push!(positions, position)
            deleteat!(todo, findfirst(==(n), todo))
            Nbeacons = size(ref_scanner, 1)
            println("Map now contains $Nbeacons beacons. $(length(todo)) scanners left.")
        end
    end

    Nbeacons = size(ref_scanner, 1)
    maxdist = maximum(manhattan_distance(p1, p2) for p1 in positions, p2 in positions)
    return Nbeacons, maxdist
end

@time part1()