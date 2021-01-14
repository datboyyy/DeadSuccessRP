local trackedVehicles = {}
local paused = false

local changingVar = ""

ESX = nil

local checkPlayerOwnedVehicles = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

DecorRegister("PlayerVehicle", 2)

function setPlayerOwnedVehicle()
	local veh = GetVehiclePedIsIn(PlayerPedId(), false)
	DecorSetBool(veh, "PlayerVehicle", true)
end

RegisterNetEvent('veh.PlayerOwned')
AddEventHandler('veh.PlayerOwned', function(veh)
	setPlayerOwnedVehicle()
end)

RegisterNetEvent('veh.checkOwner')
AddEventHandler('veh.checkOwner', function(status)
  checkPlayerOwnedVehicles = status
end)

function checkPlayerOwnedVehicle(veh)
  --print(veh)
--   ESX.TriggerServerCallback('vehicle:isOwner', function(owner)
--  -- return DecorExistOn(veh, "PlayerVehicle", true)
-- --   print('owner',owner)
--   end)
end


local carsEnabled = {}

local airtime = 0

local offroadTimer = 0

local airtimeCoords = GetEntityCoords(GetPlayerPed(-1))

local heightPeak = 0

local lasthighPeak = 0

local highestPoint = 0

local zDownForce = 0

local veloc = GetEntityVelocity(veh)

local offroadVehicle = false

local NosVehicles = {}

local nosForce = 0.0


function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
  end
  


RegisterNetEvent('veh.updateVehicleDegredation')
AddEventHandler('veh.updateVehicleDegredation', function(br,ax,rad,cl,tra,elec,fi,ft)
--	print('veh.updateVehicleDegredationServer', br,ax,rad,cl,tra,elec,fi,ft)
	local tempReturn = {}
	for k, v in pairs(trackedVehicles) do
		if not IsEntityDead(k) then
			tempReturn[#tempReturn+1] = v
		else
			trackedVehicles[k] = nil
		end
		if #tempReturn > 0 then
			--print('veh.updateVehicleDegredation HERE 45')
		--	print(v[1],br,ax,rad,cl,tra,elec,fi,ft)
			TriggerServerEvent('veh.updateVehicleDegredationServer', v[1],br,ax,rad,cl,tra,elec,fi,ft)
		end		
	end
end)

local handbrake = 0

local nitroTimer = false



RegisterNetEvent('resethandbrake')

AddEventHandler('resethandbrake', function()

    while handbrake > 0 do

        handbrake = handbrake - 1

        Citizen.Wait(30)

    end

end)

RegisterNetEvent('veh.randomDegredation')
AddEventHandler('veh.randomDegredation', function(upperLimit,vehicle,spinAmount)
	degHealth = getDegredationArray()
	local plate = GetVehicleNumberPlateText(vehicle)

	--('RANDOM DEGRATION', vehicle)
	--print('calling here after tick 60', "upperLimi:",upperLimit,"vehile:",vehicle,"spinAmount:",spinAmount)

	if checkPlayerOwnedVehicles then

			local br = degHealth.breaks
			local ax = degHealth.axle
			local rad = degHealth.radiator
			local cl = degHealth.clutch
			local tra = degHealth.transmission
			local elec = degHealth.electronics
			local fi = degHealth.fuel_injector 
			local ft = degHealth.fuel_tank

			--print(spinAmount)
			for i=1,spinAmount do
				local chance =  math.random(0,150)
				 if chance <= 10 and chance >= 0 then
					  br = br - math.random(0,upperLimit)
					 -- print('change low 10 to morethan 0')
					 -- print('break:', br)
				elseif chance <= 20 and chance >= 11 then
					--print('change low 20 to morethan 11')
					 ax = ax - math.random(0,upperLimit)
					-- print('axle:', ax)
				elseif chance <= 30 and chance >= 21 then
					--print('change low 30 to morethan 21')
					 rad = rad - math.random(0,upperLimit)
					-- print('radiator:', rad)
				elseif chance <= 40 and chance >= 31 then
				--	print('change low 40 to morethan 31')
					 cl = cl - math.random(0,upperLimit)
					-- print('clutch:', cl)
				elseif chance <= 50 and chance >= 41 then
					--print('change low 50 to morethan 41')
					 tra = tra - math.random(0,upperLimit)
					-- print('tansmission:', tra)
				elseif chance <= 60 and chance >= 51 then
					--print('change low 60 to morethan 51')
					 elec = elec - math.random(0,upperLimit)
					-- print('electric:', elec)
				elseif chance <= 70 and chance >= 61 then
					--print('change low 70 to morethan 61')
					 fi = fi - math.random(0,upperLimit)
					-- print('fix:', fi)
				elseif chance <= 80 and chance >= 71 then
					--print('change low 90 to morethan 71')
					 ft = ft - math.random(0,upperLimit)
					 --print('ft:', ft)
				end
			end

			if br < 0 then 
				br = 0 
			end
			if ax < 0 then ax = 0 end
			if rad < 0 then rad = 0 end
			if cl < 0 then cl = 0 end
			if tra < 0 then tra = 0 end
			if elec < 0 then elec = 0 end
			if fi < 0 then fi = 0 end
			if ft < 0 then ft = 0 end
			--print('veh.randomDegredation')
			--Citizen.Trace("random degen done")
			--Citizen.Trace(br..","..ax..","..rad..","..cl..","..tra..","..elec..","..fi..","..ft)
			TriggerServerEvent('veh.updateVehicleDegredationServer',plate,br,ax,rad,cl,tra,elec,fi,ft)
			TriggerServerEvent('veh.callDegredation',plate)
	end
end)


RegisterNetEvent('veh.updateVehicleBounce')
AddEventHandler('veh.updateVehicleBounce', function(br,ax,rad,cl,tra,elec,fi,ft,plate)
	if br == 0 then br = nil end
--	print('veh.updateVehicleBounce')
	TriggerServerEvent('veh.updateVehicleDegredationServer',plate,br,ax,rad,cl,tra,elec,fi,ft)
end)

RegisterNetEvent('veh.getSQL')
AddEventHandler('veh.getSQL', function(degredation)
	changingVar = degredation
end)

local degHealth = {
	["breaks"] = 0,-- has neg effect
	["axle"] = 0,	-- has neg effect
	["radiator"] = 0, -- has neg effect
	["clutch"] = 0,	-- has neg effect
	["transmission"] = 0, -- has neg effect
	["electronics"] = 0, -- has neg effect
	["fuel_injector"] = 0, -- has neg effect
	["fuel_tank"] = 0 
}
local engineHealth = 0
local bodyHealth = 0

RegisterNetEvent('towgarage:triggermenu')
AddEventHandler('towgarage:triggermenu', function(degradation,eHealth,bHealth)
	local degHealth = {
		["breaks"] = 0,-- has neg effect
		["axle"] = 0,	-- has neg effect
		["radiator"] = 0, -- has neg effect
		["clutch"] = 0,	-- has neg effect
		["transmission"] = 0, -- has neg effect
		["electronics"] = 0, -- has neg effect
		["fuel_injector"] = 0, -- has neg effect
		["fuel_tank"] = 0 
	}
	-- print(eHealth,bHealth)
	local engineHealth = eHealth
	local bodyHealth = bHealth
	local temp = degradation:split(",")
	if(temp[1] ~= nil) then	

		for i,v in ipairs(temp) do
			if i == 1 then
				degHealth.breaks = tonumber(v)
				if degHealth.breaks == nil then
					degHealth.breaks = 0
				end
			elseif i == 2 then
				degHealth.axle = tonumber(v)
			elseif i == 3 then
				degHealth.radiator = tonumber(v)
			elseif i == 4 then
				degHealth.clutch = tonumber(v)
			elseif i == 5 then
				degHealth.transmission = tonumber(v)
			elseif i == 6 then
				degHealth.electronics = tonumber(v)
			elseif i == 7 then
				degHealth.fuel_injector = tonumber(v)
			elseif i == 8 then	
				degHealth.fuel_tank = tonumber(v)
			end
		end
	end

	local playerped = PlayerPedId()
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)


	if targetVehicle ~= nil  and targetVehicle ~= 0 then
		--print('target here')
		engineHealth = GetVehicleEngineHealth(targetCar) 
		bodyHealth = GetVehicleBodyHealth(targetCar)
		currentVeh = targetVehicle
		local strng = "<br> Brakes (Rubber) - " .. round(degHealth["breaks"] / 10,2) .. "/10.0" .. " <br> Axle (Scrap) - " .. round(degHealth["axle"] / 10,2) .. "/10.0" .. " <br> Radiator (Scrap) - " .. round(degHealth["radiator"] / 10,2) .. "/10.0" .. " <br> Clutch (Scrap) - " .. round(degHealth["clutch"] / 10,2) .. "/10.0" .. " <br> Transmission (Aluminium) - " .. round(degHealth["transmission"] / 10,2) .. "/10.0" .. " <br> Electronics (Plastic) - " .. round(degHealth["electronics"] / 10,2) .. "/10.0" .. " <br> Injector (Copper) - " .. round(degHealth["fuel_injector"] / 10,2) .. "/10.0" .. " <br> Fuel (Steel) - " .. round(degHealth["fuel_tank"] / 10,2) .. "/10.0" .. " <br> Body (Glass) - " .. round((bHealth / 10) / 10,2) .. "/10.0" .. " <br> Engine (Scrap) - " .. round((eHealth / 10) / 10,2) .. "/10.0"
		-- local strng = "\n Brakes (Rubber) - " .. round(degHealth["breaks"] / 10,2) .. "/10.0" .. " \n Axle (Scrap) - " .. round(degHealth["axle"] / 10,2) .. "/10.0" .. " \n Radiator (Scrap) - " .. round(degHealth["radiator"] / 10,2) .. "/10.0" .. " \n Clutch (Scrap) - " .. round(degHealth["clutch"] / 10,2) .. "/10.0" .. " \n Transmission (Aluminium) - " .. round(degHealth["transmission"] / 10,2) .. "/10.0" .. " \n Electronics (Plastic) - " .. round(degHealth["electronics"] / 10,2) .. "/10.0" .. " \n Injector (Copper) - " .. round(degHealth["fuel_injector"] / 10,2) .. "/10.0" .. " \n Fuel (Steel) - " .. round(degHealth["fuel_tank"] / 10,2) .. "/10.0" .. " \n Body (Glass) - " .. round((bodyHealth / 10) / 10,2) .. "/10.0" .. " \n Engine (Scrap) - " .. round((engineHealth / 10) / 10,2) .. "/10.0"
		TriggerEvent("customNotification",strng)
	end
end)

RegisterNetEvent("customNotification")
AddEventHandler("customNotification", function(msg, length, type)
    -- TriggerEvent("chatMessagess","SYSTEM",4,msg)
    TriggerEvent('chat:addMessage', { template = '<div style="padding: 0.6vw; padding-left: 0.8vw; background-color: rgba(67, 57, 111, 0.9); border-radius: 6px;"><span style="width: 100%; font-weight: bold;">SYSTEM:</span>'..msg..'</div>', args = { msg }, color = color })

end)

function getDegredationArray()
    local temp = changingVar:split(",")
    
		if(temp[1] ~= nil) then	
			local degHealth = {
			["breaks"] = 0,-- has neg effect
			["axle"] = 0,	-- has neg effect
			["radiator"] = 0, -- has neg effect
			["clutch"] = 0,	-- has neg effect
			["transmission"] = 0, -- has neg effect
			["electronics"] = 0, -- has neg effect
			["fuel_injector"] = 0, -- has neg effect
			["fuel_tank"] = 0 
			}

      for i,v in pairs(temp) do
					if i == 1 then
						degHealth.breaks = tonumber(v)
						if degHealth.breaks == nil then
							degHealth.breaks = 0
						end
					elseif i == 2 then
						degHealth.axle = tonumber(v)
					elseif i == 3 then
						degHealth.radiator = tonumber(v)
					elseif i == 4 then
						degHealth.clutch = tonumber(v)
					elseif i == 5 then
						degHealth.transmission = tonumber(v)
					elseif i == 6 then
						degHealth.electronics = tonumber(v)
					elseif i == 7 then
						degHealth.fuel_injector = tonumber(v)
					elseif i == 8 then	
						degHealth.fuel_tank = tonumber(v)
					end
			end
		return degHealth
	end
end

RegisterNetEvent('veh.getVehicleDegredation')
AddEventHandler('veh.getVehicleDegredation', function(currentVehicle,tick)
		degHealth = getDegredationArray()
		--print(changingVar)
		if IsPedInVehicle(PlayerPedId(),currentVehicle,false) then
			if checkPlayerOwnedVehicles then
				if GetVehicleClass(currentVehicle) ~= 13 and GetVehicleClass(currentVehicle) ~= 21 and GetVehicleClass(currentVehicle) ~= 16 and GetVehicleClass(currentVehicle) ~= 15 and GetVehicleClass(currentVehicle) ~= 14 then
					if degHealth.fuel_injector <= 45 then
						--print("fuel injector "..degHealth.fuel_injector)
						local decayChance = math.random(10,100)
						if degHealth.fuel_injector <= 45 and degHealth.fuel_injector >= 25 then	
							if decayChance > 99 then
								fuelInjector(currentVehicle,50)
							end
						elseif degHealth.fuel_injector <= 24 and degHealth.fuel_injector >= 15 then	
							if decayChance > 98 then
								fuelInjector(currentVehicle,400)

							end
						elseif degHealth.fuel_injector <= 14 and degHealth.fuel_injector >= 9 then	
							if decayChance > 97 then
								fuelInjector(currentVehicle,600)

							end
						elseif  degHealth.fuel_injector <= 8 and degHealth.fuel_injector >= 0 then	
							if decayChance > 90 then
								fuelInjector(currentVehicle,1000)

							end
						end
					end

					if degHealth.radiator <= 35 and tick >= 15 then
						--print("rad "..degHealth.radiator)
						local engineHealth = GetVehicleEngineHealth(currentVehicle)
						if degHealth.radiator <= 35 and degHealth.radiator >= 20 then
							if engineHealth <= 1000 and engineHealth >= 700 then
								SetVehicleEngineHealth(currentVehicle, engineHealth-10)
							end
						elseif degHealth.radiator <= 19 and degHealth.radiator >= 10 then
							if engineHealth <= 1000 and engineHealth >= 500 then
								SetVehicleEngineHealth(currentVehicle, engineHealth-20)
							end
						elseif degHealth.radiator <= 9 and degHealth.radiator >= 0 then
							if engineHealth <= 1000 and engineHealth >= 200 then
								SetVehicleEngineHealth(currentVehicle, engineHealth-30)
							end
						end
					end

					if degHealth.axle <= 35 and tick >= 15 then
					--	print("axle "..degHealth.axle)
						local Chance = math.random(1,100)
						if degHealth.axle <= 35 and degHealth.axle >= 20 and Chance > 90 then
							for i=0,360 do					
								SetVehicleSteeringScale(currentVehicle,i)
								Citizen.Wait(5)
							end
						elseif degHealth.axle <= 19 and degHealth.axle >= 10 and Chance > 70 then
							for i=0,360 do	
								Citizen.Wait(10)
								SetVehicleSteeringScale(currentVehicle,i)
							end
						elseif degHealth.axle <= 9 and degHealth.axle >= 0 and Chance > 50 then
							for i=0,360 do
								Citizen.Wait(15)
								SetVehicleSteeringScale(currentVehicle,i)
							end
						end
					end

					if degHealth.transmission <= 35 and tick >= 15 then
					--	print("Trans "..degHealth.transmission)
						local speed = GetEntitySpeed(currentVehicle)
						local Chance = math.random(1,100)
						if degHealth.transmission <= 35 and degHealth.transmission >= 20 and Chance > 90 then
							for i=0,3 do
								if not IsPedInVehicle(PlayerPedId(),currentVehicle,false) then
									return
								end
								Citizen.Wait(5)
								SetVehicleHandbrake(currentVehicle,true)
								Citizen.Wait(math.random(1000))
								SetVehicleHandbrake(currentVehicle,false)
							end
						elseif degHealth.transmission <= 19 and degHealth.transmission >= 10 and Chance > 70 then
							for i=0,5 do
								if not IsPedInVehicle(PlayerPedId(),currentVehicle,false) then
									return
								end							
								Citizen.Wait(10)
								SetVehicleHandbrake(currentVehicle,true)
								Citizen.Wait(math.random(1000))
								SetVehicleHandbrake(currentVehicle,false)
							end
						elseif degHealth.transmission <= 9 and degHealth.transmission >= 0 and Chance > 50 then
							for i=0,11 do
								if not IsPedInVehicle(PlayerPedId(),currentVehicle,false) then
									return
								end							
								Citizen.Wait(20)
								SetVehicleHandbrake(currentVehicle,true)
								Citizen.Wait(math.random(1000))
								SetVehicleHandbrake(currentVehicle,false)
							end
						end
					end

					if degHealth.electronics <= 35 and tick >= 15 then
					--	print("elec "..degHealth.electronics)
						local Chance = math.random(1,100)
						if degHealth.electronics <= 35 and degHealth.electronics >= 20 and Chance > 90 then
							for i=0,10 do
								Citizen.Wait(50)
								electronics(currentVehicle)
							end
						elseif degHealth.electronics <= 19 and degHealth.electronics >= 10 and Chance > 70 then
							for i=0,10 do
								Citizen.Wait(100)
								electronics(currentVehicle)
							end
						elseif degHealth.electronics <= 9 and degHealth.electronics >= 0 and Chance > 50 then
							for i=0,10 do
								Citizen.Wait(200)
								electronics(currentVehicle)
							end
						end
					end

					if degHealth.breaks <= 35 and tick >= 15 then
					--	print("breaks "..degHealth.breaks)
						local Chance = math.random(1,100)
						if degHealth.breaks <= 35 and degHealth.breaks >= 20 and Chance > 90 then
								SetVehicleHandbrake(currentVehicle,true)
								Citizen.Wait(1000)
								SetVehicleHandbrake(currentVehicle,false)
						elseif degHealth.breaks <= 19 and degHealth.breaks >= 10 and Chance > 70 then
								SetVehicleHandbrake(currentVehicle,true)
								Citizen.Wait(4500)
								SetVehicleHandbrake(currentVehicle,false)
						elseif degHealth.breaks <= 9 and degHealth.breaks >= 0 and Chance > 50 then
								SetVehicleHandbrake(currentVehicle,true)
								Citizen.Wait(7000)
								SetVehicleHandbrake(currentVehicle,false)
						end
					else
						SetVehicleHandbrake(currentVehicle,false)
					end

					if degHealth.clutch <= 35 and tick >= 15 then
					--	print("Clutch "..degHealth.clutch)
						local Chance = math.random(1,100)
						if degHealth.clutch <= 35 and degHealth.clutch >= 20 and Chance > 90 then
								SetVehicleHandbrake(currentVehicle,true)
								fuelInjector(currentVehicle,50)
								for i=1,360 do
									SetVehicleSteeringScale(currentVehicle,i)
									Citizen.Wait(5)
								end
								Citizen.Wait(2000)
								SetVehicleHandbrake(currentVehicle,false)
						elseif degHealth.clutch <= 19 and degHealth.clutch >= 10 and Chance > 70 then
								SetVehicleHandbrake(currentVehicle,true)
								fuelInjector(currentVehicle,100)
								for i=1,360 do
									SetVehicleSteeringScale(currentVehicle,i)
									Citizen.Wait(5)
								end
								Citizen.Wait(5000)
								SetVehicleHandbrake(currentVehicle,false)
						elseif degHealth.clutch <= 9 and degHealth.clutch >= 0 and Chance > 50 then
								SetVehicleHandbrake(currentVehicle,true)
								fuelInjector(currentVehicle,200)
								for i=1,360 do
									SetVehicleSteeringScale(currentVehicle,i)
									Citizen.Wait(5)
								end
								Citizen.Wait(7000)
								SetVehicleHandbrake(currentVehicle,false)
						end
					end

					if degHealth.fuel_tank <= 35 and tick >= 15 then
					--	print("fuel tank "..degHealth.fuel_tank)
						if degHealth.clutch <= 35 and degHealth.clutch >= 20 then
							TriggerEvent("carHud:FuelMulti",20)
						elseif degHealth.clutch <= 19 and degHealth.clutch >= 10 then
							TriggerEvent("carHud:FuelMulti",10)
						elseif degHealth.clutch <= 9 and degHealth.clutch >= 0 then
							TriggerEvent("carHud:FuelMulti",20)
						end
					else
						TriggerEvent("carHud:FuelMulti",1)
					end	
				end			
			end
		end
		-- add in actions for vechile when health is low 
end)
function fuelInjector(currentVehicle,wait)
	SetVehicleEngineOn(currentVehicle,0,0,1)
	SetVehicleUndriveable(currentVehicle,true)
	Citizen.Wait(wait)
	SetVehicleEngineOn(currentVehicle,1,0,1)
	SetVehicleUndriveable(currentVehicle,false)
end

function electronics(currentVehicle)
	local radioStations = {"RADIO_01_CLASS_ROCK","RADIO_02_POP","RADIO_03_HIPHOP_NEW","RADIO_04_PUNK","RADIO_05_TALK_01","RADIO_06_COUNTRY","RADIO_07_DANCE_01","RADIO_08_MEXICAN","RADIO_09_HIPHOP_OLD",
	"RADIO_12_REGGAE","RADIO_13_JAZZ","RADIO_14_DANCE_02","RADIO_15_MOTOWN","RADIO_20_THELAB","RADIO_16_SILVERLAKE","RADIO_17_FUNK","RADIO_18_90S_ROCK"}
	SetVehicleLights(currentVehicle,1)
	local radioRand = math.random(1,18)
	SetVehRadioStation(currentVehicle,radioStations[radioRand])
	Citizen.Wait(600)
	SetVehicleLights(currentVehicle,0)
end

function trackVehicleHealth()
	local tempReturn = {}
	for k, v in pairs(trackedVehicles) do
		if not IsEntityDead(k) then
			v[2] = math.ceil(GetVehicleEngineHealth(k))
			v[3] = math.ceil(GetVehicleBodyHealth(k))
			v[4] = DecorGetInt(k, "CurrentFuel")
			if v[4] == nil then
				v[4] = 50
			end
			tempReturn[#tempReturn+1] = v
		else
			trackedVehicles[k] = nil
		end
	end
	if #tempReturn > 0 then
		TriggerServerEvent('veh.updateVehicleHealth', tempReturn)
	end
end

RegisterNetEvent('veh.setVehicleHealth')
AddEventHandler('veh.setVehicleHealth', function(eh, bh, Fuel, veh)
	Citizen.CreateThread(function()
		setPlayerOwnedVehicle()
		paused = true
		smash = false
		damageOutside = false
		damageOutside2 = false 
		local engine = eh + 0.0
		local body = bh + 0.0

		if engine < 200.0 then
			engine = 200.0
		end

		if body < 900.0 then
			body = 900.0
		end
		if body < 950.0 then
			smash = true
		end

		if body < 920.0 then
			damageOutside = true
		end

		local currentVehicle = (veh and IsEntityAVehicle(veh)) and veh or GetVehiclePedIsIn(PlayerPedId(), false)

		SetVehicleEngineHealth(currentVehicle, engine)


		if smash then
			SmashVehicleWindow(currentVehicle, 0)
			SmashVehicleWindow(currentVehicle, 1)
			SmashVehicleWindow(currentVehicle, 2)
			SmashVehicleWindow(currentVehicle, 3)
			SmashVehicleWindow(currentVehicle, 4)
		end

		if damageOutside then
			SetVehicleDoorBroken(currentVehicle, 1, true)
			SetVehicleDoorBroken(currentVehicle, 6, true)
			SetVehicleDoorBroken(currentVehicle, 4, true)
		end


		SetVehicleBodyHealth(currentVehicle, body)

		DecorSetInt(currentVehicle, "CurrentFuel", Fuel)

		paused = false
	end)
end)


function string:split(delimiter)
  local result = { }
  local from  = 1
  local delim_from, delim_to = string.find( self, delimiter, from  )
  while delim_from do
    table.insert( result, string.sub( self, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = string.find( self, delimiter, from  )
  end
  table.insert( result, string.sub( self, from  ) )
  return result
end

enteredveh = false

RegisterNetEvent('deg:EnteredVehicle')
AddEventHandler('deg:EnteredVehicle', function()
	enteredveh = true
	--print('here entered vehicle', enteredveh)
end)

 Citizen.CreateThread(function()
	Citizen.Wait(1000)

	local tick = 0
	local rTick = 0
	local vehicleNewBodyHealth = 0
	local vehicleNewEngineHealth = 0
	local exitveh = true
	local lastvehicle = 0

	while true do
		
		Citizen.Wait(1000)
			local playerPed = PlayerPedId()
			local currentVehicle = GetVehiclePedIsIn(playerPed, false)
		if IsPedInVehicle(PlayerPedId(),currentVehicle,false) then

			tick = tick + 1
			rTick = rTick + 1

			local driverPed = GetPedInVehicleSeat(currentVehicle, -1)
			if playerPed == driverPed then
				local plate = GetVehicleNumberPlateText(currentVehicle)
				local engineHealth = math.ceil(GetVehicleEngineHealth(currentVehicle))
				local bodyHealth = math.ceil(GetVehicleBodyHealth(currentVehicle))
				--local vehicleAmount = 0
				if checkPlayerOwnedVehicles then
					trackedVehicles[currentVehicle] = {plate, engineHealth, bodyHealth}
				end
				-- Removeing Vehcile check for now 
				--[[for k,v in pairs(trackedVehicles) do 
					if plate == trackedVehicles[k][1] then
						vehicleAmount = vehicleAmount+1
					end
					if vehicleAmount >= 2 then
						DeleteEntity(currentVehicle)
						trackedVehicles[k] = nil
					end
				end
				vehicleAmount = 0]]
			end

			if enteredveh and checkPlayerOwnedVehicles then
			--	print('i entered my vehicle shit')
				currentVehicle = GetVehiclePedIsIn(playerPed, false)
				lastvehicle = currentVehicle
				local plate = GetVehicleNumberPlateText(currentVehicle)
				if currentVehicle then TriggerServerEvent('veh.callDegredation', plate) end
				enteredveh = false
				exitveh = false
				tick = 13
				rTick = 55
				--Citizen.Trace("entered new veh triggered")
			end

			if tick >= 15 then
				--Citizen.Trace("Tick hit 15\n")
				TriggerEvent('veh.getVehicleDegredation',currentVehicle,tick)
			--	TriggerEvent('veh.updateVehicleDegredation',nil,nil,nil,nil,nil,nil,nil,nil,nil)
				trackVehicleHealth()
				tick = 0
			end

			if rTick >= 60 then
				-- Citizen.Trace("rTick hit 60\n")
				TriggerEvent('veh.randomDegredation',1,currentVehicle,3)
				rTick = 0
			end

		else

			if not exitveh then	
				--Citizen.Trace("exited vehicle and updated.")
				TriggerEvent('veh.getVehicleDegredation',lastvehicle,15)
			--	TriggerEvent('veh.updateVehicleDegredation',nil,nil,nil,nil,nil,nil,nil,nil,nil)
				tick = 0
				rTick = 0
				lastvehicle = 0
				currentVehicle = 0
				exitveh = true
			end

		end

	end

end)





 RegisterNetEvent('veh.isPlayers')
AddEventHandler('veh.isPlayers', function(veh,cb)
	if checkPlayerOwnedVehicle(veh) then
		cb(true)
	else
		cb(false)
	end	
end)


RegisterNetEvent('veh.getDegredation')
AddEventHandler('veh.getDegredation', function(veh,cb)

	local plate = GetVehicleNumberPlateText(veh)
	if checkPlayerOwnedVehicles then
		TriggerServerEvent('veh.callDegredation', plate)
	end
	if not checkPlayerOwnedVehicles then
		print('thi is not my owned car dude')
		TriggerServerEvent('veh.callDegredation', plate)
	end

	Citizen.Wait(100)
	deghealth = getDegredationArray()
	cb(deghealth)
end)

RegisterNetEvent('veh:requestUpdate')
AddEventHandler('veh:requestUpdate', function()
  --print("Come here? In REquest Update")
 -- print(GetPlayerPed(-1))
	local playerped = GetPlayerPed(-1)   
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)
  local plate = GetVehicleNumberPlateText(targetVehicle)

	TriggerServerEvent('veh.examine',plate,targetVehicle)
end)

function getVehicleInDirection(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle

	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		
		offset = offset - 1

		if vehicle ~= 0 then break end
	end
	
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	
	if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

function resetdowngrade(veh)
    if carsEnabled["" .. veh .. ""] == nil then 
        return 
    end
    local carData = carsEnabled["" .. veh .. ""]
    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', carData["fInitialDriveMaxFlatVel"])
    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock', carData["fSteeringLock"])
    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionLossMult', carData["fTractionLossMult"])
    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fLowSpeedTractionLossMult', carData["fLowSpeedTractionLossMult"])
    SetVehicleEnginePowerMultiplier(veh,0.7)
    SetVehicleEngineTorqueMultiplier(veh,0.7)

end



-- RegisterCommand('vehfix', function(src, args)
-- 	playerped = PlayerPedId()
--     coordA = GetEntityCoords(playerped, 1)
--     coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
-- 	targetVehicle = getVehicleInDirection(coordA, coordB)
-- 	-- TriggerEvent("veh_damage:fixing", targetVehicle)
-- 	print(targetVehicle)
-- 	resetdowngrade(targetVehicle)
-- 	TriggerEvent("resethandbrake")
-- end)

Citizen.CreateThread(function()

    local firstDrop = GetEntityVelocity(GetPlayerPed(-1))

    local lastentSpeed = 0

    while true do



        Citizen.Wait(1)



        if (IsPedInAnyVehicle(GetPlayerPed(-1), false)) then



            local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)

            if not invehicle and not IsThisModelABike(GetEntityModel(veh)) then

                invehicle = true

                TriggerEvent("InteractSound_CL:PlayOnOne","beltalarm",0.35)

            end

            

            local bicycle = IsThisModelABicycle( GetEntityModel(veh) )



            if carsEnabled["" .. veh .. ""] == nil and not bicycle then



                --local fSteeringLock = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock')



                fSteeringLock = math.ceil((fSteeringLock * 0.6)) + 0.1

                --SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock', fSteeringLock)

                --SetVehicleHandlingField(veh, 'CHandlingData', 'fSteeringLock', fSteeringLock)



                local fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel')

                if IsThisModelABike(GetEntityModel(veh)) then



                    local fTractionCurveMin = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMin')



                    fTractionCurveMin = fTractionCurveMin * 0.6

                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMin', fTractionCurveMin)

                    SetVehicleHandlingField(veh, 'CHandlingData', 'fTractionCurveMin', fTractionCurveMin)   



                    local fTractionCurveMax = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMax')



                    fTractionCurveMax = fTractionCurveMax * 0.6

                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveMax', fTractionCurveMax)

                    SetVehicleHandlingField(veh, 'CHandlingData', 'fTractionCurveMax', fTractionCurveMax)







                    local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')

                    fInitialDriveForce = fInitialDriveForce * 2.4

                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', fInitialDriveForce)



                    local fBrakeForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce')

                    fBrakeForce = fBrakeForce * 1.4

                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce', fBrakeForce)

                    

                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionReboundDamp', 5.000000)

                    SetVehicleHandlingField(veh, 'CHandlingData', 'fSuspensionReboundDamp', 5.000000)



                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionCompDamp', 5.000000)

                    SetVehicleHandlingField(veh, 'CHandlingData', 'fSuspensionCompDamp', 5.000000)



                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fSuspensionForce', 22.000000)

                    SetVehicleHandlingField(veh, 'CHandlingData', 'fSuspensionForce', 22.000000)



                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fCollisionDamageMult', 2.500000)

                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fEngineDamageMult', 0.120000)

                else



                    local fBrakeForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce')

                    fBrakeForce = fBrakeForce * 0.5

                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce', fBrakeForce)



                    local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')

                    --print(fInitialDriveForce)

                    if fInitialDriveForce < 0.289 then

                        --print("buff shit vh")

                        fInitialDriveForce = fInitialDriveForce * 1.2

                        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', fInitialDriveForce)

                    else

                        --print("nerf good vh")

                        fInitialDriveForce = fInitialDriveForce * 0.9

                        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', fInitialDriveForce)

                    end

                                

                    local fInitialDragCoeff = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff')

                    fInitialDragCoeff = fInitialDragCoeff * 0.3

                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDragCoeff', fInitialDragCoeff)



                    --print(fInitialDriveForce .. " " .. GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce'))



                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fEngineDamageMult', 0.100000)

                    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fCollisionDamageMult', 2.900000)



                end

            

                SetVehicleHandlingFloat(veh, 'CHandlingData', 'fDeformationDamageMult', 1.000000)



                SetVehicleHasBeenOwnedByPlayer(veh,true)

                carsEnabled["" .. veh .. ""] = { 

                    ["fInitialDriveMaxFlatVel"] = fInitialDriveMaxFlatVel, 

                    --["fSteeringLock"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock'), 

                    ["fTractionLossMult"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionLossMult'), 

                    ["fLowSpeedTractionLossMult"] = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fLowSpeedTractionLossMult') 

                }

                local plt = GetVehicleNumberPlateText(veh)

                TriggerServerEvent("request:illegal:upgrades",plt)

            else

                Wait(1000)

            end





            if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then



                local coords = GetEntityCoords(GetPlayerPed(-1))

                local roadtest2 = IsPointOnRoad(coords.x, coords.y, coords.z, veh)

              --  roadtest, endResult, outHeading = GetClosestVehicleNode(coords.x, coords.y, coords.z,  1, 0, -1)

             --   endDistance = GetDistanceBetweenCoords(endResult.x, endResult.y, endResult.z,GetEntityCoords(GetPlayerPed(-1)))   

                local myspeed = GetEntitySpeed(veh) * 3.6

                local xRot = GetEntityUprightValue(veh)

                if not roadtest2 then

                    if (xRot < 0.90) then

                        offroadTimer = offroadTimer + (1 - xRot)

                    elseif xRot > 0.90 then

                        if offroadTimer < 1 then

                            offroadTimer = 0

                        else

                            offroadTimer = offroadTimer - xRot

                            resetdowngrade(veh)

                        end                         

                    end

                elseif offroadTimer > 0 or offroadTimer == 0 then

                    offroadTimer = 0

                    offroadVehicle = false 

                    resetdowngrade(veh)

                end



                if offroadTimer > 5 and not IsPedInAnyHeli(GetPlayerPed(-1)) and not IsPedInAnyBoat(GetPlayerPed(-1)) then  

           

                    for i = 1, #offroadVehicles do

                        if IsVehicleModel( GetVehiclePedIsUsing(GetPlayerPed(-1)), GetHashKey(offroadVehicles[i]) ) then

                            offroadVehicle = true



                        end

                    end



                    if not offroadVehicle then

                        if IsThisModelABike(GetEntityModel(veh)) then

                            downgrade(veh,0.12 - xRot / 10,offroadVehicle)  

                        else

                            downgrade(veh,0.20 - xRot / 10,offroadVehicle)

                        end

                    

                    else

                        downgrade(veh,0.35 - xRot / 10,offroadVehicle)

                    end

                end



                if IsEntityInAir(veh) then

                    firstDrop = GetEntityVelocity(veh)

                    lastentSpeed = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(GetPlayerPed(-1))))

                    if airtime == 1 then

                        heightPeak = 0

                        lasthighPeak = 0                        

                        airtimeCoords = GetEntityCoords(veh)

                        lasthighPeak = airtimeCoords.z

                    else

                        local AirCurCoords = GetEntityCoords(veh)

                        heightPeak = AirCurCoords.z

                        if tonumber(heightPeak) > tonumber(lasthighPeak) and airtime ~= 0 then

                            lasthighPeak = heightPeak

                            highestPoint = heightPeak - airtimeCoords.z

                        end

                    end

                    airtime = airtime + 1

                elseif airtime > 0 then

                    

                    if airtime > 110 then

                        Citizen.Wait(333)

                        local landingCoords = GetEntityCoords(veh)  

                        local landingfactor = landingCoords.z - airtimeCoords.z     

                        local momentum = GetEntityVelocity(veh)

                        highestPoint = highestPoint - landingfactor



                        highestPoint = highestPoint * 0.55



                        airtime = math.ceil(airtime * highestPoint)



                        local xdf = 0

                        local ydf = 0

                        if momentum.x < 0 then

                            xdf = momentum.x

                            xdf = math.ceil(xdf - (xdf * 2))

                        else

                            xdf = momentum.x

                        end



                        if momentum.y < 0 then

                            ydf = momentum.y

                            ydf = math.ceil(ydf - (ydf * 2))

                        else

                            ydf = momentum.y

                        end







                        zdf = momentum.z 

                        lastzvel = firstDrop.z

                       -- print("IMPACT Z" .. zdf)

                       --- print("LAST DROP Z" .. lastzvel)





                        zdf = zdf - lastzvel

                        local dirtBike = false

                        for i = 1, #offroadbikes do

                            if IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed(-1)), GetHashKey(offroadbikes[i], _r)) then

                                dirtBike = true

                            end

                        end

                        if dirtBike then

                            airtime = airtime - 200

                        end



                        if IsThisModelABicycle(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1)))) then

                           -- print(airtime .. " what " .. zdf)

                            local ohshit = math.ceil((zdf * 200))

                            local entSpeed = math.ceil( GetEntitySpeed(GetVehiclePedIsUsing(GetPlayerPed(-1))) * 1.35 )

                           -- print("speed - " .. entSpeed)



                            if airtime > 550 then

                                if airtime > 550 and ohshit > airtime and ( entSpeed < lastentSpeed or entSpeed < 2.0 ) then

                                    ejectionLUL()

                                    --TriggerEvent("SendAlert","eject : " .. ohshit .. " vs " .. airtime .. " " .. entSpeed .. " vs " .. lastentSpeed)

                                elseif airtime > 1500 and entSpeed < lastentSpeed then

                                    ejectionLUL()

                                    --TriggerEvent("SendAlert","eject 2 : " .. ohshit .. " vs " .. airtime .. " " .. entSpeed .. " vs " .. lastentSpeed)

                                else

                                --  TriggerEvent("SendAlert","Good Landing" .. ohshit .. " vs " .. airtime .. " " .. entSpeed .. " vs " .. lastentSpeed)

                                end

                            end



                        elseif airtime > 950 and IsThisModelABike(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1)))) then

                        --    print(airtime .. " what " .. zdf)

                            local ohshit = math.ceil((zdf * 200))

                            local entSpeed = math.ceil( GetEntitySpeed(GetVehiclePedIsUsing(GetPlayerPed(-1))) * 1.15 )

                         --   print("speed - " .. entSpeed)



                            if airtime > 950 then

                                if airtime > 950 and ohshit > airtime and ( entSpeed < lastentSpeed or entSpeed < 2.0 ) then

                                    ejectionLUL()

                                    --TriggerEvent("SendAlert","eject : " .. ohshit .. " vs " .. airtime .. " " .. entSpeed .. " vs " .. lastentSpeed)

                                elseif airtime > 2500 and entSpeed < lastentSpeed then

                                    ejectionLUL()

                                    --TriggerEvent("SendAlert","eject 2 : " .. ohshit .. " vs " .. airtime .. " " .. entSpeed .. " vs " .. lastentSpeed)

                                else

                                    --TriggerEvent("SendAlert","Good Landing" .. ohshit .. " vs " .. airtime .. " " .. entSpeed .. " vs " .. lastentSpeed)

                                end

                            end

                                 

                        end

                    end

                    airtimeCoords = GetEntityCoords(GetPlayerPed(-1))

                    heightPeak = 0

                    airtime = 0

                    lasthighPeak = 0

                    zDownForce = 0

                end



                --GetVehicleClass(vehicle)

                local ped = GetPlayerPed(-1)

                local roll = GetEntityRoll(veh)



                if IsEntityInAir(veh) and not IsThisModelABike(GetEntityModel(veh)) then

                    DisableControlAction(0, 59)

                    DisableControlAction(0, 60)

                end

                if ((roll > 75.0 or roll < -75.0) or not IsVehicleEngineOn(veh)) and not IsThisModelABike(GetEntityModel(veh)) then         

                    DisableControlAction(2,59,true)

                    DisableControlAction(2,60,true)

                end

            else

                Wait(1000)

            end

        else

            if invehicle or seatbelt then

                if seatbelt then

                    TriggerEvent("InteractSound_CL:PlayOnOne","seatbeltoff",0.7)

                end

                invehicle = false

                seatbelt = false

                TriggerEvent("seatbelt",false)

            end

            Citizen.Wait(1500)

        end

    end

end)







Citizen.CreateThread(function()

    Citizen.Wait(1000)

    local newvehicleBodyHealth = 0

    local newvehicleEngineHealth = 0

    local currentvehicleEngineHealth = 0

    local currentvehicleBodyHealth = 0

    local frameBodyChange = 0

    local frameEngineChange = 0

    local lastFrameVehiclespeed = 0

    local lastFrameVehiclespeed2 = 0

    local thisFrameVehicleSpeed = 0

    local tick = 0

    local damagedone = false



    local modifierDensity = true

    while true do



        Citizen.Wait(5)

        local playerPed = GetPlayerPed(-1)

        local currentVehicle = GetVehiclePedIsIn(playerPed, false)



        local driverPed = GetPedInVehicleSeat(currentVehicle, -1)



        if currentVehicle ~= nil and currentVehicle ~= false and currentVehicle ~= 0 then



            SetPedHelmet(playerPed, false)



            lastVehicle = GetVehiclePedIsIn(playerPed, false)



            if driverPed == GetPlayerPed(-1) then





                if GetVehicleEngineHealth(currentVehicle) < 0.0 then

                    SetVehicleEngineHealth(currentVehicle,0.0)

                end







                if (GetVehicleHandbrake(currentVehicle) or (GetVehicleSteeringAngle(currentVehicle)) > 25.0 or (GetVehicleSteeringAngle(currentVehicle)) < -25.0) then

                    if handbrake == 0 then

                        handbrake = 100

                        TriggerEvent("resethandbrake")

                    else

                        handbrake = 100

                    end

                end



                if NosVehicles[currentVehicle] == nil then

                    NosVehicles[currentVehicle] = 0

                end



                thisFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6



                if (IsControlJustReleased(1,21) or NosVehicles[currentVehicle] < 10) and nitroTimer then

                    endNos()

                end



                if not disablenos and handbrake < 5 and lastFrameVehiclespeed > 45.0 and IsControlPressed(1,21) and not IsThisModelAHeli(GetEntityModel(currentVehicle)) and not IsThisModelABoat(GetEntityModel(currentVehicle)) and not IsThisModelABike(GetEntityModel(currentVehicle)) and NosVehicles[currentVehicle] ~= nil then

                    if NosVehicles[currentVehicle] > 1 then

                        TriggerEvent("NosBro",currentVehicle)

                        NosVehicles[currentVehicle] = NosVehicles[currentVehicle] - 1

                    end

                end













                currentvehicleBodyHealth = GetVehicleBodyHealth(currentVehicle)





                if currentvehicleBodyHealth == 1000 and frameBodyChange ~= 0 then

                    frameBodyChange = 0

                end



                if frameBodyChange ~= 0 then

                        

                    if lastFrameVehiclespeed > 110 and thisFrameVehicleSpeed < (lastFrameVehiclespeed * 0.75) and not damagedone then



                        if frameBodyChange > 18.0 then

                                if not IsThisModelABike(currentVehicle) then 

                                TriggerServerEvent("carhud:ejection:server",GetVehicleNumberPlateText(currentVehicle))

                                end     



                                if not seatbelt and not IsThisModelABike(currentVehicle) then

                                    if math.random(math.ceil(lastFrameVehiclespeed)) > 110 then

                                        ejectionLUL()                           

                                    end

                                elseif seatbelt and not IsThisModelABike(currentVehicle) then

                                    if lastFrameVehiclespeed > 150 then

                                        if math.random(math.ceil(lastFrameVehiclespeed)) > 99 then

                                            ejectionLUL()                           

                                        end

                                    end

                                end

                        else

                            if not IsThisModelABike(currentVehicle) then 

                                TriggerServerEvent("carhud:ejection:server",GetVehicleNumberPlateText(currentVehicle))

                            end     



                            if not seatbelt and not IsThisModelABike(currentVehicle) then

                                if math.random(math.ceil(lastFrameVehiclespeed)) > 60 then

                                    ejectionLUL()                           

                                end

                            elseif seatbelt and not IsThisModelABike(currentVehicle) then

                                if lastFrameVehiclespeed > 120 then

                                    if math.random(math.ceil(lastFrameVehiclespeed)) > 99 then

                                        ejectionLUL()                           

                                    end

                                end

                            end

                        end

                        damagedone = true       

                        SetVehicleTyreBurst(currentVehicle, tireToBurst, true, 1000) 

                        SetVehicleEngineHealth(currentVehicle, 0)

                        SetVehicleEngineOn(currentVehicle, false, true, true)

                        Citizen.Wait(1000)

                        TriggerEvent("civilian:alertPolice",50.0,"carcrash",0) --alert police



                    end



                    if currentvehicleBodyHealth < 350.0 and not damagedone then

                        damagedone = true

                        SetVehicleBodyHealth(targetVehicle, 945.0)

                        SetVehicleTyreBurst(currentVehicle, tireToBurst, true, 1000) 

                        SetVehicleEngineHealth(currentVehicle, 0)

                        SetVehicleEngineOn(currentVehicle, false, true, true)

                        Citizen.Wait(1000)

                    end



                end



                if lastFrameVehiclespeed < 100 then

                    Wait(100)

                    tick = 0

                end





                frameBodyChange = newvehicleBodyHealth - currentvehicleBodyHealth

                if tick > 0 then 

                    tick = tick - 1

                    if tick == 1 then

                        lastFrameVehiclespeed = GetEntitySpeed(currentVehicle) * 3.6

                    end

                else

                    

                    if damagedone then

                        damagedone = false

                        frameBodyChange = 0

                        lastFrameVehiclespeed = GetEntitySpeed(currentVehicle) * 3.6

                    end



                    lastFrameVehiclespeed2 = GetEntitySpeed(currentVehicle) * 3.6

                    if lastFrameVehiclespeed2 > lastFrameVehiclespeed then

                        lastFrameVehiclespeed = GetEntitySpeed(currentVehicle) * 3.6

                    end



                    if lastFrameVehiclespeed2 < lastFrameVehiclespeed then

                        tick = 25

                    end



                end



                vels = GetEntityVelocity(currentVehicle)



                if tick < 0 then 

                    tick = 0

                end     



                newvehicleBodyHealth = GetVehicleBodyHealth(currentVehicle)

                if not modifierDensity then

                    modifierDensity = true

                    TriggerEvent("DensityModifierEnable",modifierDensity)

                end

            else



                vels = GetEntityVelocity(currentVehicle)

                if modifierDensity then

                    modifierDensity = false

                    TriggerEvent("DensityModifierEnable",modifierDensity)

                end

                Wait(1000)

            end



            veloc = GetEntityVelocity(currentVehicle)



        else



            if lastVehicle ~= nil then

                SetPedHelmet(playerPed, true)

                Citizen.Wait(200)

                newvehicleBodyHealth = GetVehicleBodyHealth(lastVehicle)



                if not damagedone and newvehicleBodyHealth < currentvehicleBodyHealth then

                    damagedone = true                   

                    SetVehicleTyreBurst(lastVehicle, tireToBurst, true, 1000) 

                    SetVehicleEngineHealth(lastVehicle, 0)

                    SetVehicleEngineOn(lastVehicle, false, true, true)

                    Citizen.Wait(1000)

                end



                lastVehicle = nil

                TriggerEvent("DensityModifierEnable",true)

            end

            lastFrameVehiclespeed2 = 0

            lastFrameVehiclespeed = 0

            newvehicleBodyHealth = 0

            currentvehicleBodyHealth = 0

            frameBodyChange = 0

            Citizen.Wait(2000)

        end

    end

end)
