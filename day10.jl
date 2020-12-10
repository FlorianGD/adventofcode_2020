using DelimitedFiles
using IterTools

const data = dropdims(readdlm("day10.txt", Int); dims=2)

function wrangle!(data::Vector{Int})
    pushfirst!(data, 0)
    sort!(data)
    return data
end

wrangle!(data)

function count_diff(data::Vector{Int})
    diff_data = diff(data)
    # +1 because there is a fake final point that is 3 above the max value as
    # stated in the instructions.
    return count(==(1), diff_data) * (count(==(3), diff_data) + 1)
end

println("Part 1: $(count_diff(data))")

function part2(data::Vector{Int})
    total = 1
    for consecutive in groupby(==(1), diff(data))
        if length(consecutive) > 1 && consecutive[1] == 1
            total *= 1 + binomial(length(consecutive), 2)
        end
    end
    return total
end

println("Part 2: $(part2(data))")
