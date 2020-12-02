struct Row
    ind1::Int
    ind2::Int
    char::Char
    string::AbstractString
end

function torow(line::AbstractString)
    ind1, ind2, char, string = split(line, r"(:? )|-")
    ind1, ind2 = parse.(Int, [ind1, ind2])
    char = first(char)
    return Row(ind1, ind2, char, string)
end

function testline(line::AbstractString)
    row = torow(line)
    counts = count(i -> (i == row.char), row.string)
    return row.ind1 <= counts <= row.ind2
end

function testline2(line::AbstractString)
    row = torow(line)
    # Only one of the two must be equal to row.char
    return sum([row.string[row.ind1], row.string[row.ind2]] .== row.char) == 1
end

function part1()
    return sum(testline(line) for line in readlines("day02.txt"))
end

function part2()
    return sum(testline2(line) for line in readlines("day02.txt"))
end

println("Part1: $(part1())")
println("Part2: $(part2())")
