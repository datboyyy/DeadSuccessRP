ESX          = nil
local IsDead = false
local IsAnimated = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('esx_status:set', 'hunger', 500000)
	TriggerEvent('esx_status:set', 'thirst', 500000)
end)

RegisterNetEvent('esx_basicneeds:healPlayer')
AddEventHandler('esx_basicneeds:healPlayer', function()
	-- restore hunger & thirst & stress 
	TriggerEvent('esx_status:set', 'hunger', 1000000)
	TriggerEvent('esx_status:set', 'thirst', 1000000)
	TriggerEvent('esx_status:set', 'stress', 0)

	-- restore hp
	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	if IsDead then
		TriggerEvent('esx_basicneeds:resetStatus')
	end

	IsDead = false
end)

AddEventHandler('esx_status:loaded', function(status)

	TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#CFAD0F', function(status)
		return true
	end, function(status)
		status.remove(100)
	end)

	TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#0C98F1', function(status)
		return true
	end, function(status)
		status.remove(75)
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)

			local playerPed  = PlayerPedId()
			local prevHealth = GetEntityHealth(playerPed)
			local health     = prevHealth

			TriggerEvent('esx_status:getStatus', 'hunger', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				end
			end)

			TriggerEvent('esx_status:getStatus', 'thirst', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				end
			end)

			if health ~= prevHealth then
				SetEntityHealth(playerPed, health)
			end
		end
	end)
end)

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)



RegisterNetEvent('esx_basicneeds:onEatBurger')
AddEventHandler('esx_basicneeds:onEatBurger', function()
	local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
	local itemid = 'hamburger'
	AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating",itemid)
end)

RegisterNetEvent('esx_basicneeds:onEatHotDog')
AddEventHandler('esx_basicneeds:onEatHotDog', function()
	local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
	local itemid = 'hotdog'
	AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating",itemid)
end)


RegisterNetEvent('esx_basicneeds:onEatSandWich')
AddEventHandler('esx_basicneeds:onEatSandWich', function()
	local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
	local itemid = 'sandwich'
	AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating",itemid)
end)
RegisterNetEvent('esx_basicneeds:onEatDonut')
AddEventHandler('esx_basicneeds:onEatDonut', function()
	local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
	local itemid = 'donut'
	AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating",itemid)
end)
RegisterNetEvent('esx_basicneeds:onEatTaco')
AddEventHandler('esx_basicneeds:onEatTaco', function()
	local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
	local itemid = 'taco'
	AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating",itemid)
end)

RegisterNetEvent('esx_basicneeds:onEatHotDog')
AddEventHandler('esx_basicneeds:onEatHotDog', function()
	local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
	local itemid = 'hotdog'
	AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating",itemid)
end)



RegisterNetEvent('esx_basicneeds:onDrinkWater')
AddEventHandler('esx_basicneeds:onDrinkWater', function(prop_name)
	local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
	local itemid = 'water'
	AttachPropAndPlayAnimation("amb@world_human_drinking@beer@female@idle_a", "idle_e", 49,6000,"Drinking",itemid)
end)
RegisterNetEvent('esx_basicneeds:onDrinkSoda')
AddEventHandler('esx_basicneeds:onDrinkSoda', function(prop_name)
	local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
	local itemid = 'cola'
	AttachPropAndPlayAnimation("amb@world_human_drinking@beer@female@idle_a", "idle_e", 49,6000,"Drinking",itemid)
end)
RegisterNetEvent('esx_basicneeds:onDrinkGreenCow')
AddEventHandler('esx_basicneeds:onDrinkGreenCow', function(prop_name)
	local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
	local itemid = 'greencow'
	AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drinking",itemid)
end)

RegisterNetEvent('esx_basicneeds:onAlchohal')
AddEventHandler('esx_basicneeds:onAlchohal', function(prop_name)
	local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
	local itemid = 'beer'
	AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drinking",itemid)
end)



RegisterNetEvent('esx_basicneeds:onDrunk')
AddEventHandler('esx_basicneeds:onDrunk', function()
local playerPed = GetPlayerPed(-1)
DoScreenFadeOut(400)
Wait(500)
DoScreenFadeIn(300)
	SetTimecycleModifier("spectator5")
    SetPedMotionBlur(playerPed, true)
	SetPedIsDrunk(playerPed, true)
	RequestAnimSet("move_m@drunk@verydrunk")
      
	while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
	  Citizen.Wait(0)
	end

	SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)
	Wait(60000)
--clear drunk
DoScreenFadeOut(400)
	Wait(1000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(playerPed, 0)
    SetPedIsDrunk(playerPed, false)
	SetPedMotionBlur(playerPed, false)
	ResetPedMovementClipset(playerPed, 0)

    DoScreenFadeIn(300)
end)


function AttachPropAndPlayAnimation(dictionary,animation,typeAnim,timer,message,itemid)
    if itemid == "hamburger" or itemid == "heartstopper" or itemid == "bleederburger" then
        TriggerEvent("attachItem", "hamburger")
    elseif itemid == "sandwich" then
		TriggerEvent("attachItem", "sandwich")
	elseif itemid == "hotdog" then
        TriggerEvent("attachItem", "hotdog")
    elseif itemid == "donut" then
        TriggerEvent("attachItem", "donut")
    elseif itemid == "water" or itemid == "cola" or itemid == "vodka" or itemid == "whiskey" or itemid == "beer" or itemid == "coffee" then
        TriggerEvent("attachItem", itemid)
    elseif itemid == "fishtaco" or itemid == "taco" then
        TriggerEvent("attachItem", "taco")
    elseif itemid == "greencow" then
        TriggerEvent("attachItem", "energydrink")
    elseif itemid == "slushy" then
		TriggerEvent("attachItem", "cup")
    end
    TaskItem(dictionary, animation, typeAnim, timer, message, itemid)
    TriggerEvent("destroyProp")
end


function TaskItem(dictionary,animation,typeAnim,timer,message,func,remove,itemid,playerVeh)
    loadAnimDict( dictionary ) 
    TaskPlayAnim( PlayerPedId(), dictionary, animation, 8.0, 1.0, -1, typeAnim, 0, 0, 0, 0 )
    local timer = tonumber(timer)
    if timer > 0 then
        local finished = exports["sway_taskbar"]:taskBar(timer,message,true,false,playerVeh)
        if finished == 100 or timer == 0 then
            TriggerEvent(func)
        end
    else
        TriggerEvent(func)
    end
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end
