ESX = nil
TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
local chicken = vehicleBaseRepairCost

RegisterServerEvent('gen-bennys:attemptPurchase')
AddEventHandler('gen-bennys:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if type == "repair" then
        if xPlayer.getMoney() >= chicken then
            xPlayer.removeMoney(chicken)
            TriggerClientEvent('gen-bennys:purchaseSuccessful', source)
        else
            TriggerClientEvent('gen-bennys:purchaseFailed', source)
        end
    elseif type == "performance" then
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('gen-bennys:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('gen-bennys:purchaseFailed', source)
        end
    else
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('gen-bennys:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('gen-bennys:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('gen-bennys:updateRepairCost')
AddEventHandler('gen-bennys:updateRepairCost', function(cost)
    chicken = cost
end)

RegisterServerEvent('updateVehicle')
AddEventHandler('updateVehicle', function(myCar)
    MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate']   = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)