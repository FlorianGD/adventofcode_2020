using DelimitedFiles

const program = readdlm("day08.txt")

function process(inst::Array, acc::Int, idx::Int)
    if inst[1] == "nop"
        idx += 1
    elseif inst[1] == "acc"
        acc += inst[2]
        idx += 1
    else
        idx += inst[2]
    end
    return acc, idx
end

function loop(program::Array)
    acc = 0
    idx = 1
    seen = Set{Int}()
    while !(idx in seen)
        push!(seen, idx)
        acc, idx = process(program[idx, :], acc, idx)
    end
    return acc
end

println("Part 1: $(loop(program))")

function alterprogram(program::Array{Any,2}, start::Int)
    new_program = copy(program)
    # find next instruction to modify
    # We need to provide a CartesianIndex but we are only interested in the first axis
    new_start = findnext(x -> x != "acc", program, CartesianIndex(start + 1, 1))[1]
    changes = Dict("nop" => "jmp", "jmp" => "nop")
    new_program[new_start] = changes[new_program[new_start]]
    return new_program, new_start
end

"""
return the acc value before exiting or looping and a flag False if looped or True if
exited normally.
"""
function loop_or_exit(program::Array)
    acc = 0
    idx = 1
    seen = Set{Int}()
    exited = false
    while !(idx in seen)
        push!(seen, idx)
        if idx > size(program)[1]
            exited = true
            break
        end
        acc, idx = process(program[idx, :], acc, idx)
    end
    return acc, exited
end

function testallprograms(program::Array)
    start = 1
    exited = false
    acc = 0
    while !exited
        new_program, start = alterprogram(program, start)
        acc, exited = loop_or_exit(new_program)
    end
    return acc
end

println("Part 2: $(testallprograms(program))")
