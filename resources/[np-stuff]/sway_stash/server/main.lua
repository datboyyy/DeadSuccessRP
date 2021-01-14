ESX = nil 

TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)

StashCodes = {
    [1] = 8405,  --- Dragons Password
    [2] = 5489,  -- Ray Weapons
    [3] = 2395, --- Ray Drug Spot
    [4] = 1289, -- survy cribbo
    [5] = 0,
}

ESX.RegisterServerCallback('sway_keypad:server:isCombinationRight', function(source, cb, safe)
    cb(StashCodes[safe])
end)

