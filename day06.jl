const DATA = read("day06.txt", String)
const groups = split(DATA, "\n\n")

function part1(groups::Vector{<:AbstractString})
    total = 0
    for group in groups
        yes = Set(replace(group, '\n' => ""))
	total += length(yes)
    end
    return total
end

println("Part1: $(part1(groups))")

function part2(groups::Vector{<:AbstractString})
    total = 0
    for group in groups
    	yes = reduce(intersect, split(group, '\n'))
	total += length(yes)
    end
    return total
end

println("Part2: $(part2(groups))")

