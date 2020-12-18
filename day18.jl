const data = readlines("day18.txt")

function evalinorder(text::AbstractString)
    withendingparens = replace(text, r"([+*] \d+)" => s"\1)")
    numparens = count(r"[+*]", text)
    withparens = '('^numparens * withendingparens
    return eval(Meta.parse(withparens))
end

function custommath(text::AbstractString)
    parensblock = r"\([^()]+?\)"
    while true
        m = match(parensblock, text)
        if m === nothing
            return evalinorder(text)
        end
        text = replace(text, parensblock => evalinorder(m.match), count=1)
    end
end

function part1(lines)
    return sum(custommath(line) for line in lines)
end
(9 + (9 * 5 * 8 * 2) + 7 + 9) + 5
println("Part1: $(part1(data))")

function evalplusfirst(text::AbstractString)
    allpluses = r"(\d+) [+] (\d+)"
    while occursin("+", text)
        m = match(allpluses, text)
        text = replace(text, m.match => sum(parse.(Int, m.captures)), count=1)
    end
    return evalinorder(text)
end

function custommath_p2(text::AbstractString)
    # println("line:\t ", text)
    parensblock = r"\([^()]+?\)"
    while true
        m = match(parensblock, text)
        if m === nothing
            res = evalplusfirst(text)
            # println("result:\t ", res)
            return res
        end
        text = replace(text, parensblock => evalplusfirst(m.match), count=1)
        # println("current: ", text)
    end
end

function part2(lines)
    return sum(custommath_p2(line) for line in lines)
end

println("Part2: $(part2(data))")

# Bonus: AST manipulation!

# The idea is to use the parser. Change + to ^ so the normal rules apply, but change it
# back to + before evaluating, this will give the good result!

# Seen on stackoverflow:
# https://stackoverflow.com/questions/51928959/how-to-find-and-replace-subexpression-of-ast-in-julia
# Here we do not care not changing the input, so no deepcopy below
function expr_replace(expr, old, new)
    expr == old && return new
    if expr isa Expr
        for i in eachindex(expr.args)
            expr.args[i] = expr_replace(expr.args[i], old, new)
        end
    end
    expr
end

function mathfromast(text::AbstractString)
    new_text = replace(text, '+' => '^')
    expr = Meta.parse(new_text)
    expr_replace(expr, :^, :+)
    return eval(expr)
end

function part2bis(lines)
    return sum(mathfromast(line) for line in lines)
end

println("Part2 with ast manipulation: $(p2)")
