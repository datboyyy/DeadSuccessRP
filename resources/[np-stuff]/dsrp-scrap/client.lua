ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
    
    
    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)


items = {
    "prop_aircon_m_01",
    "prop_aircon_m_10",
    "prop_aircon_m_04",
    "prop_aircon_m_02",
    "prop_aircon_m_05"
}

Citizen.CreateThread(function()
    while true do
        sleepTime = 100
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed, 1)
        local nearest = 0
        
        for k, v in pairs(items) do
            nearest = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 3.0, GetHashKey(v), false, false, false)
            if nearest ~= 0 then
                break
            end
        end
        local nearestCoords = GetEntityCoords(nearest, 0)
        
        local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, nearestCoords.x, nearestCoords.y, nearestCoords.z, true)
        
        if nearest ~= 0 and distance < 3 then
            DrawText3D(nearestCoords, "Press [E] to remove parts")
            sleepTime = 0
        end
        if nearest ~= 0 and distance < 2.0 then
            if IsControlJustPressed(0, 38) then
                disabledControls = true
                processScrap(nearest, nearestCoords)
            end
        end
        Citizen.Wait(sleepTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if disabledControls == true then
            DisableControlAction(0, 38, true)
        end
    end
end)

function processScrap(nearest, nearestCoords)
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, false)
    exports["sway_taskbar"]:taskBar(15000, 'Removing parts...')
    ClearPedTasksImmediately(playerPed)
    disabledControls = false
    exports['mythic_notify']:SendAlert('success', 'You stole some parts', 10000)
    SetEntityAsMissionEntity(nearest)
    DeleteEntity(nearest)
    TriggerServerEvent('tp-scrap:giveItem')
end
--[[
function DrawText3D(coords, text)
if not Drawing then
Drawing = true
local onScreen,_x,_y = World3dToScreen2d(coords.x,coords.y,coords.z +0.3)
local px,py,pz = table.unpack(GetGameplayCamCoord())
local dist = GetDistanceBetweenCoords(px,py,pz, coords.x,coords.y,coords.z + 0.4, 1)
local dropShadow = true
local scale = ((1/dist)*2)*(1/GetGameplayCamFov())*100
if onScreen then
SetTextScale(0.35, 0.35)
SetTextFont(4)
SetTextProportional(1)
SetTextColour(255, 255, 255, 215)
SetTextEntry("STRING")
SetTextCentre(1)
AddTextComponentString(text)
DrawText(_x,_y)
if dropShadow then
SetTextDropshadow(10, 100, 100, 100, 255)
end
BeginTextCommandWidth("STRING")
AddTextComponentString(text)
local height = GetTextScaleHeight(0.45*scale, font)
local width = EndTextCommandGetWidth(font)
SetTextEntry("STRING")
AddTextComponentString(text)
EndTextCommandDisplayText(_x, _y)
end
Drawing = false
end
end
--]]

function DrawText3D(coords, text)
    if not Drawing then
        Drawing = true
        local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z + 1)
        local px, py, pz = table.unpack(GetGameplayCamCoord())
        local dist = GetDistanceBetweenCoords(px, py, pz, coords.x, coords.y, coords.z + 0.1, 1)
        local dropShadow = true
        local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 50
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
        Drawing = false
    end
end
