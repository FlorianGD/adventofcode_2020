const timestamp_raw, buses_raw = readlines("day13.txt")

const timestamp = parse(Int, timestamp_raw)

const buses_p1 = parse.(Int, [b for b in split(buses_raw, ',') if b != "x"])

function part1(buses::Array{Int}, timestamp::Int)
    remainders = mod.(-timestamp, buses)
    bus_min = argmin(remainders)
    return buses[bus_min] * remainders[bus_min]
end

println("Part 1: $(part1(buses_p1, timestamp))")

buses_p2 = [[parse(Int, b), -i + 1] for (i, b) in enumerate(split(buses_raw, ",")) if b != "x"]

function chineseremainder(Ns::Vector{BigInt}, remainders::Vector{BigInt})
    n = BigInt(prod(Ns))
    Ni = n .÷ Ns
    invs = invmod.(Ni, Ns) .* Ni
    s = sum(remainders .* invs) % n
    return s >= 0 ? s : s + n
end

function part2(buses)
    Ns = @. BigInt(first(buses))
    remainders = @. BigInt(last(buses))
    return chineseremainder(Ns, remainders)
end

println("Part 2: $(part2(buses_p2))")
