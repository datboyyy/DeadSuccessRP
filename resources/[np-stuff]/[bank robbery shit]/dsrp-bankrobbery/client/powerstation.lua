--sydres & sway
local closestStation = 0
local currentStation = 0
CurrentCops = 10
local currentFires = {}
local currentGate = 0

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local dist

        if ESX ~= nil then
            local inRange = false
            for k, v in pairs(Config.PowerStations) do
                dist = GetDistanceBetweenCoords(pos, Config.PowerStations[k].coords.x, Config.PowerStations[k].coords.y, Config.PowerStations[k].coords.z)
                if dist < 5 then
                    closestStation = k
                    inRange = true
                end
            end

            if not inRange then
                Citizen.Wait(1000)
                closestStation = 0
            end
        end
        Citizen.Wait(3)
    end
end)


function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end



Citizen.CreateThread(function()
    Citizen.Wait(2000)
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        if ESX ~= nil then
            if closestStation ~= 0 then
                if not Config.PowerStations[closestStation].hit then
                    DrawMarker(2, Config.PowerStations[closestStation].coords.x, Config.PowerStations[closestStation].coords.y, Config.PowerStations[closestStation].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.1, 255, 255, 255, 155, 0, 0, 0, 1, 0, 0, 0)
                end
            else
                Citizen.Wait(1500)
            end
        end

        Citizen.Wait(1)
    end
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent("robbery:StartFire")
AddEventHandler("robbery:StartFire", function(coords, maxChildren, isGasFire)
    if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, GetEntityCoords(GetPlayerPed(-1))) < 100 then
        local pos = {
            x = coords.x, 
            y = coords.y,
            z = coords.z,
        }
        pos.z = pos.z - 0.9
        local fire = StartScriptFire(pos.x, pos.y, pos.z, maxChildren, isGasFire)
        table.insert(currentFires, fire)
    end
end)

RegisterNetEvent("robbery:StopFires")
AddEventHandler("robbery:StopFires", function()
    for k, v in ipairs(currentFires) do
        RemoveScriptFire(v)
    end
end)

RegisterNetEvent('robbery:UseThermite')
AddEventHandler('robbery:UseThermite', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    if closestStation ~= 0 then
        local dist = GetDistanceBetweenCoords(pos, Config.PowerStations[closestStation].coords.x, Config.PowerStations[closestStation].coords.y, Config.PowerStations[closestStation].coords.z)
        if dist < 1.5 then
            if CurrentCops >= Config.MinimumThermitePolice then
                if not Config.PowerStations[closestStation].hit then
                    loadAnimDict("weapon@w_sp_jerrycan")
                    TaskPlayAnim(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 3.0, 3.9, 180, 49, 0, 0, 0, 0)
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        action = "openThermite",
                        amount = math.random(5, 10),
                    })
                    currentStation = closestStation
                else
                    TriggerEvent('notification', "It seems that the fuses have blown.", 2)
                end
            else
                TriggerEvent('notification', "Not enough police (2 needed)", 2)
            end
        end
    elseif currentThermiteGate ~= 0 then
        print(currentThermiteGate)
        if CurrentCops >= Config.MinimumThermitePolice then
            currentGate = currentThermiteGate
            loadAnimDict("weapon@w_sp_jerrycan")
            TaskPlayAnim(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 3.0, 3.9, -1, 49, 0, 0, 0, 0)
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "openThermite",
                amount = math.random(5, 10),
            })
        else
            TriggerEvent('notification', "Not enough police (2 needed)", 2)
        end
    end
end)

RegisterNetEvent('dsrp-bankrobbery:client:SetStationStatus')
AddEventHandler('dsrp-bankrobbery:client:SetStationStatus', function(key, isHit)
    Config.PowerStations[key].hit = isHit
end)

RegisterNUICallback('thermiteclick', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('thermitefailed', function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    TriggerEvent('inventory:removeItem',"thermite", 1)    
  --  TriggerServerEvent("dsrp-bankrobbery:Server:RemoveItem", "thermite", 1)
    ClearPedTasks(GetPlayerPed(-1))
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local randTime = math.random(10000, 15000)
    Wait(3000)
    CreateFire(coords, randTime)
end)

RegisterNUICallback('thermitesuccess', function()
    ClearPedTasks(GetPlayerPed(-1))
    local time = 3
    local coords = GetEntityCoords(GetPlayerPed(-1))
    while time > 0 do 
        TriggerEvent('notification', "Fire over " .. time .. "!")
        Citizen.Wait(1000)
        time = time - 1
    end
    local randTime = math.random(10000, 15000)
    CreateFire(coords, randTime)
    if currentStation ~= 0 then
        TriggerEvent('notification', "The fuses are broken!", 1)
        TriggerServerEvent("dsrp-bankrobbery:server:SetStationStatus", currentStation, true)
    elseif currentGate ~= 0 then
        TriggerEvent('notification', "The door is burned open!", 1)
        TriggerServerEvent('esx_doorlock:server:updateState', currentGate, false)
        currentGate = 0
    end
end)

RegisterNUICallback('closethermite', function()
    SetNuiFocus(false, false)
end)

function CreateFire(coords, time)
    TriggerServerEvent("robbery:fireMessage")
    for i = 1, math.random(1, 7), 1 do
        TriggerServerEvent("robbery:StartServerFire", coords, 24, false)
    end
    Citizen.Wait(time)
    TriggerServerEvent("robbery:StopFires")
end