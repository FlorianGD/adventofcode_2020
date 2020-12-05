const DATA = readlines("day05.txt")

function input_to_int(row::AbstractString, pair1::Pair, pair2::Pair, pair3::Pair, pair4::Pair)
    row_bin = replace(replace(replace(replace(row, pair1), pair2), pair3), pair4)
    return parse(Int, row_bin, base = 2)
end

function compute(seat::AbstractString)
    return input_to_int(seat, 'R' => '1', 'L' => '0', 'F' => '0', 'B' => '1')
end

const seats = Set(compute(seat) for seat in DATA)

println("Part 1 : $(maximum(seats))")

part2 = setdiff(minimum(seats):maximum(seats), seats)

println("Part 2 : $(part2[1])")

