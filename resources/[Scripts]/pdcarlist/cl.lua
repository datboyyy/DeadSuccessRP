local inVehMenu = false
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(10)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)


RegisterCommand('job', function()
    local plyPed = PlayerPedId()
    local job = PlayerData.job.name
    TriggerEvent('notification', 'You\'re working as: ' .. job, 1)
end)
-----------------------------------------------------------------------------
-- PolyZones
-----------------------------------------------------------------------------
local pdgarage = PolyZone:Create({
        --Name: PD Garage | 2020-12-11T08:14:17Z
        vector2(423.1575012207, -1000.2854003906),
        vector2(423.16708374023, -973.03930664063),
        vector2(463.70239257813, -973.03649902344),
        vector2(463.79641723633, -1000.0756835938)
}, {
    name = "PD Garage",
    minZ = 24.338989257813,
    maxZ = 27.40362739563,
    debugGrid = false,
    gridDivisions = 30
})

--Name: ambulancearea | 2020-12-11T08:34:34Z
local emsgarage = PolyZone:Create({
    vector2(301.9016418457, -603.13061523438),
    vector2(296.80221557617, -618.150390625),
    vector2(281.29574584961, -615.21624755859),
    vector2(293.74243164063, -598.75592041016)
}, {
    name = "ambulancearea",
    minZ = 40.301704406738,
    maxZ = 45.450912475586,
    debugGrid = false,
    gridDivisions = 30
})

-----------------------------------------------------------------------------
-- NUI OPEN/CLOSE FUNCTIONS
-----------------------------------------------------------------------------
function openVehlist()
    inVehMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openGeneral"
    })
end

function closeVehlist()
    inVehMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "closeAll"
    })
end

RegisterNUICallback('NUIFocusOff', function()
    inVehMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "closeAll"
    })
end)

AddEventHandler('govcarlist', function(pGangNum)
    local plyPed = PlayerPedId()
    local coord = GetEntityCoords(plyPed)
    local job = PlayerData.job.name
    pdgaragein = pdgarage:isPointInside(coord)
    ambulancearea = emsgarage:isPointInside(coord)
    if job == 'police' and pdgaragein == true then
        openVehlist()
    else
        if job == 'ambulance' and ambulancearea == true then
            print(ambulancearea)
            openVehlist()
        elseif job == 'ambulance' and ambulancearea == false then
            TriggerEvent('notification', 'Not Near EMS Garage')
        elseif job == 'police' and pdgaragein == false then
            TriggerEvent('notification', 'Not Near PD Garage')
        end
    end
end)
-----------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------
RegisterNUICallback('poltaurus', function()
        
        Citizen.CreateThread(function()
            local plyPed = PlayerPedId()
            local coord = GetEntityCoords(plyPed)
            local job = PlayerData.job.name
            pdgaragein = pdgarage:isPointInside(coord)
            if job == 'police' and pdgaragein == true then
                local hash = GetHashKey('poltaurus')
                
                if not IsModelAVehicle(hash) then return end
                if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
                RequestModel(hash)
                
                while not HasModelLoaded(hash) do
                    Citizen.Wait(0)
                end
                
                local localped = PlayerPedId()
                local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)
                
                local heading = GetEntityHeading(localped)
                local vehicle = CreateVehicle(hash, coords, heading, true, false)
                local plate = GetVehicleNumberPlateText(vehicle)
                TriggerServerEvent('garage:addKeys', plate)
                TriggerEvent("keys:addNew", vehicle, plate)
                TriggerServerEvent('garages:addJobPlate', plate)
                TriggerEvent('notification', 'Received keys to: ' .. plate)
                
                
                SetVehicleDirtLevel(vehicle, 0)
                SetVehicleWindowTint(vehicle, 3)
                SetVehicleModKit(vehicle, 0)
                SetVehicleMod(vehicle, 11, 2, false)
                SetVehicleMod(vehicle, 12, 2, false)
                ToggleVehicleMod(vehicle, 18, true)
                ToggleVehicleMod(vehicle, 22, true)
                SetVehicleMod(vehicle, 13, 2, false)
                SetVehicleMod(vehicle, 15, 2, false)
                SetVehicleMod(vehicle, 16, 2, false)
                SetVehicleLivery(vehicle, 1)
                print('veh sawned', vehicle)
                TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
            else
                TriggerEvent('notification', 'You are not an Officer')
            end
        end)
end)

RegisterNUICallback('pol8', function()
        
        Citizen.CreateThread(function()
            local plyPed = PlayerPedId()
            local coord = GetEntityCoords(plyPed)
            local job = PlayerData.job.name
            pdgaragein = pdgarage:isPointInside(coord)
            if job == 'police' and pdgaragein == true then
                local hash = GetHashKey('pol8')
                
                if not IsModelAVehicle(hash) then return end
                if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
                RequestModel(hash)
                
                while not HasModelLoaded(hash) do
                    Citizen.Wait(0)
                end
                
                local localped = PlayerPedId()
                local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)
                
                local heading = GetEntityHeading(localped)
                local vehicle = CreateVehicle(hash, coords, heading, true, false)
                local plate = GetVehicleNumberPlateText(vehicle)
                TriggerServerEvent('garage:addKeys', plate)
                TriggerEvent("keys:addNew", vehicle, plate)
                TriggerServerEvent('garages:addJobPlate', plate)
                TriggerEvent('notification', 'Received keys to: ' .. plate)
                SetVehicleDirtLevel(vehicle, 0)
                SetVehicleWindowTint(vehicle, 3)
                SetVehicleModKit(vehicle, 0)
                SetVehicleMod(vehicle, 11, 2, false)
                SetVehicleMod(vehicle, 12, 2, false)
                ToggleVehicleMod(vehicle, 18, true)
                ToggleVehicleMod(vehicle, 22, true)
                SetVehicleMod(vehicle, 13, 2, false)
                SetVehicleMod(vehicle, 15, 2, false)
                SetVehicleMod(vehicle, 16, 2, false)
                SetVehicleLivery(vehicle, 1)
                print('veh sawned', vehicle)
                TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
            else
                TriggerEvent('notification', 'You are not an Officer')
            end
        end)
end)
RegisterNUICallback('pol9', function()
        
        Citizen.CreateThread(function()
            local plyPed = PlayerPedId()
            local coord = GetEntityCoords(plyPed)
            local job = PlayerData.job.name
            pdgaragein = pdgarage:isPointInside(coord)
            if job == 'police' and pdgaragein == true then
                local hash = GetHashKey('pol9')
                
                if not IsModelAVehicle(hash) then return end
                if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
                RequestModel(hash)
                
                while not HasModelLoaded(hash) do
                    Citizen.Wait(0)
                end
                
                local localped = PlayerPedId()
                local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)
                
                local heading = GetEntityHeading(localped)
                local vehicle = CreateVehicle(hash, coords, heading, true, false)
                local plate = GetVehicleNumberPlateText(vehicle)
                TriggerServerEvent('garage:addKeys', plate)
                TriggerEvent("keys:addNew", vehicle, plate)
                TriggerServerEvent('garages:addJobPlate', plate)
                TriggerEvent('notification', 'Received keys to: ' .. plate)
                SetVehicleDirtLevel(vehicle, 0)
                SetVehicleWindowTint(vehicle, 3)
                SetVehicleModKit(vehicle, 0)
                SetVehicleMod(vehicle, 11, 2, false)
                SetVehicleMod(vehicle, 12, 2, false)
                ToggleVehicleMod(vehicle, 18, true)
                ToggleVehicleMod(vehicle, 22, true)
                SetVehicleMod(vehicle, 13, 2, false)
                SetVehicleMod(vehicle, 15, 2, false)
                SetVehicleMod(vehicle, 16, 2, false)
                SetVehicleLivery(vehicle, 1)
                print('veh sawned', vehicle)
                TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
            else
                TriggerEvent('notification', 'You are not an Officer')
            end
        end)
end)

RegisterNUICallback('polchar', function()
        
        Citizen.CreateThread(function()
            local plyPed = PlayerPedId()
            local coord = GetEntityCoords(plyPed)
            local job = PlayerData.job.name
            pdgaragein = pdgarage:isPointInside(coord)
            if job == 'police' and pdgaragein == true then
                local hash = GetHashKey('polchar')
                
                if not IsModelAVehicle(hash) then return end
                if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
                RequestModel(hash)
                
                while not HasModelLoaded(hash) do
                    Citizen.Wait(0)
                end
                
                local localped = PlayerPedId()
                local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)
                
                local heading = GetEntityHeading(localped)
                local vehicle = CreateVehicle(hash, coords, heading, true, false)
                local plate = GetVehicleNumberPlateText(vehicle)
                TriggerServerEvent('garage:addKeys', plate)
                TriggerEvent("keys:addNew", vehicle, plate)
                TriggerServerEvent('garages:addJobPlate', plate)
                TriggerEvent('notification', 'Received keys to: ' .. plate)
                SetVehicleDirtLevel(vehicle, 0)
                SetVehicleWindowTint(vehicle, 3)
                SetVehicleModKit(vehicle, 0)
                SetVehicleMod(vehicle, 11, 2, false)
                SetVehicleMod(vehicle, 12, 2, false)
                ToggleVehicleMod(vehicle, 18, true)
                ToggleVehicleMod(vehicle, 22, true)
                SetVehicleMod(vehicle, 13, 2, false)
                SetVehicleMod(vehicle, 15, 2, false)
                SetVehicleMod(vehicle, 16, 2, false)
                SetVehicleLivery(vehicle, 1)
                print('veh sawned', vehicle)
                TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
            else
                PlaySound(l_208, "NAV_UP_DOWN", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1);
                TriggerEvent('notification', 'You are not an Officer')
            end
        end)
end)

RegisterNUICallback('2015polstang', function()
    Citizen.CreateThread(function()
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        local job = PlayerData.job.name
        pdgaragein = pdgarage:isPointInside(coord)
        if job == 'police' and pdgaragein == true then
            local hash = GetHashKey('2015polstang')
            
            if not IsModelAVehicle(hash) then return end
            if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Citizen.Wait(0)
            end
            
            local localped = PlayerPedId()
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)
            
            local heading = GetEntityHeading(localped)
            local vehicle = CreateVehicle(hash, coords, heading, true, false)
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent('garage:addKeys', plate)
            TriggerEvent("keys:addNew", vehicle, plate)
            TriggerServerEvent('garages:addJobPlate', plate)
            TriggerEvent('notification', 'Received keys to: ' .. plate)
            SetVehicleDirtLevel(vehicle, 0)
            SetVehicleWindowTint(vehicle, 3)
            SetVehicleModKit(vehicle, 0)
            SetVehicleMod(vehicle, 11, 2, false)
            SetVehicleMod(vehicle, 12, 2, false)
            ToggleVehicleMod(vehicle, 18, true)
            ToggleVehicleMod(vehicle, 22, true)
            SetVehicleMod(vehicle, 13, 2, false)
            SetVehicleMod(vehicle, 15, 2, false)
            SetVehicleMod(vehicle, 16, 2, false)
            SetVehicleLivery(vehicle, 0)
            print('veh sawned', vehicle)
            TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
        else
            TriggerEvent('notification', 'You are not an Officer')
        end
    end)
end)

RegisterNUICallback('polraptor', function()
    Citizen.CreateThread(function()
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        local job = PlayerData.job.name
        pdgaragein = pdgarage:isPointInside(coord)
        if job == 'police' and pdgaragein == true then
            local hash = GetHashKey('polraptor')
            
            if not IsModelAVehicle(hash) then return end
            if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Citizen.Wait(0)
            end
            
            local localped = PlayerPedId()
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)
            
            local heading = GetEntityHeading(localped)
            local vehicle = CreateVehicle(hash, coords, heading, true, false)
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent('garage:addKeys', plate)
            TriggerEvent("keys:addNew", vehicle, plate)
            TriggerServerEvent('garages:addJobPlate', plate)
            TriggerEvent('notification', 'Received keys to: ' .. plate)
            SetVehicleDirtLevel(vehicle, 0)
            SetVehicleWindowTint(vehicle, 3)
            SetVehicleModKit(vehicle, 0)
            SetVehicleMod(vehicle, 11, 2, false)
            SetVehicleMod(vehicle, 12, 2, false)
            ToggleVehicleMod(vehicle, 18, true)
            ToggleVehicleMod(vehicle, 22, true)
            SetVehicleMod(vehicle, 13, 2, false)
            SetVehicleMod(vehicle, 15, 2, false)
            SetVehicleMod(vehicle, 16, 2, false)
            SetVehicleLivery(vehicle, 0)
            print('veh sawned', vehicle)
            TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
        else
            TriggerEvent('notification', 'You are not an Officer')
        end
    end)
end)

RegisterNUICallback('polschafter3', function()
    Citizen.CreateThread(function()
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        local job = PlayerData.job.name
        pdgaragein = pdgarage:isPointInside(coord)
        if job == 'police' and pdgaragein == true then
            local hash = GetHashKey('polschafter3')
            
            if not IsModelAVehicle(hash) then return end
            if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Citizen.Wait(0)
            end
            
            local localped = PlayerPedId()
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)
            
            local heading = GetEntityHeading(localped)
            local vehicle = CreateVehicle(hash, coords, heading, true, false)
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent('garage:addKeys', plate)
            TriggerEvent("keys:addNew", vehicle, plate)
            TriggerServerEvent('garages:addJobPlate', plate)
            TriggerEvent('notification', 'Received keys to: ' .. plate)
            SetVehicleDirtLevel(vehicle, 0)
            SetVehicleWindowTint(vehicle, 3)
            SetVehicleModKit(vehicle, 0)
            SetVehicleMod(vehicle, 11, 2, false)
            SetVehicleMod(vehicle, 12, 2, false)
            ToggleVehicleMod(vehicle, 18, true)
            ToggleVehicleMod(vehicle, 22, true)
            SetVehicleMod(vehicle, 13, 2, false)
            SetVehicleMod(vehicle, 15, 2, false)
            SetVehicleMod(vehicle, 16, 2, false)
            SetVehicleLivery(vehicle, 0)
            print('veh sawned', vehicle)
            TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
        else
            TriggerEvent('notification', 'You are not an Officer')
        end
    end)
end)

RegisterNUICallback('poltah', function()
    Citizen.CreateThread(function()
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        local job = PlayerData.job.name
        pdgaragein = pdgarage:isPointInside(coord)
        if job == 'police' and pdgaragein == true then
            local hash = GetHashKey('poltah')
            
            if not IsModelAVehicle(hash) then return end
            if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Citizen.Wait(0)
            end
            
            local localped = PlayerPedId()
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)
            
            local heading = GetEntityHeading(localped)
            local vehicle = CreateVehicle(hash, coords, heading, true, false)
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent('garage:addKeys', plate)
            TriggerEvent("keys:addNew", vehicle, plate)
            TriggerServerEvent('garages:addJobPlate', plate)
            TriggerEvent('notification', 'Received keys to: ' .. plate)
            SetVehicleDirtLevel(vehicle, 0)
            SetVehicleWindowTint(vehicle, 3)
            SetVehicleModKit(vehicle, 0)
            SetVehicleMod(vehicle, 11, 2, false)
            SetVehicleMod(vehicle, 12, 2, false)
            ToggleVehicleMod(vehicle, 18, true)
            ToggleVehicleMod(vehicle, 22, true)
            SetVehicleMod(vehicle, 13, 2, false)
            SetVehicleMod(vehicle, 15, 2, false)
            SetVehicleMod(vehicle, 16, 2, false)
            SetVehicleLivery(vehicle, 1)
            print('veh sawned', vehicle)
            TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
        else
            TriggerEvent('notification', 'You are not an Officer')
        end
    end)
end)

RegisterNUICallback('polvic', function()
    Citizen.CreateThread(function()
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        local job = PlayerData.job.name
        pdgaragein = pdgarage:isPointInside(coord)
        if job == 'police' and pdgaragein == true then
            local hash = GetHashKey('polvic')
            
            if not IsModelAVehicle(hash) then return end
            if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Citizen.Wait(0)
            end
            
            local localped = PlayerPedId()
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)
            
            local heading = GetEntityHeading(localped)
            local vehicle = CreateVehicle(hash, coords, heading, true, false)
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent('garage:addKeys', plate)
            TriggerEvent("keys:addNew", vehicle, plate)
            TriggerServerEvent('garages:addJobPlate', plate)
            TriggerEvent('notification', 'Received keys to: ' .. plate)
            SetVehicleDirtLevel(vehicle, 0)
            SetVehicleWindowTint(vehicle, 3)
            SetVehicleModKit(vehicle, 0)
            SetVehicleMod(vehicle, 11, 2, false)
            SetVehicleMod(vehicle, 12, 2, false)
            ToggleVehicleMod(vehicle, 18, true)
            ToggleVehicleMod(vehicle, 22, true)
            SetVehicleMod(vehicle, 13, 2, false)
            SetVehicleMod(vehicle, 15, 2, false)
            SetVehicleMod(vehicle, 16, 2, false)
            SetVehicleLivery(vehicle, 1)
            print('veh sawned', vehicle)
            TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
        else
            TriggerEvent('notification', 'You are not an Officer')
        end
    end)
end)

RegisterNUICallback('pbus', function()
    Citizen.CreateThread(function()
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        local job = PlayerData.job.name
        pdgaragein = pdgarage:isPointInside(coord)
        if job == 'police' and pdgaragein == true then
            local hash = GetHashKey('pbus')
            
            if not IsModelAVehicle(hash) then return end
            if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Citizen.Wait(0)
            end
            
            local localped = PlayerPedId()
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)
            
            local heading = GetEntityHeading(localped)
            local vehicle = CreateVehicle(hash, coords, heading, true, false)
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent('garage:addKeys', plate)
            TriggerEvent("keys:addNew", vehicle, plate)
            TriggerServerEvent('garages:addJobPlate', plate)
            TriggerEvent('notification', 'Received keys to: ' .. plate)
            SetVehicleDirtLevel(vehicle, 0)
            SetVehicleWindowTint(vehicle, 3)
            SetVehicleModKit(vehicle, 0)
            SetVehicleMod(vehicle, 11, 2, false)
            SetVehicleMod(vehicle, 12, 2, false)
            ToggleVehicleMod(vehicle, 18, true)
            ToggleVehicleMod(vehicle, 22, true)
            SetVehicleMod(vehicle, 13, 2, false)
            SetVehicleMod(vehicle, 15, 2, false)
            SetVehicleMod(vehicle, 16, 2, false)
            SetVehicleLivery(vehicle, 1)
            print('veh sawned', vehicle)
            TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
        else
            TriggerEvent('notification', 'You are not an Officer')
        end
    end)
end)


RegisterNUICallback('emsa', function()
    Citizen.CreateThread(function()
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        local job = PlayerData.job.name
        ambulancearea = emsgarage:isPointInside(coord)
        if job == 'ambulance' and ambulancearea == true then
            local hash = GetHashKey('emsa')
            
            if not IsModelAVehicle(hash) then return end
            if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Citizen.Wait(0)
            end
            
            local localped = PlayerPedId()
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)
            
            local heading = GetEntityHeading(localped)
            local vehicle = CreateVehicle(hash, coords, heading, true, false)
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent('garage:addKeys', plate)
            TriggerEvent("keys:addNew", vehicle, plate)
            TriggerServerEvent('garages:addJobPlate', plate)
            TriggerEvent('notification', 'Received keys to: ' .. plate)
            SetVehicleDirtLevel(vehicle, 0)
            SetVehicleWindowTint(vehicle, 3)
            SetVehicleModKit(vehicle, 0)
            SetVehicleMod(vehicle, 11, 2, false)
            SetVehicleMod(vehicle, 12, 2, false)
            ToggleVehicleMod(vehicle, 18, true)
            ToggleVehicleMod(vehicle, 22, true)
            SetVehicleMod(vehicle, 13, 2, false)
            SetVehicleMod(vehicle, 15, 2, false)
            SetVehicleMod(vehicle, 16, 2, false)
            SetVehicleLivery(vehicle, 0)
            print('veh sawned', vehicle)
            TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
        else
            TriggerEvent('notification', 'You are not a EMS')
        end
    end)
end)




-----------------------------------------------------------------------------
-- PolyZone Checks (distance checking)
-----------------------------------------------------------------------------
RegisterCommand("extra", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local extraID = tonumber(args[1])
    local toggle = tostring(args[2])
    if toggle == "true" then
        toggle = 0
    end
    if veh ~= nil and veh ~= 0 and veh ~= 1 then
        if extraID == "99" then
            SetVehicleAutoRepairDisabled(veh, true)
            SetVehicleExtra(veh, 1, toggle)
            SetVehicleExtra(veh, 2, toggle)
            SetVehicleExtra(veh, 3, toggle)
            SetVehicleExtra(veh, 4, toggle)
            SetVehicleExtra(veh, 5, toggle)
            SetVehicleExtra(veh, 6, toggle)
            SetVehicleExtra(veh, 7, toggle)
            SetVehicleExtra(veh, 8, toggle)
            SetVehicleExtra(veh, 9, toggle)
            SetVehicleExtra(veh, 10, toggle)
            SetVehicleExtra(veh, 11, toggle)
            SetVehicleExtra(veh, 12, toggle)
            SetVehicleExtra(veh, 13, toggle)
            SetVehicleExtra(veh, 14, toggle)
            SetVehicleExtra(veh, 15, toggle)
            SetVehicleExtra(veh, 16, toggle)
            SetVehicleExtra(veh, 17, toggle)
            SetVehicleExtra(veh, 18, toggle)
            SetVehicleExtra(veh, 19, toggle)
            SetVehicleExtra(veh, 20, toggle)
        else
            SetVehicleAutoRepairDisabled(Vehicle, true)
            SetVehicleExtra(veh, extraID, toggle)
        end
    
    end
end, false)



local fixarea = PolyZone:Create({
    vector2(404.98764038086, -1011.822265625),
    vector2(411.26461791992, -1011.4103393555),
    vector2(411.8935546875, -977.08953857422),
    vector2(405.48754882813, -974.49475097656)
}, {
    name = "fixareapd",
    minZ = 28.266778945923,
    maxZ = 32.427549362183,
    debugGrid = false,
})

RegisterCommand("fix", function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    local coord = GetEntityCoords(ped)
    local job = PlayerData.job.name
    infixarea = fixarea:isPointInside(coord)
    if job == 'police' and infixarea == true then
        exports["sway_taskbar"]:taskBar(4000, "Fixing Vehicle")
        SetVehicleFixed(veh)
        SetVehicleDeformationFixed(veh)
        SetVehicleUndriveable(veh, false)
        SetVehicleEngineOn(veh, true, true)
    else
        TriggerEvent('notification', 'Cannot do this action', 1)
    end
end, false)
