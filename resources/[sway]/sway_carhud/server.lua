ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

RegisterServerEvent('carfill:pay')
AddEventHandler('carfill:pay', function(cash)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if cash > 0 then
        xPlayer.removeMoney(cash)
        TriggerClientEvent("banking:removeBalance", source, cash)
    end
end)
