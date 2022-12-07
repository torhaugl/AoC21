function parseinput(fname)
    lines = readlines(fname)
    algorhitm_str = lines[1]
    algorhitm = [c == '#' for c in algorhitm_str]

    image = lines[3:end]

    A = zeros(Bool, length(image[1]), length(image))
    for (i, line) in enumerate(image), (j, c) in enumerate(line)
        A[i, j] = (c == '#')
    end
    return algorhitm, A
end

function bit2int(bit)
    t = 0
    for i = 0:length(bit)-1
        t += 2^(i) * bit[end-i]
    end
    return t
end

function enhance(input, flip, flip2)
    N = 4
    if !flip2 
        input2 = zeros(Bool, size(input,1) + N, size(input,2) + N)
        output = zeros(Bool, size(input2))
    else
        if !flip
            input2 = ones(Bool, size(input,1) + N, size(input,2) + N)
            output = zeros(Bool, size(input2))
        else
            input2 = zeros(Bool, size(input,1) + N, size(input,2) + N)
            output = ones(Bool, size(input2))
        end
    end

    for i = 1:size(input, 1), j = 1:size(input, 2)
        input2[i+N÷2, j+N÷2] = input[i, j]
    end


    for i = 2:size(input, 1)+N-1, j = 2:size(input, 2)+N-1
        input_space = vcat(input2[i-1, j-1:j+1], input2[i, j-1:j+1], input2[i+1, j-1:j+1])
        index_bit = BitVector(input_space)
        new_value = algorhitm[bit2int(index_bit)+1]
        output[i, j] = new_value
    end
    output
end


algorhitm, input = parseinput("aoc/day20.txt")

output = copy(input)
flip = algorhitm[1]
N = 2
for _ = 1:N
    output = enhance(output, flip, algorhitm[1])
    if algorhitm[1]
        flip = !flip
    end
end
part1_ans = sum(output[1+N:end-N, 1+N:end-N])

output = copy(input)
flip = algorhitm[1]
N = 50
for _ = 1:N
    output = enhance(output, flip, algorhitm[1])
    if algorhitm[1]
        flip = !flip
    end
end
part2_ans = sum(output[1+N:end-N, 1+N:end-N])