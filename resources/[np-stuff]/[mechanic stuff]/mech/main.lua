
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)



local isMechanic = false
-- local isPolice = false
-- local isMedic = false

local degHealth = {
	["breaks"] = 0,-- has neg effect
	["axle"] = 0,	-- has neg effect
	["radiator"] = 0, -- has neg effect
	["clutch"] = 0,	-- has neg effect
	["transmission"] = 0, -- has neg effect
	["electronics"] = 0, -- has neg effect
	["fuel_injector"] = 0, -- has neg effect
	["fuel_tank"] = 0 
}
local engineHealth = 0
local bodyHealth = 0

-- RegisterNetEvent("krp:playerBecameJob")
-- AddEventHandler("krp:playerBecameJob", function(job, name, notify)
--     print(job)
--     if isMedic and job ~= "ambulance" then isMedic = false end
--     if isPolice and job ~= "police" then isPolice = false end
--     if isMechanic and job ~= "mechanic" then isMechanic = false end
--     if job == "police" then isPolice = true end
--     if job == "ambulance" then isMedic = true end
--     if job == "mechanic" then isMechanic = true end
--     myJob = job
-- end)
Citizen.CreateThread(function()
        if ESX.GetPlayerData().job.name == "tuner" then
        isMechanic = true
        print(isMechanic) 
    end
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(930.68, -962.61, 39.49)
	SetBlipSprite (blip, 446)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Mechanic')
	EndTextCommandSetBlipName(blip)
end)
-- #MarkedForMarker
Citizen.CreateThread(function()
      while true do
       Citizen.Wait(5)
       local plyId = PlayerPedId()
       local plyCoords = GetEntityCoords(plyId)
       local dstStorage = #(plyCoords - vector3(950.34387207031,-969.96685791016,39.506797790527))
       local dstRepair = #(plyCoords - vector3(953.39831542969,-947.10028076172,39.499847412109))
       local dstRepair2 = #(plyCoords - vector3(921.14514160156,-966.00964355469,39.499847412109))
    
       if dstStorage < 2.0 and isMechanic then
        --DrawText3Ds( 950.34387207031,-969.96685791016,39.506797790527, '[E] Enter Job Centre' )
        DrawMarker(27,950.34387207031,-969.96685791016,38.506797790527, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0) 
        RegisterCommand('mech', function(source, args)
            TriggerEvent("mech:tools", args)
        end)
       elseif dstRepair < 10.0 and isMechanic then
        --print('im near repairing')
        --DrawText3Ds( 954.1484375,-951.37951660156,39.499843597412, '[E] Exit Job Centre' )
        RegisterCommand('repair', function(source, args)
            repairVeh(args)
        end)
    elseif dstRepair2 < 25.0 and isMechanic then
        --print('im near repairing')
        --DrawText3Ds( 954.1484375,-951.37951660156,39.499843597412, '[E] Exit Job Centre' )
        RegisterCommand('repair', function(source, args)
            repairVeh(args)
        end)
       else
         if dstStorage > 10.0 and dstRepair > 10.0 then
           Citizen.Wait(2000)
         end
       end
     end
end)

RegisterNetEvent("mech:tools")
AddEventHandler("mech:tools", function(args)
    if args[1] == "check" then
        TriggerServerEvent("mech:check:materials")
    elseif args[1] == "add" then
        if exports["dsrp-inventory"]:hasEnoughOfItem(args[2],1,false) then
            TriggerServerEvent("mech:add:materials", args[2],tonumber(args[3]))
        else
            TriggerEvent("notification", "You don't have the materials",2)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        if isMechanic then
        TriggerEvent('chat:addSuggestion', '/mech', 'Use by mechanic!')
        TriggerEvent('chat:addSuggestion', '/mech add', '/mech add [materials] [amount]')
        TriggerEvent('chat:addSuggestion', '/repair', '/repair [parts] [amount]')
        
        end
        TriggerEvent('chat:addSuggestion', '/bill', '/bill [amount] target must be near you.')
        TriggerEvent('chat:addSuggestion', '/packweed', '/packweed [amount] - 10 | 20 | 30 etc')
    end
end)

function repairVeh(args)
    if isMechanic then
        local degname = string.lower(args[1])
        local amount = tonumber(args[2])
        if amount == nil then
            TriggerEvent("notification", "No amount? KEKW", 2)
            return
        end
        playerped = PlayerPedId()
        coordA = GetEntityCoords(playerped, 1)
        coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
        veh = getVehicleInDirection(coordA, coordB)
        local itemname = "Scrap"
        local itemid = 26
        local garagename = "NAME"
        local notfucked = false
        local current = 100

        if degname == "body" or degname == "Body" then
            itemid = 28
            itemname = "Glass"
            degname = "body"
            notfucked = false
            current = bodyHealth
        end

        if degname == "Engine" or degname == "engine" then
            degname = "engine"
            notfucked = false
            current = engineHealth
        end

        if degname == "brakes" or degname == "Brakes" then
            itemid = 33
            itemname = "Rubber"
            degname = "breaks"
            notfucked = true
            current = degHealth["breaks"]
        end

        if degname == "Axle" or degname == "axle" then
            degname = "axle"
            notfucked = true
            current = degHealth["axle"]
        end

        if degname == "Radiator" or degname == "radiator" then
            degname = "radiator"
            notfucked = true
            current = degHealth["radiator"]
        end

        if degname == "Clutch" or degname == "clutch" then
            degname = "clutch"
            notfucked = true
            current = degHealth["clutch"]
        end

        if degname == "electronics" or degname == "Electronics" then
            degname = "electronics"
            itemid = 27
            itemname = "Plastic"
            notfucked = true
            current = degHealth["electronics"]
        end

        if degname == "fuel" or degname == "Fuel" then
            itemid = 30
            itemname = "Steel"
            degname = "fuel_tank"
            notfucked = true
            current = degHealth["fuel_tank"]
        end

        if degname == "transmission" or degname == "Transmission" then
            itemid = 31
            itemname = "Aluminium"
            degname = "transmission"
            notfucked = true
            current = degHealth["transmission"]
        end

        if degname == "Injector" or degname == "injector" then
            itemid = 34
            itemname = "Copper"
            degname = "fuel_injector"
            notfucked = true
            current = degHealth["fuel_injector"]
        end

        if not notfucked then
            TriggerEvent("notification","Only mechanics can repair this or not exist",2)
        else

            
            local playerped = PlayerPedId()
            RequestAnimDict("mp_car_bomb")
            TaskPlayAnim(playerped,"mp_car_bomb","car_bomb_mechanic",8.0, -8, -1, 49, 0, 0, 0, 0)
            Wait(100)
            TaskPlayAnim(playerped,"mp_car_bomb","car_bomb_mechanic",8.0, -8, -1, 49, 0, 0, 0, 0)

                local finished = exports["taskbar"]:taskBar(15000,"Repairing")
                local coordA = GetEntityCoords(playerped, 1)
                local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
                local targetVehicle = getVehicleInDirection(coordA, coordB)

                if finished == 100 then
                    local plate = GetVehicleNumberPlateText(targetVehicle)
                    ---print(degname,string.lower(itemname),amount,current,plate)
                    if targetVehicle ~= nil  and targetVehicle ~= 0 then
                        TriggerServerEvent('scrap:towTake',degname,string.lower(itemname),amount,current,plate)
                    else
                        TriggerEvent("customNotification","No Vehicle")
                    end
                else
                    --print("REPAIR: 12")
                end
        end
    end
end

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 3000 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end