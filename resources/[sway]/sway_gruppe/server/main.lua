ESX = nil

Trucks = {}

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('gruppe_black_card', function(source)
	TriggerClientEvent("tp:gruppeCard", source)
end)

RegisterServerEvent('tp:gruppeItem')
AddEventHandler('tp:gruppeItem', function(item, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem(item, amount)  
    TriggerClientEvent('esx:showNotification', source, 'You found an interesting item in the van!')
end)

RegisterServerEvent('tp:gruppe:addPlate')
AddEventHandler('tp:gruppe:addPlate', function(truckPlate)
	table.insert(Trucks, tostring(truckPlate))
end)

ESX.RegisterServerCallback('tp:gruppe:checkPlate', function(source, cb, plate)
	if #Trucks ~= 0 then
		for k, v in pairs(Trucks) do
			if v == plate then
				cb(false) -- truck already robbed before
				break
			end
		end
	end
	cb(true)
end)

RegisterServerEvent('tp_gruppe:SendPlayerToPd')
AddEventHandler('tp_gruppe:SendPlayerToPd', function(x, y, z) 
    TriggerClientEvent('tp_gruppe:informPD', -1, x, y, z)
end)

RegisterServerEvent("tp:removeIDcard")
AddEventHandler("tp:removeIDcard", function() 
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem("gruppe_black_card", 1) 
end)

RegisterServerEvent('tp_gruppe:giveDirtyCash')
AddEventHandler('tp_gruppe:giveDirtyCash', function(amount)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local amount = amount
    xPlayer.addMoney( amount)
	TriggerClientEvent('esx:showNotification', source, 'You\'re taking $'..amount..' from the van')
end)