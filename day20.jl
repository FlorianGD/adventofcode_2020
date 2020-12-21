using Combinatorics

Tile = Matrix{Bool}

function extracttiles(lines::Vector{<:AbstractString})
    sep = findall(x -> ':' ∈ x, lines)
    # 6:end - 1 because the line is "Tile <id>:"
    ids = parse.(Int, [l[6:end - 1] for l in lines[sep]])
    # -2 because there is a blank line between the tiles
    ends = sep[2:end] .- 2
    push!(ends, length(lines))
    d = Dict{Int,Tile}()
    # the tiles are 10 by 10, hence the hardcoded 10 below
    for (id, start, stop) in zip(ids, sep .+ 1, ends)
        tile = lines[start:stop]
        d[id] = [t[i] == '#' for t in tile, i = 1:10]
    end
    return d
end

function pprint(tile::Tile)
    for l in eachrow(tile)
        line = join([i == false ? "░" : "█" for i in l])
        println(line)
    end
end

function makeallpositions(tile::Tile)
    m = Tile[tile]
# Rotations
    for i in 1:3
        push!(m, rotl90(tile, i))
    end
# Flips
    push!(m, reverse(tile, dims=1))
    push!(m, reverse(tile, dims=2))
    return m
end

rightside(t::Tile) = view(t, :, 10)
leftside(t::Tile) = view(t, :, 1)
upside(t::Tile) = view(t, 1, :)
downside(t::Tile) = view(t, 10, :)

function findmatch(t1::Tile, t2::Tile)
    facing = [(leftside, rightside), (rightside, leftside), (upside, downside), (downside, upside)]
    for (op1, op2) in facing
        if op1(t1) == op2(t2)
            return true
        end
    end
    return false
end

function allpositions(tiles::Dict{Int,Tile})
    alltiles = Dict{Int,Vector{Tile}}()
    for (id, tile) in tiles
        alltiles[id] = makeallpositions(tile)
    end
    return alltiles
end

function findallmatches(all_tiles::Dict{Int,Vector{Tile}})
    # Init dictionary of matching tiles
    matches = Dict{Int,Vector{Int}}()
    for id in keys(all_tiles)
        matches[id] = Int[]
    end
    # The hard way, check all combinations of all possible positions
    for (id1, id2) in combinations(collect(keys(all_tiles)), 2)
        for t1 in all_tiles[id1], t2 in all_tiles[id2]
            if findmatch(t1, t2)
                push!(matches[id1], id2)
                push!(matches[id2], id1)
                break
            end
        end
    end
    return matches
end

function corners(matches::Dict{Int,Vector{Int}})
    return [k for k in keys(matches) if length(matches[k]) == 2]
end

function part1(lines)
    tiles = extracttiles(lines)
    alltiles = allpositions(tiles)
    matches = findallmatches(alltiles)
    return prod(corners(matches))
end
test = split("""Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...""", "\n")
