ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj)
    ESX = obj
end)


RegisterServerEvent('tacomission:completAVACed')
AddEventHandler('tacomission:completAVACed', function(money)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addMoney(money)
    --add notification for payout
end)

RegisterServerEvent('TacoShop:reputations')
AddEventHandler('TacoShop:reputations', function(money)
    local xPlayer = ESX.GetPlayerFromId(source)
    --get rep from db? and then send it back
    TriggerClientEvent("TacoShop:reputation", source, 10) -- 1-100
end)

local counter = 0
local cookitem = 1

RegisterServerEvent('delivery:status')
AddEventHandler('delivery:status', function(status)
    local xPlayer = ESX.GetPlayerFromId(source)

    counter = counter + status
    cookitem = cookitem + 1

    if cookitem == 15 then
        cookitem = 1
    end

    TriggerClientEvent("delivery:deliverables", -1, counter, cookitem)
end)
local weed12oz = 1250
RegisterServerEvent('weed:checkmoney')
AddEventHandler('weed:checkmoney', function(status)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeMoney(weed12oz)
print("cunt")
end)



RegisterServerEvent("pay:bandmoney")
AddEventHandler('pay:bandmoney', function(payment)
	xPlayer = ESX.GetPlayerFromId(source)
	local bandprice = 5000
	xPlayer.addMoney(bandprice)
end)




RegisterServerEvent("pay:rollcashmoney")
AddEventHandler('pay:rollcashmoney', function(payment)
	xPlayer = ESX.GetPlayerFromId(source)
	local rollcashprice = 300
	xPlayer.addMoney(rollcashprice)
end)
