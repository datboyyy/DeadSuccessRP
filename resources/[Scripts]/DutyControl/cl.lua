local inDutyMenu = false
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
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
function openDutyControl()
    inDutyMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openGeneral"
    })
end

function closeDutyControl()
    inDutyMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "closeAll"
    })
end

RegisterNUICallback('NUIFocusOff', function()
    inDutyMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "closeAll"
    })
end)

-----------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------
RegisterNUICallback('onduty', function()
        --On Duty Trigger
        TriggerServerEvent('duty:on')
end)

RegisterNUICallback('offduty', function()
        -- off duty
        TriggerServerEvent('duty:off')
end)

-----------------------------------------------------------------------------
-- PolyZone Checks (distance checking)
-----------------------------------------------------------------------------
local dutyspot = PolyZone:Create({
    vector2(441.98956298828, -981.06964111328),
    vector2(440.49389648438, -980.95550537109),
    vector2(440.30163574219, -982.44293212891),
    vector2(441.9225769043, -982.55249023438)
}, {
    name = "duty_spot",
    minZ = 29.7,
    maxZ = 31.97,
    debugGrid = false,
    gridDivisions = 30
})

--Name: ems | 2020-12-11T09:31:55Z
local emsdutyspot = PolyZone:Create({
    vector2(308.1379699707, -597.48291015625),
    vector2(305.14697265625, -596.65374755859),
    vector2(304.77584838867, -597.92523193359),
    vector2(307.23696899414, -598.73413085938)
  }, {
    name="ems",
    minZ = 41.7,
    maxZ = 44.97,
    debugGrid = false,
    gridDivisions = 30
  })
  
  

dutyspot:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
    if isPointInside then
        TriggerEvent('cd_drawtextui:ShowUI', 'show', '[E] - Duty')
        isPointInside = true
    else
        isPointInside = false
        TriggerEvent('cd_drawtextui:HideUI')
    end
end)

emsdutyspot:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
    if isPointInside then
        TriggerEvent('cd_drawtextui:ShowUI', 'show', '[E] - Duty')
        isPointInside = true
    else
        isPointInside = false
        TriggerEvent('cd_drawtextui:HideUI')
    end
end)

-----------------------------------------------------------------------------
-- Job Handler (SetJob)
-----------------------------------------------------------------------------
local dutyspotin = false
Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        dutyspotin = dutyspot:isPointInside(coord)
        local sleep = dutyspotin and 1 or 2000
        if IsControlJustReleased(0, 54) and dutyspotin then
            openDutyControl()
		end
		Citizen.Wait(sleep)
    end
end)

local emsdutyspotin = false
Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        emsdutyspotin = emsdutyspot:isPointInside(coord)
        local sleep = emsdutyspotin and 1 or 2000
        if IsControlJustReleased(0, 54) and emsdutyspotin then
            openDutyControl()
		end
		Citizen.Wait(sleep)
    end
end)



