ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
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

RegisterNetEvent('trp-doors:setInitialState')
AddEventHandler('trp-doors:setInitialState', function(pDoors)
    doors = pDoors
    for id, door in ipairs(doors) do
        if door and (door.active == nil or door.active) and not IsDoorRegisteredWithSystem(id) then
            AddDoorToSystem(id, door.objName, door.objCoords, false, false, false)
            DoorSystemSetDoorState(id, door.locked, false, true)
        end
    end
end)

RegisterNetEvent('SetState')
AddEventHandler('SetState', function(closestDoorId, doors)
	DoorSystemSetDoorState(closestDoorId, doors)
end)


CreateThread(function()
    TriggerServerEvent("trp-doors:fetchInitialState")
end)


--[[RegisterCommand('door:unlock', function(src, args, raw)
doors[1].locked = not doors[1].locked
exports['mythic_notify']:SendAlert('inform', ("Door is %s"):format(not doors[1].locked and "unlocked" or 'locked'))
DoorSystemSetDoorState(1, doors[1].locked, false, true)
end, false)]]--


RegisterCommand('toggledoorstate', function(src, args, raw)
    local closestDoorDistance, closestDoorId = 9999.9, -1
    local currentPos = GetEntityCoords(PlayerPedId())
    for id, handle in pairs(doors) do
        local currentDoorDistance = #(doors[id].objCoords - currentPos)
		if handle and currentDoorDistance < closestDoorDistance then
            closestDoorDistance = currentDoorDistance
            closestDoorId = id
        end
    end
	if closestDoorId ~= -1 then
        local authjob = doors[closestDoorId].authorizedJobs
		if doors[closestDoorId].distance > closestDoorDistance and PlayerData.job.name == authjob then
            doors[closestDoorId].locked = not doors[closestDoorId].locked
			DoorSystemSetDoorState(closestDoorId, doors[closestDoorId].locked, false, true)
			TriggerServerEvent('trp-doors:fetchState', closestDoorId, doors[closestDoorId].locked)
            openDoorAnim()
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'keydoors', 0.8)
			if DoorSystemGetDoorState(closestDoorId) == 1 then
			exports['mythic_notify']:SendAlert('inform', 'Door is locked.')
			else
			exports['mythic_notify']:SendAlert('inform', 'Door is unlocked.')
			end
			else
				if doors[closestDoorId].distance > closestDoorDistance then
				exports['mythic_notify']:SendAlert('error', 'You cannot open this door.')
				end
			end
		end
end, false)



function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function openDoorAnim()
    loadAnimDict("anim@heists@keycard@")
    TaskPlayAnim(GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0)
    SetTimeout(400, function()
        ClearPedTasks(GetPlayerPed(-1))
    end)
end



local Doorlock = false
local garage = false

RegisterCommand("doorlock", function(source, args, rawCommand)
    if Doorlock then
        Doorlock = false
        print("Doorlock OFF!")
    else
        -- Error
        if args[1] == nil then
            print("Missing Info!")
            return
        elseif args[2] == nil then
            print("Missing Info!")
            return
        end
        
        -- All ok
        name = args[1]
        job = args[2]
        distance = args[3]
        garage = args[4]
        print("Doorlock On!")
        Doorlock = true
        
        StartMainDoorlockLoop()
    end
end)

-- Inserted in a function to optimize the cpu time
function StartMainDoorlockLoop()
    Citizen.CreateThread(function()
        while true do
            if Doorlock then
                local IsFound, Object = GetEntityPlayerIsFreeAimingAt(PlayerId())
                if IsFound then
                    Doorlock = false -- Prevent Multiple Creation
                    local _, __, yaw = table.unpack(GetEntityRotation(Object))
                    
                    TriggerServerEvent("esx_doorlock:SaveOnConfig", name, GetEntityCoords(Object), GetEntityModel(Object), job, Object, distance, garage)
                    break
                end
            end
            Citizen.Wait(500)
        end
    end)
end

-- Chat suggestion
Citizen.CreateThread(function()
    TriggerEvent("chat:addSuggestion", "/doorlock", "Create a doorlock", {
        {name = "name", help = "Door Name"},
        {name = "job", help = "the job you want to be able to open the door"},
        {name = "distance", help = "the distance you want to be able to open the door"},
        {name = "garage", help = "if the \"door\" is a garage turn this on, else ignore that, simply prevent garage that is flying when closed"}
    })
end)
