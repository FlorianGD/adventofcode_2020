function parseinput(lines)
    idx = findall(==(""), lines)[1]
    rules = lines[1:idx-1] 
    messages = lines[idx+1:end]
    return (rules, messages)
end

function recpattern(v, mapping)
    vals = split(v, " ")
    pattern = join(mapping[a] for a in vals)
    return pattern
end

function makemapping(rules)
    starting_rules = filter(x -> '"' ∈ x, rules)
    recursive_rules= filter(x -> !occursin("\"", x), rules)
    mapping = Dict{String, String}()
    for r in starting_rules            
        k, v = split(r, ": \"")
        mapping[k] = v[1:1]
    end
    while length(keys(mapping)) != length(rules)
        nextrules(recursive_rules, mapping)
    end
    return mapping
end

function nextrules(rules, mapping)        
    possiblevalues = [keys(mapping)...,"|"]
    for r in rules
        k, v = split(r, ": ")
        if k in keys(mapping)
	    continue
	end
       if all(split(v, " ") .∈ Ref(possiblevalues)) 
           if occursin("|", v)
               v1, v2  = split(v, " | ")
	       p1 = recpattern(v1, mapping)
               p2 = recpattern(v2, mapping)
	       pattern = "($p1|$p2)"
           else
               pattern = recpattern(v, mapping)
	   end
           mapping[k] = pattern
        end
    end
    return mapping
end

function part1(lines)
    rules, messages = parseinput(lines)
    mapping = makemapping(rules)
    regex = Regex("^$(mapping["0"])\$")
    total = sum(occursin(regex, m) for m in messages)
    return total
end

data = readlines("day19.txt")

println("Part 1: $(part1(data))")

# Horrible solution but works
# 0 is 8 11
# the new 8 is 8+ (regex 8 once or more)
# the new 11 is 42 {i} 31 {i}
# making the regex once is not possible as it
# will be too big so I make a lot of regexes

function makeregex(mapping, i)
    d = "($(mapping["8"]))+"
    a = mapping["42"]
    b = mapping["31"]
    c = "($a){$i}($b){$i}"
    m = "^$d$c\$"
    return Regex(m)
end

function part2(lines)
    rules, messages = parseinput(lines)      
    mapping = makemapping(rules)
    regexes =[makeregex(mapping, i) for i in 1:10]
    total = 0
    for m in messages
        if any(occursin.(regexes, m))
	    total += 1
	end
    end
    return total
end

println("Part2 : $(part2(data))")


    
