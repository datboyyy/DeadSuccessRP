ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

local doors = {}

RegisterNetEvent('trp-doors:sendforpoly')
AddEventHandler('trp-doors:sendforpoly', function(pDoors)
    doors = pDoors
    for id, door in ipairs(doors) do
        if door and (door.active == nil or door.active) and not IsDoorRegisteredWithSystem(id) then
            print(door, id)
        end
    end
end)

local show = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(800)
        local closestDoorDistance, closestDoorId = 9999.9, -1
        local currentPos = GetEntityCoords(PlayerPedId())
        for id, handle in pairs(doors) do
            local currentDoorDistance = #(doors[id].objCoords - currentPos)
            if handle and currentDoorDistance < closestDoorDistance then
                closestDoorDistance = currentDoorDistance
                closestDoorId = id
            end
        end
        local authjob = doors[closestDoorId].authorizedJobs
        if doors[closestDoorId].distance > closestDoorDistance and PlayerData.job.name == authjob then
            if DoorSystemGetDoorState(closestDoorId) == 1 then
                TriggerEvent('cd_drawtextui:ShowUI', 'show', '[E] - Locked')
                show = true
            else 
                show = true
                TriggerEvent('cd_drawtextui:ShowUI', 'show', '[E] - Unlocked')
            end 
        else
            if show == true then
                show = false
                TriggerEvent('cd_drawtextui:HideUI')
            end
        end
    end
end)

--[[function drawClosestDoor()
    Citizen.CreateThread(function()
        local closestDoorDistance, closestDoorId = 9999.9, -1
        local currentPos = GetEntityCoords(PlayerPedId())
        for id, handle in pairs(doors) do
            local currentDoorDistance = #(doors[id].objCoords - currentPos)
            if handle and currentDoorDistance < closestDoorDistance then
                closestDoorDistance = currentDoorDistance
                closestDoorId = id
            end
        end
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        local authjob = doors[closestDoorId].authorizedJobs
        if doors[closestDoorId].distance > closestDoorDistance and PlayerData.job.name == authjob then
            if DoorSystemGetDoorState(closestDoorId) == 1 then
                TriggerEvent('cd_drawtextui:ShowUI', 'show', '[E] Locked')
            else
                TriggerEvent('cd_drawtextui:ShowUI', 'show', '[E] Unlocked')
            end
        else
            TriggerEvent('cd_drawtextui:HideUI')
        end
    end)
    SetTimeout(1200, drawClosestDoor)
end

SetTimeout(1200, drawClosestDoor)]]--