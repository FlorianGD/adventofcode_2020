const data = parse.(Int, split("219748365", ""))

function destination(cups::Vector{Int}, current::Int, n::Int=9)
    for i in 1:4
        a = mod1(current - i, n)
        a ∉ cups && return a
    end
end

function move!(allcups::Vector{Int}, current_ind::Int)
    current = allcups[current_ind]
    allcups = circshift(allcups, -current_ind)
    cups = splice!(allcups, 1:3)
    next_val = allcups[1]
    dest = findfirst(==(destination(cups, current)), allcups)
    allcups = prepend!(circshift(allcups, -dest), cups)
    return (allcups, findfirst(==(next_val), allcups))
end

function play(allcups::Vector{Int}, n::Int=100)
    dest = 1
    for i in 1:n
        i % 1000 == 0 && println("$(i / n) %")
        allcups, dest = move!(allcups, dest)
    end
    return allcups
end

function result(allcups::Vector{Int})
    one = findfirst(==(1), allcups)
    return join(circshift(allcups, -one)[1:8])
end

println("Part 1: $(result(play(data)))")

# Shame
const data2 = [parse.(Int, split("219748365", ""))..., 10:1000000...]


