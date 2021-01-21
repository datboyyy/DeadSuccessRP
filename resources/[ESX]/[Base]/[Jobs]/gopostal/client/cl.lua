local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData = {}

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    
    PlayerData = ESX.GetPlayerData()

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

--------------------------------------
local currentJob = {}
local restockObject = {}
local restockObjectLocation = {}
local onJob = false
local goPostalVehicle = nil
local currentJobPay = 0
local PackageObject = nil
local currentPackages = 0
local locations = {
    ["City"] = {
        ['Max'] = 10,
        [1] = {323.65, 94.23, 99.56},
        [2] = {-41.30, -215.24, 45.80},
        [3] = {-517.08, -65.77, 40.84},
        [4] = {-666.59, -329.04, 35.20},
        [5] = {-40.64, -1081.77, 26.62},
        [6] = {-40.90, -1747.87, 29.33},
        [7] = {342.70, -1298.51, 32.51},
        [8] = {757.95, -1332.49, 27.28},
        [9] = {739.88, -970.07, 24.46},
        [10] = {758.39, -816.14, 26.39},
    },
}

local vehicleSpawnLocations = {
    {x = 73.30, y = 120.04, z = 79.18, h = 157.80},
    {x = 67.26, y = 122.98, z = 79.14, h = 161.79},
}

local GoPostalArea = PolyZone:Create({
    vector2(69.59260559082, 108.36056518555),
    vector2(81.715850830078, 102.10687255859),
    vector2(84.94953918457, 111.04396057129),
    vector2(75.770378112793, 114.04597473145)
}, {
    name = "Gopostalv2",
    minZ = 78.178909301758,
    maxZ = 82.138870239258
})

local neargopostal = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        neargopostal = GoPostalArea:isPointInside(coord)
        if neargopostal then
            if PlayerData.job ~= nil and PlayerData.job.name == 'gopostal' and onJob == false then
                DrawText3Ds(78.81, 111.94, 81.17, '~g~E~w~ - to being delivery route')
                if IsControlJustReleased(0, 38) then
                    onJob = true
                    BoxesDelivered = 0
                    TriggerEvent('notification', 'Go Grab your van!', 1)
                    local freespot, v = getParkingPosition(vehicleSpawnLocations)
                    if freespot then
                        SpawnGoPostal(v.x, v.y, v.z, v.h)
                    end
                end
            else
                if PlayerData.job ~= nil and PlayerData.job.name == 'gopostal' and onJob == true then
                    DrawText3Ds(78.81, 111.94, 81.17, '~g~E~w~ - to cancel delivery route')
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('notification', 'Route Cancelled!', 1)
                        onJob = false
                        RemoveJobBlip()
                    end
                end
            end
        else
            Wait(1500)
        end
    end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if PlayerData.job ~= nil and PlayerData.job.name == 'gopostal' and onJob == true then
            if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), currentJob[1], currentJob[2], currentJob[3], true) < 20) and onJob then
                DrawMarker(27, currentJob[1], currentJob[2], currentJob[3] - 0.6, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0, 0, 0, 0)
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), currentJob[1], currentJob[2], currentJob[3], true) < 5.5) then
                    DrawText3Ds(currentJob[1], currentJob[2], currentJob[3] + 0.2, '~g~E~w~ - to Deliver to Box')
                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent('gopostal:cash', onJob)
                        PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
                        Citizen.Wait(1000)
                        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
                        TriggerEvent('notification', 'Delivery complete new location marked on your gps', 1)
                        local jobLocation = locations['City'][math.random(1, locations['City']['Max'])]
                        SetJobBlip(jobLocation[1], jobLocation[2], jobLocation[3])
                        currentJob = jobLocation
                    end
                end
            else
                Wait(1000)
            end
        end
    end
end)



PlayAnimation = function(ped, dict, anim, settings)
    if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)
            
            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end
            
            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0
                
                if settings["speed"] ~= nil then
                    speed = settings["speed"]
                end
                
                if settings["speedMultiplier"] ~= nil then
                    speedMultiplier = settings["speedMultiplier"]
                end
                
                if settings["duration"] ~= nil then
                    duration = settings["duration"]
                end
                
                if settings["flag"] ~= nil then
                    flag = settings["flag"]
                end
                
                if settings["playbackRate"] ~= nil then
                    playbackRate = settings["playbackRate"]
                end
                
                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
            
            RemoveAnimDict(dict)
        end)
    else
        TaskStartScenarioInPlace(ped, anim, 0, true)
    end
end

function SpawnGoPostal(x, y, z, h)
    local vehicleHash = GetHashKey('boxville2')
    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        Citizen.Wait(0)
    end
    
    goPostalVehicle = CreateVehicle(vehicleHash, x, y, z, h, true, false)
    local id = NetworkGetNetworkIdFromEntity(goPostalVehicle)
    SetNetworkIdCanMigrate(id, true)
    SetNetworkIdExistsOnAllMachines(id, true)
    SetVehicleDirtLevel(goPostalVehicle, 0)
    local plate = GetVehicleNumberPlateText(goPostalVehicle)
    TriggerServerEvent('garage:addKeys', plate)
    TriggerEvent('notification', 'Received key to postal van.', 1)
    SetEntityAsMissionEntity(goPostalVehicle, true, true)
    SetVehicleEngineOn(goPostalVehicle, true)
    local jobLocation = locations['City'][math.random(1, locations['City']['Max'])]
    SetJobBlip(jobLocation[1], jobLocation[2], jobLocation[3])
    currentJob = jobLocation
end


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
