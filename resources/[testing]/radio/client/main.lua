-- Disable controls while GUI open
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
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

function closeGui()
  TriggerEvent("InteractSound_CL:PlayOnOne","radioclick",0.6)
  GuiOpened = false
  SetCustomNuiFocus(false,false)
  SendNUIMessage({open = false})
  TriggerEvent("animation:radio",GuiOpened)
end

function openGui()
  local radio = hasRadio()
  local incall = false
  if (incall) then
    TriggerEvent("notification","You can not do that while in a call!",2)
    return
  end
  local job = PlayerData.job.name
  local Emergency = false
  if job == "police" then
    Emergency = true
  elseif job == "ambulance" then
    Emergency = true
  end
  
  if not GuiOpened and radio then
    GuiOpened = true
    SetCustomNuiFocus(false,false)
    SetCustomNuiFocus(true,true)
    SendNUIMessage({open = true, jobType = Emergency})
  else
    GuiOpened = false
    SetCustomNuiFocus(false,false)
    SendNUIMessage({open = false, jobType = Emergency})
  end
  TriggerEvent("animation:radio",GuiOpened)
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

RegisterNUICallback('volumeUp', function(data, cb)
  exports["dsrp-voice"]:IncreaseRadioVolume()
  cb('ok')
end)

RegisterNUICallback('volumeDown', function(data, cb)
  exports["dsrp-voice"]:DecreaseRadioVolume()
  cb('ok')
end)

RegisterNUICallback('cleanClose', function(data, cb)
  closeGui()
  cb('ok')
end)

local function handleConnectionEvent(pChannel)
  local newChannel = formattedChannelNumber(pChannel)

  if newChannel < 1.0 then
    TriggerServerEvent("lol:voice:radio:removePlayerFromRadio", newChannel)
  else
    TriggerServerEvent("lol:voice:radio:addPlayerToRadio", newChannel, true)
  end
end

RegisterNUICallback('poweredOn', function(data, cb)
  TriggerEvent("InteractSound_CL:PlayOnOne","radioon",0.6)
  exports["dsrp-voice"]:SetRadioPowerState(true)
  cb('ok')
end)

RegisterNUICallback('poweredOff', function(data, cb)
  TriggerEvent("InteractSound_CL:PlayOnOne","radiooff",0.6)
  exports["dsrp-voice"]:SetRadioPowerState(false)
  cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
  handleConnectionEvent(data.channel)
  closeGui()
  cb('ok')
end)


RegisterNetEvent('animation:radio')
AddEventHandler('animation:radio', function(enable)
  TriggerEvent("destroyPropRadio")
  local lPed = PlayerPedId()
  inPhone = enable

  RequestAnimDict("cellphone@")
  while not HasAnimDictLoaded("cellphone@") do
    Citizen.Wait(0)
  end

  local intrunk = false
  if not intrunk then
    TaskPlayAnim(lPed, "cellphone@", "cellphone_text_in", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
  end
  Citizen.Wait(300)
  if inPhone then
    TriggerEvent("attachItemRadio","radio01")
    Citizen.Wait(150)
    while inPhone do

      local dead = exports["ambulancejob"]:GetDeath()
      if dead then
        closeGui()
        inPhone = false
      end
      local intrunk = false
      if not intrunk and not IsEntityPlayingAnim(lPed, "cellphone@", "cellphone_text_read_base", 3) and not IsEntityPlayingAnim(lPed, "cellphone@", "cellphone_swipe_screen", 3) then
        TaskPlayAnim(lPed, "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
      end    
      Citizen.Wait(500)
    end
    local intrunk = false
    if not intrunk then
      ClearPedTasks(PlayerPedId())
    end
  else
    local intrunk = false
    if not intrunk then
      Citizen.Wait(100)
      ClearPedTasks(PlayerPedId())
      TaskPlayAnim(lPed, "cellphone@", "cellphone_text_out", 2.0, 1.0, 5.0, 49, 0, 0, 0, 0)
      Citizen.Wait(400)
      TriggerEvent("destroyPropRadio")
      Citizen.Wait(400)
      ClearPedTasks(PlayerPedId())
    else
      TriggerEvent("destroyPropRadio")
    end
  end
  TriggerEvent("destroyPropRadio")
end)

Citizen.CreateThread(function()

  while true do
    if GuiOpened then
      Citizen.Wait(1)
      DisableControlAction(0, 1, GuiOpened) -- LookLeftRight
      DisableControlAction(0, 2, GuiOpened) -- LookUpDown
      DisableControlAction(0, 14, GuiOpened) -- INPUT_WEAPON_WHEEL_NEXT
      DisableControlAction(0, 15, GuiOpened) -- INPUT_WEAPON_WHEEL_PREV
      DisableControlAction(0, 16, GuiOpened) -- INPUT_SELECT_NEXT_WEAPON
      DisableControlAction(0, 17, GuiOpened) -- INPUT_SELECT_PREV_WEAPON
      DisableControlAction(0, 99, GuiOpened) -- INPUT_VEH_SELECT_NEXT_WEAPON
      DisableControlAction(0, 100, GuiOpened) -- INPUT_VEH_SELECT_PREV_WEAPON
      DisableControlAction(0, 115, GuiOpened) -- INPUT_VEH_FLY_SELECT_NEXT_WEAPON
      DisableControlAction(0, 116, GuiOpened) -- INPUT_VEH_FLY_SELECT_PREV_WEAPON
      DisableControlAction(0, 142, GuiOpened) -- MeleeAttackAlternate
      DisableControlAction(0, 106, GuiOpened) -- VehicleMouseControlOverride
    else
      Citizen.Wait(20)
    end    
  end
end)



function SetCustomNuiFocus(hasKeyboard, hasMouse)
  HasNuiFocus = hasKeyboard or hasMouse

  SetNuiFocus(hasKeyboard, hasMouse)
  SetNuiFocusKeepInput(HasNuiFocus)

  TriggerEvent("lol:voice:focus:set", HasNuiFocus, hasKeyboard, hasMouse)
end

