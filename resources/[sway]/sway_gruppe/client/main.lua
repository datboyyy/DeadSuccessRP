
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
    PlayerData = ESX.GetPlayerData()
    xPlayer = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    xPlayer = xPlayer
end)


local attempted = 0

RegisterNetEvent("tp:gruppeCard") 
AddEventHandler("tp:gruppeCard", function()
    local coordA = GetEntityCoords(PlayerPedId(), 1)
    local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 100.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)
    if targetVehicle ~= 0 and GetHashKey("stockade") == GetEntityModel(targetVehicle) then
        local entityCreatePoint = GetOffsetFromEntityInWorldCoords(targetVehicle, 0.0, -4.0, 0.0)
        local coords = GetEntityCoords(PlayerPedId())
        local aDist = GetDistanceBetweenCoords(coords["x"], coords["y"],coords["z"], entityCreatePoint["x"], entityCreatePoint["y"],entityCreatePoint["z"])
        if aDist < 2.0 then
            TriggerEvent("sec:AttemptHeist", targetVehicle) 
        else
            exports['mythic_notify']:SendAlert('inform', "You need to do this from behind the vehicle.")
        end
    end
end)

RegisterNetEvent('sec:AttemptHeist')
AddEventHandler('sec:AttemptHeist', function(veh)
    attempted = veh
    SetEntityAsMissionEntity(attempted,true,true)
    local plate = GetVehicleNumberPlateText(veh)
    ESX.TriggerServerCallback('tp:gruppe:checkPlate', function(canRob)
        if canRob then
        TriggerEvent('snowball') 
        local finished = exports["sway_taskbar"]:taskBar(30000, "Unlocking Van")
                    AlertBankTruck()
                    TriggerServerEvent('tp:gruppe:addPlate', plate)
                    TriggerEvent("sec:AllowHeist", veh)
                    TriggerServerEvent("tp:removeIDcard")
                    TriggerEvent("robbery:scanLock",false,itemid)   
                    if finished == 100 then
                end
            end


    end, plate)
end)

RegisterNetEvent('sec:AllowHeist')
AddEventHandler('sec:AllowHeist', function(veh)
    TriggerEvent("sec:AddPeds",attempted)
    SetVehicleDoorOpen(attempted, 2, 0, 0)
    SetVehicleDoorOpen(attempted, 3, 0, 0)
    TriggerEvent("sec:PickupCash")

end)

RegisterNetEvent('sec:AddPeds')
AddEventHandler('sec:AddPeds', function(veh)
    local cType = 's_m_m_highsec_01'

    local pedmodel = GetHashKey(cType)
    RequestModel(pedmodel)
    while not HasModelLoaded(pedmodel) do
        RequestModel(pedmodel)
        Citizen.Wait(100)
    end

   ped2 = CreatePedInsideVehicle(veh, 4, pedmodel, 0, 1, 0.0)
   ped3 = CreatePedInsideVehicle(veh, 4, pedmodel, 1, 1, 0.0)
   ped4 = CreatePedInsideVehicle(veh, 4, pedmodel, 2, 1, 0.0)

   GiveWeaponToPed(ped2, GetHashKey('WEAPON_SpecialCarbine'), 420, 0, 1)
   GiveWeaponToPed(ped3, GetHashKey('WEAPON_SpecialCarbine'), 420, 0, 1)
   GiveWeaponToPed(ped4, GetHashKey('WEAPON_SpecialCarbine'), 420, 0, 1)

   SetPedMaxHealth(ped2, 350)
   SetPedMaxHealth(ped3, 350)
   SetPedMaxHealth(ped4, 350)

   SetPedDropsWeaponsWhenDead(ped2,false)
   SetPedRelationshipGroupDefaultHash(ped2,GetHashKey('COP'))
   SetPedRelationshipGroupHash(ped2,GetHashKey('COP'))
   SetPedAsCop(ped2,true)
   SetCanAttackFriendly(ped2,false,true)

   SetPedDropsWeaponsWhenDead(ped3,false)
   SetPedRelationshipGroupDefaultHash(ped3,GetHashKey('COP'))
   SetPedRelationshipGroupHash(ped3,GetHashKey('COP'))
   SetPedAsCop(ped3,true)
   SetCanAttackFriendly(ped3,false,true)
   

   SetPedDropsWeaponsWhenDead(ped4,false)
   SetPedRelationshipGroupDefaultHash(ped4,GetHashKey('COP'))
   SetPedRelationshipGroupHash(ped4,GetHashKey('COP'))
   SetPedAsCop(ped4,true)
   SetCanAttackFriendly(ped4,false,true)

   TaskCombatPed(ped2, PlayerPedId(), 0, 16)
   TaskCombatPed(ped3, PlayerPedId(), 0, 16)
   TaskCombatPed(ped4, PlayerPedId(), 0, 16)
end)




local pickup = false
RegisterNetEvent('sec:PickupCash')
AddEventHandler('sec:PickupCash', function()
    pickup = true
    TriggerEvent("sec:PickupCashLoop")
    Wait(180000)
    pickup = false
end)

RegisterNetEvent('sec:PickupCashLoop')
AddEventHandler('sec:PickupCashLoop', function()
    local markerlocation = GetOffsetFromEntityInWorldCoords(attempted, 0.0, -3.7, 0.1)
    SetVehicleHandbrake(attempted,true)
    while pickup do
        Citizen.Wait(1)
        local coords = GetEntityCoords(PlayerPedId())
        local aDist = GetDistanceBetweenCoords(coords["x"], coords["y"],coords["z"], markerlocation["x"],markerlocation["y"],markerlocation["z"])
       
            if aDist < 2.0 then
                if IsDisabledControlJustReleased(0, 38) then
                    pickUpCash()
                end
                DrawText3Ds(markerlocation["x"],markerlocation["y"],markerlocation["z"], "Press [E] to pick up cash.")
            else
                DrawText3Ds(markerlocation["x"],markerlocation["y"],markerlocation["z"], "Get Closer to pick up the cash.")
            end
        end

end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

local gotem = false

local pickingup = false
function pickUpCash()

    if not pickingup then
        local coords = GetEntityCoords(PlayerPedId())
       -- Citizen.Trace("Doing Animation")
        pickingup = true

        while pickingup do

            local coords2 = GetEntityCoords(PlayerPedId())
            local aDist = GetDistanceBetweenCoords(coords["x"], coords["y"],coords["z"], coords2["x"],coords2["y"],coords2["z"])
            if aDist > 1.0 or not pickup then
                pickingup = false
            end
           
            local chance = math.random(1,100)

            if chance > 96 then
               -- DropItemPedBankCard()
            end

            if math.random(200) > 195 and gotem == false then
                gotem = true    
                TriggerEvent('snowball')  
                local ped = PlayerPedId()
                SetCurrentPedWeapon(ped, 'WEAPON_UNARMED', 1)
                exports["sway_taskbar"]:taskBar(25000,'Searching Truck ')
                TriggerEvent("player:receiveItem", "goldbar", math.random(1,5))
               -- TriggerEvent("player:receiveItem", "markedbills", math.random(10,20) )
                TriggerEvent("player:receiveItem", "band", math.random(16,30) )
                ClearPedTasks(PlayerPedId())
                pickingup = false
                pickup = false
            end
        end
    end
end

local function uuid()
    math.randomseed(GetCloudTimeAsInt())
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end
function GetStreetAndZone()
    local plyPos = GetEntityCoords(PlayerPedId(),  true)
    local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    zone = tostring(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
    local playerStreetsLocation = GetLabelText(zone)
    local street = street1 .. ", " .. playerStreetsLocation
    return street
end

function AlertBankTruck()
    local street1 = GetStreetAndZone()
    local esxder = IsPedMale(PlayerPedId())
    local plyPos = GetEntityCoords(PlayerPedId())
    local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local dispatchCode = "10-90"
    local eventId = uuid()
    TriggerServerEvent('dispatch:svNotify', {
      dispatchCode = dispatchCode,
      firstStreet = street1,
      esxder = esxder,
      eventId = eventId,
      isImportant = true,
      priority = 1,
      dispatchMessage = "Bank Truck",
      origin = {
        x = plyPos.x,
        y = plyPos.y,
        z = plyPos.z
      }
    })
    
    TriggerServerEvent('esx-alertsSV:banktruck', plyPos)
    Wait(math.random(5000,15000))
  
    if math.random(1,10) > 3 and IsPedInAnyVehicle(PlayerPedId()) and not isInVehicle then
      plyPos = GetEntityCoords(PlayerPedId())
      vehicleData = GetVehicleDescription() or {}
      TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = 'CarFleeing',
        relatedCode = dispatchCode,
        firstStreet = street1,
        esxder = esxder,
        model = vehicleData.model,
        plate = vehicleData.plate,
        firstColor = vehicleData.firstColor,
        secondColor = vehicleData.secondColor,
        heading = vehicleData.heading,
        eventId = eventId,
        isImportant = true,
        priority = 1,
        origin = {
          x = plyPos.x,
          y = plyPos.y,
          z = plyPos.z
        }
      })
      TriggerServerEvent('esx-alertsSV:banktruck', plyPos)
    end
  end


RegisterNetEvent('snowball')
AddEventHandler('snowball', function()
    ClearPedSecondaryTask(PlayerPedId())
    loadAnimDict( "mini@repair" ) 
    FreezeEntityPosition(PlayerPedId(),true) 
    TaskPlayAnim( PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(25000)
    FreezeEntityPosition(PlayerPedId(),false) 
    ClearPedTasks(PlayerPedId())

end)
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end


function DropItemPedBankCard()

    local pos = GetEntityCoords(PlayerPedId())
    local myluck = math.random(20) 

    if myluck == 1 then
        TriggerServerEvent("tp:gruppeItem", "gruppe_black_card", 1)--gruppe
    elseif myluck == 2 then
        TriggerServerEvent("tp:gruppeItem", "pacificidcard", 1) 
     elseif myluck == 3 then
        TriggerServerEvent("tp:gruppeItem", "bankidcard", 1)
    end
    
end

function FindEndPointCar(x,y)   
	local randomPool = 50.0
	while true do

		if (randomPool > 2900) then
			return
		end
	    local vehSpawnResult = {}
	    vehSpawnResult["x"] = 0.0
	    vehSpawnResult["y"] = 0.0
	    vehSpawnResult["z"] = 30.0
	    vehSpawnResult["x"] = x + math.random(randomPool - (randomPool * 2),randomPool) + 1.0  
	    vehSpawnResult["y"] = y + math.random(randomPool - (randomPool * 2),randomPool) + 1.0  
	    roadtest, vehSpawnResult, outHeading = GetClosestVehicleNode(vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"],  0, 55.0, 55.0)

        Citizen.Wait(1000)        
        if vehSpawnResult["z"] ~= 0.0 then
            local caisseo = GetClosestVehicle(vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], 20.000, 0, 70)
            if not DoesEntityExist(caisseo) then

                return vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], outHeading
            end
            
        end

        randomPool = randomPool + 50.0
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
    
    if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

RegisterNetEvent('tp_gruppe:informPD')
AddEventHandler('tp_gruppe:informPD', function(x, y, z)	
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		exports['mythic_notify']:SendAlert('error', 'Someone is attempting to take cash from a Gruppe van, All units please respond IMMEDIATELY! Do not ignore!', 30000)
        
        PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
        Citizen.Wait(250)
        PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
        Citizen.Wait(250)
        PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)

        local alpha = 250
		local alpha2 = 180
		local blip = AddBlipForCoord(x, y, z)
		local blip2 = AddBlipForCoord(x, y, z)
		SetBlipHighDetail(blip2, true)
		SetBlipColour(blip2, 1)
		SetBlipAlpha(blip2, alpha2)
		SetBlipAsShortRange(blip2, true)		
        SetBlipSprite(blip, 67)
		SetBlipHighDetail(blip, true)
		SetBlipColour(blip, 4)
		SetBlipAlpha(blip, alpha)
		SetBlipFlashes(blip, true)
		SetBlipRoute(blip, true)
		SetBlipRouteColour(blip, 1)
		SetBlipShowCone(blip, true)
		SetBlipDisplay(blip, 10)
		SetBlipBright(blip, true)
		BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Gruppe 6 ROBBERY')
        EndTextCommandSetBlipName(blip)
        Citizen.Wait(90000)
        RemoveBlip(blip)
        RemoveBlip(blip2)
	end
end)

function AlertPD()
    local plyPos = GetEntityCoords(PlayerPedId(),true)
	TriggerEvent('alert:noPedCheck', "banktruck")
	Citizen.Wait(500)
end

