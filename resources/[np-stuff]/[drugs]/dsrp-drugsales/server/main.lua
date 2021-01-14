ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

RegisterServerEvent('sellDrugs')
AddEventHandler('sellDrugs', function(blackMoney)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)	
	xPlayer.addMoney(blackMoney)
	TriggerClientEvent('sold', _source)
	TriggerClientEvent('esx:showNotification', _source, 'You have sold some drugs for $' .. blackMoney)
end)


