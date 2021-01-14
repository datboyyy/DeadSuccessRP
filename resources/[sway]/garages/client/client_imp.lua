-- Register a network event 

local distanceToCheck = 5.0


function deleteVeh(ent)

	SetVehicleHasBeenOwnedByPlayer(ent, true)
	NetworkRequestControlOfEntity(ent)
	local finished = exports["sway_taskbar"]:taskBar(2500,"Impounding",false,true)	
	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(ent))
	DeleteEntity(ent)
	DeleteVehicle(ent)
	SetEntityAsNoLongerNeeded(ent)
end

RegisterNetEvent('impoundVehicle')
AddEventHandler('impoundVehicle', function()

	playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)

	licensePlate = GetVehicleNumberPlateText(targetVehicle)
	print(DecorExistOn(targetVehicle, "CurrentFuel"))
	TriggerEvent('persistent-vehicles/forget-vehicle', targetVehicle)
	TriggerServerEvent("garages-imp:ImpoundCar", licensePlate)
	deleteVeh(targetVehicle)
end)





RegisterNetEvent('impoundVehicle2')
AddEventHandler('impoundVehicle2', function()

	playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)

	licensePlate = GetVehicleNumberPlateText(targetVehicle)
	print(DecorExistOn(targetVehicle, "CurrentFuel"))

	TriggerServerEvent("garages-imp:ImpoundCar", licensePlate)
	deleteVeh(targetVehicle)
end)





















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