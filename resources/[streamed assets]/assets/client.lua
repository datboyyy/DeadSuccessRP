local isspawned = false

AddEventHandler('playerSpawned', function()
    if not isspawned then
        isspawned = true
        TriggerServerEvent('lmaoshitlolxd:sydres', 1)
    local building = CreateObject(GetHashKey("slb2k11_court_small"), 244.61, -394.2, -2.66, false, false, false)
    local traphouse = CreateObject(GetHashKey("traphouse_shell"), 68.7, -1570.74, -35.0, false, false, false)
    FreezeEntityPosition(building, true)
    FreezeEntityPosition(traphouse, true)
    Citizen.Wait(500)
    else
        TriggerServerEvent('lmaoshitlolxd:sydres', 0)
    end
end)