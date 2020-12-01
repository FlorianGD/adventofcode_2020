data = parse.(Int32, readlines("day01.txt"))

function part1(data::Array{Int32,1})
    l = length(data)
    for i in 1:(l - 1), j in (i + 1):l
        if data[i] + data[j] == 2020
            return data[i] * data[j]
        end
    end
end

function part2(data::Array{Int32,1})
    l = length(data)
    for i in 1:(l - 2), j in (i + 1):(l - 1), k in (i + 2):l
        if data[i] + data[j] + data[k] == 2020
            return data[i] * data[j] * data[k]
        end
    end
end

println("Part 1 solution $(part1(data))")
println("Part 2 solution $(part2(data))")
