local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(10)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        PlayerData = xPlayer
    end)
    
    
    
    
    ESX.PlayerData = ESX.GetPlayerData()
    
    while true do
        if ESX.PlayerData.job.name == 'mechanic' and not registed then
            RegisterCommands()
            registed = true
        else
            registed = false
        end
        Citizen.Wait(1500)
    end
end)

-- disable health regen





--- AntiPistol whip
Citizen.CreateThread(function()
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HEAVYSNIPER"), 0.0001)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_RPG"), 0.000001)
    N_0x4757f00bc6323cfe(GetHashKey("weapon_sawnoffshotgun"), 0.5)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HEAVYSNIPER_MK2"), 0.0001)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNIFE"), 0.25)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BAT"), 0.25)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHETE"), 0.25)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CROWBAR"), 0.25)
    N_0x4757f00bc6323cfe(GetHashKey("weapon_flashlight"), 0.1)
    N_0x4757f00bc6323cfe(GetHashKey("weapon_nightstick"), 0.1)
    N_0x4757f00bc6323cfe(GetHashKey("weapon_pistol50"), 0.5)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.5)
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
         DisableControlAction(2, 36, true) -- Disable going stealth
        if IsPedArmed(ped, 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            DisableControlAction(2, 36, true) -- Disable going stealth
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        else
            Wait(100)
        end
    end
end)


RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_CARBINERIFLE'))
RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_PISTOL'))
RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_PUMPSHOTGUN'))
N_0x4757f00bc6323cfe(-1553120962, 0.0)
N_0x4757f00bc6323cfe(-1553120962, 0.0)--undocumented damage modifier. 1st argument is hash, 2nd is modified (0.0-1.0)


Citizen.CreateThread(function()
    while true do
        N_0x4757f00bc6323cfe(-1553120962, 0.0)--undocumented damage modifier. 1st argument is hash, 2nd is modified (0.0-1.0)
        Wait(50)
    end
end)



local ragdoll = false
local stunShouldRagdoll = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ragdoll then
            SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, true, true, false)
        end
    end
end)

RegisterNetEvent('sway_ragdoll:toggle')
AddEventHandler('sway_ragdoll:toggle', function()
    ragdoll = not ragdoll
end)

RegisterNetEvent('sway_ragdoll:set')
AddEventHandler('sway_ragdoll:set', function(value)
    ragdoll = value
end)

RegisterCommand("trunk", function(src, args, raw)
    TriggerEvent('trunk', s)
end, false)


RegisterCommand("hood", function(src, args, raw)
    TriggerEvent('hood', s)
end, false)



RegisterCommand("rag", function(src, args, raw)
    TriggerEvent("sway_ragdoll:toggle")
end, false)


local disableShuffle = true
function disableSeatShuffle(flag)
    disableShuffle = flag
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
                if GetIsTaskActive(GetPlayerPed(-1), 165) then
                    SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
                end
            end
        end
    end
end)

RegisterNetEvent("SeatShuffle")
AddEventHandler("SeatShuffle", function()
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        disableSeatShuffle(false)
        Citizen.Wait(5000)
        disableSeatShuffle(true)
    else
        CancelEvent()
    end
end)

RegisterCommand("s", function(source, args, raw)--change command here
    TriggerEvent("SeatShuffle")
end, false)--False, allow everyone to run it




RegisterCommand('livery', function(source, args, rawCommand)
    local Veh = GetVehiclePedIsIn(GetPlayerPed(-1))
    local livery = tonumber(args[1])
    
    SetVehicleLivery(Veh, livery)--CHANGE livery(id)
    TriggerEvent('notification', "Vehicle Livery " .. livery .. " loaded!")
end)

function drawNotification(Notification)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(Notification)
    DrawNotification(false, false)
end


ESX = nil

Currentstates = {
        
        [1] = {["text"] = "Red Hands", ["status"] = false, ["timer"] = 0},
        
        [2] = {["text"] = "Dialated Eyes", ["status"] = false, ["timer"] = 0},
        
        [3] = {["text"] = "Red Eyes", ["status"] = false, ["timer"] = 0},
        
        [4] = {["text"] = "Smells Like Marijuana", ["status"] = false, ["timer"] = 0},
        
        [5] = {["text"] = "Fresh Bandaging", ["status"] = false, ["timer"] = 0},
        
        [6] = {["text"] = "Agitated", ["status"] = false, ["timer"] = 0},
        
        [7] = {["text"] = "Uncoordinated", ["status"] = false, ["timer"] = 0},
        
        [8] = {["text"] = "Breath smells like Alcohol", ["status"] = false, ["timer"] = 0},
        
        [9] = {["text"] = "Smells like Gasoline", ["status"] = false, ["timer"] = 0},
        
        [10] = {["text"] = "Red Gunpowder Residue", ["status"] = false, ["timer"] = 0},
        
        [11] = {["text"] = "Smells of Chemicals", ["status"] = false, ["timer"] = 0},
        
        [12] = {["text"] = "Smells of Oil / Metalwork", ["status"] = false, ["timer"] = 0},
        
        [13] = {["text"] = "Ink Stained Hands", ["status"] = false, ["timer"] = 0},
        
        [14] = {["text"] = "Smells like smoke", ["status"] = false, ["timer"] = 0},
        
        [15] = {["text"] = "Has camping equipment", ["status"] = false, ["timer"] = 0},
        
        [16] = {["text"] = "Smells like burnt Aluminum and iron", ["status"] = false, ["timer"] = 0},
        
        [17] = {["text"] = "Has metal specs on clothing", ["status"] = false, ["timer"] = 0},
        
        [18] = {["text"] = "Smells Like Cigarette Smoke", ["status"] = false, ["timer"] = 0},
        
        [19] = {["text"] = "Labored Breathing", ["status"] = false, ["timer"] = 0},
        
        [20] = {["text"] = "Body Sweat", ["status"] = false, ["timer"] = 0},
        
        [21] = {["text"] = "Clothing Sweat", ["status"] = false, ["timer"] = 0},
        
        [22] = {["text"] = "Wire Cuts", ["status"] = false, ["timer"] = 0},
        
        [23] = {["text"] = "Saturated Clothing", ["status"] = false, ["timer"] = 0},
        
        [24] = {["text"] = "Looks Dazed", ["status"] = false, ["timer"] = 0},
        
        [25] = {["text"] = "Looks Well Fed", ["status"] = false, ["timer"] = 0},
        
        [26] = {["text"] = "Has scratches on hands.", ["status"] = false, ["timer"] = 0},
        
        [27] = {["text"] = "Looks Alert", ["status"] = false, ["timer"] = 0},

}


RegisterNetEvent("sway-state:stateSet")

AddEventHandler("sway-state:stateSet", function(stateId, stateLength)
        
        if Currentstates[stateId]["timer"] < 10 and stateLength ~= 0 then
            
            TriggerEvent('chat:addMessage', {template = '<div class="chat-message status stategained"><r> {0}</r> {1}</div>', args = {"STATUS: ", Currentstates[stateId]["text"]}})
        
        end
        
        Currentstates[stateId]["timer"] = stateLength

end)





local lastTarget

local target

local targetLastHealth

local bodySweat = 0

local sweatTriggered = false

Citizen.CreateThread(function()
        
        
        
        while true do
            
            Wait(300)
            
            
            
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                
                local vehicle = GetVehiclePedIsUsing(PlayerPedId())
                
                local bicycle = IsThisModelABicycle(GetEntityModel(vehicle))
                
                local speed = GetEntitySpeed(vehicle)
                
                if bicycle and speed > 0 then
                    
                    sweatTriggered = true
                    
                    if bodySweat < 180 then
                        
                        bodySweat = bodySweat + (150 + math.ceil(speed * 20))
                    
                    else
                        
                        bodySweat = bodySweat + (150 + math.ceil(speed * 10))
                    
                    end
                    
                    
                    
                    if bodySweat > 300 then
                        
                        bodySweat = 300
                    
                    end
                
                end
            
            end
            
            if IsPedOnAnyBike(PlayerPedId(), false) then
                
                local vehicle = GetVehiclePedIsUsing(PlayerPedId())
                
                local bicycle = IsThisModelABicycle(GetEntityModel(vehicle))
                
                local speed = GetEntitySpeed(vehicle)
                
                if bicycle and speed > 0 then
                    
                    sweatTriggered = true
                    
                    if bodySweat < 180 then
                        
                        bodySweat = bodySweat + (150 + math.ceil(speed * 20))
                    
                    else
                        
                        bodySweat = bodySweat + (150 + math.ceil(speed * 10))
                    
                    end
                    
                    
                    
                    if bodySweat > 300 then
                        
                        bodySweat = 300
                    
                    end
                
                end
            
            end
            
            
            
            if IsPedInMeleeCombat(PlayerPedId()) then
                
                bodySweat = bodySweat + 300
                
                sweatTriggered = true
                
                target = GetMeleeTargetForPed(PlayerPedId())
                
                if target == lastTarget or lastTarget == nil then
                    
                    if IsPedAPlayer(target) then
                        
                        TriggerEvent("sway-state:stateSet", 1, 300)
                        
                        lastTarget = target
                    
                    end
                
                else
                    
                    if IsPedAPlayer(target) then
                        
                        TriggerEvent("sway-state:stateSet", 1, 300)
                        
                        targetLastHealth = GetEntityHealth(target)
                        
                        lastTarget = target
                    
                    end
                
                end
            
            end
            
            
            if IsPedInCombat(PlayerPedId()) then
                
                bodySweat = bodySweat + 300
                
                sweatTriggered = true
                
                target = GetCombatTargetForPed(PlayerPedId())
                
                if target == lastTarget or lastTarget == nil then
                    
                    if IsPedAPlayer(target) then
                        
                        TriggerEvent("sway-state:stateSet", 1, 300)
                        
                        lastTarget = target
                    
                    end
                
                else
                    
                    if IsPedAPlayer(target) then
                        
                        TriggerEvent("sway-state:stateSet", 1, 300)
                        
                        targetLastHealth = GetEntityHealth(target)
                        
                        lastTarget = target
                    
                    end
                
                end
            
            end
            
            
            
            if IsPedSwimming(PlayerPedId()) then
                
                local speed = GetEntitySpeed(PlayerPedId())
                
                if speed > 0 then
                    
                    sweatTriggered = true
                    
                    TriggerEvent("sway-state:stateSet", 20, 0)
                    
                    TriggerEvent("sway-state:stateSet", 21, 0)
                    
                    TriggerEvent("sway-state:stateSet", 23, 600)
                    
                    if bodySweat < 180 then
                        
                        bodySweat = bodySweat + (100 + math.ceil(speed * 10))
                    
                    else
                        
                        bodySweat = bodySweat + (100 + math.ceil(speed * 11))
                    
                    end
                    
                    
                    
                    
                    
                    if bodySweat > 210 then
                        
                        TriggerEvent("sway-state:stateSet", 19, 600)
                        
                        bodySweat = 210
                    
                    end
                
                end
            
            end
            
            
            
            if IsPedRunning(PlayerPedId()) then
                
                bodySweat = bodySweat + 30
                
                if bodySweat > 800 then
                    
                    bodySweat = 800
                
                end
            
            elseif bodySweat > 0.0 then
                
                if not sweatTriggered then
                    
                    bodySweat = 0.0
                
                end
                
                if bodySweat < 1200 then
                    
                    bodySweat = bodySweat - 1000
                
                end
                
                bodySweat = bodySweat - 100
                
                if bodySweat == 0.0 then
                    
                    sweatTriggered = false
                
                end
            
            end
            
            if bodySweat > 200 and not IsPedSwimming(PlayerPedId()) then
                
                TriggerEvent("sway-state:stateSet", 19, 300)
            
            end
            
            
            
            if bodySweat > 300 and not IsPedSwimming(PlayerPedId()) and Currentstates[22]["timer"] < 50 then
                
                TriggerEvent("sway-state:stateSet", 20, 450)
            
            end
            
            if bodySweat > 800 and not IsPedSwimming(PlayerPedId()) and Currentstates[22]["timer"] < 50 then
                
                sweatTriggered = true
                
                TriggerEvent("sway-state:stateSet", 21, 600)
            
            end
        
        
        
        end

end)


--Loads Animation Dictionary
function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end




--[[DisableLMB = false



Citizen.CreateThread(function()
while true do
Citizen.Wait(0)

local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)


if IsControlJustPressed(0, 24) or IsControlJustPressed(0, 69) or IsControlJustPressed(0, 70) or IsControlJustPressed(0, 92) or IsControlJustPressed(0, 106) or IsControlJustPressed(0, 140) or IsControlJustPressed(0, 141) or IsControlJustPressed(0, 142) then
if GetSelectedPedWeapon(GetPlayerPed(-1)) == -1569615261 then
if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
DisableLMB = true
if math.random(1, 100) <= 10 then
print("Anti punch spam ragdoll")
SetPedToRagdoll(GetPlayerPed(-1), 500, 500, 2, 0, 0, 0)
end
Citizen.Wait(1700)
DisableLMB = false
end
end
end

end
end)

Citizen.CreateThread(function()
while true do
if DisableLMB then
DisableControlAction(0, 24, true)
DisableControlAction(0, 69, true)
DisableControlAction(0, 70, true)
DisableControlAction(0, 92, true)
DisableControlAction(0, 106, true)
DisableControlAction(0, 140, true)
DisableControlAction(0, 141, true)
DisableControlAction(0, 142, true)
end
Citizen.Wait(0)
end
end)]]
--
Citizen.CreateThread(function()
    while true do
        SetPedSuffersCriticalHits(GetPlayerPed(-1), false)
        Citizen.Wait(1000)
    end
end)


-- C O N F I G --
interactionDistance = 3.5 --The radius you have to be in to interact with the vehicle.


--  V A R I A B L E S --
engineoff = false


-- E N G I N E --
IsEngineOn = true
RegisterNetEvent('engine')
AddEventHandler('engine', function()
    local player = GetPlayerPed(-1)
    
    if (IsPedSittingInAnyVehicle(player)) then
        local vehicle = GetVehiclePedIsIn(player, false)
        
        if IsEngineOn == true then
            IsEngineOn = false
            SetVehicleEngineOn(vehicle, false, false, false)
        else
            IsEngineOn = true
            SetVehicleUndriveable(vehicle, false)
            SetVehicleEngineOn(vehicle, true, false, false)
        end
        
        while (IsEngineOn == false) do
            SetVehicleUndriveable(vehicle, true)
            Citizen.Wait(0)
        end
    end
end)


-- T R U N K --
RegisterNetEvent('trunk')
AddEventHandler('trunk', function()
    local player = GetPlayerPed(-1)
    if controlsave_bool == true then
        vehicle = saveVehicle
    else
        vehicle = GetVehiclePedIsIn(player, true)
    end
    
    local isopen = GetVehicleDoorAngleRatio(vehicle, 5)
    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
    
    if distanceToVeh <= interactionDistance then
        if (isopen == 0) then
            SetVehicleDoorOpen(vehicle, 5, 0, 0)
        else
            SetVehicleDoorShut(vehicle, 5, 0)
        end
    else
        TriggerEvent('notification', "You must be near your vehicle to do that.")
    end
end)


-- H O O D --
RegisterNetEvent('hood')
AddEventHandler('hood', function()
    local player = GetPlayerPed(-1)
    if controlsave_bool == true then
        vehicle = saveVehicle
    else
        vehicle = GetVehiclePedIsIn(player, true)
    end
    
    local isopen = GetVehicleDoorAngleRatio(vehicle, 4)
    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
    
    if distanceToVeh <= interactionDistance then
        if (isopen == 0) then
            SetVehicleDoorOpen(vehicle, 4, 0, 0)
        else
            SetVehicleDoorShut(vehicle, 4, 0)
        end
    else
        TriggerEvent('notification', "You must be near your vehicle to do that.")
    end
end)
-- L O C K --

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end




Citizen.CreateThread(function()
        
        for i = 1, #Config.Map, 1 do
            
            local blip = AddBlipForCoord(Config.Map[i].x, Config.Map[i].y, Config.Map[i].z)
            SetBlipSprite(blip, Config.Map[i].id)
            SetBlipDisplay(blip, 4)
            SetBlipColour(blip, Config.Map[i].color)
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)
            
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.Map[i].name)
            EndTextCommandSetBlipName(blip)
        end

end)

local carryingBackInProgress = false
local carryAnimNamePlaying = ""
local carryAnimDictPlaying = ""
local carryControlFlagPlaying = 0

RegisterNetEvent('carrytrigger')
AddEventHandler('carrytrigger', function()
    ExecuteCommand("carry")
end)

RegisterCommand("carry", function(source, args)
    if not carryingBackInProgress then
        local player = PlayerPedId()
        lib = 'missfinale_c2mcs_1'
        anim1 = 'fin_c2_mcs_1_camman'
        lib2 = 'nm'
        anim2 = 'firemans_carry'
        distans = 0.15
        distans2 = 0.27
        height = 0.63
        spin = 0.0
        length = 100000
        controlFlagMe = 49
        controlFlagTarget = 33
        animFlagTarget = 1
        TriggerServerEvent('3dme:shareDisplay', "*Attempts to carry/putdown someone.*")
        exports["sway_taskbar"]:taskBar(1000, "Picking Up Person")
        local closestPlayer = GetClosestPlayer(3)
        target = GetPlayerServerId(closestPlayer)
        if closestPlayer ~= -1 then
            carryingBackInProgress = true
            TriggerServerEvent('CarryPeople:sync', closestPlayer, lib, lib2, anim1, anim2, distans, distans2, height, target, length, spin, controlFlagMe, controlFlagTarget, animFlagTarget)
        else
            TriggerEvent("notifcation", 'No one nearby to carry!')
        end
    
    else
        carryingBackInProgress = false
        ClearPedSecondaryTask(GetPlayerPed(-1))
        DetachEntity(GetPlayerPed(-1), true, false)
        local closestPlayer = GetClosestPlayer(3)
        target = GetPlayerServerId(closestPlayer)
        if target ~= 0 then
            TriggerServerEvent("CarryPeople:stop", target)
            local finished = exports["sway_taskbar"]:taskBar(1000, "Dropping")
            if finished == 100 then
                end
        end
    end
end, false)

RegisterNetEvent('CarryPeople:syncTarget')
AddEventHandler('CarryPeople:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length, spin, controlFlag)
    local playerPed = GetPlayerPed(-1)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
    carryingBackInProgress = true
    RequestAnimDict(animationLib)
    
    while not HasAnimDictLoaded(animationLib) do
        Citizen.Wait(10)
    end
    if spin == nil then spin = 180.0 end
    AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
    if controlFlag == nil then controlFlag = 0 end
    TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
    carryAnimNamePlaying = animation2
    carryAnimDictPlaying = animationLib
    carryControlFlagPlaying = controlFlag
end)


RegisterNetEvent('CarryPeople:syncMe')
AddEventHandler('CarryPeople:syncMe', function(animationLib, animation, length, controlFlag, animFlag)
    local playerPed = GetPlayerPed(-1)
    RequestAnimDict(animationLib)
    
    while not HasAnimDictLoaded(animationLib) do
        Citizen.Wait(10)
    end
    Wait(500)
    if controlFlag == nil then controlFlag = 0 end
    TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
    carryAnimNamePlaying = animation
    carryAnimDictPlaying = animationLib
    carryControlFlagPlaying = controlFlag
end)


RegisterNetEvent('CarryPeople:cl_stop')
AddEventHandler('CarryPeople:cl_stop', function()
    carryingBackInProgress = false
    ClearPedSecondaryTask(GetPlayerPed(-1))
    DetachEntity(GetPlayerPed(-1), true, false)
end)

Citizen.CreateThread(function()
    while true do
        if carryingBackInProgress then
            while not IsEntityPlayingAnim(GetPlayerPed(-1), carryAnimDictPlaying, carryAnimNamePlaying, 3) do
                TaskPlayAnim(GetPlayerPed(-1), carryAnimDictPlaying, carryAnimNamePlaying, 8.0, -8.0, 100000, carryControlFlagPlaying, 0, false, false, false)
                Citizen.Wait(0)
            end
        end
        Wait(0)
    end
end)

function GetPlayers()
    local players = {}
    
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    
    return players
end

function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index, value in ipairs(players) do
        local target = GetPlayerPed(value)
        if (target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if (closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    print("Sway is watching you be careful")
    if closestDistance <= radius then
        return closestPlayer
    else
        return nil
    end
end






-- peacetime script
local peacetimeon = false

RegisterNetEvent("sway:peacetime")
AddEventHandler("sway:peacetime", function(NewPeacetimestatus)
    peacetimeon = NewPeacetimestatus
end)

Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Citizen.Wait(0)
    end
    
    while true do
        Citizen.Wait(0)
        local player = GetPlayerPed(-1)
        local x, y, z = table.unpack(GetEntityCoords(player, true))
        if peacetimeon then
            DisableControlAction(2, 37, true)-- disable weapon wheel (Tab)
            DisablePlayerFiring(player, true)-- Disables firing all together if they somehow bypass inzone Mouse Disable
            DisableControlAction(0, 106, true)-- Disable in-game mouse controls
            if IsDisabledControlJustPressed(2, 37) then --if Tab is pressed, send error message
                SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)-- if tab is pressed it will set them to unarmed (this is to cover the vehicle glitch until I sort that all out)
                
                exports['mythic_notify']:SendAlert('error', 'You can not use weapons while there is PeaceTime', 6000, {['background-color'] = '#2F5C73', ['color'] = '#FFFFFF'})
            end
            if IsDisabledControlJustPressed(0, 106) then --if LeftClick is pressed, send error message
                SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)-- If they click it will set them to unarmed
                
                exports['mythic_notify']:SendAlert('error', 'You can not do that while there is PeaceTime', 6000, {['background-color'] = '#2F5C73', ['color'] = '#FFFFFF'})
            end
        end
    end
end)




local sway = 0
local shakeLevel = 0
function Sway(pLy)
    local newShake = 2.0
    if GetEntitySpeed(pLy) < 50 then
        newShake = 1.0
    end
    if shakeLevel == newShake then
        return
    end
    shakeLevel = newShake
    ShakeGameplayCam('ROAD_VIBRATION_SHAKE', newShake)
end

function AddTextEntry(key, value)
    Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
    AddTextEntry('FE_THDR_GTAO', 'DeadSuccessRP discord.gg/dsrp ')
end)



Citizen.CreateThread(function()
    while true do Citizen.Wait(100)
        if IsPedInAnyPoliceVehicle(GetPlayerPed(-1), -1) or IsPedInAnyHeli(GetPlayerPed(-1)) then
            DisablePlayerVehicleRewards(GetPlayerPed(-1))
        end
    end
end)

RegisterCommand('crouch', function()
cmdcrouch()
end, false)

function cmdcrouch()
    local ped = GetPlayerPed(-1)
    if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
        if (not IsPauseMenuActive()) then
                RequestAnimSet("move_ped_crouched")
                RequestAnimSet("MOVE_M@TOUGH_GUY@")
                
                while (not HasAnimSetLoaded("move_ped_crouched")) do
                    Wait(100)
                end
                while (not HasAnimSetLoaded("MOVE_M@TOUGH_GUY@")) do
                    Citizen.Wait(100)
                end
                if (crouched) then
                    ResetPedMovementClipset(ped)
                    ResetPedStrafeClipset(ped)
                    SetPedMovementClipset(PlayerPedId(), AnimSet, true)
                    crouched = false
                elseif (not crouched) then
                    SetPedMovementClipset(ped, "move_ped_crouched", 0.55)
                    SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
                    crouched = true
                end
            end
    else
        
        crouched = false
    end
end






local citizen = false

RegisterNetEvent('LRP-Armour:Client:SetPlayerArmour')
AddEventHandler('LRP-Armour:Client:SetPlayerArmour', function(armour)
    Citizen.Wait(10000)-- Give ESX time to load their stuff. Because some how ESX remove the armour when load the ped.
    SetPedArmour(PlayerPedId(), tonumber(armour))
    citizen = true
end)

local TimeFreshCurrentArmour = 60000 -- 60 seconds

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if citizen == true then
            TriggerServerEvent('LRP-Armour:Server:RefreshCurrentArmour', GetPedArmour(PlayerPedId()))
            Citizen.Wait(TimeFreshCurrentArmour)
        end
    end
end)


--[[RegisterCommand("pc", function(source, args, raw)
local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
local pleb = GetPlayerServerId(closestPlayer)
if closestPlayer ~= -1 and closestDistance ~= -1 and closestDistance <= 2.0 then
TriggerServerEvent("shitidk:pulsecheck", pleb)
TriggerServerEvent('3dme:shareDisplay', "*Checks for a pulse*")
end
end, false)

local pulseresponse = false

RegisterNetEvent('shitidk2:pulsecheck')
AddEventHandler('shitidk2:pulsecheck', function(pleb)
pulseresponse = true
end)

Citizen.CreateThread(function()
while true do
Citizen.Wait(0)
local plyPed = GetPlayerPed(-1)
local plyPos = GetEntityCoords(plyPed)

if pulseresponse then
DrawText2(0.929, 1.230, 1.0, 1.0, 0.45, "Someone is checking for your pulse.", 255, 255, 255, 255)
DrawText2(0.889, 1.258, 1.0, 1.0, 0.45, "[1] ~g~Have a pulse ~w~| [2] ~y~Weak pulse ~w~| [3] ~r~No pulse (perma)~w~.", 255, 255, 255, 255)

if (IsControlJustPressed(0, 157) or IsDisabledControlJustPressed(0, 157)) then
TriggerServerEvent('3dme:shareDisplay', "*Has a pulse*")
pulseresponse = false
elseif (IsControlJustPressed(0, 158) or IsDisabledControlJustPressed(0, 158)) then
TriggerServerEvent('3dme:shareDisplay', "*Has a weak pulse*")
pulseresponse = false
elseif (IsControlJustPressed(0, 160) or IsDisabledControlJustPressed(0, 160)) then
TriggerServerEvent('3dme:shareDisplay', "*Has no pulse*")
pulseresponse = false
end
end
end
end)--]]
function DrawText2(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

function getclosestnoob()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        
        for index, value in ipairs(players) do
            local target = GetPlayerPed(value)
            if (target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if (closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        
        return closestPlayer, closestDistance, closestPed
    
    else
        --TriggerEvent("notification", "Person a in vehicle", 2)
        end
end

RegisterNetEvent('animation:tacklelol')
AddEventHandler('animation:tacklelol', function()
        
        if not handCuffed and not IsPedRagdoll(PlayerPedId()) then
            
            local lPed = PlayerPedId()
            
            RequestAnimDict("swimming@first_person@diving")
            while not HasAnimDictLoaded("swimming@first_person@diving") do
                Citizen.Wait(1)
            end
            
            if IsEntityPlayingAnim(lPed, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3) then
                ClearPedSecondaryTask(lPed)
            
            else
                TaskPlayAnim(lPed, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 8.0, -8, -1, 49, 0, 0, 0, 0)
                seccount = 3
                while seccount > 0 do
                    Citizen.Wait(100)
                    seccount = seccount - 1
                
                end
                ClearPedSecondaryTask(lPed)
                SetPedToRagdoll(PlayerPedId(), 150, 150, 0, 0, 0, 0)
            end
        
        end

end)

function TryTackle()
    if not TimerEnabled then
        print("attempting a tackle.")
        t, distance = getclosestnoob()
        if t and distance then
            if (distance ~= -1 and distance < 2) then
                local maxheading = (GetEntityHeading(PlayerPedId()) + 15.0)
                local minheading = (GetEntityHeading(PlayerPedId()) - 15.0)
                local theading = (GetEntityHeading(t))
                
                TriggerServerEvent('CrashTackle', GetPlayerServerId(t))
                TriggerEvent("animation:tacklelol")
                
                TimerEnabled = true
                Citizen.Wait(4500)
                TimerEnabled = false
            
            else
                TimerEnabled = true
                Citizen.Wait(1000)
                TimerEnabled = false
            
            end
        end
    
    end
--SetPedToRagdoll(PlayerPedId(), 500, 500, 0, 0, 0, 0)
end


Citizen.CreateThread(function()
    while true do
        if IsControlPressed(0, Keys['LEFTSHIFT']) and IsControlPressed(0, Keys['G']) then
            TryTackle()
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent('playerTackled')
AddEventHandler('playerTackled', function()
    SetPedToRagdoll(PlayerPedId(), math.random(8500), math.random(8500), 0, 0, 0, 0)
    
    TimerEnabled = true
    Citizen.Wait(1500)
    TimerEnabled = false
end)


RegisterNetEvent('healed:useOxy')
AddEventHandler('healed:useOxy', function()
    local playerPed = GetPlayerPed(-1)
    if (DoesEntityExist(PlayerPedId()) and not IsEntityDead(PlayerPedId())) then
        TriggerEvent('esx_status:set', 'stress', 0)
        TriggerEvent('mythic_hospital:client:RemoveBleed')
        TriggerEvent('mythic_hospital:client:ResetLimbs')
        TriggerEvent('mythic_hospital:client:RemoveBleed')
        TriggerEvent('mythic_hospital:client:ResetLimbs')
        AddArmourToPed(PlayerPedId(), 25)
        SetRunSprintMultiplierForPlayer(player, 1.1)
        exports['mythic_notify']:SendAlert('inform', "Stress is being relieved")
    end
end)

RegisterNetEvent('ammo:clip')
AddEventHandler('ammo:clip', function()
    ped = GetPlayerPed(-1)
    if IsPedArmed(ped, 4) then
        hash = GetSelectedPedWeapon(ped)
        if hash ~= nil then
            AddAmmoToPed(GetPlayerPed(-1), hash, 50)
            ESX.ShowNotification(_U("clip_use"))
        else
            ESX.ShowNotification(_U("clip_no_weapon"))
        end
    else
        ESX.ShowNotification(_U("clip_not_suitable"))
    end
end)

AnimSet = "default";
RegisterNetEvent("walkstyle:setAnimData")
AddEventHandler("walkstyle:setAnimData", function(animationset)
    AnimSet = animationset
end)
