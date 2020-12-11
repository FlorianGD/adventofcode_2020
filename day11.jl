using DelimitedFiles

const data = readdlm("day11.txt", String)

# floor will be 0, empty will be 1 and occupied will be 2

function create_matrix(data::Array{<:AbstractString,2})
    # We will pad the data with 0s around
    height = length(data) + 2
    width = length(data[1]) + 2
    mat = zeros(Int, (height, width))
    for (i, line) in enumerate(data)
        for (j, c) in enumerate(data[i])
            if c == 'L'
                # +1 because padding
                mat[i + 1 , j + 1] = 1
            end
        end
    end
    return mat
end

function process(mat::Array{Int,2}, i::Int, j::Int)
    state = mat[i, j]
    # empty
    if state == 1
        # if any is occupied, stay empty, else occupied
        new_state = any(mat[xi, xj] == 2 for xi ∈ i - 1:i + 1, xj ∈ j - 1:j + 1) ? 1 : 2
    # occupied
    elseif state == 2
        # If 4 adjacent (i.e. 5 including itself) are occupied, becomes empty
        new_state = sum(mat[xi, xj] == 2 for xi ∈ i - 1:i + 1, xj ∈ j - 1:j + 1) >= 5 ? 1 : 2
    else
        new_state = state
    end
    return new_state
end

function one_pass(mat::Array{Int,2})
    h, w = size(mat)
    new_mat = zeros(Int, (h, w))
    for i ∈ 2:h - 1, j ∈ 2:w - 1
        new_mat[i, j] = process(mat, i, j)
    end
    return new_mat
end

function wait_for_stable(mat::Array{Int,2})
    new_mat = one_pass(mat)
    while new_mat != mat
        mat = new_mat
        new_mat = one_pass(mat)
    end
    return count(==(2), mat)
end

const mat = create_matrix(data)

println("Part 1: $(wait_for_stable(mat))")


# Now we want the first non empty seat in each of the 8 directions

function look_in_direction(mat::Array{Int,2}, i::Int, j::Int, xi::Int, xj::Int)
    maxi, maxj = size(mat)
    while true
        new_i, new_j = i + xi, j + xj
        if new_i ∈ [1, maxi] || new_j ∈ [1, maxj]
            # we reached the end
            return 0
        end
        if mat[new_i, new_j] != 0
            return mat[new_i, new_j]
        end
        i, j = new_i, new_j
    end
end


function process_p2(mat::Array{Int,2}, i::Int, j::Int)
    state = mat[i, j]
    # empty
    if state == 1
        # if any is occupied, stay empty, else occupied
        new_state = any(look_in_direction(mat, i, j, xi, xj) == 2 for xi ∈ - 1:1, xj ∈ - 1:1) ? 1 : 2
    # occupied
    elseif state == 2
        # If 5 adjacent (i.e. 6 including itself) are occupied, becomes empty
        new_state = sum(look_in_direction(mat, i, j, xi, xj) == 2 for xi ∈ - 1:1, xj ∈ - 1:1) >= 6 ? 1 : 2
    else
        new_state = state
    end
    return new_state
end

function one_pass_p2(mat::Array{Int,2})
    h, w = size(mat)
    new_mat = zeros(Int, (h, w))
    for i ∈ 2:h - 1, j ∈ 2:w - 1
        new_mat[i, j] = process_p2(mat, i, j)
    end
    return new_mat
end

function wait_for_stable_p2(mat::Array{Int,2})
    new_mat = one_pass(mat)
    while new_mat != mat
        mat = new_mat
        new_mat = one_pass_p2(mat)
    end
    return count(==(2), mat)
end

println("Part 2: $(wait_for_stable_p2(mat))")
