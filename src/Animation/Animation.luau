local Animation = {}
Animation.__index = Animation

function Animation.new(tweenService)
    return setmetatable({TweenService = tweenService}, Animation)
end

function Animation:Play(instance, properties, duration, easing, direction)
    local info = TweenInfo.new(duration or 0.18, easing or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out)
    local tween = self.TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

return Animation
