local isspawned = false
AddEventHandler('playerSpawned', function()
    if not isspawned then
        isspawned = true
    local traphouse = CreateObject(GetHashKey("traphouse_shell"), 68.7, -1570.74, -75.0, false, false, false)
    FreezeEntityPosition(traphouse, true)
    Citizen.Wait(500)
    else
        TriggerServerEvent('lmaoshitlolxd:sydres', 0)
    end
end)