function parseinput(lines)
    sep1, sep2 = findall(==(""), lines)
    rules = Dict{String,Vector{UnitRange{Int}}}()
    for i in 1:sep1 - 1
        key, values = split(lines[i], ": ")
        regex = r"(\d+)-(\d+)"
        rule = [parse(Int, m.captures[1]):parse(Int, m.captures[2]) for m in eachmatch(regex, values)]
        rules[key] = rule
    end
    parseticket = x -> parse.(Int, [m.match for m in eachmatch(r"\d+", x)])
    ticket = parseticket(lines[sep1 + 2])
    tickets = Vector{Int}[]
    for i in sep2 + 2:length(lines)
        push!(tickets, parseticket(lines[i]))
    end
    return rules, ticket, tickets
end

function invalid(ticket::Vector{Int}, rules_values)
    mask = [sum(sum(t .∈ r) for r in rules_values) == 0 for t in ticket]
    return  sum(ticket[mask])
end

const rules, ticket, tickets = parseinput(readlines("day16.txt"))

println("Part 1: $(sum(invalid(t, values(rules)) for t in tickets))")

function isvalidticket(ticket::Vector{Int}, rules_values)
    return all(sum(sum(t .∈ r) for r in rules_values) >= 1 for t in ticket)
end

function part2(tickets::Vector{Vector{Int}}, rules::Dict{String,Vector{UnitRange{Int}}})
    valid_tickets = filter(x -> isvalidticket(x, values(rules)), tickets)
    # create a 2D array where each row is a ticket and each colum a field
    T = [t[i] for t in valid_tickets, i = 1:length(valid_tickets[1])]
    # We want to check each column of the array, to see how many rules can apply. We
    # will find one rule that has only one possibility, we will remove it from the
    # others possible values and so on, until we know which field corresponds to which
    # rule
    possibilities = Dict{String,Vector{Int}}()
    num_tickets = length(valid_tickets)
    for (name, rule) in rules
        # this is ugly because it collects everything, but I had trouble with
        # broadcasting when I kept the 2 unit ranges.
        ranges = union(rule...)
        # Ref is necessary to avoid the broadcasting, we just want to check is each
        # element of the column (i.e. each field) is possible with this rule
        # We sum to know if the rule is valid for all tickets and findall to know which
        # columns are applicable for this rule
        possibles = findall([sum(col .∈ Ref(ranges)) == num_tickets for col in eachcol(T)])
        possibilities[name] = possibles
    end
    seen = Set{Int}()
    fields = Dict{String,Int}()
    sorted = sort(collect(possibilities), by=x -> length(x[2]))
    for (name, values) in sorted
        field = setdiff(values, seen)[1]
        seen = seen ∪ values
        fields[name] = field
    end
    return prod(ticket[fields[i]] for i in keys(fields) if startswith(i, "departure"))
end

println("Part 2: $(part2(tickets, rules))")
