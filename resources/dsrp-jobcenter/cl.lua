local inJobCenterMenu = false
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    
    ESX.PlayerData = ESX.GetPlayerData()
end)
-----------------------------------------------------------------------------
-- NUI OPEN/CLOSE FUNCTIONS
-----------------------------------------------------------------------------
function openJobCenter()
    inJobCenterMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openGeneral"
    })
end

function closeJobCenter()
    inJobCenterMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "closeAll"
    })
end

RegisterNUICallback('NUIFocusOff', function()
    inJobCenterMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "closeAll"
    })
end)

-----------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------
RegisterNUICallback('garbage', function()
    local job = 'garbage'
    TriggerServerEvent('setjob:jobcenter', job)
    TriggerEvent('notification', 'Job Set to ' .. job, 1)
end)

RegisterNUICallback('gopostal', function()
    local job = 'gopostal'
    TriggerServerEvent('setjob:jobcenter', job)
    TriggerEvent('notification', 'Job Set to ' .. job, 1)
end)

RegisterNUICallback('unemployed', function()
    local job = 'unemployed'
    TriggerEvent('notification', 'Job Set to ' .. job, 1)
    TriggerServerEvent('setjob:jobcenter', job)
end)



-----------------------------------------------------------------------------
-- PolyZone Checks (distance checking)
-----------------------------------------------------------------------------
local jobcenter = PolyZone:Create({
    vector2(-137.88977050781, -629.19494628906),
    vector2(-136.98983764648, -633.42205810547),
    vector2(-141.02642822266, -634.16845703125),
    vector2(-141.71607971191, -629.73864746094)
}, {
    name = "jobcenter",
    minZ = 167.82054138184,
    maxZ = 170.82054138184,
    debugGrid = false,
    gridDivisions = 30
})



jobcenter:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
    if isPointInside then
        TriggerEvent('cd_drawtextui:ShowUI', 'show', '[E] - Job Center')
        isPointInside = true
    else
        isPointInside = false
        TriggerEvent('cd_drawtextui:HideUI')
    end
end)
-----------------------------------------------------------------------------
-- Job Handler (SetJob)
-----------------------------------------------------------------------------
local jobcenterin = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        jobcenterin = jobcenter:isPointInside(coord)
        if jobcenterin then
            DrawText3Ds(-139.23, -631.87, 168.82, '~g~E~w~ - Job Center')
            if IsControlJustReleased(0, 38) and jobcenterin then
                openJobCenter()
            end
        else 
            Citizen.Wait(1700)
            end
        end
    end)  

function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)

end
