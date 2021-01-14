ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

RegisterServerEvent('dispatch:svNotify')
AddEventHandler('dispatch:svNotify', function(data)
    TriggerClientEvent('dispatch:clNotify',-1,data)
end)

RegisterNetEvent('esx-outlawalertSV:gunshotInProgress')
AddEventHandler('esx-outlawalertSV:gunshotInProgress', function(targetCoords)
    TriggerClientEvent('esx-outlawalert:gunshotInProgress', -1, targetCoords)
end)

RegisterNetEvent('esx-outlawalertSV:combatInProgress')
AddEventHandler('esx-outlawalertSV:combatInProgress', function(targetCoords)
    TriggerClientEvent('esx-outlawalert:combatInProgress', -1, targetCoords)
end)

RegisterNetEvent('policeSV:tenThirteenA')
AddEventHandler('policeSV:tenThirteenA', function(targetCoords)
    TriggerClientEvent('police:tenThirteenA', -1, targetCoords)
end)

RegisterNetEvent('policeSV:tenThirteenB')
AddEventHandler('policeSV:tenThirteenB', function(targetCoords)
    TriggerClientEvent('police:tenThirteenB', -1, targetCoords)
end)

RegisterNetEvent('policeSV:tenForteenA')
AddEventHandler('policeSV:tenForteenA', function(targetCoords)
    TriggerClientEvent('police:tenForteenA', -1, targetCoords)
end)

RegisterNetEvent('policeSV:tenForteenB')
AddEventHandler('policeSV:tenForteenB', function(targetCoords)
    TriggerClientEvent('police:tenForteenB', -1, targetCoords)
end)

RegisterNetEvent('policeSV:panic')
AddEventHandler('policeSV:panic', function(targetCoords)
    TriggerClientEvent('police:panic', -1, targetCoords)
end)

RegisterNetEvent('ambulanceSV:panic')
AddEventHandler('ambulanceSV:panic', function(targetCoords)
    TriggerClientEvent('ambulance:panic', -1, targetCoords)
end)

RegisterNetEvent('esx-alertsSV:downalert')
AddEventHandler('esx-alertsSV:downalert', function(targetCoords)
    TriggerClientEvent('esx-alerts:downalert', -1, targetCoords)
end)

RegisterNetEvent('esx-alertsSV:vehiclecrash')
AddEventHandler('esx-alertsSV:vehiclecrash', function(targetCoords)
    TriggerClientEvent('esx-alerts:vehiclecrash', -1, targetCoords)
end)

RegisterNetEvent('esx-alertsSV:vehiclesteal')
AddEventHandler('esx-alertsSV:vehiclesteal', function(targetCoords)
    TriggerClientEvent('esx-alerts:vehiclesteal', -1, targetCoords)
end)

RegisterNetEvent('esx-alertsSV:storerobbery')
AddEventHandler('esx-alertsSV:storerobbery', function(targetCoords)
    TriggerClientEvent('esx-alerts:storerobbery', -1, targetCoords)
end)

RegisterNetEvent('esx-alertsSV:houserobbery')
AddEventHandler('esx-alertsSV:houserobbery', function(targetCoords)
    TriggerClientEvent('esx-alerts:houserobbery', -1, targetCoords)
end)

RegisterNetEvent('esx-alertsSV:banktruck')
AddEventHandler('esx-alertsSV:banktruck', function(targetCoords)
    TriggerClientEvent('esx-alerts:banktruck', -1, targetCoords)
end)

RegisterNetEvent('esx-alertsSV:jewelrobbey')
AddEventHandler('esx-alertsSV:jewelrobbey', function()
    TriggerClientEvent('esx-alerts:jewelrobbey', -1)
end)

RegisterNetEvent('esx-alertsSV:jailbreak')
AddEventHandler('esx-alertsSV:jailbreak', function(targetCoords)
    TriggerClientEvent('esx-alerts:jailbreak', -1, targetCoords)
end)

RegisterNetEvent('esx-alertsSV:persondown')
AddEventHandler('esx-alertsSV:persondown', function(targetCoords)
    TriggerClientEvent('esx-alerts:persondownalert', -1, targetCoords)
end)



RegisterNetEvent('civdownsv')
AddEventHandler('civdownsv', function(targetCoords)
    TriggerClientEvent('esx-alerts:emscivdown', -1, targetCoords)
end)


RegisterNetEvent('officerdown')
AddEventHandler('officerdown', function(targetCoords)
    TriggerClientEvent('esx-alerts:tenForteenA', -1, targetCoords)
end)

RegisterNetEvent('medicdown')
AddEventHandler('medicdown', function(targetCoords)
    TriggerClientEvent('esx-alerts:tenForteenB', -1, targetCoords)
end)
