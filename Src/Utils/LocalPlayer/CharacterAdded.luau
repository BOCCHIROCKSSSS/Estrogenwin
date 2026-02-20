local LocalPlayer = wax.shared.LocalPlayer

return function(Character:Model)
    assert(Character == LocalPlayer.Character, 'Expected Local Player\'s Character.')
    wax.shared.LocalCharacter = Character
end