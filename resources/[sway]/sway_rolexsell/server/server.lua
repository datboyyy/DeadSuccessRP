ESX = nil
local lastStarted = 0

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)



	RegisterServerEvent('sway:rolexsat')
	AddEventHandler('sway:rolexsat', function(item)
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)

		local item = xPlayer.getInventoryItem(Config.item)
		local miktar = Config.amount

			TriggerClientEvent("inventory:removeItem","rolexwatch",1)
			xPlayer.addMoney(Config.rolexprice)
		

	end)



