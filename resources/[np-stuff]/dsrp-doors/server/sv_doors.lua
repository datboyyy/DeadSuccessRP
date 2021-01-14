local steamIds = {
    ["steam:11000010aa15521"] = true --kevin
}

local ESX = nil
-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('dsrp-doors:alterlockstate2')
AddEventHandler('dsrp-doors:alterlockstate2', function()
    evo.DoorCoords[10]["lock"] = 0
    evo.DoorCoords[11]["lock"] = 0
    evo.DoorCoords[12]["lock"] = 0
    evo.DoorCoords[39]["lock"] = 0
    evo.DoorCoords[40]["lock"] = 0
    evo.DoorCoords[41]["lock"] = 0
    evo.DoorCoords[42]["lock"] = 0
    evo.DoorCoords[44]["lock"] = 0
    evo.DoorCoords[45]["lock"] = 0
    evo.DoorCoords[46]["lock"] = 0
    evo.DoorCoords[47]["lock"] = 0
    evo.DoorCoords[48]["lock"] = 0
    evo.DoorCoords[49]["lock"] = 0
    evo.DoorCoords[50]["lock"] = 0
    evo.DoorCoords[51]["lock"] = 0
    evo.DoorCoords[52]["lock"] = 0
    evo.DoorCoords[53]["lock"] = 0
    evo.DoorCoords[54]["lock"] = 0
    evo.DoorCoords[55]["lock"] = 0
    evo.DoorCoords[56]["lock"] = 0

    TriggerClientEvent('dsrp-doors:alterlockstateclient', source, evo.DoorCoords)

end)

RegisterServerEvent('dsrp-doors:alterlockstate')
AddEventHandler('dsrp-doors:alterlockstate', function(alterNum)
    -- print('lockstate:', alterNum)
    evo.alterState(alterNum)
end)

RegisterServerEvent('dsrp-doors:ForceLockState')
AddEventHandler('dsrp-doors:ForceLockState', function(alterNum, state)
    evo.DoorCoords[alterNum]["lock"] = state
    TriggerClientEvent('evo:Door:alterState', -1,alterNum,state)
end)

RegisterServerEvent('dsrp-doors:requestlatest')
AddEventHandler('dsrp-doors:requestlatest', function()
    local src = source 
    local steamcheck = ESX.GetPlayerFromId(source).identifier
    if steamIds[steamcheck] then
        TriggerClientEvent('doors:HasKeys',src,true)
    end
    TriggerClientEvent('dsrp-doors:alterlockstateclient', source,evo.DoorCoords)
end)

function isDoorLocked(door)
    if evo.DoorCoords[door].lock == 1 then
        return true
    else
        return false
    end
end