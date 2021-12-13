using DelimitedFiles

function read_input(input)
    data = readdlm(input, ',', Int)
    data .+= 1
    mat = falses(maximum(data[:,2]), maximum(data[:,1]))
    for row in eachrow(data)
        mat[row[2],row[1]] = true
    end
    return mat
end

function fold_y(A, y)
    y += 1
    B = copy(A[1:y-1, :])
    for x = 1:size(A, 2)
        for i = 1:(size(A,1) - y)
            B[y-i,x] = A[y-i,x] || A[y+i,x]
        end
    end
    return B
end

function fold_x(A, x)
    x += 1
    B = copy(A[:, 1:x-1])
    for y = 1:size(A, 1)
        for i = 1:(size(A, 2) - x)
            B[y,x-i] = A[y,x-i] || A[y,x+i]
        end
    end
    return B
end

# TEST
#mat = read_input("aoc/day13_test.txt")
#sum(mat)
#mat = fold_y(mat, 7)
#sum(mat)
#mat = fold_x(mat, 5)
#sum(mat)



mat = read_input("aoc/day13.txt")
mat = fold_x(mat, 655)
sum(mat)
mat = fold_y(mat, 447)
mat = fold_x(mat, 327)
mat = fold_y(mat, 223)
mat = fold_x(mat, 163)
mat = fold_y(mat, 111)
mat = fold_x(mat, 81)
mat = fold_y(mat, 55)
mat = fold_x(mat, 40)
mat = fold_y(mat, 27)
mat = fold_y(mat, 13)
mat = fold_y(mat, 6)
using Plots
heatmap(mat[end:-1:1,:], aspect_ratio=:equal)