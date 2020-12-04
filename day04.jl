const REQUIRED_KEYS = Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
const PASSPORTS = split(read("day04.txt", String), "\n\n")

const PATTERN1 = r"([a-z]{3}):"

function validate_part1(passport::AbstractString; required_keys=REQUIRED_KEYS, pattern=PATTERN1)
    found_keys = Set(m.captures[1] for m in eachmatch(pattern, passport))
    return found_keys >= required_keys
end

println("Part 1: $(sum(validate_part1(passport) for passport in PASSPORTS))")

const PATTERN2 = r"([a-z]{3}):([a-z0-9#]+)"

function validate_number_between(value::AbstractString, min::Int, max::Int)
    val = tryparse(Float64, value)
    if val === nothing
        return false
    end
    return min <= val <= max
end


function validate_height(value::AbstractString)
    if endswith(value, "cm")
        return validate_number_between(value[begin:end - 2], 150, 193)
    elseif endswith(value, "in")
        return validate_number_between(value[begin:end - 2], 59, 76)
    else
        return false
    end
end

function validate_hair_color(value::AbstractString)
    if startswith(value, '#')
        return occursin(r"[a-f0-9]{6}", value[begin + 1:end])
    else
        return false
    end
end

function validate_eye_color(value::AbstractString)
    return value in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
end

function validate_pid(value::AbstractString)
    return occursin(r"^[0-9]{9}$", value)
end

function validate_passport(passport::AbstractString; required_keys=REQUIRED_KEYS, pattern=PATTERN2)
    data = Dict(m.captures for m in eachmatch(pattern, passport))
    if !validate_part1(passport)
        return false
    end
    return (
        validate_number_between(data["byr"], 1920, 2002) &&
        validate_number_between(data["iyr"], 2010, 2020) &&
        validate_number_between(data["eyr"], 2020, 2030) &&
        validate_height(data["hgt"]) &&
        validate_hair_color(data["hcl"]) &&
        validate_eye_color(data["ecl"]) &&
        validate_pid(data["pid"])
    )
end

println("Part 2: $(sum(validate_passport(passport) for passport in PASSPORTS))")