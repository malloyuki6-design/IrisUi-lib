local Theme = {}
Theme.__index = Theme

function Theme.new(definition)
    return setmetatable({Data = definition or {}}, Theme)
end

function Theme:Get(key, fallback)
    local value = self.Data[key]
    if value == nil then return fallback end
    return value
end

function Theme:Set(key, value)
    self.Data[key] = value
    return self
end

function Theme:Merge(values)
    for key, value in pairs(values or {}) do
        self.Data[key] = value
    end
    return self
end

return Theme
