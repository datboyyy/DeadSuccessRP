ESX = nil
local hasBeenUnlocked = {}
local vehicleHotwired = {}
local gotKeys = false
local failedAttempt = {}
local vehicleSearched = {}
local disableH = false
local showText = true
local hasKilledNPC = false
local useLockpick = false
local vehicleBlacklist = {
    ['BMX'] = true,
    ['BMXST'] = true,
    ['CRUISER'] = true,
    ['FIXTER'] = true,
    ['SCORCHER'] = true,
    ['TRIBIKE'] = true,
    ['TRIBIKE2'] = true,
    ['TRIBIKE3'] = true,
    ['FLATBED'] = true,
    ['BOXVILLE2'] = true,
    ['BENSON'] = true,
    ['PHANTOM'] = true,
    ['RUBBLE'] = true,
    ['RUMPO'] = true,
    ['YOUGA2'] = true,
    ['BOXVILLE'] = true,
    ['TAXI'] = true,
    ['DINGHY'] = true
}

TriggerEvent('esx:getSharAVACedObject', function(obj)
    esx = obj
end)


RegisterCommand('key:togglevehlock', function()
  TriggerEvent('keys:togglelocks')
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local plate = GetVehicleNumberPlateText(vehicle)
            
            if IsControlJustPressed(0, 47) and GetLastInputMethod(2) then
                if not vehicleSearched[plate] and not hasVehicleKey(plate) and showText and not vehicleHotwired[plate] and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                    showText = false
                    exports["sway_taskbar"]:taskBar(10000, "Searching Vehicle")
                    vehicleSearched[plate] = true
                    if not hasVehicleKey(plate) then
                        TriggerServerEvent('garage:searchItem', plate)
                        showText = true
                    end
                elseif vehicleSearched[plate] then
                    TriggerEvent('notification', 'You have already searched this vehicle.', 2)
                end
            end
      else
          Wait(1000)
      end
        
        
        if disableF then
            DisableControlAction(0, 23, true)
        end
        
        if disableH then
            DisableControlAction(0, 74, true)
            DisableControlAction(0, 47, true)
        end
    end
end)
--[[
Citizen.CreateThread(function()
while true do
if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then
local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
local pedd = GetPedInVehicleSeat(veh, -1)

if DoesEntityExist(pedd) and not IsPedAPlayer(pedd) and not IsEntityDead(pedd) then
print('cannot enter this door dick(autist)')
SetVehicleDoorsLocked(veh, 2)
SetPedCanBeDraggedOut(pedd, false)
TaskVehicleMissionPedTarget(pedd, veh, PlayerPedId(), 8, 50.0, 790564, 300.0, 15.0, 1)
disableF = true
Wait(1500)
disableF = false
end
end
Citizen.Wait(0)
end
end)
--]]
RegisterNetEvent('vehicle:start')
AddEventHandler('vehicle:start', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleEngineOn(vehicle, true, true)
end)


Citizen.CreateThread(function()
    local plate = GetVehicleNumberPlateText(vehicle)
    while true do
        Citizen.Wait(5)
        
        if IsPedShooting(PlayerPedId()) then
            hasKilledNPC = true
        end
        
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local plate = GetVehicleNumberPlateText(vehicle)
            
            if DoesEntityExist(vehicle) and not hasVehicleKey(plate) and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() and not vehicleHotwired[plate] and not vehicleBlacklist[GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))] then
                while not IsPedInAnyVehicle(PlayerPedId(), false) do
                    Citizen.Wait(5)
                end
                
                SetVehicleEngineOn(vehicle, false, false)
                
                if showText then
                    local pos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 2.0, 1.0)
                    DrawText3Ds(pos["x"], pos["y"], pos["z"], "[H] Hotwire / [G] Search")
                end
                
                if IsControlJustPressed(0, 74) and showText and GetLastInputMethod(2) then
                    if not failedAttempt[plate] and not vehicleSearched[plate] and not vehicleHotwired[plate] then
                        TriggerEvent('animation:hotwire', true)
                        showText = false
                        exports["sway_taskbar"]:taskBar(40000, "Starting Hotwire")
                        TriggerEvent('animation:hotwire', false)
                        if math.random(10, 10) <= 10 then
                            vehicleHotwired[plate] = true
                            SetVehicleEngineOn(vehicle, true, true)
                            TriggerServerEvent('garage:addKeys', plate)
                            TriggerEvent('notification', 'You successfuly hotwired the vehicle.', 1)
                            showText = true
                        else
                            TriggerEvent('notification', 'You failed this hotwire.', 2)
                            failedAttempt[plate] = true
                            showText = true
                        end
                    elseif failedAttempt[plate] then
                        TriggerEvent('notification', 'The wires are already messed up.', 2)
                    elseif vehicleHotwired[plate] then
                        TriggerEvent('notification', 'Looks like this isn\'t going to work out.', 2)
                    else
                        TriggerEvent('notification', 'This is to complicated.', 2)
                    end
                elseif useLockpick then
                    useLockpick = true
                    TriggerEvent('animation:hotwire', true)
                    showText = false
                    exports["sway_taskbar"]:taskBar(20000, "Modifying Ignition Stage 1")
                    exports["sway_taskbar"]:taskBar(20000, "Modifying Ignition Stage 2")
                    exports["sway_taskbar"]:taskBar(20000, "Modifying Ignition Stage 3")
                    TriggerEvent('animation:hotwire', false)
                    vehicleHotwired[plate] = true
                    SetVehicleEngineOn(vehicle, true, true)
                    TriggerEvent('notification', 'Keys received.', 1)
                    TriggerEvent('notification', 'Engine Started.', 1)
                    TriggerServerEvent('garage:addKeys', plate)
                    SetVehicleEngineOn(vehicle, true, true)
                    showText = true
                    SetVehicleEngineOn(vehicle, true, true)
                    TriggerServerEvent('removelockpick')
                end
            end
        else
            Wait(2000)
        end
    end
end)

AddEventHandler('vehicle:setUnlocked', function(plate)
    hasBeenUnlocked[plate] = true
end)

function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
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
end


AddEventHandler('keys:togglelocks', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = nil
    if IsPedInAnyVehicle(ped, false) then vehicle = GetVehiclePedIsIn(ped, false) else vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71) end
    if DoesEntityExist(vehicle) then
        Citizen.CreateThread(function()
            if hasVehicleKey(GetVehicleNumberPlateText(vehicle)) then
                if not IsPedInAnyVehicle(PlayerPedId(), false) then
                    playLockAnimation()
                    SetVehicleEngineOn(vehicle, true, true, true)
                    SetVehicleLights(vehicle, 2)Wait(200)SetVehicleLights(vehicle, 1)Wait(200)SetVehicleLights(vehicle, 2)Wait(200)SetVehicleLights(vehicle, 1)
                    SetVehicleEngineOn(vehicle, false, false, false)
                    SetVehicleLights(vehicle, 0)
                end
                if GetVehicleDoorLockStatus(vehicle) == 1 then
                    SetVehicleDoorsLocked(vehicle, 2)
                    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "unlock", 0.1)
                    TriggerEvent('notification', 'Vehicle Locked', 1)
                
                elseif GetVehicleDoorLockStatus(vehicle) == 2 then
                    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "lock", 0.1)
                    TriggerEvent('notification', 'Vehicle Unlocked', 1)
                    SetVehicleDoorsLocked(vehicle, 1)
                end
            end
        end)
    else
        TriggerEvent('notification', 'No vehicle found.', 2)
    end
end)

function playLockAnimation()
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        RequestAnimDict('anim@heists@keycard@')
        while not HasAnimDictLoaded('anim@heists@keycard@') do
            Citizen.Wait(1)
        end
        TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 24.0, 16.0, 1000, 50, 0, false, false, false)
    end
end

RegisterCommand('givekey', function(args, source)
    local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 100.0, 0.0)
    local latestveh = getVehicleInDirection(coordA, coordB)
    
    if latestveh == nil or not DoesEntityExist(latestveh) then
        TriggerEvent('notification', 'No vehicle found.', 2)
        return
    end
    
    if not hasVehicleKey(GetVehicleNumberPlateText(latestveh)) then
        TriggerEvent('notification', 'No keys for target vehicle!', 2)
        return
    end
    
    if GetDistanceBetweenCoords(GetEntityCoords(latestveh), GetEntityCoords(GetPlayerPed(-1), 0)) > 5 then
        TriggerEvent('notification', 'You are to far away from the vehicle!', 2)
        return
    end
    
    t, distance = esx.Game.GetClosestPlayer()
    if (distance ~= -1 and distance < 8) then
        TriggerServerEvent('garage:giveKey', GetPlayerServerId(t), GetVehicleNumberPlateText(latestveh))
        TriggerEvent('notification', 'You just gave keys to your vehicles!', 1)
    else
        TriggerEvent('notification', 'No player near you!', 2)
    end
end)


RegisterNetEvent('vehkey')
AddEventHandler('vehkey', function()
    local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 100.0, 0.0)
    local latestveh = getVehicleInDirection(coordA, coordB)
    
    if latestveh == nil or not DoesEntityExist(latestveh) then
        TriggerEvent('notification', 'No vehicle found.', 2)
        return
    end
    
    if not hasVehicleKey(GetVehicleNumberPlateText(latestveh)) then
        TriggerEvent('notification', 'No keys for target vehicle!', 2)
        return
    end
    
    if GetDistanceBetweenCoords(GetEntityCoords(latestveh), GetEntityCoords(GetPlayerPed(-1), 0)) > 5 then
        TriggerEvent('notification', 'You are to far away from the vehicle!', 2)
        return
    end
    
    t, distance = esx.Game.GetClosestPlayer()
    if (distance ~= -1 and distance < 8) then
        TriggerServerEvent('garage:giveKey', GetPlayerServerId(t), GetVehicleNumberPlateText(latestveh))
        TriggerEvent('notification', 'You just gave keys to your vehicles!', 1)
    else
        TriggerEvent('notification', 'No player near you!', 2)
    end
end)

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle
    
    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, GetPlayerPed(-1), 0)
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1
        
        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 25 then vehicle = nil end
    
    return vehicle ~= nil and vehicle or 0
end

local disable = false

RegisterNetEvent('animation:hotwire')
AddEventHandler('animation:hotwire', function(disable)
    local lPed = GetPlayerPed(-1)
    ClearPedTasks(lPed)
    ClearPedSecondaryTask(lPed)
    
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
    end
    if disable ~= nil then
        if not disable then
            lockpicking = false
            return
        else
            lockpicking = true
        end
    end
    while lockpicking do
        
        if not IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then
            ClearPedSecondaryTask(lPed)
            TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        end
        Citizen.Wait(1)
    end
    ClearPedTasks(lPed)
end)

-- Start stealing a car
local isLockpicking = false


RegisterNetEvent('lockpick:vehicleUse')
AddEventHandler('lockpick:vehicleUse', function()
        
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local vehicle = nil
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        end
        
        if DoesEntityExist(vehicle) then
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                if GetVehicleDoorLockStatus(vehicle) ~= 1 then
                    RequestAnimDict("mini@repair")
                    while not HasAnimDictLoaded("mini@repair") do
                        Citizen.Wait(0)
                    end
                    
                    TriggerEvent('carLockpickAnim')
                    
                    Citizen.CreateThread(function()
                        TriggerEvent('InteractSound_CL:PlayOnOne', 'lockpick', 0.7)
                        exports["sway_taskbar"]:taskBar(20000, "You are lockpicking car")
                        isLockpicking = false
                        SetVehicleDoorsLocked(vehicle, 1)
                        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                        hasBeenUnlocked[GetVehicleNumberPlateText(vehicle)] = true
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "lock", 0.1)
                        TriggerEvent('notification', 'Vehicle Unlocked', 1)
                        SetVehicleEngineOn(vehicle, true, true, true)
                        SetVehicleLights(vehicle, 2)Wait(200)
                        SetVehicleLights(vehicle, 1)Wait(200)
                        SetVehicleLights(vehicle, 2)Wait(200)
                        SetVehicleLights(vehicle, 1)Wait(200)
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                        TriggerServerEvent('removelockpick')
                    
                    end)
                end
            else
                local plate = GetVehicleNumberPlateText(vehicle)
                if failedAttempt[plate] or vehicleHotwired[plate] or vehicleSearched[plate] or hasVehicleKey(plate) then
                    TriggerEvent('notification', 'You can not work out this hotwire.', 2)
                else
                    useLockpick = true
                end
            end
        end
end)

AddEventHandler('carLockpickAnim', function()
    isLockpicking = true
    loadAnimDict('veh@break_in@0h@p_m_one@')
    while isLockpicking do
        if not IsEntityPlayingAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3) then
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 1, 0.0, 0, 0, 0)
            Citizen.Wait(1500)
            ClearPedTasks(PlayerPedId())
        end
        Citizen.Wait(1)
    end
    ClearPedTasks(PlayerPedId())
end)


function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(5)
    end
end


local vehicleKeys = {}
local myCharacterID = 0

RegisterNetEvent("garage:updateKeys")
AddEventHandler("garage:updateKeys", function(data, char_id)
    vehicleKeys = data
    myCharacterID = char_id
end)

function hasVehicleKey(plate)
    if vehicleKeys[plate] ~= nil then
        for id, v in pairs(vehicleKeys[plate]) do
            if v.id == myCharacterID then
                return true
            end
        end
        return false
    else
        return false
    end
end
