ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
        Citizen.Wait(500)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            ExecuteCommand('hud')
            Citizen.Wait(500)
            TriggerEvent("kashactersC:WelcomePage")
            TriggerEvent("kashactersC:SetupCharacters")
            TriggerServerEvent("kGetWeather")
            return -- break the loop
        end
    end
end)

local cam = nil
local cam2 = nil
RegisterNetEvent('kashactersC:SetupCharacters')
AddEventHandler('kashactersC:SetupCharacters', function()
    SetTimecycleModifier('hud_def_blur')
    
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -682.0, -1092.0, 226.0, 0.00, 0.00, 301.03, 45.03, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
end)

RegisterNetEvent('kashactersC:WelcomePage')
AddEventHandler('kashactersC:WelcomePage', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openwelcome"
    })
end)

RegisterNetEvent('kashactersC:SetupUI')
AddEventHandler('kashactersC:SetupUI', function(Characters)
    IsChoosing = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openui",
        characters = Characters,
    })
end)

RegisterNetEvent('kashactersC:SpawnCharacter')
AddEventHandler('kashactersC:SpawnCharacter', function(spawn, isnew)
    TriggerServerEvent('es:firstJoinProper')
    TriggerServerEvent('sway_scoreboard:AddPlayer')
    TriggerEvent('es:allowedToSpawn')
    Citizen.Wait(3700)
    if isnew then
        IsChoosing = false
        TriggerScreenblurFadeOut(0)
        TriggerEvent('esx_identity:showRegisterIdentity')
        SendNUIMessage({
            action = "displayback"
        })
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -682.0, -1092.0, 226.0, 0.00, 0.00, 301.03, 45.03, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        local pos = spawn
        Citizen.Wait(900)
        exports.spawnmanager:setAutoSpawn(false)
        TriggerEvent('esx_ambulancejob:multicharacter', source)
        
        TriggerEvent("spawnselector:openspawner")
        
        IsChoosing = false
        TriggerEvent('aqua:load', false)
    end
    TriggerServerEvent('kashactersS:requestSteam')
    TriggerServerEvent('kashactersS:requestCID')
    TriggerServerEvent('kashactersS:requestPlyName')
    TriggerServerEvent('kashactersS:requestfunds')
    ExecuteCommand('hud')
    ESX.TriggerServerCallback('esx-qalle-jail:retrieveJailTime', function(cb) 
        if cb == true then 
            TriggerEvent('notfication','You have been jailed since you logged out while jailed.', 2)
            SetEntityCoords(PlayerPedId(), 1785.99, 2577.46, 45.71)
        else 
        end
	end)
end)

RegisterNetEvent('kashactersC:ReloadCharacters')
AddEventHandler('kashactersC:ReloadCharacters', function()
    TriggerServerEvent("kashactersS:SetupCharacters")
    TriggerEvent("kashactersC:SetupCharacters")
end)

RegisterNUICallback("CharacterChosen", function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('kashactersS:CharacterChosen', data.charid, data.ischar, data.spawnid or "1")
    cb("ok")
end)
RegisterNUICallback("DeleteCharacter", function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('kashactersS:DeleteCharacter', data.charid)
    cb("ok")
end)

RegisterNUICallback("ShowSelection", function(data, cb)
    TriggerServerEvent("kashactersS:SetupCharacters")
end)
