ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)

RegisterServerEvent('Admins:add')
AddEventHandler('Admins:add', function(type, amount, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.getGroup() == 'superadmin' then
        if type == 'item' then
            xPlayer.addInventoryItem(name, amount)
        end
    end
end)


RegisterServerEvent("np-admin:bringPlayerServer")
AddEventHandler("np-admin:bringPlayerServer", function(pos, target)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.getGroup() == 'superadmin' then
        TriggerClientEvent('np-admin:bringPlayer', target, pos)
    end
end)

RegisterServerEvent("np-admin:kickplayer")
AddEventHandler("np-admin:kickplayer", function(id, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    print(id, reason)
    if xPlayer.getGroup() == 'superadmin' then
        DropPlayer(id, reason)
    
    end
end)

RegisterServerEvent("np-admin:reviveplayer")
AddEventHandler("np-admin:reviveplayer", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'superadmin' then
        TriggerClientEvent('esx_status:set', 'stress', 0,target)
        TriggerClientEvent('mythic_hospital:client:RemoveBleed',target)
        TriggerClientEvent('mythic_hospital:client:ResetLimbs',target)
        TriggerClientEvent('tp_ambulancejob:revive', target)
    end
end)

RegisterServerEvent("np-admin:reviveplayerd")
AddEventHandler("np-admin:reviveplayerd", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'superadmin' then
        TriggerClientEvent('esx_status:set', 'stress', 0, -1)
        TriggerClientEvent('mythic_hospital:client:RemoveBleed',-1)
        TriggerClientEvent('mythic_hospital:client:ResetLimbs',-1)
        TriggerClientEvent('tp_ambulancejob:revive', -1)
    end
end)

RegisterServerEvent("np-admin:unbanPlayer")
AddEventHandler("np-admin:unbanPlayer", function(steamHex)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'superadmin' then
        TriggerEvent('np-admin:flickbean', steamHex, 'SUCKONMYBALLHAIRSFAGGOT')


    end
end)

RegisterServerEvent("np-admin:banplayer")
AddEventHandler("np-admin:banplayer", function(target, time, reason)
    local xPlayer = ESX.GetPlayerFromId(source)


    print(target, reason, time, GetPlayerName(target))

    if not time or not type(time) == "string" then return end

    if time == "0" then
        return 0
    end

    local times = {
        ["m"] = {text = "Minute(s)", time = 0},
        ["h"] = {text = "Hour(s)", time = 0},
        ["d"] = {text = "Day(s)", time = 0},
        ["w"] = {text = "Week(s)", time = 0},
        ["M"] = {text = "Month(s)", time = 0},
        ["y"] = {text = "Year(s)", time = 0}
    }

    local temp = {}
    local timeSum = 0

    for i = 1, #time do
        local l = time:sub(i, i)
        if not tonumber(l) then
            if not times[l] then return false, false, false end
        end
    end

    local l = string.match(time, "%a+")
    if not l then return false, false, false end

    for k,v in pairs(times) do
        local s = string.match(time, "[%d+]?" .. k)

        if s then
            local t = tonumber(string.match(s, "%d+"))

            if not t or t < 0 then return false, false, false end

            times[k].time = t

            if k == "m" then
                timeSum = timeSum + (t * 60)
            elseif k == "h" then
                timeSum = timeSum + (t * 3600)
            elseif k == "d" then
                timeSum = timeSum + (t * 86400)
            elseif k == "w" then
                timeSum = timeSum + (t * 604800)
            elseif k == "M" then
                timeSum = timeSum + (t * 2629746)
            elseif k == "y" then
                timeSum = timeSum + (t * 31556952)
            end
        end
    end

    if IsDuplicityVersion() then
        local curTime = os.time()
        addedTime = timeSum + curTime
    else
        addedTime = false
    end

    local temp = {}

    for k,v in pairs(times) do
        if v.time > 0 then
            temp[k] = v
        end
    end

    print(temp, timeSum, addedTime)

   local newtime = timeSum


    if xPlayer.getGroup() == 'superadmin' then
        print('woulda banned')
        TriggerEvent("EasyAdmin:banPlayer", target, reason, newtime, GetPlayerName(target))
    
    end
end)


RegisterCommand("menu", function(source, args, raw)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'superadmin' then
        TriggerClientEvent('np-admin:openMenu', source)
    end
end)

ESX.RegisterServerCallback('np-admin:checkperms', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getGroup() == 'superadmin')
end)
