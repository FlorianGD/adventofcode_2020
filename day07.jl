const rules = rstrip(read("day07.txt", String), '\n')

function parse_line(line::AbstractString)
    color, contained = split(line, " bags contain ")
    pattern = r"(\d+) (.*?) bag"
    return color => [(parse(Int, m.captures[1]), m.captures[2]) for m in eachmatch(pattern, contained)]
end

BagsColors = Vector{Tuple{Int,String}}

function create_assoc(rules::AbstractString)
    return Dict{String,BagsColors}(parse_line.(line) for line in split(rules, '\n'))
end

function find_possibles(rules::AbstractString)
    to_check = ["shiny gold"]
    assoc = create_assoc(rules)
    possible = Set{String}()
    for color in to_check
        for (rule_color, rule_contained) in assoc
            if color in [r[2] for r in rule_contained]
                push!(possible, rule_color)
                push!(to_check, rule_color)
            end
        end
    end
    return possible
end

function part1(rules::AbstractString)
    possibles = find_possibles(rules)
    return length(possibles)
end

println("Part 1: $(part1(rules))")

function count_bags(assoc::Dict{String,BagsColors}, key::String)::Int
    if isempty(assoc[key])
        return 0
    end
    return sum(c + c * count_bags(assoc, new_key) for (c, new_key) in assoc[key])
end

function part2(rules::AbstractString)
    assoc = create_assoc(rules)
    return count_bags(assoc, "shiny gold")
end

println("Part 2: $(part2(rules))")
