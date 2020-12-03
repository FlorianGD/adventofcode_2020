const TREES = readlines("day03.txt")

function numhit(slope::Tuple{Int64,Int64}, trees::Array{<:AbstractString,1})
    total = 0
    height = length(trees)
    width = length(trees[1])
    for i = 2:slope[1]:height
        j = mod1(slope[2] * (i - 1) + 1, width)
        if trees[i][j] == '#'
            total += 1
        end
    end
    return total
end

println("Part 1: $(numhit((1, 3), TREES))")

const SLOPES = [(1, 1), (1, 3), (1, 5), (1, 7), (2, 1)]

println("Part 2: $(prod(numhit(slope, TREES) for slope in SLOPES))")
