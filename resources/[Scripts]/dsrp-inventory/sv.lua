ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function (source)
	--GetLicenses(source)
	TriggerEvent("playerSpawned")
end)

RegisterServerEvent('cash:remove')
AddEventHandler('cash:remove', function(source, cash)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer.getMoney() >= cash then
	xPlayer.removeMoney(cash)
    TriggerClientEvent("banking:removeBalance", source, cash)
    cash = xPlayer.getMoney()
    TriggerClientEvent('banking:updateCash', source, cash)
	end
end)

RegisterServerEvent('people-search')
AddEventHandler('people-search', function(target)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(target)
    local identifiersforcid = xPlayer.identifier
    if xPlayer.job.name == 'police' or 'sway' then
        TriggerClientEvent("server-inventory-open", source, "1", 'ply-'..cidcock(identifiersforcid))
	else
		TriggerEvent('DiscordBot:ToDiscord', 'cheat', 'Cheaters', '@here ``` '.. GetPlayerName(source) .. ' | IP: ' ..GetPlayerEndpoint(source) .. ' | steam: ' .. GetPlayerIdentifier(source) .. ' has been flagged for cheating Method: [ people-search ] ' .. '```', 'IMAGE_URL', true)
	end
end)

function cidcock(identifier)
    local cid = 999999
    local finished = nil
    MySQL.Async.fetchAll('SELECT id FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function (result)
        isTaken = result[1] ~= nil
        if result ~= nil and #result > 0 then
            for k,v in pairs(result[1]) do
                if k == 'id' then
                    cid = v
                    break
                end
            end
        end
        finished = true
    end)
    while finished == nil do
        Wait(0)
    end
    return cid
end


RegisterServerEvent("aqua-getcash")
AddEventHandler("aqua-getcash", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local cash = xPlayer.getMoney()
    TriggerClientEvent("aqua-setcash", source, cash)
end)


RegisterServerEvent('Stealtheybread')
AddEventHandler('Stealtheybread', function(target)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local zPlayer = ESX.GetPlayerFromId(target)

    TriggerClientEvent("banking:addBalance", src, zPlayer.getMoney())
    TriggerClientEvent("banking:removeBalance", target, zPlayer.getMoney())
    xPlayer.addMoney(zPlayer.getMoney())
    zPlayer.setMoney(0)
    TriggerClientEvent('notification', target, 'Your cash was robbed off you.', 1)
end)



RegisterServerEvent('police:SeizeCash')
AddEventHandler('police:SeizeCash', function(target)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local zPlayer = ESX.GetPlayerFromId(target)
    TriggerClientEvent("banking:addBalance", src, zPlayer.getMoney())
    TriggerClientEvent("banking:removeBalance", target, zPlayer.getMoney())
    zPlayer.setMoney(0)
    TriggerClientEvent('notification', target, 'Your cash was seized',1)
    TriggerClientEvent('notification', src, 'Seized persons cash', 1)

end)

RegisterServerEvent('cash-checksv')
AddEventHandler('cash-checksv', function(target)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local zPlayer = ESX.GetPlayerFromId(target)
    local money = zPlayer.getMoney()
    local money2 = zPlayer.getAccount('bank').money
    print('ran?')
    TriggerClientEvent('chat:svtocl', source, 'Bank:', 3, money2)
    TriggerClientEvent('chat:svtocl', source, 'Cash:', 3, money)

    TriggerClientEvent("notification", target, "Your Balances were checked")
end)


RegisterServerEvent("grpLockers:sendCaseFileID")
AddEventHandler("grpLockers:sendCaseFileID", function(id)
local src = source
TriggerClientEvent("evLockers:openCaseFile", src, id)
end)



RegisterServerEvent("police:showID")
AddEventHandler("police:showID", function(pid,data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local info = json.decode(data)
    local info = {
        status = 1,
        Name = info.Name,
        Surname = info.Surname,
        DOB = info.DOB,
        sex = info.Sex,
        identifier = 'ply-'..info.identifier
    }
    TriggerClientEvent('chat:showCID', src, info)
    TriggerClientEvent('chat:showCID', pid, info)
end)


RegisterServerEvent("police:showFBIID")
AddEventHandler("police:showFBIID", function(pid,data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local info = json.decode(data)
    local info = {
        status = 1,
        Name = info.Name,
        Surname = info.Surname,
        DOB = info.DOB,
        sex = info.Sex,
        identifier = 'ply-'..info.identifier
    }
    TriggerClientEvent('chat:showFBI', src, info)
    TriggerClientEvent('chat:showFBI', pid, info)
end)