ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)

--base
RegisterServerEvent('gopostal:cash')
AddEventHandler('gopostal:cash', function(currentJobPay)
        
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer.job.name == 'gopostal' then
            xPlayer.addMoney(currentJobPay)
            
            TriggerEvent('notifaction', 'Received paycheck', 1)
		else
            TriggerEvent('banCheater', _source, "Tried Spawning in Money")
        end
end)
