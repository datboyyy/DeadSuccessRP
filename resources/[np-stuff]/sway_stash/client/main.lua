Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
end)

local currentStash = 0

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        local inRange = false
        if ESX ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            for locker,_ in pairs(Config.Stash) do
                local dist = GetDistanceBetweenCoords(pos, Config.Stash[locker].x, Config.Stash[locker].y, Config.Stash[locker].z)
                if dist < 3 then
                    inRange = true
                    if dist < 1.0 then
                        --DrawText3Ds(Config.Stash[locker].x, Config.Stash[locker].y, Config.Stash[locker].z, '~g~E~w~ - Enter Stash')
                        if IsControlJustPressed(0, Keys["E"]) then
                            currentStash = locker
                            if Config.Stash[locker].type == "keypad" then
                                SendNUIMessage({
                                    action = "open",
                                })
                                SetNuiFocus(true, true)
                            else
                                -- null
                            end
                        end
                    end
                end
            end
        end
        if not inRange then
            Citizen.Wait(2000)
        end
    end
end)

-- Functions

DrawText3Ds = function(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function takeAnim()
    local ped = GetPlayerPed(-1)
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
    Citizen.Wait(2500)
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end

-- NUI Callbacks
RegisterNUICallback('PinpadClose', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ErrorMessage', function(data)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('EnterPincode', function(data)
    ESX.TriggerServerCallback('sway_keypad:server:isCombinationRight', function(combination)
        if tonumber(data.pin) == combination then
            TriggerServerEvent('3dme:shareDisplay', 'opens stash')
            TriggerEvent("server-inventory-open", "1", "Stash"..currentStash)
            takeAnim()
            currentStash = 0
        else
            TriggerServerEvent('3dme:shareDisplay', 'tried to enter stash')
            TriggerEvent('notification', 'Access denied', 2)
            PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
            currentStash = 0
        end
    end, currentStash)
end)