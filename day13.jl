const timestamp_raw, buses_raw = readlines("day13.txt")

const timestamp = parse(Int, timestamp_raw)

const buses_p1 = parse.(Int, [b for b in split(buses_raw, ',') if b != "x"])

function part1(buses::Array{Int}, timestamp::Int)
    remainders = mod.(-timestamp, buses)
    bus_min = argmin(remainders)
    return buses[bus_min] * remainders[bus_min]
end

prinln("Part 1: $(part1(buses_p1, timestamp))")
