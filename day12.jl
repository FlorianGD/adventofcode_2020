using Match

struct Instruction
    action::Char
    value::Int
end

mutable struct Ship
    direction::Complex{Int}
    position::Complex{Int}
end

function move!(s::Ship, i::Instruction)
    @match i.action begin
        'N' => (s.position += i.value * im)
        'S' => (s.position -= i.value * im)
        'E' => (s.position += i.value)
        'W' => (s.position -= i.value)
        'L' => (s.direction *= (im)^(i.value ÷ 90))
        'R' => (s.direction *= (-im)^(i.value ÷ 90))
        'F' => (s.position += s.direction * i.value)
        _ => error(i)
    end
end

function part1(lines)
    ship = Ship(1, 0)
    for line in lines
        inst = Instruction(line[1], parse(Int, line[2:end]))
        move!(ship, inst)
    end
    return abs(real(ship.position)) + abs(imag(ship.position))
end

const DATA = readlines("day12.txt")

println("Part 1: $(part1(DATA))")

function move2!(s::Ship, i::Instruction, waypoint::Complex{Int})
    @match i.action begin
        'N' => (waypoint += i.value * im)
        'S' => (waypoint -= i.value * im)
        'E' => (waypoint += i.value)
        'W' => (waypoint -= i.value)
        'L' => (waypoint *= (im)^(i.value ÷ 90))
        'R' => (waypoint *= (-im)^(i.value ÷ 90))
        'F' => (s.position += waypoint * i.value)
        _ => error(i)
    end
    return waypoint
end

function part2(lines)
    ship = Ship(1, 0)
    waypoint = complex(10, 1)
    for line in lines
        inst = Instruction(line[1], parse(Int, line[2:end]))
        waypoint = move2!(ship, inst, waypoint)
    end
    return abs(real(ship.position)) + abs(imag(ship.position))
end

println("Part 2: $(part2(DATA))")
