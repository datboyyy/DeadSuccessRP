ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_outlawalert:carJackInProgress')
AddEventHandler('esx_outlawalert:carJackInProgress', function(targetCoords, streetName, vehicleLabel, playerGender)
    mytype = 'police'
    data = {["code"] = '10-16', ["name"] = 'Car Jacking  '   ..vehicleLabel..  '.', ["loc"] = streetName}
    length = 3500
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
    TriggerClientEvent('esx_outlawalert:robberyinprogress', -1, targetCoords)
    TriggerClientEvent('esx_outlawalert:carJackInProgress', -1, targetCoords)
end, false)

RegisterServerEvent('esx_outlawalert:robberyinprogress')
AddEventHandler('esx_outlawalert:robberyinprogress', function(targetCoords, streetName, playerGender)
	mytype = 'error'
    data = {["code"] = '10-68', ["name"] = 'Robbery in Progress', ["loc"] = streetName}
    length = 5500
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
    TriggerClientEvent('esx_outlawalert:robberyinprogress', -1, targetCoords)
end, false)

RegisterServerEvent('esx_outlawalert:gunshotInProgress')
AddEventHandler('esx_outlawalert:gunshotInProgress', function(targetCoords, streetName, playerGender)
	mytype = 'gunshots'
    data = {["code"] = '10-11', ["name"] = 'Shooting in Progress', ["loc"] = streetName}
    length = 3500
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
    TriggerClientEvent('esx_outlawalert:gunshotInProgress', -1, targetCoords)
end, false)

RegisterServerEvent('esx_outlawalert:ems')
AddEventHandler('esx_outlawalert:ems', function(targetCoords, streetName, playerGender)
	mytype = 'ems'
    data = {["code"] = '10-53', ["name"] = 'Civilian Down', ["loc"] = streetName}
    length = 5500
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
    TriggerClientEvent('esx_outlawalert:ems', -1, targetCoords)
end, false)

ESX.RegisterServerCallback('esx_outlawalert:isVehicleOwner', function(source, cb, plate)
	local identifier = GetPlayerIdentifier(source, 0)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = identifier,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			cb(result[1].owner == identifier)
		else
			cb(false)
		end
	end)
end)



RegisterServerEvent('esx_outlawalert:officerdown')
AddEventHandler('esx_outlawalert:officerdown', function(targetCoords, streetName, playerGender)
	mytype = 'officer-dow'
    data = {["code"] = '10-13', ["name"] = 'Officer Down', ["loc"] = streetName}
    length = 5500
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
    TriggerClientEvent('esx_outlawalert:officerdown', -1, targetCoords)
end, false)



RegisterServerEvent('esx_outlawalert:emspanic')
AddEventHandler('esx_outlawalert:emspanic', function(targetCoords, streetName, playerGender)
	mytype = 'ems-down'
    data = {["code"] = '10-14', ["name"] = 'EMS Medic Down', ["loc"] = streetName}
    length = 5500
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
    TriggerClientEvent('esx_outlawalert:emspanicdown', -1, targetCoords)
end, false)

RegisterServerEvent('esx_outlawalert:officerpanic')
AddEventHandler('esx_outlawalert:officerpanic', function(targetCoords, streetName, playerGender)
	mytype = 'officer-down'
    data = {["code"] = '11-99', ["name"] = 'Officer Down', ["loc"] = streetName}
    length = 5500
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
    TriggerClientEvent('esx_outlawalert:officerpanicdown', -1, targetCoords)
end, false)