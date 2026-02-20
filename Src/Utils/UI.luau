--!nocheck

local Library:Library = wax.shared.Library

local Window:Window = Library:CreateWindow({
    Title = 'Everlose',
	Footer = `Version: {'Alpha'}: {'1.0.0'}`,
	Icon = 89401785954152,
	NotifySide = 'Right',
	ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab('Main', 'circle-user-round'),
    Visuals = Window:AddTab('Visuals', 'eye'),
}

local SupportedGames = require('./SupportedGames')

wax.shared.Window = Window
wax.shared.Tabs = Tabs

for GameName, PlaceIds in SupportedGames do
    local LoaderToUse = PlaceIds[game.PlaceId]
    if LoaderToUse then
        require('Loaders/'..LoaderToUse)()
    end
end

return {
    Window = Window,
    Tabs = Tabs,
    Library = Library,
}