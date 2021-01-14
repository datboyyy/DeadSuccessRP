ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

RegisterNetEvent("np-weapons:updateAmmo")
AddEventHandler("np-weapons:updateAmmo",function(ammoTable)
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	local steam = xPlayer.identifier
	MySQL.Async.execute('UPDATE user_inventory_ammo SET ammo = @ammo WHERE steam = @steam', {
        ['@steam'] = steam,
        ['@ammo'] = ammoTable
    }, function(results)
        if results == 0 then
            MySQL.Async.execute('INSERT INTO user_inventory_ammo (steam, ammo) VALUES (@steam, @ammo)', {
                ['@steam'] = steam,
                ['@ammo'] = ammoTable
			})
		end
	end)
end)



RegisterNetEvent("np-weapons:set")
AddEventHandler("np-weapons:set",function()
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	local steam = GetPlayerIdentifier(source)
	MySQL.Async.fetchAll('SELECT * FROM `user_inventory_ammo` WHERE `steam` = @steam', {
		['@steam'] = steam
	}, function(result)
		if result[1] then
			ammoTable = result[1].ammo
			TriggerClientEvent('np-items:SetAmmo', source, json.decode(result[1].ammo))
		end
	end)
end)

