--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
ESX                         = nil
inMenu                      = true
local showblips = true
local atbank = false
local inATM = false
local sleeper = 0
local bankMenu = true
local banks = {
}	

local atm_models = {"prop_fleeca_atm", "prop_atm_01", "prop_atm_02", "prop_atm_03"}

--================================================================================================
--==                                THREADING - DO NOT EDIT                                     ==
--================================================================================================

--===============================================
--==           Base ESX Threading              ==
--===============================================
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)





--===============================================
--==             Core Threading                ==
--===============================================
if bankMenu then
	Citizen.CreateThread(function()
  while true do
    Wait(0)
	if nearBank() then
			DisplayHelpText("Press ~INPUT_PICKUP~ to access the bank ~b~")
	
		if IsControlJustPressed(1, 38) then
			inMenu = true
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'openGeneral'})
			TriggerServerEvent('bank:balance')
			local ped = GetPlayerPed(-1)
		end
	end
        
    if IsControlJustPressed(1, 322) then
	  inMenu = false
      SetNuiFocus(false, false)
      SendNUIMessage({type = 'close'})
    end
	end
  end)
end


--===============================================
--==             Map Blips	                   ==
--===============================================

Citizen.CreateThread(function()
	if showblips then
	  for k,v in ipairs(banks)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, v.id)
		SetBlipScale(blip, 0.7)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(tostring(v.name))
		EndTextCommandSetBlipName(blip)
	  end
  end
  while true do
    sleeper = 1000
    local ped = GetPlayerPed(PlayerId())
    local pedPos = GetEntityCoords(ped, false)
    Citizen.Wait(sleeper)
  end
end)

function CloseATM()

  local pedPos = GetEntityCoords(GetPlayerPed(PlayerId()), false)
  local pedHead = GetEntityHeading(GetPlayerPed(PlayerId()))
  TaskStartScenarioAtPosition(GetPlayerPed(PlayerId()), "PROP_HUMAN_ATM", pedPos.x, pedPos.y, pedPos.z + 1.0, pedHead, 0, 0, 0)
  local finished = exports["sway_taskbar"]:taskBar(3500, "Removing Card")
  if finished == 100 then
    
      ClearPedTasksImmediately(GetPlayerPed(PlayerId()))
    else
      -- Do Something If Action Was Cancelled
    end
end


--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNetEvent('stcurrentbalance1')
AddEventHandler('stcurrentbalance1', function(balance)
	local id = PlayerId()
	local playerName = GetPlayerName(id)
	
	SendNUIMessage({
		type = "balanceHUD",
		balance = balance,
		player = playerName
		})
end)
--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNUICallback('stdeposit', function(data)
	TriggerServerEvent('bank:dAVACeposit', tonumber(data.amount))
end)

--===============================================
--==          Withdraw Event                   ==
--===============================================
RegisterNUICallback('stwithdrawl', function(data)
	TriggerServerEvent('bank:withdAVACraw', tonumber(data.amountw))
end)

--===============================================
--==         Balance Event                     ==
--===============================================
RegisterNUICallback('stbalance', function()
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('stbalance:back')
AddEventHandler('stbalance:back', function(balance)

	SendNUIMessage({type = 'balanceReturn', bal = balance})

end)


--===============================================
--==         Transfer Event                    ==
--===============================================
RegisterNUICallback('sttransfer', function(data)
	TriggerServerEvent('bank:traAVACnsfer', data.to, data.amountt)
	
end)




--===============================================
--==               NUIFocusoff                 ==
--===============================================
RegisterNUICallback('NUIFocusOff', function()
  inMenu = false
  SetNuiFocus(false, false)
  SendNUIMessage({type = 'closeAll'})
  if inATM then
    inATM = false
    CloseATM()
  end
end)


--===============================================
--==            Capture Bank Distance          ==
--===============================================
function nearBank()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)
	
	for _, search in pairs(banks) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
		
		if distance <= 1 then
			return true
		end
	end
end

function nearATM()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)
	
	for _, search in pairs(atms) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
		
		if distance <= 3 then
			return true
		end
	end
end


function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--===============================================
--==              Cash & Bank HUD              ==
--===============================================

-- listeners
RegisterNetEvent("es:addedMoney")
AddEventHandler("es:addedMoney", function(m, native, current)
	TriggerEvent("st-banking:updateCash", current)
  TriggerEvent("st-banking:addCash", m)
end)



-- nuis
--bank
RegisterNetEvent('st-banking:updateBank')
AddEventHandler('st-banking:updateBank', function(balance, show)
  local id = PlayerId()
  local playerName = GetPlayerName(id)
	SendNUIMessage({
		updateBank = true,
		bank = balance,
    player = playerName,
    show = show
	})
end)

RegisterNetEvent("st-banking:addBank")
AddEventHandler("st-banking:addBank", function(amount)
	SendNUIMessage({
		addBank = true,
		amount = amount
	})
end)

RegisterNetEvent("st-banking:removeBank")
AddEventHandler("st-banking:removeBank", function(amount)
	SendNUIMessage({
		removeBank = true,
		amount = amount
	})
end)

RegisterNetEvent("st-banking:viewBank")
AddEventHandler("st-banking:viewBank", function()
  SendNUIMessage({
    viewBank = true
  })
end)

--cash
RegisterNetEvent('st-banking:updateCash')
AddEventHandler('st-banking:updateCash', function(balance, show)
  local id = PlayerId()
  local playerName = GetPlayerName(id)
	SendNUIMessage({
		updateCash = true,
		cash = balance,
    show = show
	})
end)

RegisterNetEvent("st-banking:addCash")
AddEventHandler("st-banking:addCash", function(amount)
	SendNUIMessage({
		addCash = true,
		amount = amount
	})
end)

RegisterNetEvent("st-banking:removeCash")
AddEventHandler("st-banking:removeCash", function(amount)
	SendNUIMessage({
		removeCash = true,
		amount = amount
	})
end)


RegisterNetEvent("st-banking:viewCash")
AddEventHandler("st-banking:viewCash", function()
  SendNUIMessage({
		viewCash = true
	})
end)

function DrawText3Ds(x,y,z, text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local p = GetGameplayCamCoords()
  local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
  local scale = (1 / distance) * 2
  local fov = (1 / GetGameplayCamFov()) * 100
  local scale = scale * fov
  if onScreen then
    SetTextScale(0.30, 0.30)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0120, factor, 0.026, 41, 11, 41, 68)
  end
end