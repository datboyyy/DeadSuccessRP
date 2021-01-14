ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)


AddEventHandler("playerDropped", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
    
    if job == 'police' or job == 'ambulance' or job == 'mechanic' then
        xPlayer.setJob('off' .. job, grade)
        TriggerEvent("TokoVoip:removePlayerFromAllRadio", _source)
        TriggerEvent("eblips:remove", _source)
        print("Set job to off for a player")
    end
end)

RegisterServerEvent('duty:on')
AddEventHandler('duty:on', function(job)
        
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local job = xPlayer.job.name
        local grade = xPlayer.job.grade
        
        if job == 'offpolice' then
            xPlayer.setJob('police', grade)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'inform', text = 'You are now on-duty', length = 9000})
            TriggerEvent("eblips:add", {name = "Police", src = _source, color = 42})
        elseif job == 'offambulance' then
            xPlayer.setJob('ambulance', grade)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'inform', text = 'You are now on-duty', length = 9000})
            TriggerEvent("eblips:add", {name = "EMS", src = _source, color = 1})
        elseif job == 'offmechanic' then
            xPlayer.setJob('mechanic', grade)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'inform', text = 'You are now on-duty', length = 9000})
        --TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Tracker status = on', length = 9000})
        --TriggerEvent("eblips:add", {name = "Mechanic", src = _source, color = 5})
        end
end)


RegisterServerEvent('duty:off')
AddEventHandler('duty:off', function(job)
        
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local job = xPlayer.job.name
        local grade = xPlayer.job.grade
        
        if job == 'police' or job == 'ambulance' or job == 'mechanic' then
            xPlayer.setJob('off' .. job, grade)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'inform', text = 'You are now off-duty', length = 9000})
            TriggerEvent("TokoVoip:removePlayerFromAllRadio", _source)
            TriggerEvent("eblips:remove", _source)
        end
end)


--[[AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local player = source
    local name, setKickReason, deferrals = name, setKickReason, deferrals;
    local ipIdentifier
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()
    Wait(0)
    deferrals.update(string.format("Hello %s. Your Client is being checked.", name))
    for _, v in pairs(identifiers) do
        if string.find(v, "ip") then
            ipIdentifier = v:sub(4)
            break
        end
    end
    Wait(0)
    if not ipIdentifier then
        deferrals.done("Error Contact an Admin.")
    else
        PerformHttpRequest("http://ip-api.com/json/" .. ipIdentifier .. "?fields=proxy", function(err, text, headers)
            if tonumber(err) == 200 then
                local tbl = json.decode(text)
                if tbl["proxy"] == false then
                    deferrals.done()
                else
                    deferrals.done("There is an error contact an admin in the discord.")
                end
            else
                deferrals.done("Please try again in a couple minutes.")
            end
        end)
    end
end)]]--



RegisterServerEvent('duty:onoff')
AddEventHandler('duty:onoff', function(job)
        
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local job = xPlayer.job.name
        local grade = xPlayer.job.grade
        
        if job == 'police' or job == 'ambulance' or job == 'mechanic' then
            xPlayer.setJob('off' .. job, grade)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'inform', text = 'You are now off-duty', length = 9000})
            TriggerEvent("TokoVoip:removePlayerFromAllRadio", source)
            TriggerEvent("eblips:remove", source)
        elseif job == 'offpolice' then
            xPlayer.setJob('police', grade)
            TriggerEvent("TokoVoip:addPlayerToRadio", 1, source)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'inform', text = 'You are now on-duty', length = 9000})
            TriggerEvent("eblips:add", {name = "Police", src = source, color = 42})
        elseif job == 'offambulance' then
            xPlayer.setJob('ambulance', grade)
            TriggerEvent("TokoVoip:addPlayerToRadio", 2, _source)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'inform', text = 'You are now on-duty', length = 9000})
            TriggerEvent("eblips:add", {name = "EMS", src = _source, color = 1})
        --TriggerEvent("eblips:add", {name = "Mechanic", src = _source, color = 5})
        end
end)
