ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)


AddEventHandler("playerDropped", function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
    if job == 'police' or job == 'ambulance' then
        xPlayer.setJob('off' ..job, grade)
        TriggerEvent("TokoVoip:removePlayerFromAllRadio", _source)
        TriggerEvent("eblips:remove", _source)
    end
end)

RegisterServerEvent('duty:off')
AddEventHandler('duty:off', function(job)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
    if job == 'police' or job == 'ambulance' then
        TriggerClientEvent('rp:playerBecameJob', _source, 'off'..job)
        xPlayer.setJob('off' ..job, grade)
        TriggerClientEvent("notification", _source, "You went 10-42", 2)
        TriggerEvent("TokoVoip:removePlayerFromAllRadio", _source)
        TriggerEvent("eblips:remove", _source)
    end
end)

RegisterServerEvent('duty:on')
AddEventHandler('duty:on', function(job)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
    if job == 'offpolice' then
        TriggerClientEvent('rp:playerBecameJob', _source, 'police')
        xPlayer.setJob('police', grade)
        TriggerClientEvent("Give:ammo", _source)
        TriggerClientEvent("notification", _source, "You Are 10-41 & Re-Stocked", 1)
        TriggerEvent("eblips:add", {name = "Police", src = _source, color = 42})
    elseif job == 'offambulance' then
        xPlayer.setJob('ambulance', grade)
        TriggerClientEvent('rp:playerBecameJob', _source, 'ambulance')
        TriggerClientEvent("Give:ammo", _source)
        TriggerClientEvent("notification", _source, "You Are 10-41 & Re-Stocked", 1)
        TriggerEvent("eblips:add", {name = "EMS", src = _source, color = 1})
    elseif job == 'police' then
        TriggerClientEvent("notification", _source, "You are already 10-41", 2)
    end
end)