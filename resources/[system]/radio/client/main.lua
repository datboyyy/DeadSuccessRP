ESX = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
		Wait(500)
	end

	while ESX.GetPlayerData().job == nil do
		Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local GuiOpened = false


RegisterNetEvent('radioGui')
AddEventHandler('radioGui', function()
  openGui()
end)

RegisterNetEvent('ChannelSet')
AddEventHandler('ChannelSet', function(chan)
    SendNUIMessage({set = true, setChannel = chan})
end)

RegisterNetEvent('radio:resetNuiCommand')
AddEventHandler('radio:resetNuiCommand', function()
    SendNUIMessage({reset = true})
end)

local function formattedChannelNumber(number)
    local power = 10 ^ 1
    return math.floor(number * power) / power
end

function openGui()
    local radio = hasRadio()
    local job = ESX.PlayerData.job.name
    local Emergency = false
    --TriggerEvent("attachItemRadio", "radio01")
    TriggerEvent('RadioAnim')
    if job == "police" then
        Emergency = true
    elseif job == "ems" then
        Emergency = true
    end

    if not GuiOpened and radio then
        GuiOpened = true
        SetCustomNuiFocus(false, false)
        SetCustomNuiFocus(true, true)
        SendNUIMessage({open = true, jobType = Emergency})
    else
        GuiOpened = false
        SetCustomNuiFocus(false, false)
        SendNUIMessage({open = false, jobType = Emergency})
        --removeAttachedPropRadio()
    end
end

function hasRadio()
    if exports["dsrp-inventory"]:hasEnoughOfItem("radio",1,false) then
      return true
    else
      return false
    end
end
RegisterNUICallback('click', function(data, cb)
    PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    cb('ok')
end)

RegisterNUICallback('cleanClose', function(data, cb)
    GuiOpened = false
    SetCustomNuiFocus(false, false)
    SendNUIMessage({open = false})
    TriggerEvent('RadioAnimClose')
    TriggerEvent('disc-inventoryhud:DisableHotKeys', false)
    --removeAttachedPropRadio()
    cb('ok')
end)


local function handleConnectionEvent(pChannel)
    local PlayerData = ESX.GetPlayerData(_source)
    if type(pChannel) == 'number' then
        local newChannel = formattedChannelNumber(pChannel)
        if pChannel <= 4.0 then
            if (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'mechanic') then
               -- exports["mumble-voip"]:SetRadioChannel(newChannel)
                TriggerServerEvent('np-voice:addtoradio', newChannel)
                exports['mythic_notify']:SendAlert('inform', 'Connected to ' .. newChannel .. ' MHz </b>')
    			TriggerEvent("InteractSound_CL:PlayOnOne", "radioclick", 0.6)
            else
                exports['mythic_notify']:SendAlert('error', 'You cannot join encrypted radio channels')
            end
        else
            if pChannel <= 100 then
                TriggerServerEvent('np-voice:addtoradio', newChannel)--Set Radio Channel to 0 (off)
                print('Channel:' .. newChannel)
                TriggerServerEvent('np:voice:radio:power', true)
              --  exports["mumble-voip"]:SetMumbleProperty("radioEnabled", true)-- Set you ass not being on a radio channel (no [Radio] Mhz on bottom either)
                exports['mythic_notify']:SendAlert('inform', 'Connected to ' .. newChannel .. ' MHz </b>')
--   				TriggerEvent("InteractSound_CL:PlayOnOne", "radioclick", 0.6)
            else
                exports['mythic_notify']:SendAlert('error', 'Invalid Frequency ( 0.00 - 99.99 )')
            end
        end
    end
end
RegisterNUICallback('poweredOn', function(data, cb)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'radioon', 0.6)
    handleConnectionEvent(data.channel)
    print('Radio on setitng channel' .. data.channel)
    cb('ok')
end)

RegisterNUICallback('poweredOff', function(data, cb)
    --exports["mumble-voip"]:SetRadioChannel(0)
    TriggerServerEvent('np:voice:radio:removed', 0)--Set Radio Channel to 0 (off)
    TriggerServerEvent('np:voice:radio:power', false)-- Set you ass not being on a radio channel (no [Radio] Mhz on bottom either)
    print('powered off setting channel to 0 and radioenabled off')
    TriggerEvent('InteractSound_CL:PlayOnOne', 'radiooff', 1.0)
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    handleConnectionEvent(data.channel)
    GuiOpened = false
    SetCustomNuiFocus(false, false)
    SendNUIMessage({open = false})
    TriggerEvent('RadioAnimClose')
    print(data.channel)
    --removeAttachedPropRadio()
    cb('ok')
end)

Citizen.CreateThread(function()
    while true do
        if GuiOpened then
            Citizen.Wait(1)
            DisableControlAction(0, 1, GuiOpened)-- LookLeftRight
            DisableControlAction(0, 2, GuiOpened)-- LookUpDown
            DisableControlAction(0, 14, GuiOpened)-- INPUT_WEAPON_WHEEL_NEXT
            DisableControlAction(0, 15, GuiOpened)-- INPUT_WEAPON_WHEEL_PREV
            DisableControlAction(0, 16, GuiOpened)-- INPUT_SELECT_NEXT_WEAPON
            DisableControlAction(0, 17, GuiOpened)-- INPUT_SELECT_PREV_WEAPON
            DisableControlAction(0, 99, GuiOpened)-- INPUT_VEH_SELECT_NEXT_WEAPON
            DisableControlAction(0, 100, GuiOpened)-- INPUT_VEH_SELECT_PREV_WEAPON
            DisableControlAction(0, 115, GuiOpened)-- INPUT_VEH_FLY_SELECT_NEXT_WEAPON
            DisableControlAction(0, 116, GuiOpened)-- INPUT_VEH_FLY_SELECT_PREV_WEAPON
            DisableControlAction(0, 142, GuiOpened)-- MeleeAttackAlternate
            DisableControlAction(0, 106, GuiOpened)-- VehicleMouseControlOverride
        else
            Citizen.Wait(20)
        end
    end
end)

function SetCustomNuiFocus(hasKeyboard, hasMouse)
    HasNuiFocus = hasKeyboard or hasMouse
    
    SetNuiFocus(hasKeyboard, hasMouse)
    SetNuiFocusKeepInput(HasNuiFocus)
    
    if HasNuiFocus then
        Citizen.CreateThread(function()
            while HasNuiFocus do
                if hasKeyboard then
                    DisableAllControlActions(0)
                    EnableControlAction(0, 249, true)
                end
                
                if not hasKeyboard and hasMouse then
                    DisableControlAction(0, 1, true)
                    DisableControlAction(0, 2, true)
                elseif hasKeyboard and not hasMouse then
                    EnableControlAction(0, 1, true)
                    EnableControlAction(0, 2, true)
                end
                
                Citizen.Wait(0)
            end
        end)
    end
end

--[[attachPropList = {
    ["radio01"] = {
        ["model"] = "prop_cs_hand_radio", ["bone"] = 57005, ["x"] = 0.14, ["y"] = 0.01, ["z"] = -0.02, ["xR"] = 110.0, ["yR"] = 120.0, ["zR"] = -15.0
    }

}

RegisterNetEvent('attachItemRadio')
AddEventHandler('attachItemRadio', function(item)
    TriggerEvent("attachPropRadio", attachPropList[item]["model"], attachPropList[item]["bone"], attachPropList[item]["x"], attachPropList[item]["y"], attachPropList[item]["z"], attachPropList[item]["xR"], attachPropList[item]["yR"], attachPropList[item]["zR"])
end)]]--

-- Radio
--[[attachedPropRadio = 0
function removeAttachedPropRadio()
    if DoesEntityExist(attachedPropRadio) then
        DeleteEntity(attachedPropRadio)
        attachedPropRadio = 0
    end
end]]--

RegisterNetEvent('destroyPropRadio')
AddEventHandler('destroyPropRadio', function()
    --removeAttachedPropRadio()
end)

RegisterNetEvent('attachPropRadio')
AddEventHandler('attachPropRadio', function(attachModelSent, boneNumberSent, x, y, z, xR, yR, zR)
   -- removeAttachedPropRadio()
    attachModelRadio = GetHashKey(attachModelSent)
    boneNumber = boneNumberSent
    SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
    local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
    RequestModel(attachModelRadio)
    while not HasModelLoaded(attachModelRadio) do
        Citizen.Wait(100)
    end
    if not IsPedInAnyVehicle(PlayerPedId(), true) then
       ---- attachedPropRadio = CreateObject(attachModelRadio, 1.0, 1.0, 1.0, 1, 1, 0)
        --AttachEntityToEntity(attachedPropRadio, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 0, 0, 0, 2, 1)
    end
end)

RegisterNetEvent('RadioAnim')
AddEventHandler('RadioAnim', function()
    local lPed = PlayerPedId()
    RequestAnimDict("cellphone@")
    while not HasAnimDictLoaded("cellphone@") do
        Citizen.Wait(0)
    end
    if not IsPedInAnyVehicle(PlayerPedId(), true) then
        TaskPlayAnim(lPed, "cellphone@", "cellphone_text_in", 4.0, -1, -1, 50, 0, false, false, false)
    end
end)
RegisterNetEvent('RadioAnimClose')
AddEventHandler('RadioAnimClose', function()
    local lPed = PlayerPedId()
    RequestAnimDict("cellphone@")
    while not HasAnimDictLoaded("cellphone@") do
        Citizen.Wait(0)
    end
    if not IsPedInAnyVehicle(PlayerPedId(), true) then
        TaskPlayAnim(lPed, "cellphone@", "cellphone_text_out", 4.0, -1, -1, 50, 0, false, false, false)
        Wait(500)
      --  TriggerEvent("destroyPropRadio")
        ClearPedTasksImmediately(lPed)
      --  removeAttachedPropRadio()
    end
end)

RegisterNetEvent('manshasnoradio')
AddEventHandler('manshasnoradio', function()
    TriggerServerEvent('np:voice:radio:removed', 0)--Set Radio Channel to 0 (off)
    TriggerServerEvent('np:voice:radio:power', false)--- Set you ass not being on a radio channel (no [Radio] Mhz on bottom either)
end)


RegisterCommand('+setvolume', function()
    local volume = 0.5 + 0.1
    TriggerEvent('np:voice:radio:volume', volume)
end, false)
RegisterCommand('-setvolume', function()
    local volume = 0.5 - 0.1
    TriggerEvent('np:voice:radio:volume', volume)
end, false)