ESX = nil

if Config.UseESX then
	TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local xPlayer = ESX.GetPlayerFromId(source)
		local amount = ESX.Math.Round(price)

		if price > 0 and xPlayer.getMoney() >= amount then
			xPlayer.removeMoney(amount)
		end
	end)

	RegisterServerEvent('fuel:jerrycan')
	AddEventHandler('fuel:jerrycan', function()
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer then
			xPlayer.addInventoryItem('WEAPON_PETROLCAN', 1)
		end
	end)
end