function parse_line(line)
    on_off_str, str1 = split(line) .|> string
    x_str, y_str, z_str = [s[3:end] for s in split(str1, ",")]

    on_off = on_off_str == "on"
    x = parse(Int, split(x_str, "..")[1]):parse(Int, split(x_str, "..")[2])
    y = parse(Int, split(y_str, "..")[1]):parse(Int, split(y_str, "..")[2])
    z = parse(Int, split(z_str, "..")[1]):parse(Int, split(z_str, "..")[2])
    return on_off, x, y, z
end

using OffsetArrays

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
    zone(a, b, c, d, e, f) #out of memory error
end

solve1()
solve2()