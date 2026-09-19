local Core = {}
Core.__index = Core

function Core.new(library)
    return setmetatable({Library = library}, Core)
end

function Core:GetLibrary()
    return self.Library
end

return Core
