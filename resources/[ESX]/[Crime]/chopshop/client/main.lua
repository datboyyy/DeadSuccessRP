ESX                             = nil
local PlayerData                = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local isDead                    = false
local CurrentTask               = {}
local menuOpen 				    = false
local wasOpen 				    = false
local pedIsTryingToChopVehicle  = false
local ChoppingInProgress        = false



Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
    isDead = false
end)




AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if menuOpen then
            ESX.UI.Menu.CloseAll()
        end
    end
end)


function IsDriver()
    return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
end



function MaxSeats(vehicle)
    local vehpas = GetVehicleNumberOfPassengers(vehicle)
    return vehpas
end

local lastTested = 0
function ChopVehicle()
    local seats = MaxSeats(vehicle)
    if seats ~= 0 then
        TriggerEvent('chat:addMessage', { args = { '[^1Chopshop^0]: Cannot chop with passengers' } })
    elseif
        GetGameTimer() - lastTested > Config.CooldownMinutes * 60000 then
        lastTested = GetGameTimer()
        ESX.TriggerServerCallback('Lenzh_chopshop:anycops', function(anycops)
            if anycops >= Config.CopsRequired then
                if Config.CallCops then
                    local randomReport = math.random(1, Config.CallCopsPercent)

                    if randomReport == Config.CallCopsPercent then
                        TriggerServerEvent('chopNotify')
                    end
                end
                local ped = PlayerPedId()
                local vehicle = GetVehiclePedIsIn( ped, false )
                ChoppingInProgress        = true
                VehiclePartsRemoval()
                if not HasAlreadyEnteredMarker then
                    HasAlreadyEnteredMarker =  true
                    ChoppingInProgress        = false
                   -- exports['mythic_notify']:SendAlert('error', "You Left The Zone. No Rewards For You")
                    TriggerEvent('notification', 'You Left The Zone. No Rewards For You', 1)
                    
                    SetVehicleAlarmTimeLeft(vehicle, 60000)
                end
            else
                ESX.ShowNotification(_U('not_enough_cops'))
            end
        end)
    else
        local timerNewChop = Config.CooldownMinutes * 60000 - (GetGameTimer() - lastTested)
        --exports['mythic_notify']:SendAlert('error', "Comeback Soon")
        TriggerEvent('notification', 'Comeback soon', 1)
        
    end
end



function VehiclePartsRemoval()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn( ped, false )
    local rearLeftDoor = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'door_dside_r')
    local bonnet = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'bonnet')
    local boot = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'boot')
    SetVehicleNumberPlateText(vehicle, "stolen")
    SetVehicleEngineOn(vehicle, false, false, true)
    SetVehicleUndriveable(vehicle, false)
    if ChoppingInProgress == true then
        exports['sway_taskbar']:taskBar(Config.DoorOpenFrontLeftTime, "Opening Front Left Door")
        Citizen.Wait(Config.DoorOpenFrontLeftTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 0, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['sway_taskbar']:taskBar(Config.DoorBrokenFrontLeftTime, "Removing Front Left Door")
        TriggerEvent('InteractSound_CL:PlayOnOne','impactdrill', 1.0)
        Citizen.Wait(Config.DoorBrokenFrontLeftTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 0, true)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['sway_taskbar']:taskBar(Config.DoorOpenFrontRightTime, "Opening Front Right Door")
        Citizen.Wait(Config.DoorOpenFrontRightTime)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 1, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        exports['sway_taskbar']:taskBar(Config.DoorBrokenFrontRightTime, "Removing Front Right Door")
        TriggerEvent('InteractSound_CL:PlayOnOne','impactdrill', 1.0)
        Citizen.Wait(Config.DoorBrokenFrontRightTime)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 1, true)
    end
    Citizen.Wait(1000)
	if rearLeftDoor ~= -1 then
        if ChoppingInProgress == true then
            exports['sway_taskbar']:taskBar(Config.DoorOpenRearLeftTime, "Opening Rear Left Door")
            Citizen.Wait(Config.DoorOpenRearLeftTime)
            SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 2, false, false)
        end
        Citizen.Wait(1000)
        if ChoppingInProgress == true then
            exports['sway_taskbar']:taskBar(Config.DoorBrokenRearLeftTime, "Removing Rear Left Door")
            TriggerEvent('InteractSound_CL:PlayOnOne','impactdrill', 1.0)
            Citizen.Wait(Config.DoorBrokenRearLeftTime)
            SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 2, true)
        end
        Citizen.Wait(1000)
        if ChoppingInProgress == true then
            exports['sway_taskbar']:taskBar(Config.DoorOpenRearRightTime, "Opening Rear Right Door")
            Citizen.Wait(Config.DoorOpenRearRightTime)
            SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 3, false, false)
        end
        Citizen.Wait(1000)
        if ChoppingInProgress == true then
            exports['sway_taskbar']:taskBar(Config.DoorBrokenRearRightTime, "Removing Rear Right Door")
            TriggerEvent('InteractSound_CL:PlayOnOne','impactdrill', 1.0)
            Citizen.Wait(Config.DoorBrokenRearRightTime)
            SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 3, true)
        end
    end
    Citizen.Wait(1000)
	if bonnet ~= -1 then
        if ChoppingInProgress == true then
            exports['sway_taskbar']:taskBar(Config.DoorOpenHoodTime, "Opening Hood")
            Citizen.Wait(Config.DoorOpenHoodTime)
            SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 4, false, false)
        end
        Citizen.Wait(1000)
        if ChoppingInProgress == true then
            exports['sway_taskbar']:taskBar(Config.DoorBrokenHoodTime, "Removing Hood")
            TriggerEvent('InteractSound_CL:PlayOnOne','impactdrill', 1.0)
            Citizen.Wait(Config.DoorBrokenHoodTime)
            SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false),4, true)
        end
    end
    Citizen.Wait(1000)
	if boot ~= -1 then
        if ChoppingInProgress == true then
            exports['sway_taskbar']:taskBar(Config.DoorOpenTrunkTime, "Opening Trunk")    
            Citizen.Wait(Config.DoorOpenTrunkTime)
            SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 5, false, false)
        end
        Citizen.Wait(1000)
        if ChoppingInProgress == true then
            exports['sway_taskbar']:taskBar(Config.DoorBrokenTrunkTime, "Removing Trunk")
            TriggerEvent('InteractSound_CL:PlayOnOne','impactdrill', 1.0)
            Citizen.Wait(Config.DoorBrokenTrunkTime)
            SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false),5, true)
        end
    end
    Citizen.Wait(1000)
    exports['sway_taskbar']:taskBar(Config.DeletingVehicleTime, "Let John take care of the car!")
    Citizen.Wait(Config.DeletingVehicleTime)
    if ChoppingInProgress == true then
        DeleteVehicle()
       -- exports['mythic_notify']:SendAlert('success', "Vehicle Chopped Successfully...")
        TriggerEvent('notification', 'Vehicle Chopped Successfully...', 1)
        
    end
end

function DeleteVehicle()
    if IsDriver() then
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)
        if IsPedInAnyVehicle(playerPed,  false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            ESX.Game.DeleteVehicle(vehicle)
        end
        TriggerServerEvent("lenzh_chopshop:rewards", rewards)
    end
end


AddEventHandler('lenzh_chopshop:hasEnteredMarker', function(zone)
    if zone == 'Chopshop' and IsDriver() then
        CurrentAction     = 'Chopshop'
        CurrentActionMsg  = _U('press_to_chop')
        CurrentActionData = {}
    end
end)

AddEventHandler('lenzh_chopshop:hasExitedMarker', function(zone)
    if menuOpen then
        ESX.UI.Menu.CloseAll()
    end

    if zone == 'Chopshop' then

        if ChoppingInProgress == true then
           -- exports['mythic_notify']:SendAlert('error', "You Left The Zone. Go Back In The Zone")
            TriggerEvent('notification', 'You Left The Zone. Go Back In The Zone', 1)
            
        end
    end
    ChoppingInProgress        = false


    CurrentAction = nil
end)



Citizen.CreateThread(function()
    if Config.EnableBlips == false then
        for k,zone in pairs(Config.Zones) do
            CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
        end
    end
end)



-- Display markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true
        for k,v in pairs(Config.Zones) do
            if Config.MarkerType ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
                DrawMarker(Config.MarkerType, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
                letSleep = false
            end
        end
        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords      = GetEntityCoords(PlayerPedId())
        local isInMarker  = false
        local currentZone = nil
        local letSleep = true
        for k,v in pairs(Config.Zones) do
            if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                isInMarker  = true
                currentZone = k
            end
        end
        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
            HasAlreadyEnteredMarker = true
            LastZone                = currentZone
            TriggerEvent('lenzh_chopshop:hasEnteredMarker', currentZone)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('lenzh_chopshop:hasExitedMarker', LastZone)
        end
    end
end)

-- Key controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CurrentAction ~= nil then
            ESX.ShowHelpNotification(CurrentActionMsg)
            if IsControlJustReleased(0, 38) then
                if IsDriver() then
                    if CurrentAction == 'Chopshop' then
                        ChopVehicle()
                    end
                end
                CurrentAction = nil
            end
        else
            Citizen.Wait(500)
        end
    end
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if menuOpen then
            ESX.UI.Menu.CloseAll()
        end
    end
end)

--Only if Config.CallCops = true
GetPlayerName()


RegisterNetEvent('ChopNotify')
AddEventHandler('ChopNotify', function(alert)
    if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
        ESX.ShowAdvancedNotification(_U('911'), _U('chop'), _U('call'), 'CHAR_CALL911', 7)
        PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    end
end)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

local timer = 1 --in minutes - Set the time during the player is outlaw
local blipTime = 35 --in second
local showcopsmisbehave = true --show notification when cops steal too
local timing = timer * 60000 --Don't touche it

Citizen.CreateThread(function()
    while true do
        Wait(100)
        if NetworkIsSessionStarted() then
            DecorRegister("IsChopperd",  3)
            DecorSetInt(PlayerPedId(), "IsChopperd", 1)
            return
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Wait(100)
        local plyPos = GetEntityCoords(PlayerPedId(),  true)
        if pedIsTryingToChopVehicle then
            DecorSetInt(PlayerPedId(), "IsChopperd", 2)
            if PlayerData.job ~= nil and PlayerData.job.name == 'police' and showcopsmisbehave == false then
            elseif PlayerData.job ~= nil and PlayerData.job.name == 'police' and showcopsmisbehave then
                TriggerServerEvent('ChoppingInProgressPos', plyPos.x, plyPos.y, plyPos.z)
                TriggerServerEvent('ChopInProgress')
                Wait(3000)
                pedIsTryingToChopVehicle = false
            end
        end
    end
end)


RegisterNetEvent('Choplocation')
AddEventHandler('Choplocation', function(tx, ty, tz)
    if PlayerData.job.name == 'police' then
        local transT = 250
        local Blip = AddBlipForCoord(tx, ty, tz)
        SetBlipSprite(Blip,  10)
        SetBlipColour(Blip,  1)
        SetBlipAlpha(Blip,  transT)
        SetBlipAsShortRange(Blip,  false)
        while transT ~= 0 do
            Wait(blipTime * 4)
            transT = transT - 1
            SetBlipAlpha(Blip,  transT)
            if transT == 0 then
                SetBlipSprite(Blip,  2)
                return
            end
        end
    end
end)

RegisterNetEvent('chopEnable')
AddEventHandler('chopEnable', function()
    pedIsTryingToChopVehicle = true
end)
