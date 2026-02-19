wax.shared.EverloseStartTime = tick()

--// UI
local UI = require('Utils/UI')

--// Services
local Services = require('Utils/Services')
Services:GetServices({
    'RunService',
    'UserInputService',
    'TweenService',
    'ContextActionService',
    'Players',
    'ReplicatedStorage',
    'CoreGui',
})