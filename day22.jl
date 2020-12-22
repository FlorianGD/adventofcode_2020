function initplayers(lines)
    sep =  findfirst(==(""), lines)
    p1 = parse.(Int, lines[2:sep-1])
    p2 = parse.(Int, lines[sep+2:end])
    return (p1, p2)
end

function oneround!(p1, p2)
    c1, c2 = popfirst!.([p1, p2])
    c1 > c2 ? push!(p1, c1, c2) : push!(p2,c2, c1)
    return (p1, p2)
end

function score(p)
    l = length(p)
    return sum(a*b for (a, b) in zip(p, l:-1:1))
end

function play!(p1, p2)
    while !(any(isempty.([p1, p2])))
        oneround!(p1, p2)
    end
end

function part1(data)
    p1, p2 = initplayers(data)
    play!(p1, p2)
    p = isempty(p2) ? p1 : p2
    return score(p)
end


const data = readlines("day22.txt")

println("Part 1: $(part1(data))")

