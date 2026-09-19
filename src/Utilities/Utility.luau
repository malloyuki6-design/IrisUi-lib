local Utility = {}

function Utility.Clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

function Utility.Round(value, step)
    if not step or step == 0 then return value end
    return math.floor(value / step + 0.5) * step
end

function Utility.Copy(values)
    local result = {}
    for key, value in pairs(values or {}) do
        if type(value) == "table" then result[key] = Utility.Copy(value) else result[key] = value end
    end
    return result
end

return Utility
