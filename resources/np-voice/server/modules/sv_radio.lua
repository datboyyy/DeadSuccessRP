ESX = nil
TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)

AddEventHandler("playerDropped", function()
    local source = source
    TriggerEvent('np:voice:radio:disconnect', source)
    print('player left removed from radio')
end)

RegisterNetEvent("np-voice:addtoradio")
AddEventHandler("np-voice:addtoradio", function(newChannel)
    local source = source
    local radiosub = ESX.GetPlayerServerId(source)
    TriggerEvent('np:voice:radio:added', newChannel, radiosub)
    print('Adding Player to radio', radiosub)
end)

RegisterNetEvent("np:voice:radio:power")
AddEventHandler("np:voice:radio:power", function(powerstate)
    local source = source
    TriggerEvent('np:voice:radio:power', source, powerstate)
    print('Power On', powerstate)
end)

RegisterNetEvent("np:voice:radio:removed")
AddEventHandler("np:voice:radio:removed", function(newChannel)
    local source = source
    local radiosub = ESX.GetPlayerServerId(source)
    TriggerEvent('np:voice:radio:removed', newChannel, radiosub)
    print('Adding Player to radio', radiosub)
end)