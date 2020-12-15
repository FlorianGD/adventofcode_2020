const input = Int[0,1,4,13,15,12,16]

function init(input::Vector{Int})
    state = Dict{Int,Vector{Int}}()
    for (i, val) in enumerate(input)
        state[val] = [i]
    end
    return state
end

function turn!(state::Dict{Int,Vector{Int}}, value::Int, now::Int)
    new_val = 0
    already_said = keys(state)
    if value ∈ already_said
        prev_turns = state[value]
        if length(prev_turns) >= 2
            new_val = prev_turns[end] - prev_turns[end - 1]
        end
    end
    if new_val ∉ already_said
        state[new_val] = [now]
    else
        push!(state[new_val], now)
    end
    return state, new_val
end

function play(input::Vector{Int}, until::Int)
    state = init(input)
    val = last(input)
    start = length(input) + 1
    for now in start:until
        state, val = turn!(state, val, now)
    end
    return val
end

println("Part 1: $(play(input, 2020))")
println("Part 2: $(play(input, 30000000))")
