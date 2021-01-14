ESX = nil
local joblist = {}
local resettime = nil
local policeclosed = false

TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)

RegisterServerEvent('esx_JewelRobbery:closestore')
AddEventHandler('esx_JewelRobbery:closestore', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local ispolice = false
    for i, v in pairs(Config.PoliceJobs) do
        if xPlayer.job.name == v then
            ispolice = true
            break
        end
    end
    if ispolice and resettime ~= nil then
        TriggerClientEvent('esx_JewelRobbery:policeclosure', -1)
        policeclosed = true
    elseif ispolice and resettime == nil then
        TriggerClientEvent('esx:showNotification', _source, 'Store does not appear to be damaged - unable to force closed!')
    else
        TriggerClientEvent('esx:showNotification', _source, 'Only Law enforcment or Vangelico staff can decide if store is closed!')
    end
end)

RegisterServerEvent('esx_JewelRobbery:playsound')
AddEventHandler('esx_JewelRobbery:playsound', function(x, y, z, soundtype)
    TriggerClientEvent('esx_JewelRobbery:playsound', -1, x, y, z, soundtype)
end)

RegisterServerEvent('esx_JewelRobbery:setcase')
AddEventHandler('esx_JewelRobbery:setcase', function(casenumber, switch)
    _source = source
    if not Config.CaseLocations[casenumber].Broken then
        Config.CaseLocations[casenumber].Broken = true
        TriggerEvent('esx_JewelRobbery:RestTimer')
        TriggerClientEvent('esx_JewelRobbery:setcase', -1, casenumber, true)
        if math.random(25) == 20 then
            local myluck = math.random(5)
            
            if myluck == 1 then
                TriggerClientEvent("player:receiveItem", source, "gruppe63", 1)
            elseif myluck == 2 then
                TriggerClientEvent("player:receiveItem", source, "cb", 1)
            end
        end
        
        TriggerClientEvent("player:receiveItem", source, "rolexwatch", math.random(5, 10))
        
        if math.random(5) == 1 then
            TriggerClientEvent("player:receiveItem", source, "goldbar", math.random(1, 10))
        end
        
        if math.random(69) == 69 then
            TriggerClientEvent("player:receiveItem", source, "valuablegoods", math.random(5, 10))
        end
        TriggerClientEvent("player:receiveItem", source, "goldbar", 2)
    end
end)

RegisterServerEvent('esx_JewelRobbery:policenotify')
AddEventHandler('esx_JewelRobbery:policenotify', function()
    TriggerClientEvent('esx_JewelRobbery:policenotify', -1)
end)

RegisterServerEvent('esx_JewelRobbery:loadconfig')
AddEventHandler('esx_JewelRobbery:loadconfig', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local buildlist = {id = _source, job = xPlayer.job.name, }
    table.insert(joblist, buildlist)
    TriggerClientEvent('esx_JewelRobbery:loadconfig', _source, Config.CaseLocations)
    if policeclosed then
        TriggerClientEvent('esx_JewelRobbery:policeclosure', _source)
    end

end)

AddEventHandler('esx_JewelRobbery:RestTimer', function()
    if resettime == nil then
        totaltime = Config.ResetTime * 60
        resettime = os.time() + totaltime
        
        while os.time() < resettime do
            Citizen.Wait(2350)
        end
        
        for i, v in pairs(Config.CaseLocations) do
            v.Broken = false
        end
        TriggerClientEvent('esx_JewelRobbery:resetcases', -1, Config.CaseLocations)
        resettime = nil
        policeclosed = false
    end
end)

AddEventHandler('esx_JewelRobbery:AwardItems', function()
    local _source = source
    if math.random(25) == 20 then
        local myluck = math.random(5)
        
        if myluck == 1 then
            TriggerClientEvent("player:receiveItem", source, "gruppe63", 1)
        elseif myluck == 2 then
            TriggerClientEvent("player:receiveItem", source, "cb", 1)
        end
    end
    
    TriggerClientEvent("player:receiveItem", source, "rolexwatch", math.random(5, 10))
    
    if math.random(5) == 1 then
        TriggerClientEvent("player:receiveItem", source, "goldbar", math.random(1, 10))
    end
    
    if math.random(69) == 69 then
        TriggerClientEvent("player:receiveItem", source, "valuablegoods", math.random(5, 10))
    end
    TriggerClientEvent("player:receiveItem", source, "goldbar", 2)
end)
