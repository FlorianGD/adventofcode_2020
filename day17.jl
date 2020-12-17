function parseinput(lines::Vector{String})::Dict{CartesianIndex{3},Int}
    grid = Dict{CartesianIndex{3},Int}()
    for (i, line) in enumerate(lines)
        for (j, char) in enumerate(line)
            grid[CartesianIndex(i, j, 0)] = char == '#'
        end
    end
    return grid
end

function nextstate(
    grid::Dict{CartesianIndex{N},Int},
    pos::CartesianIndex{N},
    neighbors::Vector{CartesianIndex{N}}) where N
    state = get(grid, pos, 0)
    if state == 1
        return sum(get(grid, pos + n, 0) for n in neighbors) ∈ [2, 3] ? 1 : 0
    else
        return sum(get(grid, pos + n, 0) for n in neighbors) == 3 ? 1 : 0
    end
end

function oneround!(
    grid::Dict{CartesianIndex{N},Int},
    neighbors::Vector{CartesianIndex{N}}) where N
    prev_grid = copy(grid)
    for k in keys(prev_grid)
        for n in neighbors
            grid[k + n] = nextstate(prev_grid, k + n, neighbors)
        end
    end
end

const neighbors_p1 = [
    CartesianIndex(i, j, k) 
    for i = -1:1 for j = -1:1 for k = -1:1 
    if !(i == j == k == 0)
]

const data = readlines("day17.txt")
const grid_p1 = parseinput(data)

function run!(grid::Dict{CartesianIndex{N},Int}, neighbors::Vector{CartesianIndex{N}}) where N
    for i in 1:6
        oneround!(grid, neighbors)
    end
    return sum(values(grid))
end

println("Part 1: $(run!(grid_p1, neighbors_p1))")


function parseinput_p2(lines::Vector{String})::Dict{CartesianIndex{4},Int}
    grid = Dict{CartesianIndex{4},Int}()
    for (i, line) in enumerate(lines)
        for (j, char) in enumerate(line)
            grid[CartesianIndex(i, j, 0, 0)] = char == '#'
        end
    end
    return grid
end

const neighbors_p2 = [
    CartesianIndex(i, j, k, l) 
    for i = -1:1 for j = -1:1 for k = -1:1 for l = -1:1
    if !(i == j == k == l == 0)
]

const grid_p2 = parseinput_p2(data)

println("Part 2: $(run!(grid_p2, neighbors_p2))")