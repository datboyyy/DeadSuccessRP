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

inside = false
closesthouse = nil
hasKey = false
isOwned = false

isLoggedIn = true
local contractOpen = false

local cam = nil
local viewCam = false

local FrontCam = false

stashLocation = nil
outfitLocation = nil
logoutLocation = nil
houseid = nil

local OwnedHouseBlips = {}

local CurrentDoorBell = 0
local rangDoorbell = nil

local houseObj = {}
local POIOffsets = nil
local entering = false
local data = nil

local CurrentHouse = nil

ESX = nil

local inHoldersMenu = false

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if ESX == nil then
            TriggerEvent("esx:getSharAVACedObject", function(obj) ESX = obj end)    
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent('qb-houses:client:sellHouse')
AddEventHandler('qb-houses:client:sellHouse', function()
    if closesthouse ~= nil and hasKey then
        TriggerServerEvent('qb-houses:server:viewHouse', closesthouse)
    end
end)

--------------------------------------------------------------


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)

        if isLoggedIn then
            if not inside then
                SetClosestHouse()
            end
        end
    end
end)

RegisterNetEvent('qb-houses:client:EnterHouse')
AddEventHandler('qb-houses:client:EnterHouse', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)

    if closesthouse ~= nil then
        local dist = GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true)
        if dist < 1.5 then
            if hasKey then
                enterOwnedHouse(closesthouse)
            else
                if not Config.Houses[closesthouse].locked then
                    enterNonOwnedHouse(closesthouse)
                end
            end
        end
    end
end)

RegisterNetEvent('qb-houses:client:RequestRing')
AddEventHandler('qb-houses:client:RequestRing', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)

    if closesthouse ~= nil then
		TriggerServerEvent('qb-houses:server:RingDoor', closesthouse)
    end
end)

RegisterNetEvent('qb-houses:client:RequestRing2')
AddEventHandler('qb-houses:client:RequestRing2', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)

    if IsControlJustPressed(0, Keys["G"]) then
		TriggerServerEvent('qb-houses:server:RingDoor2', closesthouse)
    end
end)

Citizen.CreateThread(function()
    Wait(1000)
    
    TriggerServerEvent('qb-houses:client:setHouses')
    isLoggedIn = true
    SetClosestHouse()
    TriggerEvent('qb-houses:client:setupHouseBlips')
    Citizen.Wait(100)
    TriggerEvent('cash-garagesystem:client:setHouseGarage', closesthouse, hasKey)
    TriggerServerEvent("qb-houses:server:setHouses")
end)

function doorText(x, y, z, text)
    SetTextScale(0.325, 0.325)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.011, -0.025+ factor, 0.03, 0, 0, 0, 68)
    ClearDrawOrigin()
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    TriggerServerEvent('qb-houses:client:setHouses')
    isLoggedIn = true
    SetClosestHouse()
    TriggerEvent('qb-houses:client:setupHouseBlips')
    Citizen.Wait(100)
    TriggerEvent('cash-garagesystem:client:setHouseGarage', closesthouse, hasKey)
    TriggerServerEvent("qb-houses:server:setHouses")
end)

--[[RegisterNetEvent('CashoutCore:Client:OnPlayerUnload')
AddEventHandler('CashoutCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    inside = false
    closesthouse = nil
    hasKey = false
    isOwned = false
    for k, v in pairs(OwnedHouseBlips) do
        RemoveBlip(v)
    end
end)]]--

RegisterNetEvent('qb-houses:client:setHouseConfig')
AddEventHandler('qb-houses:client:setHouseConfig', function(houseConfig)
    Config.Houses = houseConfig
end)

RegisterNetEvent('qb-houses:client:lockHouse')
AddEventHandler('qb-houses:client:lockHouse', function(bool, house)
    Config.Houses[house].locked = bool
end)

RegisterNetEvent('qb-houses:client:createHouses')
AddEventHandler('qb-houses:client:createHouses', function(price, tier)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local heading = GetEntityHeading(GetPlayerPed(-1))
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street = GetStreetNameFromHashKey(s1)
    local coords = {
        enter 	= { x = pos.x, y = pos.y, z = pos.z, h = heading},
        cam 	= { x = pos.x, y = pos.y, z = pos.z, h = heading, yaw = -10.00},
    }
    street = street:gsub("%-", " ")
    TriggerServerEvent('qb-houses:server:addNewHouse', street, coords, price, tier)
end)

RegisterNetEvent('qb-houses:client:addGarage')
AddEventHandler('qb-houses:client:addGarage', function()
    if closesthouse ~= nil then 
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local heading = GetEntityHeading(GetPlayerPed(-1))
        local coords = {
            x = pos.x,
            y = pos.y,
            z = pos.z,
            h = heading,
        }
        TriggerServerEvent('qb-houses:server:addGarage', closesthouse, coords)
    else
        ESX.ShowNotification("No house around..")
    end
end)

RegisterNetEvent('qb-houses:client:toggleDoorlock')
AddEventHandler('qb-houses:client:toggleDoorlock', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    
    if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true) < 1.5)then
        if hasKey then
            if Config.Houses[closesthouse].locked then
                TriggerServerEvent('qb-houses:server:lockHouse', false, closesthouse)
                ESX.ShowNotification("House is unlocked")
            else
                TriggerServerEvent('qb-houses:server:lockHouse', true, closesthouse)
                ESX.ShowNotification("House is locked!")
            end
        else
            ESX.ShowNotification("You don't have the keys to this house...")
        end
    else
        ESX.ShowNotification("There is no door in sight??")
    end
end)

DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do

        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        local inRange = false

        if closesthouse ~= nil then
            if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, false) < 30)then
                inRange = true
                if hasKey then
                    -- ENTER HOUSE
                    if not inside then
                        if closesthouse ~= nil then
                            if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true) < 1.5)then
                                DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, 'Press ~b~ E ~w~ - to enter the house')
								if IsControlJustPressed(0, Keys["E"]) then
                                TriggerEvent("qb-houses:client:EnterHouse")
								end
                            end
                        end
                    end

                    if CurrentDoorBell ~= 0 then
                        if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[closesthouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, true) < 1.5)then
                            DrawText3Ds(Config.Houses[closesthouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[closesthouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z + 0.35, 'Press ~g~ G ~w~ - to open a house')
                            if IsControlJustPressed(0, Keys["G"]) then
                                TriggerServerEvent("qb-houses:server:OpenDoor", CurrentDoorBell, closesthouse)
                                CurrentDoorBell = 0
                            end
                        end
                    end
                    -- EXIT HOUSE
                    if inside then
                        if not entering then
                            if POIOffsets ~= nil then
                                if POIOffsets.exit ~= nil then
                                    if(GetDistanceBetweenCoords(pos, Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, -100.00 + POIOffsets.exit.z, true) < 1.5)then
                                        DrawText3Ds(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, -100.00 + POIOffsets.exit.z, 'Press ~g~ E ~w~ - to leave the house')
                                        DrawText3Ds(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, -100.00 + POIOffsets.exit.z - 0.1, 'Press ~g~ H ~w~ - to see monitoring')
                                        if IsControlJustPressed(0, Keys["E"]) then
                                            leaveOwnedHouse(CurrentHouse)
                                        end
                                        if IsControlJustPressed(0, Keys["H"]) then
                                            FrontDoorCam(Config.Houses[CurrentHouse].coords.enter)
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    if not isOwned then
                        if closesthouse ~= nil then
                            if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true) < 1.5)then
                                if not viewCam and Config.Houses[closesthouse].locked then
                                    DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, 'Press ~g~ E ~w~ - to see the offer')
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        TriggerServerEvent('qb-houses:server:viewHouse', closesthouse)
                                    end
                                end
                            end
                        end
                    elseif isOwned then
                        if closesthouse ~= nil then
                            if not inOwned then
                            elseif inOwned then
                                if POIOffsets ~= nil then
                                    if POIOffsets.exit ~= nil then
                                        if(GetDistanceBetweenCoords(pos, Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, -100.00 + POIOffsets.exit.z, true) < 1.5)then
                                            DrawText3Ds(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, -100.00 + POIOffsets.exit.z, 'Press ~g~ E ~w~ - to leave the house')
                                            if IsControlJustPressed(0, Keys["E"]) then
                                                leaveNonOwnedHouse(CurrentHouse)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if inside and not isOwned then
                        if not entering then
                            if POIOffsets ~= nil then
                                if POIOffsets.exit ~= nil then
                                    if(GetDistanceBetweenCoords(pos, Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, -100.00 + POIOffsets.exit.z, true) < 1.5)then
                                        DrawText3Ds(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, -100.00 + POIOffsets.exit.z, 'Press ~g~ E ~w~ - to leave the house')
                                        if IsControlJustPressed(0, Keys["E"]) then
                                            leaveNonOwnedHouse(CurrentHouse)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                local StashObject = nil
                -- STASH
                if inside then
                    if CurrentHouse ~= nil then
                        if stashLocation ~= nil then
                            if(GetDistanceBetweenCoords(pos, stashLocation.x, stashLocation.y, stashLocation.z, true) < 1.5)then
                                DrawText3Ds(stashLocation.x, stashLocation.y, stashLocation.z, 'Press ~g~ E ~w~ - to access storage')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    TriggerEvent("server-inventory-open", "1", 'House-'..houseid)
                                    --TriggerServerEvent("inventory:server:OpenInventory", "stash", CurrentHouse)
                                    --TriggerEvent("inventory:client:SetCurrentStash", CurrentHouse)
                                end
                            elseif(GetDistanceBetweenCoords(pos, stashLocation.x, stashLocation.y, stashLocation.z, true) < 3)then
                                DrawText3Ds(stashLocation.x, stashLocation.y, stashLocation.z, 'Stash')
                            end
                        end
                    end
                end

                if inside then
                    if CurrentHouse ~= nil then
                        if outfitLocation ~= nil then
                            if(GetDistanceBetweenCoords(pos, outfitLocation.x, outfitLocation.y, outfitLocation.z, true) < 1.5)then
                                DrawText3Ds(outfitLocation.x, outfitLocation.y, outfitLocation.z, 'Press ~g~ E ~w~ - change outfit')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    TriggerEvent('openskinmenu')
                                end
                            elseif(GetDistanceBetweenCoords(pos, outfitLocation.x, outfitLocation.y, outfitLocation.z, true) < 3)then
                                DrawText3Ds(outfitLocation.x, outfitLocation.y, outfitLocation.z, 'Outfits')
                            end
                        end
                    end
                end

                if inside then
                    if CurrentHouse ~= nil then
                        if logoutLocation ~= nil then
                            if(GetDistanceBetweenCoords(pos, logoutLocation.x, logoutLocation.y, logoutLocation.z, true) < 1.5)then
                                DrawText3Ds(logoutLocation.x, logoutLocation.y, logoutLocation.z, '~g~E~w~ - Disconnect')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    DoScreenFadeOut(250)
                                    while not IsScreenFadedOut() do
                                        Citizen.Wait(10)
                                    end
                                    exports['qb-interior']:DespawnInterior(houseObj, function()
                                        TriggerEvent('cash-timeandweather:client:EnableSync')
                                        SetEntityCoords(GetPlayerPed(-1), Config.Houses[CurrentHouse].coords.enter.x, Config.Houses[CurrentHouse].coords.enter.y, Config.Houses[CurrentHouse].coords.enter.z + 0.5)
                                        SetEntityHeading(GetPlayerPed(-1), Config.Houses[CurrentHouse].coords.enter.h)
                                        inOwned = false
                                        inside = false
                                        TriggerServerEvent('qb-houses:server:LogoutLocation')
                                    end)
                                end
                            elseif(GetDistanceBetweenCoords(pos, logoutLocation.x, logoutLocation.y, logoutLocation.z, true) < 3)then
                                DrawText3Ds(logoutLocation.x, logoutLocation.y, logoutLocation.z, 'Disconnect')
                            end
                        end
                    end
                end
            end
        end
        if not inRange then
            Citizen.Wait(1500)
        end
    
        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if inHoldersMenu then
            Menu.renderGUI()
        end
    end
end)

function openHouseAnim()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(GetPlayerPed(-1))
end

RegisterNetEvent('qb-houses:client:RingDoor')
AddEventHandler('qb-houses:client:RingDoor', function(player, house)
    if closesthouse == house and inside then
        CurrentDoorBell = player
        -- TriggerServerEvent("InteractSound_SV:PlayOnSource", "doorbell", 0.1)
        ESX.ShowNotification("Someone calls at the door!")
    end
end)

RegisterNetEvent('qb-houses:client:RingDoor2')
AddEventHandler('qb-houses:client:RingDoor2', function(player, house)
    if closesthouse == house and inside then
        CurrentDoorBell = player
        -- TriggerServerEvent("InteractSound_SV:PlayOnSource", "doorbell", 0.1)
        ESX.ShowNotification("Someone calls at the door2")
    end
end)
GetPlayers = function()
local players = {}
for _, player in ipairs(GetActivePlayers()) do
    local ped = GetPlayerPed(player)
    if DoesEntityExist(ped) then
        table.insert(players, player)
    end
end
return players
end

GetPlayersFromCoords = function(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

    if coords == nil then
		coords = GetEntityCoords(GetPlayerPed(-1))
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
		if targetdistance <= distance then
			table.insert(closePlayers, player)
		end
    end
    
    return closePlayers
end

function GetClosestPlayer()
    local closestPlayers = GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end
RegisterCommand('testcommand', function()
    local license = exports["isPed"]:isPed("steam")
    TriggerEvent('qb-houses:client:giveHouseKey')
end,false)

RegisterCommand('removeHouseKey', function()
local license = exports["isPed"]:isPed("steam")
TriggerEvent('qb-houses:client:removeHouseKey')
end,false)

RegisterNetEvent('qb-houses:client:giveHouseKey')
AddEventHandler('qb-houses:client:giveHouseKey', function(data)
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 and closesthouse ~= nil then
        local playerId = GetPlayerServerId(player)
        local housedist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z)
        
        if housedist < 10 then
            print(playerId, closesthouse)
            TriggerServerEvent('qb-houses:server:giveHouseKey', playerId, closesthouse)
        else
            ESX.ShowNotification("You are not close enough to the house..")
        end
    elseif closesthouse == nil then
        ESX.ShowNotification("There is no house nearby!")
    else
        ESX.ShowNotification("No one around!")
    end
end)

RegisterNetEvent('qb-houses:client:removeHouseKey')
AddEventHandler('qb-houses:client:removeHouseKey', function(data, source)
    local license = exports["isPed"]:isPed("steam")
    print('Hex', license)
    if closesthouse ~= nil then 
        local housedist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z)
        if housedist < 5 then
            ESX.TriggerServerCallback('qb-houses:server:getHouseOwner', function(result)
                if license == result then
                    inHoldersMenu = true
                    HouseKeysMenu()
                    Menu.hidden = not Menu.hidden
                else
                    ESX.ShowNotification("You are not a homeowner..")
                end
            end, closesthouse)
        else
            ESX.ShowNotification("You are not close enough to the house..")
        end
    else
        ESX.ShowNotification("You are not close enough to the house..")
    end
end)

RegisterNetEvent('qb-houses:client:refreshHouse')
AddEventHandler('qb-houses:client:refreshHouse', function(data)
    Citizen.Wait(100)
    SetClosestHouse()
    --TriggerEvent('cash-garagesystem:client:setHouseGarage', closesthouse, hasKey)
end)

RegisterNetEvent('qb-houses:client:SpawnInApartment')
AddEventHandler('qb-houses:client:SpawnInApartment', function(house)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if rangDoorbell ~= nil then
        if(GetDistanceBetweenCoords(pos, Config.Houses[house].coords.enter.x, Config.Houses[house].coords.enter.y, Config.Houses[house].coords.enter.z, true) > 5)then
            return
        end
    end
    closesthouse = house
    enterNonOwnedHouse(house)
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end 

function HouseKeysMenu()
    ped = GetPlayerPed(-1);
    MenuTitle = "Sleutels"
    ClearMenu()
    ESX.TriggerServerCallback('qb-houses:server:getHouseKeyHolders', function(holders)
        ped = GetPlayerPed(-1);
        MenuTitle = "Sleutelhouders:"
        ClearMenu()
        if holders == nil or next(holders) == nil then
            ESX.ShowNotification("No key holders found..")
            closeMenuFull()
        else
            for k, v in pairs(holders) do
                Menu.addButton(holders[k].firstname .. " ", "optionMenu", holders[k]) 
            end
        end
        Menu.addButton("Close Menu", "closeMenuFull", nil) 
    end, closesthouse)
end

function changeOutfit()
	Wait(200)
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(3100)
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function optionMenu(citizenData)
    ped = GetPlayerPed(-1);
    MenuTitle = "What now?"
    ClearMenu()
    Menu.addButton("Remove house key", "removeHouseKey", citizenData) 
    Menu.addButton("Back", "HouseKeysMenu",nil)
end

function removeHouseKey(citizenData)
    print(closesthouse, json.encode(citizenData))
    TriggerServerEvent('qb-houses:server:removeHouseKey', closesthouse, citizenData)
    closeMenuFull()
end

function removeOutfit(oData)
    TriggerServerEvent('clothes:removeOutfit', oData.outfitname)
    ESX.ShowNotification(oData.outfitname.." is removed")
    closeMenuFull()
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    inHoldersMenu = false
    ClearMenu()
end

function ClearMenu()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function openContract(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "toggle",
        status = bool,
    })
    contractOpen = bool
end

function enterOwnedHouse(house)
    CurrentHouse = house
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    inside = true
    Citizen.Wait(250)
    local coords = { x = Config.Houses[house].coords.enter.x, y = Config.Houses[house].coords.enter.y, z= -100.00}
    print(json.encode(coords))
    LoadDecorations(house)
    
    if Config.Houses[house].tier == 1 then
        data = exports['qb-interior']:CreateTier1House(coords)
    elseif Config.Houses[house].tier == 2 then
        data = exports['qb-interior']:CreateTrevorsShell(coords)
    elseif Config.Houses[house].tier == 3 then
        data = exports['qb-interior']:CreateMichaelShell(coords)
    elseif Config.Houses[house].tier == 4 then
        data = exports['qb-interior']:CreateApartmentShell(coords)
    elseif Config.Houses[house].tier == 5 then
        data = exports['qb-interior']:CreateCaravanShell(coords)
    elseif Config.Houses[house].tier == 6 then
        data = exports['qb-interior']:CreateFranklinShell(coords)
    elseif Config.Houses[house].tier == 7 then
        data = exports['qb-interior']:CreateFranklinAuntShell(coords)
    elseif Config.Houses[house].tier == 8 then
        data = exports['qb-interior']:CreateTrapHouseShell(coords)
	end
    
	Citizen.Wait(100)
    houseObj = data[1]
    POIOffsets = data[2]
    print(POIOffsets)
    print(data[2])
    print(POIOffsets.exit.x)
    entering = true
    --TriggerServerEvent('qb-houses:server:SetInsideMeta', house, true)
    Citizen.Wait(500)
    SetRainFxIntensity(0.0)
    TriggerEvent('qb-weathersync:client:DisableSync')
    TriggerEvent('cash-weeddrug:client:getHousePlants', house)
    Citizen.Wait(100)
    entering = false
    setHouseLocations()
end
RegisterNetEvent('qb-houses:client:enterOwnedHouse')
AddEventHandler('qb-houses:client:enterOwnedHouse', function(house)
    ESX.GetPlayerData(function(PlayerData)
		--if PlayerData.metadata["injail"] == 0 then
			enterOwnedHouse(house)
		--end
	end)
end)

RegisterNUICallback('HasEnoughMoney', function(data, cb)
    ESX.TriggerServerCallback('qb-houses:server:HasEnoughMoney', function(hasEnough)
        
    end, data.objectData)
end)

RegisterNetEvent('qb-houses:client:LastLocationHouse')
AddEventHandler('qb-houses:client:LastLocationHouse', function(houseId)
    ESX.GetPlayerData(function(PlayerData)
		--if PlayerData.metadata["injail"] == 0 then
			enterOwnedHouse(houseId)
		--end
	end)
end)

function leaveOwnedHouse(house)
    if not FrontCam then
        inside = false
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
        openHouseAnim()
        Citizen.Wait(250)
        DoScreenFadeOut(250)
        Citizen.Wait(500)
        exports['qb-interior']:DespawnInterior(houseObj, function()
            UnloadDecorations()
            TriggerEvent('qb-weathersync:client:EnableSync')
            Citizen.Wait(250)
            DoScreenFadeIn(250)
            SetEntityCoords(GetPlayerPed(-1), Config.Houses[CurrentHouse].coords.enter.x, Config.Houses[CurrentHouse].coords.enter.y, Config.Houses[CurrentHouse].coords.enter.z + 0.2)
            SetEntityHeading(GetPlayerPed(-1), Config.Houses[CurrentHouse].coords.enter.h)
            TriggerEvent('cash-weeddrug:client:leaveHouse')
            --TriggerServerEvent('qb-houses:server:SetInsideMeta', house, false)
            CurrentHouse = nil
        end)
    end
end

function enterNonOwnedHouse(house)
    CurrentHouse = house
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    inside = true
    Citizen.Wait(250)
    local coords = { x = Config.Houses[closesthouse].coords.enter.x, y = Config.Houses[closesthouse].coords.enter.y, z= -100.00}
    LoadDecorations(house)

    if Config.Houses[house].tier == 1 then
        data = exports['qb-interior']:CreateTier1House(coords)
    elseif Config.Houses[house].tier == 2 then
        data = exports['qb-interior']:CreateTrevorsShell(coords)
    elseif Config.Houses[house].tier == 3 then
        data = exports['qb-interior']:CreateMichaelShell(coords)
    elseif Config.Houses[house].tier == 4 then
        data = exports['qb-interior']:CreateApartmentShell(coords)
    elseif Config.Houses[house].tier == 5 then
        data = exports['qb-interior']:CreateCaravanShell(coords)
    elseif Config.Houses[house].tier == 6 then
        data = exports['qb-interior']:CreateFranklinShell(coords)
    elseif Config.Houses[house].tier == 7 then
        data = exports['qb-interior']:CreateFranklinAuntShell(coords)
	elseif Config.Houses[house].tier == 8 then
        data = exports['qb-interior']:CreateTrapHouseShell(coords)
	end
	
    houseObj = data[1]
    POIOffsets = data[2]
    entering = true
    Citizen.Wait(500)
    SetRainFxIntensity(0.0)
    --TriggerServerEvent('qb-houses:server:SetInsideMeta', house, true)
    TriggerEvent('qb-weathersync:client:DisableSync')
    TriggerEvent('cash-weeddrug:client:getHousePlants', house)
    Citizen.Wait(100)
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    print('test time')
    NetworkOverrideClockTime(12, 0, 0)
    entering = false
    inOwned = true
    setHouseLocations()
end
function leaveNonOwnedHouse(house)
    if not FrontCam then
        inside = false
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
        openHouseAnim()
        Citizen.Wait(250)
        DoScreenFadeOut(250)
        Citizen.Wait(500)
        exports['qb-interior']:DespawnInterior(houseObj, function()
            UnloadDecorations()
            TriggerEvent('qb-weathersync:client:EnableSync')
            Citizen.Wait(250)
            DoScreenFadeIn(250)
            SetEntityCoords(GetPlayerPed(-1), Config.Houses[CurrentHouse].coords.enter.x, Config.Houses[CurrentHouse].coords.enter.y, Config.Houses[CurrentHouse].coords.enter.z + 0.2)
            SetEntityHeading(GetPlayerPed(-1), Config.Houses[CurrentHouse].coords.enter.h)
            inOwned = false
            TriggerEvent('cash-weeddrug:client:leaveHouse')
            --TriggerServerEvent('qb-houses:server:SetInsideMeta', house, false)
            CurrentHouse = nil
        end)
    end
end

RegisterNetEvent('qb-houses:client:setupHouseBlips')
AddEventHandler('qb-houses:client:setupHouseBlips', function()
    Citizen.CreateThread(function()
        Citizen.Wait(2000)
        if isLoggedIn then
            ESX.TriggerServerCallback('qb-houses:server:getOwnedHouses', function(ownedHouses)
                if ownedHouses ~= nil then
                    for k, v in pairs(ownedHouses) do
                        local house = Config.Houses[ownedHouses[k]]
                        HouseBlip = AddBlipForCoord(house.coords.enter.x, house.coords.enter.y, house.coords.enter.z)

                        SetBlipSprite (HouseBlip, 40)
                        SetBlipDisplay(HouseBlip, 4)
                        SetBlipScale  (HouseBlip, 0.65)
                        SetBlipAsShortRange(HouseBlip, true)
                        SetBlipColour(HouseBlip, 0)

                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentSubstringPlayerName(house.adress)
                        EndTextCommandSetBlipName(HouseBlip)

                        table.insert(OwnedHouseBlips, HouseBlip)
                    end
                end
            end)
        end
    end)
end)

RegisterNetEvent('qb-houses:client:SetClosestHouse')
AddEventHandler('qb-houses:client:SetClosestHouse', function()
    SetClosestHouse()
end)

function setViewCam(coords, h, yaw)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z, yaw, 0.00, h, 80.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    viewCam = true
end

function FrontDoorCam(coords)
    DoScreenFadeOut(150)
    Citizen.Wait(500)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z + 0.5, 0.0, 0.00, coords.h - 180, 80.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    FrontCam = true
    FreezeEntityPosition(GetPlayerPed(-1), true)
    Citizen.Wait(500)
    DoScreenFadeIn(150)
    SendNUIMessage({
        type = "frontcam",
        toggle = true,
        label = Config.Houses[closesthouse].adress
    })
    Citizen.CreateThread(function()
        while FrontCam do

            local instructions = CreateInstuctionScaleform("instructional_buttons")
            DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
            SetTimecycleModifier("scanline_cam_cheap")
            SetTimecycleModifierStrength(1.0)

            if IsControlJustPressed(1, Keys["BACKSPACE"]) then
                DoScreenFadeOut(150)
                SendNUIMessage({
                    type = "frontcam",
                    toggle = false,
                })
                Citizen.Wait(500)
                RenderScriptCams(false, true, 500, true, true)
                FreezeEntityPosition(GetPlayerPed(-1), false)
                SetCamActive(cam, false)
                DestroyCam(cam, true)
                ClearTimecycleModifier("scanline_cam_cheap")
                cam = nil
                FrontCam = false
                Citizen.Wait(500)
                DoScreenFadeIn(150)
            end

            local getCameraRot = GetCamRot(cam, 2)

            -- ROTATE UP
            if IsControlPressed(0, Keys["W"]) then
                if getCameraRot.x <= 0.0 then
                    SetCamRot(cam, getCameraRot.x + 0.7, 0.0, getCameraRot.z, 2)
                end
            end

            -- ROTATE DOWN
            if IsControlPressed(0, Keys["S"]) then
                if getCameraRot.x >= -50.0 then
                    SetCamRot(cam, getCameraRot.x - 0.7, 0.0, getCameraRot.z, 2)
                end
            end

            -- ROTATE LEFT
            if IsControlPressed(0, Keys["A"]) then
                SetCamRot(cam, getCameraRot.x, 0.0, getCameraRot.z + 0.7, 2)
            end

            -- ROTATE RIGHT
            if IsControlPressed(0, Keys["D"]) then
                SetCamRot(cam, getCameraRot.x, 0.0, getCameraRot.z - 0.7, 2)
            end

            Citizen.Wait(1)
        end
    end)
end

function CreateInstuctionScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    InstructionButton(GetControlInstructionalButton(1, 194, true))
    InstructionButtonMessage("Close Camera")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function InstructionButton(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function InstructionButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function disableViewCam()
    if viewCam then
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        viewCam = false
    end
end

RegisterNUICallback('buy', function()
    openContract(false)
    disableViewCam()
    TriggerServerEvent('qb-houses:server:buyHouse', closesthouse)
end)

RegisterNUICallback('exit', function()
    openContract(false)
    disableViewCam()
end)

RegisterCommand('closenui', function()
    openContract(false)
    disableViewCam()
end)

RegisterNetEvent('qb-houses:client:viewHouse')
AddEventHandler('qb-houses:client:viewHouse', function(houseprice, brokerfee, bankfee, taxes, firstname, lastname)
    setViewCam(Config.Houses[closesthouse].coords.cam, Config.Houses[closesthouse].coords.cam.h, Config.Houses[closesthouse].coords.yaw)
    Citizen.Wait(500)
    openContract(true)
    SendNUIMessage({
        type = "setupContract",
        firstname = firstname,
        lastname = lastname,
        street = Config.Houses[closesthouse].adress,
        houseprice = houseprice,
        brokerfee = brokerfee,
        bankfee = bankfee,
        taxes = taxes,
        totalprice = (houseprice + brokerfee + bankfee + taxes)
    })
end)

function SetClosestHouse()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil
    if not inside then
        for id, house in pairs(Config.Houses) do
            if current ~= nil then
                if(GetDistanceBetweenCoords(pos, Config.Houses[id].coords.enter.x, Config.Houses[id].coords.enter.y, Config.Houses[id].coords.enter.z, true) < dist)then
                    current = id
                    dist = GetDistanceBetweenCoords(pos, Config.Houses[id].coords.enter.x, Config.Houses[id].coords.enter.y, Config.Houses[id].coords.enter.z, true)
                end
            else
                dist = GetDistanceBetweenCoords(pos, Config.Houses[id].coords.enter.x, Config.Houses[id].coords.enter.y, Config.Houses[id].coords.enter.z, true)
                current = id
            end
        end
        closesthouse = current
    
        if closesthouse ~= nil then 
            ESX.TriggerServerCallback('qb-houses:server:hasKey', function(result)
                hasKey = result
            end, closesthouse)
        
            ESX.TriggerServerCallback('qb-houses:server:isOwned', function(result)
                isOwned = result
            end, closesthouse)
        end
    end
    TriggerEvent('cash-garagesystem:client:setHouseGarage', closesthouse, hasKey)
end

function setHouseLocations()
    if closesthouse ~= nil then
        ESX.TriggerServerCallback('qb-houses:server:getHouseLocations', function(result)
            if result ~= nil then
                if result.id ~= nil then
                    houseid = result.id
                    print(houseid)
                end
                if result.stash ~= nil then
                    stashLocation = json.decode(result.stash)
                end

                if result.outfit ~= nil then
                    outfitLocation = json.decode(result.outfit)
                end

                if result.logout ~= nil then
                    logoutLocation = json.decode(result.logout)
                end
            end
        end, closesthouse)
    end
end

RegisterNetEvent('qb-houses:client:setLocation')
AddEventHandler('qb-houses:client:setLocation', function(data)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local coords = {x = pos.x, y = pos.y, z = pos.z}

    --if inside then
        if hasKey then
            if data == 'setstash' then
                TriggerServerEvent('qb-houses:server:setLocation', coords, closesthouse, 1)
            elseif data == 'setoutift' then
                TriggerServerEvent('qb-houses:server:setLocation', coords, closesthouse, 2)
            elseif data == 'setlogout' then
                TriggerServerEvent('qb-houses:server:setLocation', coords, closesthouse, 3)
            end
        else
            ESX.ShowNotification('You are not the owner of the house..')
        end
   -- else    
       -- ESX.ShowNotification('You are not in a house..')
    --end
end)

RegisterCommand('setstash', function()
    TriggerEvent('qb-houses:client:setLocation', 'setstash')
end)

RegisterCommand('setoutfit', function()
    TriggerEvent('qb-houses:client:setLocation', 'setoutift')
end)

RegisterNetEvent('qb-houses:client:refreshLocations')
AddEventHandler('qb-houses:client:refreshLocations', function(house, location, type)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)

    if closesthouse == house then
        if inside then
            if type == 1 then
                stashLocation = json.decode(location)
            elseif type == 2 then
                outfitLocation = json.decode(location)
            elseif type == 3 then
                logoutLocation = json.decode(location)
            end
        end
    end
end)

local RamsDone = 0

function DoRamAnimation(bool)
    local ped = GetPlayerPed(-1)
    local dict = "missheistfbi3b_ig7"
    local anim = "lift_fibagent_loop"

    if bool then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(1)
        end
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 1, -1, false, false, false)
    else
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(1)
        end
        TaskPlayAnim(ped, dict, "exit", 8.0, 8.0, -1, 1, -1, false, false, false)
    end
end

RegisterNetEvent('qb-houses:client:HomeInvasion')
AddEventHandler('qb-houses:client:HomeInvasion', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)

    if closesthouse ~= nil then
        ESX.TriggerServerCallback('police:server:IsPoliceForcePresent', function(IsPresent)
            if IsPresent then
                local dist = GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true)
                if Config.Houses[closesthouse].IsRaming == nil then
                    Config.Houses[closesthouse].IsRaming = false
                end
        
                if dist < 1 then
                    if Config.Houses[closesthouse].locked then
                        if not Config.Houses[closesthouse].IsRaming then
                            DoRamAnimation(true)
                                if RamsDone + 1 >= Config.RamsNeeded then
                                    TriggerServerEvent('qb-houses:server:lockHouse', false, closesthouse)
                                    ESX.ShowNotification('It worked, the door is now out.')
                                    TriggerServerEvent('qb-houses:server:SetHouseRammed', true, closesthouse)
                                    DoRamAnimation(false)
                                else
                                RamsDone = 0
                                TriggerServerEvent('qb-houses:server:SetRamState', false, closesthouse)
                                ESX.ShowNotification('It failed .. Please try again.')
                                DoRamAnimation(false)
                            end
                            TriggerServerEvent('qb-houses:server:SetRamState', true, closesthouse)
                        else
                            ESX.ShowNotification('Someone is already working on the door..')
                        end
                    else
                        ESX.ShowNotification('This house is already open..')
                    end
                else
                    ESX.ShowNotification('You\'re not near a house..')
                end
            else
                ESX.ShowNotification('There is no police force present..')
            end
        end)
    else
        ESX.ShowNotification('You\'re not near a house..')
    end
end)

RegisterNetEvent('qb-houses:client:SetRamState')
AddEventHandler('qb-houses:client:SetRamState', function(bool, house)
    Config.Houses[house].IsRaming = bool
end)

RegisterNetEvent('qb-houses:client:SetHouseRammed')
AddEventHandler('qb-houses:client:SetHouseRammed', function(bool, house)
    Config.Houses[house].IsRammed = bool
end)

RegisterNetEvent('qb-houses:client:ResetHouse')
AddEventHandler('qb-houses:client:ResetHouse', function()
    local ped = GetPlayerPed(-1)

    if closesthouse ~= nil then
        if Config.Houses[closesthouse].IsRammed == nil then
            Config.Houses[closesthouse].IsRammed = false
            TriggerServerEvent('qb-houses:server:SetHouseRammed', false, closesthouse)
            TriggerServerEvent('qb-houses:server:SetRamState', false, closesthouse)
        end
        if Config.Houses[closesthouse].IsRammed then
            openHouseAnim()
            TriggerServerEvent('qb-houses:server:SetHouseRammed', false, closesthouse)
            TriggerServerEvent('qb-houses:server:SetRamState', false, closesthouse)
            TriggerServerEvent('qb-houses:server:lockHouse', true, closesthouse)
            RamsDone = 0
            ESX.ShowNotification('You locked the house again..')
        else
            ESX.ShowNotification('This door is not broken open..')
        end
    end
end)


function OpenStash(identifier, motel, room)
    TriggerEvent('ev-inventory:MotelBed', ' House Storage')
end
  
function OpenInv(owner, motel, room)
    TriggerEvent('ev-inventory:MotelBed', ' House Storage')
end