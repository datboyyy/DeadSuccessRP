ESX = nil

showstatushud = true

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

local currentValues = {
    ["health"] = 100,
    ["armor"] = 100,
    ["hunger"] = 100,
    ["thirst"] = 100,
    ["oxy"] = 100,
    ["stress"] = 100,
    ["voice"] = 2,
    ["dev"] = false,
    ["devdebug"] = false,
    ["is_talking"] = false
}

Citizen.CreateThread(function()
    while true do
        
        if HasPedGotWeapon(PlayerPedId(), `gadget_parachute`, false) then
            Parachute = true
        else
            Parachute = false
        end

		Citizen.Wait(300)
		TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
			TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
                --TriggerEvent('esx_status:getStatus', 'stress', function(stress)

					SendNUIMessage({
                        type = "updateStatusHudstate",
                        show = showstatushud,
						hasParachute = Parachute,
						varSetHunger = hunger.getPercent(),
						varSetThirst = thirst.getPercent(),
						varSetStress = 0 --stress.getPercent()
					})
				--end)
			end)
        end)
        Citizen.Wait(5000)
	end
end)

fuckerspawned = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if (not IsPedInAnyVehicle(PlayerPedId(), false)) then
            DisplayRadar(0)
        else
            DisplayRadar(1)
        end
        if fuckerspawned == true then
            
            local player = PlayerPedId()
            local id = PlayerId()
            local health = (GetEntityHealth(player) - 100)
            local armor = GetPedArmour(player)
            local oxy = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 18 / 4
            SendNUIMessage({
                type = "updateStatusHud",
                show = showstatushud,
                varSetHealth = health,
                varSetArmor = armor,
                varSetOxy = oxy,
                colorblind = colorblind,
                varSetVoice = currentValues["voice"],
                varDev = 0,
                varDevDebug = 0,
                is_talking = IsControlPressed(0, 306)
            })
            Citizen.Wait(500)
        end
    end
end)

-- Show hud command
RegisterCommand('hud', function(source, args, rawCommand)
    if showstatushud then
        showstatushud = false
    else
        showstatushud = true
        fuckerspawned(true)
    end
end)

function fuckerspawned()
    fuckerspawned = true
end

-- Parachute Item
RegisterNetEvent('useparachute')
AddEventHandler('useparachute', function()
    if not HasPedGotWeapon(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), false) then
        giveParachute()
    -- Alttaki event paraşüt itemini removeliyor
    --TriggerServerEvent('parachute:equip')
    else
        TriggerEvent('notification', 'You already have a parachute', 2)
    end
end)

function giveParachute()
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
end


Citizen.CreateThread(function ()
    while true do
        local isTalking = NetworkIsPlayerTalking(PlayerId())

        if isTalking and not currentValues["is_talking"] then
            SendNUIMessage({type = "talkingStatus", is_talking = true})
        elseif not isTalking and currentValues["is_talking"] then
            SendNUIMessage({type = "talkingStatus", is_talking = false})
        end

        currentValues["is_talking"] = isTalking

        Citizen.Wait(100)
    end
end)


RegisterNetEvent("hud:changeRange")
AddEventHandler("hud:changeRange", function(pRange)
    currentValues["voice"] = pRange or 2
end)
RegisterNetEvent("hud:talkonradio")
AddEventHandler("hud:talkonradio", function(talk)
    if talk == true then 
    SendNUIMessage({type = "radiostatus", radiotalk = true})
    else 
    SendNUIMessage({type = "radiostatus", radiotalk = false})
    end
end)


local HUD_ELEMENTS = {
    HUD = {id = 0, hidden = false},
    HUD_WANTED_STARS = {id = 1, hidden = true},
    HUD_WEAPON_ICON = {id = 2, hidden = false},
    HUD_CASH = {id = 3, hidden = true},
    HUD_MP_CASH = {id = 4, hidden = true},
    HUD_MP_MESSAGE = {id = 5, hidden = true},
    HUD_VEHICLE_NAME = {id = 6, hidden = true},
    HUD_AREA_NAME = {id = 7, hidden = true},
    HUD_VEHICLE_CLASS = {id = 8, hidden = true},
    HUD_STREET_NAME = {id = 9, hidden = true},
    HUD_HELP_TEXT = {id = 10, hidden = false},
    HUD_FLOATING_HELP_TEXT_1 = {id = 11, hidden = false},
    HUD_FLOATING_HELP_TEXT_2 = {id = 12, hidden = false},
    HUD_CASH_CHANGE = {id = 13, hidden = true},
    HUD_SUBTITLE_TEXT = {id = 15, hidden = false},
    HUD_RADIO_STATIONS = {id = 16, hidden = false},
    HUD_SAVING_GAME = {id = 17, hidden = false},
    HUD_GAME_STREAM = {id = 18, hidden = false},
    HUD_WEAPON_WHEEL = {id = 19, hidden = false},
    HUD_WEAPON_WHEEL_STATS = {id = 20, hidden = false},
    MAX_HUD_COMPONENTS = {id = 21, hidden = false},
    MAX_HUD_WEAPONS = {id = 22, hidden = false},
    MAX_SCRIPTED_HUD_COMPONENTS = {id = 141, hidden = false}
}

-- Parameter for hiding radar when not in a vehicle
local HUD_HIDE_RADAR_ON_FOOT = true

-- Main thread
Citizen.CreateThread(function()
        -- Loop forever and update HUD every frame
        while true do
            Citizen.Wait(0)
            
            -- If enabled only show radar when in a vehicle (use a zoomed out view)
            if HUD_HIDE_RADAR_ON_FOOT then
                local player = GetPlayerPed(-1)
                -- DisplayRadar(IsPedInAnyVehicle(player, false))
                SetRadarZoomLevelThisFrame(100.0)
            end
            
            -- Hide other HUD components
            for key, val in pairs(HUD_ELEMENTS) do
                if val.hidden then
                    HideHudComponentThisFrame(val.id)
                else
                    ShowHudComponentThisFrame(val.id)
                end
            end
        end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        HideHudComponentThisFrame(14)-- hide crosshair
    end
end)
