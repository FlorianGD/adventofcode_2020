using Mods

door, card = parse.(Int, readlines("day25.txt"))

function part1(door, card)
    # We need to find p such that 7^p = door (20202127)
    start = Mod{20201227}(7)
     p = 1

    while start != door
        start *= 7
        p += 1
    end
    # Niw the solution is card^p (20201227)

    solution = Mod{20201227}(card)^p
    return value(solution)
end

println("Part 1: $(part1(door, card))")

