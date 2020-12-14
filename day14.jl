function parse_mask(mask::AbstractString)
    ones = parse(Int, replace(mask, 'X' => '0'), base=2)
    zeros = parse(Int,
    replace(replace(replace(mask, '1' => 'X'), '0' => '1'), 'X' => '0'),
    base=2)
    return ones, zeros
end

function apply_mask(val::Int, ones::Int, zeros::Int)
    return ones | val & ~zeros
end

function part1(lines)
    ones = zeros = 0
    mem = Dict{Int, Int}()
    for line in lines
        if startswith(line, "ma")
            # 8 because the line is "mask = XXXX...", so X starts at 8
            ones, zeros = parse_mask(line[8:end])
        else
            place, value = parse.(Int, (m.match for m in eachmatch(r"\d+", line)))
            mem[place] = apply_mask(value, ones, zeros)
        end
    end
    return sum(values(mem))
end

const DATA = readlines("day14.txt")

println("Part 1: $(part1(DATA))")

using Combinatorics


function parse_mask_p2(mask::AbstractString)
    ones = parse(Int, replace(mask, 'X' => '0'), base=2)
    Xindices = reduce(vcat, findall("X", reverse(mask)))
    # 1 << n is 2^n, and as the indexes start at 1, we need to substract 1
    Xvalues = 1 .<< (Xindices .- 1)
    return ones, Xvalues
end

function apply_mask_p2(val::Int, ones::Int, Xs::Array{Int})
    values = Int[]
    # set all the mask's 1 to 1 and set all the Xs to 0
    start_val = (val | ones) & ~(sum(Xs))
    push!(values, start_val)
    for comb in combinations(Xs)
        mask = sum(comb)
        push!(values, start_val | mask)
    end
    return values
end

function part2(lines)
    ones = 0
    Xs = Int[]
    mem = Dict{Int,Int}()
    for line in lines
        if startswith(line, "ma")
            # 8 because the line is "mask = XXXX...", so X starts at 8
            ones, Xs = parse_mask_p2(line[8:end])
        else
            place, value = parse.(Int, (m.match for m in eachmatch(r"\d+", line)))
            new_adresses = apply_mask_p2(place, ones, Xs)
            for address in new_adresses
                mem[address] = value
            end
        end
    end
    return sum(values(mem))
end

println("Part 2: $(part2(DATA))")