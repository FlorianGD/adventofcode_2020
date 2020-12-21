function getallergens(lines::Vector{<:AbstractString})
    ingredients = Vector{Vector{String}}()
    allergens = Dict{String,Vector{String}}()
    for line in lines
        ingr, aller = split(line[1:end - 1], " (contains ")
        ingr_list = split(ingr, " ")
        push!(ingredients, ingr_list)
        aller_list = split(aller, ", ")
        for al in aller_list
            allergens[al] = intersect(get(allergens, al, ingr_list), ingr_list)
        end
    end
    return allergens, ingredients
end

function countsafe(
    allergens::Dict{String,Vector{String}},
    ingredients::Vector{Vector{String}})
    unsafe = union(values(allergens)...)
    all_ingredients = union(ingredients...)
    safe = setdiff(all_ingredients, unsafe)
    total = 0
    for ingr_list in ingredients
        total += count(x -> x ∈ safe, ingr_list)
    end
    return total
end

const data = readlines("day21.txt")
const allergens, ingredients = getallergens(data)

println("Part 1: $(countsafe(allergens, ingredients))")

function next_identified(allergens::Dict{String,Vector{String}})
    sure = Tuple{String,String}[]
    for (aller, ing) in filter(x -> length(x[2]) == 1, collect(allergens))
        push!(sure, (aller, ing[1]))
        for (k, v) in allergens
            allergens[k] = setdiff(v, ing)
        end
    end
    return sure
end

function findmap(allergens::Dict{String,Vector{String}})
    known = []
    m = next_identified(allergens)
    while !(isempty(m))
        push!(known, m)
        m = next_identified(allergens)
    end
    return collect(Iterators.flatten(known))
end

function part2(allergens)
    known = findmap(allergens)
    return join((x[2] for x in sort(known)), ",")
end

println("Part 2: $(part2(allergens))")
