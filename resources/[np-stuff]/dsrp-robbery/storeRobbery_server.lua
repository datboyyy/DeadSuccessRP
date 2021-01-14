ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

RegisterServerEvent("police:camrobbery")
AddEventHandler("police:camrobbery", function(storeid)
    TriggerClientEvent("police:notifySecurityCam",-1,storeid)
end)

RegisterServerEvent('store:robbery:register')
AddEventHandler('store:robbery:register', function(storeid)
    TriggerClientEvent('store:register', source, storeid,1)
end)

RegisterServerEvent('store:robbery:safe')
AddEventHandler('store:robbery:safe', function(storeid)
    TriggerClientEvent('store:dosafe', source, storeid,1)
end)

RegisterServerEvent('mission:complAVACeted')
AddEventHandler('mission:complAVACeted', function(cash)
    local xPlayer = ESX.GetPlayerFromId(source)
    if cash <= 3500 then
    xPlayer.addMoney(cash)
    else 
        local source = source
        TriggerEvent('banCheater', source, "Money Exploit :)")
    end
end)

AddEventHandler('explosionEvent', function(sender,ev)
    local pos = vector3(ev.posX, ev.posY, ev.posZ)
    local vaultDoorLoc = vector3(294.29, 225.26, 97.72)
    if #(vaultDoorLoc - pos) < 1.0 then
        TriggerEvent("fx:smoke")
        TriggerClientEvent('vault:door:explosion',-1)
    end
end)