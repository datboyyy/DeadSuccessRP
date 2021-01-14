ESX = nil
local PlayerData = {}
random = 0
spawned = false
satiyor = false
local textcoords = Config.textcoords

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
end)

function DrawText3D(x, y, z, text, size)
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
    --DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 100)
end

local DeliveryLocations = {
    [1] = {coords = vector3(197.41, -1499.97, 29.14)},
    [2] = {coords = vector3(4.13, -1476.94, 30.51)},
    [3] = {coords = vector3(231.22, -1752.63, 28.99)},
    [4] = {coords = vector3(64.77, -1574.44, 29.6)},
    [5] = {coords = vector3(-37.9, -1298.48, 29.35)},
    [6] = {coords = vector3(-158.98, -1451.0, 31.47)},
    [7] = {coords = vector3(-299.29, -1368.69, 31.27)},
    [8] = {coords = vector3(153.24, -1441.38, 29.24)},
    [9] = {coords = vector3(160.61, -1541.65, 29.14)},
    [10] = {coords = vector3(25.06, -1411.2, 29.75)},
    [11] = {coords = vector3(46.94, -1493.73, 31.20)},
    [12] = {coords = vector3(977.14, -1487.72, 32.0)},
    [13] = {coords = vector3(370.98, -1440.24, 30.0)},
    [14] = {coords = vector3(1222.89, -649.79, 66.0)},
    [15] = {coords = vector3(448.34, -1739.06, 29.58)},
    [15] = {coords = vector3(25.06, -1411.2, 29.75)},
    [17] = {coords = vector3(46.94, -1493.73, 31.20)},
    [18] = {coords = vector3(977.14, -1487.72, 32.0)},
    [19] = {coords = vector3(370.98, -1440.24, 30.0)},
    [20] = {coords = vector3(1222.89, -649.79, 66.0)},
    [21] = {coords = vector3(448.34, -1739.06, 29.58)},
    [22] = {coords = vector3(25.06, -1411.2, 29.75)},
    [23] = {coords = vector3(46.94, -1493.73, 31.20)},
    [24] = {coords = vector3(977.14, -1487.72, 32.0)},
    [25] = {coords = vector3(370.98, -1440.24, 30.0)},
    [26] = {coords = vector3(1222.89, -649.79, 66.0)},
    [27] = {coords = vector3(448.34, -1739.06, 29.58)},
    [28] = {coords = vector3(25.06, -1411.2, 29.75)},
    [29] = {coords = vector3(46.94, -1493.73, 31.20)},
    [30] = {coords = vector3(977.14, -1487.72, 32.0)},

}

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end



function swayplayeranim()
    loadAnimDict("mp_safehouselost@")
    TaskPlayAnim(PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
end



function swayveranim()
    if (DoesEntityExist(meth_dealer_seller) and not IsEntityDead(meth_dealer_seller)) then
        loadAnimDict("mp_safehouselost@")
        if (IsEntityPlayingAnim(meth_dealer_seller, "mp_safehouselost@", "package_dropoff", 3)) then
            TaskPlayAnim(meth_dealer_seller, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
        else
            TaskPlayAnim(meth_dealer_seller, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
        end
    end
end


RegisterNetEvent('satis')
AddEventHandler('satis', function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local playercoords = GetEntityCoords(ped)
        if random == 0 then
            random = math.random(1, 6)
        end
        if not spawned then
            RequestModel('g_m_m_chiboss_01')
            while not HasModelLoaded('g_m_m_chiboss_01') do
                Wait(1)
            end
            
            meth_dealer_seller = CreatePed(1, 'g_m_m_chiboss_01', DeliveryLocations[random].coords.x, DeliveryLocations[random].coords.y, DeliveryLocations[random].coords.z, 203.01, false, true)
            SetBlockingOfNonTemporaryEvents(meth_dealer_seller, true)
            SetPedDiesWhenInjured(meth_dealer_seller, false)
            SetPedCanPlayAmbientAnims(meth_dealer_seller, true)
            SetPedCanRagdollFromPlayerImpact(meth_dealer_seller, false)
            SetEntityInvincible(D, true)
            SetEntityAsMissionEntity(meth_dealer_seller)
            spawned = true
            print(DeliveryLocations[random].coords)
        end
        
        
        if spawned then
            local distance = GetDistanceBetweenCoords(playercoords["x"], playercoords["y"], playercoords["z"], DeliveryLocations[random].coords.x, DeliveryLocations[random].coords.y, DeliveryLocations[random].coords.z, true)
            local randometc = Config.ETCluck
            if distance <= 2.0 then
                if not satiyor then
                    ESX.Game.Utils.DrawText3D(DeliveryLocations[random].coords, "[E]", 0.7)
                end
                if IsControlPressed(0, 46) then
                    satiyor = true
                    swayplayeranim()
                    PlayAmbientSpeech1(meth_dealer_seller, "Chat_State", "Speech_Params_Force")
                    exports["sway_taskbar"]:taskBar(5300, "Exchanging Rolex's")
                    swayveranim()
                    Citizen.Wait(10)
                    exports["sway_taskbar"]:taskBar(4300, "Being Passed Money")
                    ClearPedTasksImmediately(meth_dealer_seller)
                    if exports["dsrp-inventory"]:getQuantity("rolexwatch") > 1  then  
                    TriggerEvent("inventory:removeItem","rolexwatch", 1)   
                    TriggerServerEvent('sway:rolexsat', 'rolexwatch')
                    TriggerServerEvent('sway:addMoney')
                    if randometc == 1 then
                        TriggerServerEvent('sway-etc')
                        TriggerEvent('phone:addnotification', 'EMAIL',  "Customers said they liked the goods very much' ")
                        
                    end
                    Citizen.Wait(1000)
                    SetPedAsNoLongerNeeded(meth_dealer_seller, true)
                    TriggerEvent('again')
                    Citizen.Wait(500)
                end
            end
            end
        end
    end
end)


RegisterNetEvent('again')
AddEventHandler('again', function()
    Citizen.Wait(5000)
    random = 0
    spawned = false
    satiyor = false
    pussy()
end)


function pussy()
    Citizen.Wait(100)
    SetNewWaypoint(DeliveryLocations[random].coords.x, DeliveryLocations[random].coords.y)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Vdist2(GetEntityCoords(PlayerPedId(), false), textcoords) < 1.5 then
            if isNight() then
                DrawText3D(textcoords.x, textcoords.y, textcoords.z, "[E] Start the watch sale by pressing")
                if IsControlJustReleased(0, 46) then
                    local plyPed = GetPlayerPed(-1)
                    while not HasAnimDictLoaded("timetable@jimmy@doorknock@") do RequestAnimDict("timetable@jimmy@doorknock@"); Citizen.Wait(0); end
                    TaskPlayAnim(plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 8.0, 8.0, -1, 4, 0, 0, 0, 0)
                    exports["sway_taskbar"]:taskBar(4300, "Door Knocking ...")
                    Citizen.Wait(0)
                    while IsEntityPlayingAnim(plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 3) do Citizen.Wait(0); end
                    TriggerEvent('satis')
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    exports['mythic_notify']:SendAlert('inform', 'Customers contacted')
                    Citizen.Wait(math.random(2500, 5000))
                    TriggerEvent('phone:addnotification', 'EMAIL',  "I Received A New Customer I am sending the location to the GPS' ")
                    Citizen.Wait(500)
                    SetNewWaypoint(DeliveryLocations[random].coords.x, DeliveryLocations[random].coords.y)
                end
            end
        end
    end
end)

function GetVecDist(v1, v2)
    if not v1 or not v2 or not v1.x or not v2.x then return 0; end
    return math.sqrt(((v1.x or 0) - (v2.x or 0)) * ((v1.x or 0) - (v2.x or 0)) + ((v1.y or 0) - (v2.y or 0)) * ((v1.y or 0) - (v2.y or 0)) + ((v1.z or 0) - (v2.z or 0)) * ((v1.z or 0) - (v2.z or 0)))
end


function isNight()
    local hour = GetClockHours()
    if hour > 00 or hour < 01 then
        return true
    end
end
