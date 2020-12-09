using DelimitedFiles
using DataStructures

function process!(values::CircularBuffer{Int}, value::Int)
    # The core is below, if the sum of two number sums to value, the difference of the
    # value and the others values must be in values. 
    if !isempty(intersect(values, value .- values))
        push!(values, value)
        return -1
    else
        return value
    end
end

function part1(xmas::Vector{Int}; preamble::Int=25)
    values = CircularBuffer{Int}(preamble)
    # init
    append!(values, xmas[1:preamble])
    for value in xmas[preamble + 1:end]
        test = process!(values, value)
        if test != -1
            return test
        end
    end
end

const xmas = dropdims(readdlm("day09.txt", Int); dims=2)

weakness = part1(xmas)
println("Part 1: $weakness")

function findweakness(xmas::Vector{Int}, target::Int)
    n = length(xmas)
    for i = 1:n - 1
        for j = i + 1:n
            s = sum(xmas[i:j])
            if s == target
                return sum(extrema(xmas[i:j]))
            elseif s > target
                break
            end
        end
    end
end

println("Part 2: $(findweakness(xmas, weakness))")
