ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)

RegisterServerEvent('setjob:jobcenter')
AddEventHandler('setjob:jobcenter', function(job)
        
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if job == 'garbage' or 'gopostal' or 'unemployed' then
            xPlayer.setJob(job, 0)
        else
            TriggerEvent('banCheater', source, 'Tried Setting Job Illegally')
        end
end)