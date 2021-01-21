ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)

--base
RegisterServerEvent('gopostal:cash')
AddEventHandler('gopostal:cash', function(onJob)
        
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer.job.name == 'gopostal' and onJob == true then
            xPlayer.addMoney(250)
            cash = xPlayer.getMoney()
            TriggerClientEvent("banking:addBalance", source, 250)
            TriggerClientEvent('banking:updateCash', source, cash)
            
            TriggerEvent('notifaction', 'Received paycheck', 1)
		else
            TriggerEvent('banCheater', _source, "Tried Spawning in Money")
        end
end)
