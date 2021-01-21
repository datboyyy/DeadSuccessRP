ESX = nil
TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)


RegisterNetEvent('removedgoods')
AddEventHandler('removedgoods', function(itemcount, hasEnoughOfItem)
    print(itemcount, hasEnoughOfItem)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local cashamount = 250 * itemcount
    if hasEnoughOfItem == true then
        cash = xPlayer.getMoney()
        TriggerClientEvent("banking:addBalance", source, cashamount)
        TriggerClientEvent('banking:updateCash', source, cash)
        
        xPlayer.addMoney(cashamount)
    else
        print('[Cheater] Mining Exploit Attempt | ' .. xPlayer)
    end
end)

RegisterNetEvent('removedgoods2')
AddEventHandler('removedgoods2', function(itemcount, hasEnoughOfItem)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local cashamount = 500 * itemcount
    if hasEnoughOfItem == true then
        cash = xPlayer.getMoney()
        TriggerClientEvent("banking:addBalance", source, cashamount)
        TriggerClientEvent('banking:updateCash', source, cash)
        xPlayer.addMoney(cashamount)
    else
        print('[Cheater] Mining Exploit Attempt | ' .. xPlayer)
    end
end)
