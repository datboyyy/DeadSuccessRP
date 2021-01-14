ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

TriggerEvent('es:addCommand', 'impound', function(source, args, user)
	local usource = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'mechanic' then
		TriggerClientEvent('impoundVehicle', source)
		CancelEvent()
	end
end)

RegisterServerEvent('garages-imp:ImpoundCar')
AddEventHandler('garages-imp:ImpoundCar', function(plate)
	local user = ESX.GetPlayerFromId(source)
    local characterId = user.identifier
	garage = 'Impound Lot'
	state = 'Normal Impound'
	MySQL.Async.execute("UPDATE owned_vehicles SET garage = @garage, state = @state WHERE plate = @plate", {['garage'] = garage, ['state'] = state, ['plate'] = plate})
end)