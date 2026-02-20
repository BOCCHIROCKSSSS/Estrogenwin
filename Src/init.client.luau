--!nocheck
wax.shared.EverloseStartTime = tick()

local deividcomsonoObsidianRepo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local mstudio45MSESPRepo = "https://raw.githubusercontent.com/mstudio45/MSESP/refs/heads/main/"

local Library: Library = loadstring(game:HttpGet(deividcomsonoObsidianRepo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(deividcomsonoObsidianRepo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(deividcomsonoObsidianRepo .. "addons/SaveManager.lua"))()
local EspLibrary = loadstring(game:HttpGet(mstudio45MSESPRepo .. "source.luau"))()

wax.shared.Library = Library
wax.shared.ThemeManager = ThemeManager
wax.shared.SaveManager = SaveManager
wax.shared.EspLibrary = EspLibrary

local Connections = require(script.Utils.Connections)
local Signal = require('Utils/Signal')
wax.shared.Signal = Signal
wax.shared.Signals = {
	PlayerAdded = wax.shared.Signal.new(),
	CharacterAdded = wax.shared.Signal.new(),
}

wax.shared['WaitForChildOfClass'] = function(Parent: Instance, ClassName: string, TimeOut: number?)
	local StartTime = tick()
	while task.wait() and (StartTime+TimeOut)-tick() > 0 and Parent do
		local Inst = Parent:FindFirstChildOfClass(ClassName)
		if Inst then return Inst end
	end
	return nil
end

getgenv().UnloadEverlose = function()
	local StartTime = tick()
	for _, Connection: RBXScriptConnection in wax.shared.Connections do
		Connection:Disconnect()
	end
	table.clear(wax.shared.Connections)
	for _,Signal:RBXScriptSignal in wax.shared.Signals do
		Signal:DisconnectAll()
	end
	table.clear(wax.shared.Signals)

	EspLibrary:Destroy()
	Library:Unload()
	getgenv().UnloadEverlose = nil

	print("Everlose Unloaded, took: " .. (tick() - StartTime) .. " seconds.")
end

Library.ForceCheckbox = true

-- local Options = Library.Options
-- local Toggles = Library.Toggles

--// Services
local Services = require("Utils/Services")
Services:GetServices({
	"RunService",
	"UserInputService",
	"TweenService",
	"ContextActionService",
	"Players",
	"ReplicatedStorage",
	"CoreGui",
})
wax.shared.Services = Services

local Players: Players = Services:GetService("Players")
local LocalPlayer: Player = Players.LocalPlayer

local function HandlePlayerAdded(Player: Player)
	wax.shared.Signals.PlayerAdded:Fire(Player)
	if Player.Character then
		wax.shared.Signals.CharacterAdded:Fire(Player.Character)
	end
	table.insert(Connections, Player.CharacterAdded:Connect(function(Character: Model)
		wax.shared.Signals.CharacterAdded:Fire(Character)
	end))
end

wax.shared.LocalPlayer = LocalPlayer

--// Loader
wax.shared.Load = function(Type: 'Tabs' | 'Functions', LoaderName:string)
	return require('Loaders/'..Type..'/'..LoaderName)
end

--// Hooking Service
local HookingService = require("Utils/HookingService")
wax.shared.HookingService = HookingService

--// UI
local _UI = require("Utils/UI")


--// Connections
local LocalCharacterAddedHandler = require("Utils/LocalPlayer/CharacterAdded")
local ConnectionsHandler = require("Utils/Connections")
if LocalPlayer.Character then
	LocalCharacterAddedHandler(LocalPlayer.Character)
end
ConnectionsHandler:GiveSignal(LocalPlayer.CharacterAdded, LocalCharacterAddedHandler)

for _,Player in Players:GetPlayers() do
	if Player ~= LocalPlayer then
		HandlePlayerAdded(Player)
	end
end
table.insert(Connections, Players.PlayerAdded:Connect(HandlePlayerAdded))

wax.shared.ConnectionsHandler = ConnectionsHandler

warn("EVERLOSE: Loading Done.")
