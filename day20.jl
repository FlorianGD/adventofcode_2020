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
        line = join([i == false ? "░░" : "██" for i in l])
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
    reversed = reverse(tile, dims=1)
    push!(m, reversed)
    push!(m, rotl90(reversed, 1))
    push!(m, rotl90(reversed, 3))
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

function getcorners(matches::Dict{Int,Vector{Int}})
    return [k for k in keys(matches) if length(matches[k]) == 2]
end

const data = readlines("day20.txt")
const tiles = extracttiles(data)
const alltiles = allpositions(tiles)
const matches = findallmatches(alltiles)
const corners = getcorners(matches)

println("Part 1: $(prod(corners))")

# We managed to make part 1 without making the grid, but we need to go there for part 2.
# one grid for the actual tiles in the correct position, and one with the id, so we can
# use our already computed matches dictionary.
const grid = Matrix{Tile}(undef, 12, 12)
const gridid = Matrix{Int}(undef, 12, 12)

function removeid!(matches, id)
    # remove from matches when the tile is set on the grid, so we do not need to look it
    # up anymore.
    for (i, tileids) in matches
        matches[i] = [t for t in tileids if t != id]
    end
    return matches
end

function settileingrid!(pos, id, tile, grid, gridid, matches, alltiles)
    grid[pos...] = tile
    gridid[pos...] = id
    alltiles[id] = Tile[tile]
    removeid!(matches, id)
end

function startingpoint!(grid, gridid, alltiles, matches, corners)
    # select arbitrarily one corner
    id = corners[1]
    gridid[1, 1] = id
    # it is a corner so we know it can only be connected to 2 tiles
    id1, id2 = matches[id]
    for t in alltiles[id], t1 in alltiles[id1], t2 in alltiles[id2]
        if rightside(t) == leftside(t1) && downside(t) == upside(t2)
            settileingrid!((1, 1), id, t, grid, gridid, matches, alltiles)
            settileingrid!((1, 2), id1, t1, grid, gridid, matches, alltiles)
            settileingrid!((2, 1), id2, t2, grid, gridid, matches, alltiles)
        elseif rightside(t) == leftside(t2) && downside(t) == upside(t1)
            settileingrid!((1, 1), id, t, grid, gridid, matches, alltiles)
            settileingrid!((1, 2), id2, t2, grid, gridid, matches, alltiles)
            settileingrid!((2, 1), id1, t1, grid, gridid, matches, alltiles)
        end
    end
end



function setnextright!(pos, grid, gridid, alltiles, matches)
    # set the next id and tile in the grids for a given position
    i, j = pos
    lefttile = j > 1 ?   grid[i, j - 1] : nothing
    leftid   = j > 1 ? gridid[i, j - 1] : nothing
    uptile   = i > 1 ?   grid[i - 1, j] : nothing
    upid     = i > 1 ? gridid[i - 1, j] : nothing
    possiblenexts = leftid !== nothing ? matches[leftid] : matches[upid]
    for id1 in possiblenexts
        # shortcut here if the related id is not on the same line
        if length(matches[id1]) > 3
            continue
        end
        for t1 in alltiles[id1]
            if lefttile === nothing
                check = downside(uptile) == upside(t1)
            elseif uptile === nothing
                check = rightside(lefttile) == leftside(t1)
            else
                check = downside(uptile) == upside(t1) && rightside(lefttile) == leftside(t1)
            end
            if check
                settileingrid!(pos, id1, t1, grid, gridid, matches, alltiles)
                return nothing
            end
        end
    end
    return nothing
end

function fillgrids!(grid, gridid, matches, alltiles, corners)
    x, y = size(grid)
    startingpoint!(grid, gridid, alltiles, matches, corners)
    # The first line, we start at 3
    for i = 3:y
        setnextright!((1, i), grid, gridid, alltiles, matches)
    end
    # The 2nd line, we start at 2
    for i = 2:y
        setnextright!((2, i), grid, gridid, alltiles, matches)
    end
    # For all the other lines, we start at 1
    for j in 3:x, i in 1:y
        setnextright!((j, i), grid, gridid, alltiles, matches)
    end
    return nothing
end


function makeimage(grid)
    x, y = size(grid)
    grid2 = Tile(undef, x * 8, y * 8)
    for i in 1:x, j in 1:y
        grid2[(8 * (i - 1) + 1):(8 * (i - 1) + 8), (8 * (j - 1) + 1):(8 * (j - 1) + 8)] = grid[i, j][2:9, 2:9]
    end
    return grid2
end


function createseamonster()
    seamonster = split("""
                      # 
    #    ##    ##    ###
     #  #  #  #  #  #   """, "\n")
    l = length(seamonster[1])
    seamonstergrid = Tile(undef, 3, l)
    for i in 1:3, j in 1:l
        seamonstergrid[i, j] = seamonster[i][j] == '#'
    end
    return seamonstergrid
end

function scanimage(image::Tile, seamonster::Tile)
    imx, imy = size(image)
    mx, my = size(seamonster)
    numones = count(isone, seamonster)
    scanned = Tile(undef, imx - mx + 1, imy - my + 1)

    for x in 1:(imx - mx + 1), y in 1:(imy - my + 1)
        scanned[x, y] = count(isone, image[x:x + mx - 1, y:y + my - 1] .* seamonster) == numones
    end
    return scanned
end

function part2(grid, gridid, matches, alltiles, corners)
    fillgrids!(grid, gridid, matches, alltiles, corners)
    image = makeimage(grid)
    seamonster = createseamonster()
    allmonsters = makeallpositions(seamonster)
    for monster in allmonsters
        scan = scanimage(image, monster)
        c = count(isone, scan)
        if c > 0
            return count(isone, image) - c * count(isone, monster)
        end
    end
end

println("Part 2: $(part2(grid, gridid, matches, alltiles, corners))")
