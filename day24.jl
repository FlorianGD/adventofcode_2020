Coord = CartesianIndex{3}

const movements = Dict{String,Coord}(
    "e"  => Coord(1, -1, 0),
    "w"  => Coord(-1, 1, 0),
    "ne" => Coord(1, 0, -1),
    "nw" => Coord(0, 1, -1),
    "se" => Coord(0, -1, 1),
    "sw" => Coord(-1, 0, 1),
)

function tilecoord(line::AbstractString, movements::Dict{String,Coord}=movements)
    dirs = r"se|sw|ne|nw|e|w"
    directions = [line[m] for m in findall(dirs, line)]
    return sum(movements[d] for d in directions) 
end

function flip!(tiles::Dict{Coord,Bool}, line::AbstractString)
    coord = tilecoord(line)
    tiles[coord] = !get(tiles, coord, false)
    return tiles
end

function init(lines::Vector{<:AbstractString})
    tiles = Dict{Coord,Bool}()
    for line in lines
        flip!(tiles, line)
    end
    return tiles
end

const tiles = init(readlines("day24.txt"))

println("Part 1: $(sum(values(tiles)))")

const neighbors = collect(values(movements))

function with_black_neighbors(blacktiles::Set{Coord}, neighbors::Vector{Coord}=neighbors)
    blackneighbors = Dict{Coord,Int}()
    for t in blacktiles, n in neighbors
        blackneighbors[t + n] =  get(blackneighbors, t + n, 0) + 1
    end
    return blackneighbors
end

function flipall(blacktiles::Set{Coord}, blackneighbors::Dict{Coord,Int})
    futuretiles = copy(blacktiles)
    for a in blacktiles
        n = get(blackneighbors, a, 0)
        if n == 0 || n > 2
            pop!(futuretiles, a)
        end
    end
    for (a, n) in blackneighbors
        if n == 2 && a ∉ blacktiles
            push!(futuretiles, a)
        end
    end
    return futuretiles
end

function part2(tiles::Dict{Coord,Bool})
    blacktiles = Set{Coord}(k for (k, v) in tiles if v)
    for i in 1:100
        blackneighbors = with_black_neighbors(blacktiles)
        blacktiles = flipall(blacktiles, blackneighbors)
    end
    return length(blacktiles)
end

println("Part 2: $(part2(tiles))")
