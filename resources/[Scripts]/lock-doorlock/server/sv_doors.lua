local steamIds = {
    ["steam:11000010aa15521"] = true --kevin
}

local ESX = nil
-- ESX
TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

RegisterServerEvent('sway-doors:alterlockstate2')
AddEventHandler('sway-doors:alterlockstate2', function()
    --sway.DoorCoords[10]["lock"] = 0

    TriggerClientEvent('sway-doors:alterlockstateclient', source, sway.DoorCoords)

end)

RegisterServerEvent('sway-doors:alterlockstate')
AddEventHandler('sway-doors:alterlockstate', function(alterNum)
    print('lockstate:', alterNum)
    sway.alterState(alterNum)
end)

RegisterServerEvent('sway-doors:ForceLockState')
AddEventHandler('sway-doors:ForceLockState', function(alterNum, state)
    sway.DoorCoords[alterNum]["lock"] = state
    TriggerClientEvent('sway:Door:alterState', -1,alterNum,state)
end)

RegisterServerEvent('sway-doors:requestlatest')
AddEventHandler('sway-doors:requestlatest', function()
    local src = source 
    local steamcheck = ESX.GetPlayerFromId(source).identifier
    if steamIds[steamcheck] then
        TriggerClientEvent('doors:HasKeys',src,true)
    end
    TriggerClientEvent('sway-doors:alterlockstateclient', source,sway.DoorCoords)
end)

function isDoorLocked(door)
    if sway.DoorCoords[door].lock == 1 then
        return true
    else
        return false
    end
end