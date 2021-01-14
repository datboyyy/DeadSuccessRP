ESX = nil
TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

RegisterServerEvent('tp-scrap:giveItem')
AddEventHandler('tp-scrap:giveItem', function()
    local source = source
    xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local mth =  1
        local random = 1
        TriggerClientEvent('player:receiveItem', source, 'aluminium', random)
        TriggerClientEvent('player:receiveItem', source, 'copper', mth)
    end
end)

