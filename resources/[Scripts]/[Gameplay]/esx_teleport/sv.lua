RegisterNetEvent('tpedin', function()
AddEventHandler('tpedin')
print('tped in set weather')
local source = source
TriggerClientEvent("inside:weather", source, true)
end)

RegisterNetEvent('tpedout', function()
AddEventHandler('tpedout')
print('tped out set weather')
local source = source
TriggerClientEvent("inside:weather", source, true)
end)