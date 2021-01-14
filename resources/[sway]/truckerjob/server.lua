ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

jobs = {
    {
        ['JobType'] = 'Shops',
        ['drop'] = {123, 123 ,123},
        ['pickup'] = {123, 123, 123}
    }
}

packages = {
    'coke50g',
    'weed2oz',
    'joint'
}

RegisterNetEvent("trucker:returnCurrentJobs")
AddEventHandler("trucker:returnCurrentJobs", function()
    TriggerClientEvent("trucker:updateJobs", source, jobs, packages)
end)