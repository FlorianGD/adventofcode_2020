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

function tonextsdict(data::Vector{Int}, p1::Bool=false)
    nexts = Dict{Int,Int}()
    for (d, n) in zip(data, data[2:end])
        nexts[d] = n
    end
    if p1
        nexts[data[end]] = data[1]
        return nexts
    end
    nexts[data[end]] = 10
    for i in 10:999_999
        nexts[i] = i + 1
    end
    nexts[1_000_000] = data[1]
    return nexts
end

function move2!(nexts::Dict{Int,Int}, current::Int)
    n1 = nexts[current]
    n2 = nexts[n1]
    n3 = nexts[n2]
    nextcurrent = nexts[n3]
    dest = destination([n1, n2, n3], current, length(nexts))
    # insert here
    finalnext = nexts[dest]
    nexts[current] = nextcurrent
    nexts[dest] = n1
    nexts[n3] = finalnext
    return nexts, nextcurrent
end

function play2!(nexts::Dict{Int,Int}, start::Int, n::Int=10_000_000)
    current = start
    for i in 1:n
        nexts, current = move2!(nexts, current)
    end
    return nexts
end


function part2(data)
    nexts = tonextsdict(data)
    play2!(nexts, data[1])
    a = nexts[1]
    b = nexts[a]
    return a * b
end

println("Part 2: $(part2(data))")
