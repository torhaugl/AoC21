using OffsetArrays

function parse_line(line)
    on_off_str, str1 = split(line) .|> string
    x_str, y_str, z_str = [s[3:end] for s in split(str1, ",")]

    on_off = on_off_str == "on"
    x = parse(Int, split(x_str, "..")[1]):parse(Int, split(x_str, "..")[2])
    y = parse(Int, split(y_str, "..")[1]):parse(Int, split(y_str, "..")[2])
    z = parse(Int, split(z_str, "..")[1]):parse(Int, split(z_str, "..")[2])
    return on_off, x, y, z
end

function find_minmax()
    xmin = xmax = 0
    ymin = ymax = 0
    zmin = zmax = 0
    for line in eachline("aoc/day22_test2.txt")
        on_off, x, y, z = parse_line(line)
        xmin = min(xmin, minimum(x))
        ymin = min(ymin, minimum(y))
        zmin = min(zmin, minimum(z))
        xmax = max(xmax, maximum(x))
        ymax = max(ymax, maximum(y))
        zmax = max(zmax, maximum(z))
    end
    xmin, xmax, ymin, ymax, zmin, zmax
end

function zone(a, b, c, d, e, f)
    M = zeros(Bool, b-a+1, d-c+1, f-e+1)
    M = OffsetArray(M, a:b, c:d, e:f)
    for line in eachline("aoc/day22.txt")
        on_off, x, y, z = parse_line(line)
        M[max(minimum(x), a):min(maximum(x), b),
        max(minimum(y), c):min(maximum(y), d),
        max(minimum(z), e):min(maximum(z), f)] .= on_off
    end
    return sum(M)
end


function solve1()
    zone(-50, 50, -50, 50, -50, 50)
end

function solve2()
    a,b,c,d,e,f =  find_minmax()
    #zone(a, b, c, d, e, f) #out of memory error
end

solve1()
solve2()

struct Box
    x :: Tuple{Int, Int}
    y :: Tuple{Int, Int}
    z :: Tuple{Int, Int}
end

function is_overlapping(a, b)
    return ( (b.x[1] <= a.x[2] && a.x[1] <= b.x[2]) || (a.x[1] <= b.x[2] && b.x[1] <= a.x[2]) ) &&
           ( (b.y[1] <= a.y[2] && a.y[1] <= b.y[2]) || (a.y[1] <= b.y[2] && b.y[1] <= a.y[2]) ) &&
           ( (b.z[1] <= a.z[2] && a.z[1] <= b.z[2]) || (a.z[1] <= b.z[2] && b.z[1] <= a.z[2]) )
end


function overlapdim(a, b)
    if !is_overlapping(a, b) return nothing end
    a1 = a.x[1]
    a2 = a.x[2]
    b1 = b.x[1]
    b2 = b.x[2]
    if b1 > a1
        x = (b1, min(a2, b2))
    else
        x = (a1, min(b2, a2))
    end
    a1 = a.y[1]
    a2 = a.y[2]
    b1 = b.y[1]
    b2 = b.y[2]
    if b1 > a1
        y = (b1, min(a2, b2))
    else
        y = (a1, min(b2, a2))
    end
    a1 = a.z[1]
    a2 = a.z[2]
    b1 = b.z[1]
    b2 = b.z[2]
    if b1 > a1
        z = (b1, min(a2, b2))
    else
        z = (a1, min(b2, a2))
    end
    return Box(x, y, z)
end

function difference(a, b)
    ov = overlapdim(a, b)

    if a.x[1] < ov.x[1] <= ov.x[2] < a.x[2]
        xs = [(a.x[1], ov.x[1]-1), ov.x, (ov.x[2]+1, a.x[2])]
    elseif a.x[1] <= ov.x[1] <= ov.x[2] < a.x[2]
        xs = [ov.x, (ov.x[2]+1, a.x[2])]
    elseif a.x[1] < ov.x[1] <= ov.x[2] <= a.x[2]
        xs = [(a.x[1], ov.x[1]-1), ov.x]
    elseif a.x[1] <= ov.x[1] <= ov.x[2] <= a.x[2]
        xs = [ov.x]
    else
        println("ERROR")
    end
    if a.y[1] < ov.y[1] <= ov.y[2] < a.y[2]
        ys = [(a.y[1], ov.y[1]-1), ov.y, (ov.y[2]+1, a.y[2])]
    elseif a.y[1] <= ov.y[1] <= ov.y[2] < a.y[2]
        ys = [ov.y, (ov.y[2]+1, a.y[2])]
    elseif a.y[1] < ov.y[1] <= ov.y[2] <= a.y[2]
        ys = [(a.y[1], ov.y[1]-1), ov.y]
    elseif a.y[1] <= ov.y[1] <= ov.y[2] <= a.y[2]
        ys = [ov.y]
    else
        println("ERROR")
    end
    if a.z[1] < ov.z[1] <= ov.z[2] < a.z[2]
        zs = [(a.z[1], ov.z[1]-1), ov.z, (ov.z[2]+1, a.z[2])]
    elseif a.z[1] <= ov.z[1] <= ov.z[2] < a.z[2]
        zs = [ov.z, (ov.z[2]+1, a.z[2])]
    elseif a.z[1] < ov.z[1] <= ov.z[2] <= a.z[2]
        zs = [(a.z[1], ov.z[1]-1), ov.z]
    elseif a.z[1] <= ov.z[1] <= ov.z[2] <= a.z[2]
        zs = [ov.z]
    else
        println("ERROR")
    end

    boxes = Box[]
    for x in xs, y in ys, z in zs
        push!(boxes, Box(x, y, z))
    end
    deleteat!(boxes, findfirst(==(ov), boxes))
    return unique(boxes)
end

function mergeboxes(boxes)
    # Merge boxes with 2 equal dimensions, and third is an extension
    # (0,1), (2,3), (0,4) with (0,1), (2,3), (4,6)
    merged = true
    while merged
        merged = false
        for i = 1:length(boxes), j = i+1:length(boxes)
            if boxes[i].x == boxes[j].x && boxes[i].y == boxes[j].y && (boxes[i].z[2] + 1 == boxes[j].z[1] || boxes[i].z[1] == boxes[j].z[2] + 1)
                merged = true
                z = (min(boxes[i].z[1], boxes[j].z[1]), max(boxes[i].z[2], boxes[j].z[2]))
                box = Box(boxes[i].x, boxes[i].y, z)
                deleteat!(boxes, (i, j))
                pushfirst!(boxes, box)
                break
            end
            if boxes[i].z == boxes[j].z && boxes[i].x == boxes[j].x && (boxes[i].y[2] + 1 == boxes[j].y[1] || boxes[i].y[1] == boxes[j].y[2] + 1)
                merged = true
                y = (min(boxes[i].y[1], boxes[j].y[1]), max(boxes[i].y[2], boxes[j].y[2]))
                box = Box(boxes[i].x, y, boxes[i].z)
                deleteat!(boxes, (i, j))
                pushfirst!(boxes, box)
                break
            end
            if boxes[i].y == boxes[j].y && boxes[i].z == boxes[j].z && (boxes[i].x[2] + 1 == boxes[j].x[1] || boxes[i].x[1] == boxes[j].x[2] + 1)
                merged = true
                x = (min(boxes[i].x[1], boxes[j].x[1]), max(boxes[i].x[2], boxes[j].x[2]))
                box = Box(x, boxes[i].y, boxes[i].z)
                deleteat!(boxes, (i, j))
                pushfirst!(boxes, box)
                break
            end
        end
    end
    return boxes
end

a = Box((0,3), (0,3), (0,3))
b = Box((1,2), (1,2), (1,2))
c = Box((2,3), (2,3), (0,4))
overlapdim(a, b)
overlapdim(a, c)
overlapdim(b, c)


boxes = difference(a, b) |> mergeboxes
@show boxes
boxes = union(a,b) |> mergeboxes

for i = 1:length(boxes), j = i+1:length(boxes)
    if is_overlapping(boxes[i], boxes[j])
        @show i, j, is_overlapping(boxes[i], boxes[j])
        @show boxes[i] boxes[j]
    end
end


is_containing(a, b)
is_overlapping(a, b)





lines = readlines("aoc/day22.txt")
on_off, x, y, z = parse_line(lines[1])
boxes = [Box((x[1], x[end]), (y[1],y[end]), (z[1], z[end]))]
for line in lines[2:end]
    on_off, x, y, z = parse_line(line)
    new_box = Box((x[1], x[end]), (y[1],y[end]), (z[1], z[end]))
    todelete = Box[]
    toadd = Box[]
    if on_off
        for box in boxes
            if is_overlapping(box, new_box)
                push!(todelete, box)
                new_boxes = difference(box, new_box) |> mergeboxes
                toadd = vcat(toadd, new_boxes)
            end
        end
        for box in todelete
            deleteat!(boxes, findfirst(==(box), boxes))
        end
        boxes = vcat(boxes, toadd)
        push!(boxes, new_box)
    else
        for box in boxes
            if is_overlapping(box, new_box)
                push!(todelete, box)
                new_boxes = difference(box, new_box) |> mergeboxes
                toadd = vcat(toadd, new_boxes)
            end
        end
        for box in todelete
            deleteat!(boxes, findfirst(==(box), boxes))
        end
        boxes = vcat(boxes, toadd)
    end
end
boxes

for i = 1:length(boxes), j = i+1:length(boxes)
    if is_overlapping(boxes[i], boxes[j])
        @show i, j, is_overlapping(boxes[i], boxes[j])
        @show boxes[i] boxes[j]
    end
end

boxes = mergeboxes(boxes)
t = 0
for b in boxes
    t += (b.x[2] - b.x[1] + 1) * (b.y[2] - b.y[1] + 1) * (b.z[2] - b.z[1] + 1)
end
@show t
boxes