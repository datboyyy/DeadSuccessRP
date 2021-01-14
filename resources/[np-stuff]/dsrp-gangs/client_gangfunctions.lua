
--	[2] = "prop_cs_package_01",



-- delivery / dump start.
local salesMade = 0
local reputation = 0
local repNames = {
	[1] = "Rookie",
	[2] = "Rookie",
	[3] = "Novice",
	[4] = "Thug",
	[5] = "Big Loke",
	[6] = "3 Star Youngin'",
	[7] = "5 Star Youngin'",
	[8] = "Plug",
	[9] = "Plug",
	[10] = "OG Gangsta"
}
local zoneNames = {
	Aerp = "Los Santos International Aerport",
	ALAMO = "Alamo Sea",
	ALTA = "Alta",
	ARMYB = "Fort Zancudo",
	BANHAMC = "Banham Canyon Dr",
	BANNING = "Banning",
	BAYTRE = "Baytree Canyon", 
	BEACH = "Vespucci Beach",
	BHAMCA = "Banham Canyon",
	BRADP = "Braddock Pass",
	BRADT = "Braddock Tunnel",
	BURTON = "Burton",
	CALAFB = "Calafia Bridge",
	CANNY = "Raton Canyon",
	CCREAK = "Cassidy Creek",
	CHAMH = "Chamberlain Hills",
	CHIL = "Vinewood Hills",
	CHU = "Chumash",
	CMSW = "Chiliad Mountain State Wilderness",
	CYPRE = "Cypress Flats",
	DAVIS = "Davis",
	DELBE = "Del Perro Beach",
	DELPE = "Del Perro",
	DELSOL = "La Puerta",
	DESRT = "Grand Senora Desert",
	DOWNT = "Downtown",
	DTVINE = "Downtown Vinewood",
	EAST_V = "East Vinewood",
	EBURO = "El Burro Heights",
	ELGORL = "El Gordo Lighthouse",
	ELYSIAN = "Elysian Island",
	GALFISH = "Galilee",
	GALLI = "Galileo Park",
	golf = "GWC and Golfing Society",
	GRAPES = "Grapeseed",
	GREATC = "Great Chaparral",
	HARMO = "Harmony",
	HAWICK = "Hawick",
	HORS = "Vinewood Racetrack",
	HUMLAB = "Humane Labs and Research",
	JAIL = "Bolingbroke Penitentiary",
	KOREAT = "Little Seoul",
	LACT = "Land Act Reservoir",
	LAGO = "Lago Zancudo",
	LDAM = "Land Act Dam",
	LEGSQU = "Legion Square",
	LMESA = "La Mesa",
	LOSPUER = "La Puerta",
	MIRR = "Mirror Park",
	MORN = "Morningwood",
	MOVIE = "Richards Majestic",
	MTCHIL = "Mount Chiliad",
	MTGORDO = "Mount Gordo",
	MTJOSE = "Mount Josiah",
	MURRI = "Murrieta Heights",
	NCHU = "North Chumash",
	NOOSE = "N.O.O.S.E",
	OCEANA = "Pacific Ocean",
	PALCOV = "Paleto Cove",
	PALETO = "Paleto Bay",
	PALFOR = "Paleto Forest",
	PALHIGH = "Palomino Highlands",
	PALMPOW = "Palmer-Taylor Power Station",
	PBLUFF = "Pacific Bluffs",
	PBOX = "Pillbox Hill",
	PROCOB = "Procopio Beach",
	RANCHO = "Rancho",
	RGLEN = "Richman Glen",
	RICHM = "Richman",
	ROCKF = "Rockford Hills",
	RTRAK = "Redwood Lights Track",
	SanAnd = "San Andreas",
	SANCHIA = "San Chianski Mountain Range",
	SANDY = "Sandy Shores",
	SKID = "Mission Row",
	SLAB = "Stab City",
	STAD = "Maze Bank Arena",
	STRAW = "Strawberry",
	TATAMO = "Tataviam Mountains",
	TERMINA = "Terminal",
	TEXTI = "Textile City",
	TONGVAH = "Tongva Hills",
	TONGVAV = "Tongva Valley",
	VCANA = "Vespucci Canals",
	VESP = "Vespucci",
	VINE = "Vinewood",
	WINDF = "Ron Alternates Wind Farm",
	WVINE = "West Vinewood",
	ZANCUDO = "Zancudo River",
	ZP_ORT = "Port of South Los Santos",
	ZQ_UAR = "Davis Quartz"
	}
	
	
	
	local hotSpots = {
		["Strawberry"] = { ["ratio"] = 0, ["zone"] = 1 },
		["Rancho"] = { ["ratio"] = 0, ["zone"] = 1 },
		["Chamberlain Hills"] = { ["ratio"] = 0, ["zone"] = 1 },
		["Davis"] = { ["ratio"] = 125, ["zone"] = 1 },
		["West Vinewood"] = { ["ratio"] = 0, ["zone"] = 2 },
		["Downtown Vinewood"] = { ["ratio"] = 0, ["zone"] = 2 },
	}
	

	local cocainetime = false
	local cracktime = false
	local sellingcocaine = false
	local sellingcrack = false
	local sellingweed = false
	function EndSelling()
		sellingweed = false
		sellingcocaine = false
		sellingcrack = false
	end
	local initialized = false


RegisterNetEvent('erp:playerLoaded')
AddEventHandler('erp:playerLoaded', function(source)
  TriggerServerEvent('weed:getPlants')
end)

	
function isNight()
	local hour = GetClockHours()

	if hour < 5 or hour > 19 then
		return true
	end
   end
	
	
	RegisterCommand('corner', function()
	TriggerEvent('drugs:corner')
	end)
	
	
	
	
	
	RegisterNetEvent('drugs:hotSpots')
	AddEventHandler('drugs:hotSpots', function(newhotSpots)
		hotSpots = newhotSpots
	end)
	RegisterNetEvent('playerSpawned')
	AddEventHandler('playerSpawned', function(newhotSpots)
		TriggerServerEvent("weed:requestTable")
	end)
	
	--Strawberry
	--Rancho
	--Chamberlain Hills
	--Davis
	local pedsused = {}
	local pedcar = {}
	

	
	
	function GetRandomNPC()
		local playerped = GetPlayerPed(-1)
		local playerCoords = GetEntityCoords(playerped)
		local handle, ped = FindFirstPed()
		local success
		local rped = nil
		local distanceFrom
		repeat
			local pos = GetEntityCoords(ped)
			local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
			if canPedBeUsed(ped,true) and distance > 1.0 and distance < 25.0 and (distanceFrom == nil or distance < distanceFrom) then
				distanceFrom = distance
				rped = ped
				success = false
				pedsused["conf"..rped] = true
			end
			success, ped = FindNextPed(handle)
		until not success
		EndFindPed(handle)
		return rped
	end
	
	
	
	
	
	
	
	
	--[[
	 * p1 is anywhere from 4 to 7 in the scripts. Might be a weapon wheel group?
	 * ^It's kinda like that.
	 * 7 returns true if you are equipped with any weapon except your fists.
	 * 6 returns true if you are equipped with any weapon except melee weapons.
	 * 5 returns true if you are equipped with any weapon except the Explosives weapon group.
	 * 4 returns true if you are equipped with any weapon except Explosives weapon group AND melee weapons.
	 * 3 returns true if you are equipped with either Explosives or Melee weapons (the exact opposite of 4).
	 * 2 returns true only if you are equipped with any weapon from the Explosives weapon group.
	 * 1 returns true only if you are equipped with any Melee weapon.
	 * 0 never returns true.
	 * Note: When I say "Explosives weapon group", it does not include the Jerry can and Fire Extinguisher.
	]]--
	
	
	local weaponTypes = {
		["2685387236"] = { "Unarmed", ["slot"] = 0 },
		["3566412244"] = { "Melee", ["slot"] = 1 },
		["-728555052"] = { "Melee", ["slot"] = 1 },
		["416676503"] = { "Pistol", ["slot"] = 2 },
		["3337201093"] = { "SMG", ["slot"] = 3 },
		["970310034"] = { "AssaultRifle", ["slot"] = 4 },
		["-957766203"] = { "AssaultRifle", ["slot"] = 4 },
		["3539449195"] = { "DigiScanner", ["slot"] = 4 },
		["4257178988"] = { "FireExtinguisher", ["slot"] = 0 },
		["1159398588"] = { "MG", ["slot"] = 4 },
		["3493187224"] = { "NightVision", ["slot"] = 0 },
		["431593103"] = { "Parachute", ["slot"] = 0 },
		["860033945"] = { "Shotgun", ["slot"] = 3 },
		["3082541095"] = { "Sniper", ["slot"] = 3 },
		["690389602"] = { "Stungun", ["slot"] = 1 },
		["2725924767"] = { "Heavy", ["slot"] = 4 },
		["1548507267"] = { "Thrown", ["slot"] = 0 },
		["1595662460"] = { "PetrolCan", ["slot"] = 1 }
	}
	
	function GetRandomMelee()
		local ws = math.random(1,4)
		if ws == 1 then
			return GetHashKey("WEAPON_KNUCKLE")
		elseif ws == 2 then 
			return GetHashKey("WEAPON_KNIFE")
		elseif ws == 3 then
			return GetHashKey("WEAPON_KNIFE")
		else 
			return GetHashKey("WEAPON_CROWBAR")
		end
	end
	
	function GetRandomPistol()
		local ws = math.random(1,4)
		if ws == 1 then
			return GetHashKey("WEAPON_PISTOL")
		elseif ws == 2 then 
			return GetHashKey("WEAPON_COMBATPISTOL")
		elseif ws == 3 then
			return GetHashKey("WEAPON_APPISTOL")
		else 
			return GetHashKey("WEAPON_PISTOL50")
		end
	end
	
	function GetRandomSmall()
		local ws = math.random(1,4)
		if ws == 1 then
			return GetHashKey("WEAPON_MICROSMG")
		elseif ws == 2 then 
			return GetHashKey("WEAPON_SMG")
		elseif ws == 3 then
			return GetHashKey("WEAPON_ASSAULTSMG")
		else 
			return GetHashKey("WEAPON_PUMPSHOTGUN")
		end
	end
	
	function GetRandomLarge()
		local ws = math.random(1,4)
		if ws == 1 then
			return GetHashKey("WEAPON_ADVANCEDRIFLE")
		elseif ws == 2 then 
			return GetHashKey("WEAPON_ASSAULTSHOTGUN")
		elseif ws == 3 then
			return GetHashKey("WEAPON_BULLPUPRIFLE")
		else 
			return GetHashKey("WEAPON_AUTOSHOTGUN")
		end
	end
	
	
	
	function DoRandomHostileAnimaiton(NPC)
	
		PlayAmbientSpeech1(NPC, "Generic_Fuck_You", "Speech_Params_Force")
		local dict = "mp_player_int_uppergrab_crotch"
		local anim = "mp_player_int_grab_crotch"
	
		local animNum = math.random(1,4)
		if animNum == 1 then
			dict = "mp_player_int_uppergang_sign_a"
			anim = "mp_player_int_gang_sign_a"
		elseif animNum == 2 then
			dict = "mp_player_int_uppergang_sign_b"
			anim = "mp_player_int_gang_sign_b"
		elseif animNum == 3 then
			dict = "mp_player_int_upperv_sign"
			anim = "mp_player_int_v_sign"
		end
		TaskLookAtEntity(NPC, GetPlayerPed(-1), 5500.0, 2048, 3)
		TaskTurnPedToFaceEntity(NPC, GetPlayerPed(-1), 5500)
	
		 Wait(3000)
	
		if ( DoesEntityExist( NPC ) and not IsEntityDead( NPC ) ) then 
			loadAnimDict( dict )
			TaskPlayAnim( NPC, dict, anim, 8.0, 1.0, -1, 16, 0, 0, 0, 0 )  
		end
	
		PlayAmbientSpeech1(NPC, "Generic_Fuck_You", "Speech_Params_Force")
	
		Wait(1500)
		PlayAmbientSpeech1(NPC, "Generic_Fuck_You", "Speech_Params_Force")
	end
	
	
	
	RegisterNetEvent('armed:success')
	AddEventHandler('armed:success', function(wp,sc)
	--	local gangType = exports["isPed"]:isPed("corner")[[Disabled temp]]
		local p = GetPlayerPed(-1)
		local hp = GetRandomHostile(sc,wp)
		local h = 50
	
		if IsPlayerFreeAiming(PlayerId()) then
			h = h + 10
		end
	
		if IsPedRunning(p) or IsPedSprinting(p) then
			h = h + 10
		end
	--	if gangType > 0 then
	--		h = h + 15
	--	end
		
	
		if hp then
	
	
			local attack = false
			local WeaponHash = 0
			if (wp == 1 and math.random(h) > 10) or (wp == 5 and math.random(h) > 50) or (wp == 6 and math.random(h) > 5) then
				attack = true
				WeaponHash = GetRandomMelee()
			--	print("1 level Hostile")
			elseif wp == 2 and math.random(h) > 15 then
				attack = true
				WeaponHash = GetRandomPistol()
			--	print("2 level Hostile")
			elseif wp == 3 and math.random(h) > 25 then
				attack = true
				WeaponHash = GetRandomSmall()
			--	print("3 level Hostile")
			elseif wp == 4  and math.random(h) > 32 then
				attack = true
				WeaponHash = GetRandomLarge()
			--	print("4 level Hostile")
			end
	
			if attack then
	
				SetPedRelationshipGroupDefaultHash(hp,GetHashKey('AMBIENT_GANG_LOST'))
				SetPedRelationshipGroupHash(hp,GetHashKey('AMBIENT_GANG_LOST'))
				   RemoveAllPedWeapons(hp, true)
			   
				   DoRandomHostileAnimaiton(hp)
	
				SetPedDropsWeaponsWhenDead(hp,false)
				
			--	print("weapoin given " .. WeaponHash)
				GiveWeaponToPed(hp, WeaponHash, 120, 0, 1)
				SetCurrentPedWeapon(hp, WeaponHash, true)
				TaskCombatPed(hp, GetPlayerPed(-1), 0, 16)
	
				Wait(60000)
	
				if not IsEntityDead( NPC ) then
					TaskWanderStandard(hp, 100.0, 100) 
				   end
	
			end
	
	
		end
	
	end)
	
	
	function GetRandomHostile(sc,wp)
		local playerped = GetPlayerPed(-1)
		local playerCoords = GetEntityCoords(playerped)
		local handle, ped = FindFirstPed()
		local success
		local rped = nil
		local distanceFrom
		repeat
			local pos = GetEntityCoords(ped)
			local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
			if GetPedRelationshipGroupHash(ped) == sc and canPedBeUsed(ped,true) and HasEntityClearLosToEntity(playerped,ped,17)  and distance > 3.0 and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
				distanceFrom = distance
				rped = ped
				if wp == 5 or wp == 6 then
					if math.random(50) > 40 then
						 pedsused["conf"..rped] = true
					end
				else
					pedsused["conf"..rped] = true
				end
			   
			end
			success, ped = FindNextPed(handle)
		until not success
		EndFindPed(handle)
		return rped
	end
	
	-- Strawberry && Chamberlain Hills is North side
	-- Davis is South Central
	-- Rancho is East Side
	
	
	
	-- 1166638144 -- ballas / north central
	
	-- -1033021910 -- grove street - south central
	
	-- 296331235 east side / mexican
	-- GetPedRelationshipGroupHash(ped)
	local gangSpots = {
		["Strawberry"] = { ["Label"] = "North Side", ["zone"] = 1, ["GroupHashKey"] = 1166638144 },
		["Rancho"] = { ["Label"] = "East Side", ["zone"] = 3, ["GroupHashKey"] = 296331235 },
		["Chamberlain Hills"] = { ["Label"] = "North Side", ["zone"] = 1, ["GroupHashKey"] = 1166638144 },
		["Davis"] = { ["Label"] = "South Central", ["zone"] = 2, ["GroupHashKey"] = -1033021910 },
	} 
	
	--Hawick Ave - Burton
	
	
	
	
	Citizen.CreateThread( function()
	
		while true do 
	
			local storagedist = GetDistanceBetweenCoords(83.31, -1635.9, 28.93,GetEntityCoords(GetPlayerPed(-1)))
	
			local p = GetPlayerPed(-1)
			if storagedist < 700 then
				local x, y, z = table.unpack(GetEntityCoords(p, true))
				local zone = tostring(GetNameOfZone(x, y, z))	
				local Area = zoneNames[tostring(zone)]
			   -- local gangType = exports["isPed"]:isPed("corner") [[Disabled temp]] Gang type was disabled due to not having isPed export.
				if not IsPedSittingInAnyVehicle(p) and gangSpots[Area] then
	
					--if gangType ~= gangSpots[Area]["zone"] then [[Disabled temp]]
	
						local w = GetSelectedPedWeapon(GetPlayerPed(-1))
						local wg = GetWeapontypeGroup(w)
						local wp = 0
	
						if weaponTypes[""..wg..""] then
							wp = weaponTypes[""..wg..""]["slot"]
						else 
							if IsPedArmed(p,2) then
								wp = 4
							end
							if IsPedArmed(p,4) then
								wp = 3
							end					
						end
	
					--	if (IsPedRunning(p) or IsPedSprinting(p)) and wp == 0 and gangType > 0 then
					--		wp = 5
					--	end
	
	
						if (IsPedInMeleeCombat(GetPlayerPed(-1)) or IsPedJacking(GetPlayerPed(-1))) and wp == 0 then
							wp = 6
						end
	
						if wp > 0 then
							TriggerEvent("armed:success",wp,gangSpots[Area]["GroupHashKey"])
						end
	
					--end
	
				else
	
				end
	
			end			
	
			if storagedist > 1000 then
				Citizen.Wait(math.ceil(storagedist*30))
			else
				Citizen.Wait(1000)
			end
	
		end
	
	end)
	
	local sellAmount = 1
	
	RegisterNetEvent('drugs:corner:amount')
	AddEventHandler('drugs:corner:amount', function(newAmount)
	
		sellAmount = tonumber(newAmount)
		if sellAmount > 5 then
			--TriggerServerEvent("exploiter", "User tried to see their weed sales over 5 to level " .. sellAmount)
			sellAmount = 5
		end
	end)


	RegisterCommand('realrep', function()
		exports['mythic_notify']:SendAlert('inform', "My reputation is : "..tostring(repNames[reputation]))
	end)

	RegisterCommand('rep', function()
		TriggerServerEvent("erp-gangs:getReputation")

		Citizen.Wait(1000)
		exports['mythic_notify']:SendAlert('inform', "My reputation is : "..tostring(repNames[reputation]))
	
	end)
	
	
	RegisterNetEvent('drugs:corner')
	AddEventHandler('drugs:corner', function()
		if cooldown then
			exports['mythic_notify']:SendAlert('inform', "You can only set up on corner once every 1 minute.")
			return
		end
		if sellingcocaine or sellingcrack or sellingweed then
			EndSelling()
		end
		
		local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
		local zone = tostring(GetNameOfZone(x, y, z))	
		local Area = zoneNames[tostring(zone)]
		local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	
		local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
		local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
	
	
		if Area == "Burton" and currentStreetName == "Hawick Ave" then
			exports['mythic_notify']:SendAlert('inform', "You are corner selling.")
				sellingweed = true
				cooldown = true
		else
			if not hotSpots[Area] then
				exports['mythic_notify']:SendAlert('inform', "You cant do that here..")
				return
			end
			if hotSpots[Area]["zone"] == 2 and not cocainetime then
				exports['mythic_notify']:SendAlert('inform', "We can not sell cocaine right now, nobody is buying.")
				return
			elseif hotSpots[Area]["zone"] == 2 and cocainetime then
				exports['mythic_notify']:SendAlert('inform', "You are corner selling.")
				sellingcocaine = true
				cooldown = true
			end
	
			if hotSpots[Area]["zone"] == 1 and not cracktime then
				exports['mythic_notify']:SendAlert('inform', "We can not sell crack right now, nobody is buying.")
				return
			elseif hotSpots[Area]["zone"] == 1 and cracktime then
				exports['mythic_notify']:SendAlert('inform', "You are corner selling.")
				sellingcrack = true
				cooldown = true
			end
		end
	
		local plyStartCoords = GetEntityCoords(GetPlayerPed(-1))
		TriggerEvent("increaseAI",true)
		while sellingcocaine or sellingcrack or sellingweed do
	
			Wait(15000)
			--TriggerEvent("DoShortHudText", "Corner Selling Active.",10)
			exports['mythic_notify']:SendAlert('inform', "Corner Selling Active.")
			local curCoords = GetEntityCoords(GetPlayerPed(-1))
			local dstCheck = GetDistanceBetweenCoords(plyStartCoords,curCoords)
			
			if dstCheck > 45.0 then
				EndSelling()
			end
			
			if sellingcocaine and not cocainetime then
				EndSelling()
			end
	
			if sellingcrack and not cracktime then
				EndSelling()
			end
	
	
			--local RandomNPC = GetRandomNPC()
			local RandomNPC = closestNPC()
			local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			local zone = tostring(GetNameOfZone(x, y, z))	
			local Area = zoneNames[tostring(zone)]
			local extraValue = 0
			--Left off here, remember to finish up selling event with delay.  Add in a reputation score for users, save it to the server side lua, then add it to the SQL on player dropped.
			--Deteriorate Reputation over time for players that have a reputation score > 0.
			if hotSpots[Area] then
				extraValue = hotSpots[Area]["ratio"]
			end
			local areaValue = extraValue -- fix this part DICK HEAD
			local saleprice = 100 + areaValue
			if math.random(100) < 90 then
				saleprice = math.random(80,saleprice)
				if sellingcocaine then
					saleprice = saleprice + math.random(80,saleprice)
				end
			end
	
			saleprice = saleprice * sellAmount
			if sellingweed then
				saleprice = math.ceil(saleprice / 1.2)
			end
			TriggerEvent("AllowSale",RandomNPC,saleprice)
	 
	
		end
		exports['mythic_notify']:SendAlert('inform', "Sales Ended.")
		--TriggerEvent("DoShortHudText", "Sales Ended.",10)
	
		TriggerEvent("increaseAI",false)
	
		Wait(60000)
		cooldown = false
	end)


	--Completed logic.  DO NOT TOUCH.
	local timeout = 0
	function closestNPC()
		local playerCoords = GetEntityCoords(GetPlayerPed(-1))
		local handle, ped = FindFirstPed()
		local success
		local rped = nil
		local distanceFrom = 999.0
		local pedcount = 0
		repeat
		Citizen.Wait(1)
		success, ped = FindNextPed(handle)
		--rped = ped
		 local pos = GetEntityCoords(ped)
		 local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
		 if distance < 30.0 and ped ~= GetPlayerPed(-1) and IsPedAPlayer(ped) == false then
		  pedcount = pedcount + 1
		if (distance < distanceFrom) and pedsused["conf"..ped] ~= true then
		   rped = ped
		   pedsused["conf"..rped] = true
		   if GetVehiclePedIsIn(rped, false) then
			local lastveh = GetVehiclePedIsIn(rped, false)
			pedcar["conf"..rped] = lastveh
		   end
		   distanceFrom = distance
		  end
		end
		 timeout = timeout + 1
		 
		if timeout == 250 then
		timeout = 0
		return rped
		end
		
		until not sucess and rped ~= nil
		 EndFindPed(handle)
		return rped
	end

	
	RegisterNetEvent('MovePed')
	AddEventHandler("MovePed",function(p)
		local usingped = p
	
		local nm1 = math.random(6,9) / 100
		local nm2 = math.random(6,9) / 100
		nm1 = nm1 + 0.3
		nm2 = nm2 + 0.3
		if math.random(10) > 5 then
		  nm1 = 0.0 - nm1
		end
	
		if math.random(10) > 5 then
		  nm2 = 0.0 - nm2
		end
	
		local moveto = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), nm1, nm2, 0.0)
		TaskGoStraightToCoord(usingped, moveto, 1.0, 30.0, 0.0, 0.0)
		SetPedKeepTask(usingped, true) 
	
		local dist = GetDistanceBetweenCoords(moveto, GetEntityCoords(usingped), false)
		local toolong = 0
		local lastcheck = GetDistanceBetweenCoords(GetEntityCoords(usingped),GetEntityCoords(GetPlayerPed(-1)))
	
		while dist > 3.5 and toolong < 600 and GetDistanceBetweenCoords(GetEntityCoords(usingped),GetEntityCoords(GetPlayerPed(-1))) > 1.5 do
			local dstmoved = lastcheck - GetDistanceBetweenCoords(GetEntityCoords(usingped),GetEntityCoords(GetPlayerPed(-1)))
			if dstmoved < 0.5 then
				toolong = toolong + 20
			end
		  toolong = toolong + 1
		  TaskGoStraightToCoord(usingped, moveto, 1.0, 30.0, 0.0, 0.0)
		  dist = GetDistanceBetweenCoords(moveto, GetEntityCoords(usingped), false)
		  Citizen.Wait(1000)
		  lastcheck = GetDistanceBetweenCoords(GetEntityCoords(usingped),GetEntityCoords(GetPlayerPed(-1)))
		end
	
		if toolong > 500 then
			TaskWanderStandard(usingped, 10.0, 10)
		else 
			
			TaskLookAtEntity(usingped, GetPlayerPed(-1), 5500.0, 2048, 3)
			TaskTurnPedToFaceEntity(usingped, GetPlayerPed(-1), 5500)
			if not sellingweed then
				TaskStartScenarioInPlace(usingped, "WORLD_HUMAN_BUM_STANDING", 0, 1)
			end
		end
	
	
	end)



	RegisterNetEvent('erp-gangs:updateGangRep')
	AddEventHandler('erp-gangs:updateGangRep', function(rep)

		reputation = rep
	end)


	RegisterNetEvent('AllowSale')
	AddEventHandler('AllowSale', function(NPC,saleprice)
		local timer = 0
		TriggerEvent("MovePed",NPC)
		--local checkPed = canPedBeUsed(NPC,false)
		--	if checkPed == false then
		--		print("Oops, the NPC died or some shit.")
		--		return
		--	end
			if NPC == nil then
				return
			end
			if NPC == GetPlayerPed(-1) then
				return
			end
		
			if not DoesEntityExist(NPC) then
				return
			end
		
			if IsPedAPlayer(NPC) then
				return
			end
		
			if IsPedFatallyInjured(NPC) then
				return
			end
		
			if IsPedFleeing(NPC) then
				return
			end
		
			if IsPedInCover(NPC) or IsPedGoingIntoCover(NPC) or IsPedGettingUp(NPC) then
				return
			end
		
			if IsPedInMeleeCombat(NPC) then
				return
			end
		
			if IsPedShooting(NPC) then
				return
			end
		
			if IsPedDucking(NPC) then
				return
			end
		
			if IsPedBeingJacked(NPC) then
				return
			end
		
			if IsPedSwimming(NPC) then
				return
			end
		
		--	if IsPedSittingInAnyVehicle(ped) or IsPedGettingIntoAVehicle(ped) or IsPedJumpingOutOfVehicle(ped) or IsPedBeingJacked(ped) then
		--		return false
		--	end
		
			if IsPedOnAnyBike(NPC) or IsPedInAnyBoat(NPC) or IsPedInFlyingVehicle(NPC) then
				return
			end
		
			local pedType = GetPedType(NPC)
			if pedType == 6 or pedType == 27 or pedType == 29 or pedType == 28 or pedType == 21 or pedType == 20 then
				return
			end
		local startdst = GetDistanceBetweenCoords(GetEntityCoords(NPC),GetEntityCoords(GetPlayerPed(-1)))
		while true do
			
			local curdst = GetDistanceBetweenCoords(GetEntityCoords(NPC),GetEntityCoords(GetPlayerPed(-1)))
			if curdst-6 > startdst then
				TaskWanderStandard(NPC, 10.0, 10)
				return
			end
			local x,y,z=table.unpack(GetEntityCoords(NPC))
			DrawText3DTest(x,y,z, "[E] to sell drugs $"..saleprice.. " [H] to shoo")
			if IsControlJustReleased(2,38) and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),x,y,z,true) < 2.0 then
				-- e stroke
				ClearPedTasks(NPC)
				ClearPedSecondaryTask(NPC)
	
				TaskTurnPedToFaceEntity(NPC, GetPlayerPed(-1), 1.0)
	
				SellDrugs(NPC,saleprice)
				return
			end
			if IsControlJustReleased(2,74) and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),x,y,z,true) < 5.0 then
				-- h stroke
				TaskWanderStandard(NPC, 10.0, 10)
				return
			end
			timer = timer + 1
			if timer > 60000 then
				TaskWanderStandard(NPC, 10.0, 10)
				return
			end
			Wait(1)
		end
	end)
	
	function loadAnimDict( dict )
		while ( not HasAnimDictLoaded( dict ) ) do
			RequestAnimDict( dict )
			Citizen.Wait( 5 )
		end
	end 





	function canPedBeUsed(ped,fresh)
		if ped == nil then
			return false
		end
	--	if pedsused["conf"..ped] and fresh then
	--	  return false
	--	end
		if ped == GetPlayerPed(-1) then
			return false
		end
	
		if not DoesEntityExist(ped) then
			return false
		end
	
		if IsPedAPlayer(ped) then
			return false
		end
	
		if IsPedFatallyInjured(ped) then
			return false
		end
	
		if IsPedFleeing(ped) then
			return false
		end
	
		if IsPedInCover(ped) or IsPedGoingIntoCover(ped) or IsPedGettingUp(ped) then
			return false
		end
	
		if IsPedInMeleeCombat(ped) then
			return false
		end
	
		if IsPedShooting(ped) then
			return false
		end
	
		if IsPedDucking(ped) then
			return false
		end
	
		if IsPedBeingJacked(ped) then
			return false
		end
	
		if IsPedSwimming(ped) then
			return false
		end
	
	--	if IsPedSittingInAnyVehicle(ped) or IsPedGettingIntoAVehicle(ped) or IsPedJumpingOutOfVehicle(ped) or IsPedBeingJacked(ped) then
	--		return false
	--	end
	
		if IsPedOnAnyBike(ped) or IsPedInAnyBoat(ped) or IsPedInFlyingVehicle(ped) then
			return false
		end
	
		local pedType = GetPedType(ped)
		if pedType == 6 or pedType == 27 or pedType == 29 or pedType == 28 or pedType == 21 or pedType == 20 then
			return false
		end
	
		return true
	end



	
	
	
	function giveAnim(NPC)
	
		if ( DoesEntityExist( NPC ) and not IsEntityDead( NPC ) ) then 
			
				loadAnimDict( "random@mugging4" )
				TaskPlayAnim( NPC, "random@mugging4", "agitated_loop_a", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
				Wait(1000)
	
	
			loadAnimDict( "mp_safehouselost@" )
	
			TaskPlayAnim( NPC, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
		
		end
	end
	
	function SellDrugs(NPC,saleprice)
	
		local success = true
	
		Citizen.Wait(500)
	
		PlayAmbientSpeech1(NPC, "Chat_State", "Speech_Params_Force")
		giveAnim(NPC)
		Wait(1000)
		--local counter = math.random(100,300)
		--while counter > 0 do
		--	counter = counter - 1
		--	Citizen.Wait(1)
		--end
	Citizen.Wait(1000)
		local crds = GetEntityCoords(NPC)
		local crds2 = GetEntityCoords(GetPlayerPed(-1))
	
		if GetDistanceBetweenCoords(crds,crds2) > 5.0 or not DoesEntityExist(NPC) or IsEntityDead(NPC) then
	
			return
		end
	
		local crack = exports["dsrp-inventory"]:hasEnoughOfItem("weedq",sellAmount,false)
		if crack and sellingcrack then
			--TriggerEvent("player:looseItemNOANIM", 112, sellAmount)
			TriggerEvent("inventory:removeItem", "1gcrack", 1)
			giveAnim(GetPlayerPed(-1))
			salesMade = salesMade + 1
			TriggerServerEvent("erp-gangs:addRep", salesMade, reputation)
		else
			exports['mythic_notify']:SendAlert('error', "You had no crack to sell.")
		end
	
		local weedbaggies = false --= exports["np-inventory"]:hasEnoughOfItem(83,sellAmount,false) Disabled Temp
		if weedbaggies and sellingweed then
			TriggerEvent("player:looseItemNOANIM", 83, sellAmount)
		end
	
	
		local cocaine = false --exports["dsrp-inventory"]:hasEnoughOfItem("1gcrack",sellAmount,false)
		if cocaine and sellingcocaine then
			TriggerEvent("player:looseItemNOANIM", 113, sellAmount)
		end
	
		if not cocaine and not crack and not weedbaggies then
			-- no product check
			TaskWanderStandard(NPC, 10.0, 10)
			return
		end
	
		if not weedbaggies and sellingweed then
			 EndSelling()
			 TaskWanderStandard(NPC, 10.0, 10)
			 return
		end	
	
	
		if not cocaine and sellingcocaine then
			 EndSelling()
			 TaskWanderStandard(NPC, 10.0, 10)
			 return
		end	
	
		if not crack and sellingcrack then
			 EndSelling()
			 TaskWanderStandard(NPC, 10.0, 10)
			 return
		end	
	
		if sellingcrack or sellingcocaine or sellingweed then
	
			if sellAmount > 1 then
				if math.random(35) < sellAmount then
					TriggerEvent("civilian:alertPolice",25.0,"drugsale",0)
				end
			end
			
			PlayAmbientSpeech1(NPC, "Generic_Thanks", "Speech_Params_Force_Shouted_Critical")
			TriggerServerEvent('mission:completed', saleprice)
			TriggerServerEvent("police:multipledenominators",true)
			TriggerEvent("denoms",true)
			TriggerEvent("client:newStress",true,50)
	
			
			Wait(4000)
			--TaskWanderStandard(NPC, 10.0, 10) --HEre we can add a task for the NPC if it was in a vehicle
			
			if pedcar["conf"..NPC] ~= 0 then
			TaskEnterVehicle(NPC, pedcar["conf"..NPC], 0, -1, 1.0, 1, 0)
			else 
			TaskWanderStandard(NPC, 10.0, 10)
			end
	
		end
	
	end
	
	
RegisterNetEvent('increaseAI')
AddEventHandler('increaseAI', function(increase)
	increaseAI = increase
end)


function ClearInfo()
pedcar = {}
pedsused = {}


end

	
	
	
	
	
	RegisterNetEvent('cocainetime')
	AddEventHandler('cocainetime', function(pass)
		cocainetime = pass
	end)
	
	RegisterNetEvent('cracktime')
	AddEventHandler('cracktime', function(pass)
		cracktime = pass	
	end)
	
	
	
	local center = { ['x'] = -1821.92,['y'] = 2179.16,['z'] = 103.71,['h'] = 329.43, ['info'] = ' Center' }
	
	local entrance = { ['x'] = -1926.44,['y'] = 2060.94,['z'] = 140.84,['h'] = 118.17, ['info'] = 'Winery Entrance' }
	
	local machinepress = { ['x'] = 1003.85,['y'] = -3199.45,['z'] = -38.99,['h'] = 189.63, ['info'] = 'Grape Press' }
	
	local workvehicles = 0
	
	local weedlevel = 1
	
	RegisterNetEvent('weed:percent')
	AddEventHandler('weed:percent', function(percentweed)
		
		if percentweed < 34 then
			weedlevel = 1
		elseif percentweed < 75 then
			weedlevel = 2
		else
			weedlevel = 3
		end
		WeedProgress()
	end)
	
	function WeedProgress()
	
		EnableInteriorProp(247297, "weed_growtha_stage1")
		EnableInteriorProp(247297, "weed_growthb_stage1")
		DisableInteriorProp(247297, "weed_growthc_stage1")
	
		EnableInteriorProp(247297, "weed_growthd_stage1")
		EnableInteriorProp(247297, "weed_growthe_stage1")
		DisableInteriorProp(247297, "weed_growthf_stage1")
	
		EnableInteriorProp(247297, "weed_growthg_stage1")
		DisableInteriorProp(247297, "weed_growthh_stage1")
		EnableInteriorProp(247297, "weed_growthi_stage1")
	
		DisableInteriorProp(247297, "weed_growtha_stage2")
		DisableInteriorProp(247297, "weed_growthb_stage2")
		DisableInteriorProp(247297, "weed_growthc_stage2")
	
		DisableInteriorProp(247297, "weed_growthd_stage2")
		DisableInteriorProp(247297, "weed_growthe_stage2")
		DisableInteriorProp(247297, "weed_growthf_stage2")
	
		DisableInteriorProp(247297, "weed_growthg_stage2")
		DisableInteriorProp(247297, "weed_growthh_stage2")
		DisableInteriorProp(247297, "weed_growthi_stage2")
	
		DisableInteriorProp(247297, "weed_growtha_stage3")
		DisableInteriorProp(247297, "weed_growthb_stage3")
		DisableInteriorProp(247297, "weed_growthc_stage3")
	
		DisableInteriorProp(247297, "weed_growthd_stage3")
		DisableInteriorProp(247297, "weed_growthe_stage3")
		DisableInteriorProp(247297, "weed_growthf_stage3")
	
		DisableInteriorProp(247297, "weed_growthg_stage3")
		DisableInteriorProp(247297, "weed_growthh_stage3")
		DisableInteriorProp(247297, "weed_growthi_stage3")
	
		if weedlevel < 3 then
			DisableInteriorProp(247297, "weed_growtha_stage"..weedlevel)
			DisableInteriorProp(247297, "weed_growthb_stage"..weedlevel)
			EnableInteriorProp(247297, "weed_growthc_stage"..weedlevel)
	
			DisableInteriorProp(247297, "weed_growthd_stage"..weedlevel)
			DisableInteriorProp(247297, "weed_growthe_stage"..weedlevel)
			EnableInteriorProp(247297, "weed_growthf_stage"..weedlevel)
	
			DisableInteriorProp(247297, "weed_growthg_stage"..weedlevel)
			EnableInteriorProp(247297, "weed_growthh_stage"..weedlevel)
			DisableInteriorProp(247297, "weed_growthi_stage"..weedlevel)
		else
			EnableInteriorProp(247297, "weed_growtha_stage"..3)
			EnableInteriorProp(247297, "weed_growthb_stage"..2)
			EnableInteriorProp(247297, "weed_growthc_stage"..2)
	
			EnableInteriorProp(247297, "weed_growthd_stage"..2)
			EnableInteriorProp(247297, "weed_growthe_stage"..2)
			EnableInteriorProp(247297, "weed_growthf_stage"..3)
	
			EnableInteriorProp(247297, "weed_growthg_stage"..3)
			EnableInteriorProp(247297, "weed_growthh_stage"..2)
			EnableInteriorProp(247297, "weed_growthi_stage"..2)
		end
		RefreshInterior(247297)
	
	end
	
	function workvehicle()
		local car = GetHashKey("BLAZER")
		RequestModel(car)
		while not HasModelLoaded(car) do
			Citizen.Wait(1)
		end						
		local veh = CreateVehicle(car, center["x"],center["y"],center["z"], 0.0, true, false)
		DecorSetInt(veh, "CurrentFuel", 100)
	
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh, false) 
		SetVehicleOnGroundProperly(veh)
		local plate = "wine" .. math.random(111,999)
		SetVehicleNumberPlateText(veh, plate)
		Citizen.Wait(100)
		plate = GetVehicleNumberPlateText(veh)
		TriggerEvent("keys:addNew",veh,plate)
		TriggerServerEvent('garges:addJobPlate', plate)
		workvehicles = veh
	end
	
	local currentWorkNumber = 0
	RegisterNetEvent("weed:completedTask")
	AddEventHandler("weed:completedTask", function()
		currentWorkNumber = 0 
	end)
	
	
	
	
	
	
	
	
	
	  --  [7] = {["name"] = "Cocaine Baggy (10g)", ["price"] = 700,    ["weight"] = 10,["nonStack"] = false,["model"] = "", ["image"] = "np_cocaine-baggy.png", ["information"] = "Increases your Stamina and Movement Speed"},
	  --  [8] = {["name"] = "Cocaine Brick (50g)",["price"] = 2200,  ["weight"] = 52,["nonStack"] = false,["model"] = "", ["image"] = "np_cocaine-brick.png", ["information"] = "Increases your Stamina and Movement Speed <br> Breaks down into product."}, -- 20 crates, 1 Brick is equal to 20 bags
	   -- [99] = {["name"] ="Small Scales",           ["price"] = 150,    ["weight"] = 1,   ["nonStack"] = false,["model"] = "", ["image"] = "np_small-scale.png", ["information"] = "Weighs Baggies with minimal loss"},
	   -- [100] = {["name"] = "High Quality Scales",  ["price"] = 1000,   ["weight"] = 2,   ["nonStack"] = false,["model"] = "", ["image"] = "np_high-quality-scales.png", ["information"] = "Weighs Baggies with no loss"},
	   -- [101] = {["name"] = "Pack of Empty Baggies",["price"] = 50,     ["weight"] = 1,   ["nonStack"] = false,["model"] = "", ["image"] = "np_pack-of-empty-baggies.png"},
	
	   -- [104] = {["name"] = "Oxy 100mg",      ["price"] = 100,    ["weight"] = 0,   ["nonStack"] = false, ["model"] = "", ["image"] = "np_Oxy.png", ["information"] = "Limits Stress to 0 for an extended period of time <br> Increases Thirst <br> Has addiction properties "},
	   -- [105] = {["name"] = "1g 10% Cocaine",      ["price"] = 100,    ["weight"] = 0,   ["nonStack"] = false, ["model"] = "", ["image"] = "np_cocaine-baggy.png", ["information"] = "10% Cut Cocaine. "},
	   -- [106] = {["name"] = "1g 35% Cocaine",      ["price"] = 100,    ["weight"] = 0,   ["nonStack"] = false, ["model"] = "", ["image"] = "np_cocaine-baggy.png", ["information"] = "35% Cut Cocaine. "},
	   -- [107] = {["name"] = "500g Glucose",      ["price"] = 100,    ["weight"] = 0,   ["nonStack"] = false, ["model"] = "", ["image"] = "np_cocaine-baggy.png", ["information"] = "Mmmm Glucose. "},
	
	
	
	
	
	
	
	RegisterNetEvent("weed:currenttask")
	AddEventHandler("weed:currenttask", function(workNumber,amountRequired)
		currentWorkNumber = 0 
		Citizen.Wait(1000)
		currentWorkNumber = workNumber
		while currentWorkNumber ~= 0 do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1))
			local x = workArray[workNumber]["x"]
			local y = workArray[workNumber]["y"]
			local z = workArray[workNumber]["z"]
			local msg = workArray[workNumber]["info"]
			local itemname = workArray[workNumber]["name"]
			local dstCheck = GetDistanceBetweenCoords(plyCoords,x,y,z)
			if dstCheck < 25.0 then
				DrawText3DTest(x,y,z, "[E]" .. msg .. " (" .. amountRequired .. " " .. itemname .. ")")
				if IsControlJustPressed(0, 38) and dstCheck < 3.0 then
					CheckAcceptWeed(workNumber,amountRequired)
				end
			elseif dstCheck > 50.0 then
				Citizen.Wait(1000)
			end
			Citizen.Wait(1)
		end
	end)
	
	function CheckAcceptWeed(workNumber,amountRequired)
		local itemid = workArray[workNumber]["itemid"]
		local hasitems --= exports["np-inventory"]:hasEnoughOfItem(itemid,amountRequired,false) Disabled temp
		if hasitems then
			currentWorkNumber = 0
			TriggerEvent("SendAlert","You have fixed the problems.",1)
			TriggerServerEvent("weed:updatePercent")
			TriggerEvent("player:looseItem", '' .. itemid .. '', amountRequired)
		else
			TriggerEvent("SendAlert","You do not have the required materials.",2)
		end
		Citizen.Wait(2000)
	end
	
	
	
	
	
	
	
	local currentWorkNumberCOKE = 0
	RegisterNetEvent("COKENEW:completedTask")
	AddEventHandler("COKENEW:completedTask", function()
		currentWorkNumberCOKE = 0 
	end)
	
	RegisterNetEvent("COKENEW:currenttask")
	AddEventHandler("COKENEW:currenttask", function(workNumber,amountRequired)
		currentWorkNumberCOKE = 0 
		Citizen.Wait(1000)
		currentWorkNumberCOKE = workNumber
		while currentWorkNumberCOKE ~= 0 do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1))
			local x = workArray2[workNumber]["x"]
			local y = workArray2[workNumber]["y"]
			local z = workArray2[workNumber]["z"]
			local msg = workArray2[workNumber]["info"]
			local itemname = workArray2[workNumber]["name"]
			local dstCheck = GetDistanceBetweenCoords(plyCoords,x,y,z)
			if dstCheck < 25.0 then
				DrawText3DTest(x,y,z, "[E]" .. msg .. "")
				if IsControlJustPressed(0, 38) and dstCheck < 3.0 then
					CheckAcceptCOKENEW(workNumber,amountRequired)
				end
			elseif dstCheck > 50.0 then
				Citizen.Wait(1000)
			end
			Citizen.Wait(1)
		end
	end)
	
	function CheckAcceptCOKENEW(workNumber,amountRequired)
		local itemid = workArray2[workNumber]["itemid"]
	
		currentWorkNumberCOKE = 0
		TriggerEvent("animation:PlayAnimation","clipboard")
	
		Citizen.Wait(10000)
		TriggerEvent("SendAlert","You have fixed the problems.",1)
		TriggerServerEvent("cocaine:updatePercent")
	
	
		Citizen.Wait(2000)
		TriggerEvent("animation:PlayAnimation","cancel")
	end
	
	
	
	
	
	
	
	
	function inveh()
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			return true
		end
		return false
	end
	
	
	
	RegisterNetEvent("gangTasks:deliveryTask")
	AddEventHandler("gangTasks:deliveryTask", function(cidsent, TaskNumber)
	
		local cid --= exports["isPed"]:isPed("cid") Disabled Temp

	
		if tonumber(cid) ~= tonumber(cidsent) then
			return
		end
	
		Citizen.Wait(1000)
		TriggerEvent("SendAlert", activeTasks[TaskNumber]["TaskInfo"])
		local deliveryType = activeTasks[TaskNumber]["ObjectType"]
	
		local returnpoint = activeTasks[TaskNumber]["Returns"]
		local dst = GetDistanceBetweenCoords(activeTasks[TaskNumber]["Location"]["x"],activeTasks[TaskNumber]["Location"]["y"],activeTasks[TaskNumber]["Location"]["z"],myCrds,true)
		SetGps(TaskNumber)
		local failure = 180000
		while dst > 15.0 and failure > 0 do
			Citizen.Wait(1)
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(activeTasks[TaskNumber]["Location"]["x"],activeTasks[TaskNumber]["Location"]["y"],activeTasks[TaskNumber]["Location"]["z"],myCrds,true)
			failure = failure - 1
		end
	
		if failure == 0 then
			TriggerServerEvent("task:TaskStateUpdate",TaskNumber,4)
			return
		end
	
		
		-- create veh give keys.
		local taskveh = 0
		local rank --= exports["isPed"]:GroupRank("carpet_factory") Disabled temp
		if rank > 0 then
			loadModel("rumpo4")
			taskveh = CreateVehicle(GetHashKey("rumpo4"), activeTasks[TaskNumber]["Location"]["x"],activeTasks[TaskNumber]["Location"]["y"],activeTasks[TaskNumber]["Location"]["z"], activeTasks[TaskNumber]["Location"]["h"], true, false)
			SetVehicleLivery(taskveh,0)
		else
			loadModel("rumpo")
			taskveh = CreateVehicle(GetHashKey("rumpo"), activeTasks[TaskNumber]["Location"]["x"],activeTasks[TaskNumber]["Location"]["y"],activeTasks[TaskNumber]["Location"]["z"], activeTasks[TaskNumber]["Location"]["h"], true, false)
			SetVehicleLivery(taskveh,0)
		end
	
	
	
		SetVehicleOnGroundProperly(taskveh)
		SetVehicleHasBeenOwnedByPlayer(taskveh,true)
		local id = NetworkGetNetworkIdFromEntity(taskveh)
		SetNetworkIdCanMigrate(id, true)
	
		SetVehicleWindowTint(taskveh, 1.0)
		local plate = GetVehicleNumberPlateText(taskveh)
		SetVehicleHasBeenOwnedByPlayer(taskveh,true)
		TriggerEvent("keys:addNew",taskveh,plate)
		TriggerEvent("SendAlert", "Jump in that van, the keys are in it!")
		-- spawn object in vehicle
	
		if deliveryType == 1 then
	
			loadModel("mp_f_deadhooker")
	
			local ped = CreatePed(GetPedType(GetHashKey("mp_f_deadhooker")), GetHashKey("mp_f_deadhooker"), activeTasks[TaskNumber]["Location"]["x"],activeTasks[TaskNumber]["Location"]["y"],activeTasks[TaskNumber]["Location"]["z"]-10, activeTasks[TaskNumber]["Location"]["h"], 1, 1)	
	
	
			AttachEntityToEntity(ped, taskveh, GetEntityBoneIndexByName(taskveh, 'bodyshell'), 0.0, -0.8, 0.6, 0, 0, 0, 1, 1, 0, 1, 0, 1)
	
			loadAnim( "dead" ) 
			TaskPlayAnim(ped, "dead", "dead_f", 8.0, 8.0, -1, 1, 0, 0, 0, 0)
	
			failure = DoBodyTask(TaskNumber,failure,taskveh,ped)
		elseif deliveryType == 2 then
	
			loadModel("prop_cs_cardbox_01")
			local obj = CreateObject(GetHashKey("prop_cs_cardbox_01"), activeTasks[TaskNumber]["Location"]["x"],activeTasks[TaskNumber]["Location"]["y"],activeTasks[TaskNumber]["Location"]["z"]-10, 1, 0, 0)
	
	
			AttachEntityToEntity(obj, taskveh, GetEntityBoneIndexByName(taskveh, 'bodyshell'), 0.0, -0.8, -0.4, 0, 0, 0, 1, 1, 0, 1, 0, 1)
			failure = DoObjectTask(TaskNumber,failure,taskveh,obj)
		elseif deliveryType == 3 then
	
			loadModel("prop_cs_cardbox_01")
			local obj = CreateObject(GetHashKey("prop_cs_cardbox_01"), activeTasks[TaskNumber]["Location"]["x"],activeTasks[TaskNumber]["Location"]["y"],activeTasks[TaskNumber]["Location"]["z"]-10, 1, 0, 0)
	
			AttachEntityToEntity(obj, taskveh, GetEntityBoneIndexByName(taskveh, 'bodyshell'), 0.0, -0.8, -0.4, 0, 0, 0, 1, 1, 0, 1, 0, 1)
			failure = DoObjectTaskInside(TaskNumber,failure,taskveh,obj)
		end
	
		activeTasks[TaskNumber]["Location"]["x"] = returnpoint["x"]
		activeTasks[TaskNumber]["Location"]["y"] = returnpoint["y"]
		activeTasks[TaskNumber]["Location"]["z"] = returnpoint["z"]
	
	
		TriggerServerEvent("gangTasks:newCoords",TaskNumber,activeTasks)
	
	
		local myCrds = GetEntityCoords(GetPlayerPed(-1))
		local dst = GetDistanceBetweenCoords(returnpoint["x"],returnpoint["y"],returnpoint["z"],myCrds,true)
		
		Citizen.Wait(1000)
		SetGps(TaskNumber)
		TriggerEvent("SendAlert","Return the van!",1)
		while dst > 100.0 and failure > 0 do
			Citizen.Wait(1)
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(returnpoint["x"],returnpoint["y"],returnpoint["z"],myCrds,true)
			failure = failure - 1
		end
		
		while GetEntitySpeed(taskveh) > 1.0 and taskveh ~= 0 do
			Citizen.Wait(1)
		end
		local bonus = 420
		local engHealth = GetVehicleEngineHealth(taskveh)
		local bodHealth = GetVehicleBodyHealth(taskveh)	
	
		SetVehicleAsNoLongerNeeded(taskveh)
	
		bonus = bonus - (50 - (bodHealth / 20)) - (100 -(engHealth / 10))
		bonus = math.ceil(bonus)
	
	
		if failure == 0 then
			TriggerServerEvent("task:TaskStateUpdate",TaskNumber,4)
			return
		else
			if bonus < 420 then
				activeTasks[TaskNumber]["TaskState"] = 5
				TriggerServerEvent("task:TaskStateUpdate",TaskNumber,5,math.random(bonus))			
			else
				activeTasks[TaskNumber]["TaskState"] = 3
				TriggerServerEvent("task:TaskStateUpdate",TaskNumber,3,bonus)
			end
		end
	
	end)
	
	
	function DoObjectTaskInside(TaskNumber,failure,taskveh,obj)
	
		local myCrds = GetEntityCoords(GetPlayerPed(-1))
		local robid = math.random(188)
		local DeliveryLocation = deliveryCoords[robid]
		local dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
	
		activeTasks[TaskNumber]["Location"]["x"] = DeliveryLocation["x"]
		activeTasks[TaskNumber]["Location"]["y"] = DeliveryLocation["y"]
		activeTasks[TaskNumber]["Location"]["z"] = DeliveryLocation["z"]
	
	
		TriggerServerEvent("gangTasks:newCoords",TaskNumber,activeTasks)
	
	
	
		Citizen.Wait(1000)
		SetGps(TaskNumber)
	
	
		while dst > 50.0 and failure > 0 do
			Citizen.Wait(1)
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
			failure = failure - 1
		end
	
		local pickedup = false
		while not pickedup and failure > 0 do
			Citizen.Wait(1)
			local d1,d2 = GetModelDimensions(GetEntityModel(taskveh))
			local myCrds = GetOffsetFromEntityInWorldCoords(taskveh, 0.0,d1["y"]-0.5,0.0)
			dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),myCrds,true)
			DrawText3DTest(myCrds["x"],myCrds["y"],myCrds["z"], "[E] Take The Package")
			failure = failure - 1
			if IsControlJustPressed(0, 38) then
	
				SetVehicleDoorOpen(taskveh, 2, 1, 1)
				SetVehicleDoorOpen(taskveh, 3, 1, 1) 
				TaskTurnPedToFaceEntity(GetPlayerPed(-1), taskveh, 1.0)
				Citizen.Wait(500)
	
	
				Citizen.Wait(500)
				DetachEntity(obj)
				attachObjPed(obj)
				ClearPedTasks(GetPlayerPed(-1))
				ClearPedSecondaryTask(GetPlayerPed(-1))
				CarryBoxAnim()
				SetVehicleDoorShut(taskveh, 2, 1, 1)
				SetVehicleDoorShut(taskveh, 3, 1, 1) 
				pickedup = true
			end
		end
	
		local holdingPackage = true
		dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
		while dst > 0.8 and failure > 0 do
			Citizen.Wait(1)
	
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
			failure = failure - 1
	
			if holdingPackage then
				DrawText3DTest(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"], "Enter Here with Package")
				if not IsEntityPlayingAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "idle", 3) then
					CarryBoxAnim()
				end
			else
				local pedcrds = GetEntityCoords(obj)
				DrawText3DTest(pedcrds["x"],pedcrds["y"],pedcrds["z"], "Pickup Package [E]")
			end
			
			if IsControlJustPressed(0, 38) or (GetHashKey("WEAPON_UNARMED") ~= GetSelectedPedWeapon(GetPlayerPed(-1)) and holdingPackage) then
				holdingPackage = not holdingPackage
				if holdingPackage then
					CarryBoxAnim()
					Citizen.Wait(500)
					attachObjPed(obj)
				else
					ClearPedTasks(GetPlayerPed(-1))
					DetachEntity(obj)
					DetachEntity(GetPlayerPed(-1))
				end
			end
		end	
	
		local holdingPackage = true
		local plantedBox = false
	
		-- create room and tp   robid
	
		TriggerServerEvent("houserobberies:enter",robid,false)
	
		local myCrds = GetEntityCoords(GetPlayerPed(-1))
		dst = GetDistanceBetweenCoords(DeliveryLocation["x"]+1.9,DeliveryLocation["y"]-3.8,DeliveryLocation["z"]-23,myCrds,true)
		while failure > 0 and not plantedBox do
			Citizen.Wait(1)
			
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(DeliveryLocation["x"]+1.1,DeliveryLocation["y"]-3.8,DeliveryLocation["z"] - 23,myCrds,true)
	
			if IsControlJustPressed(0, 38) or (GetHashKey("WEAPON_UNARMED") ~= GetSelectedPedWeapon(GetPlayerPed(-1)) and holdingPackage) then
				holdingPackage = not holdingPackage
				if holdingPackage then
					CarryBoxAnim()
					Citizen.Wait(500)
					attachObjPed(obj)
				else
					ClearPedTasks(GetPlayerPed(-1))
					DetachEntity(obj)
					DetachEntity(GetPlayerPed(-1))
				end
			end
	
			if holdingPackage then
				DrawText3DTest(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"], "Enter Here with Package")
				if not IsEntityPlayingAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "idle", 3) then
					CarryBoxAnim()
				end
			else
				local pedcrds = GetEntityCoords(obj)
				DrawText3DTest(pedcrds["x"],pedcrds["y"],pedcrds["z"], "Pickup Package [E]")
			end
	
	
			if dst < 1.5 then
				plantedBox = true
				ClearPedTasks(GetPlayerPed(-1))
				DetachEntity(obj)
				DetachEntity(GetPlayerPed(-1))
			else
				DrawText3DTest( DeliveryLocation["x"]+1.1,DeliveryLocation["y"]-3.8,DeliveryLocation["z"] - 23, 'Drop Box Here!' )
			end
		end
	
		local hasLeft = false
		while failure > 0 and not hasLeft do
			Citizen.Wait(1)
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
			failure = failure - 1
	
			if (GetDistanceBetweenCoords(DeliveryLocation["x"] + 4.3,DeliveryLocation["y"] - 15.95,DeliveryLocation["z"]-24.42, GetEntityCoords(GetPlayerPed(-1))) < 10.0 ) then
				DrawText3DTest( (DeliveryLocation["x"] + 4.3),(DeliveryLocation["y"] - 15.95),(DeliveryLocation["z"]-21.42), 'RUN - ITS GONNA BLOW!' )
				if (GetDistanceBetweenCoords(DeliveryLocation["x"] + 4.3,DeliveryLocation["y"] - 15.95,DeliveryLocation["z"]-24.42, GetEntityCoords(GetPlayerPed(-1))) < 3.0 ) then
					SetEntityCoords(GetPlayerPed(-1),DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"])
					Citizen.Wait(10000)
					hasLeft = true
				end
			end
		end	
	
	
		DeleteEntity(obj)
		return failure
	end
	
	function DoObjectTaskGroup(TaskNumber,failure,taskveh,obj)
		local myCrds = GetEntityCoords(GetPlayerPed(-1))
		local DeliveryLocation = deliveryCoords[math.random(#deliveryCoords)]
		local dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
	
		activeTasks[TaskNumber]["Location"]["x"] = DeliveryLocation["x"]
		activeTasks[TaskNumber]["Location"]["y"] = DeliveryLocation["y"]
		activeTasks[TaskNumber]["Location"]["z"] = DeliveryLocation["z"]
	
	
		TriggerServerEvent("gangTasks:newCoords",TaskNumber,activeTasks)
		Citizen.Wait(1000)
		SetGps(TaskNumber)
	
		while dst > 50.0 and failure > 0 do
			Citizen.Wait(1)
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
			failure = failure - 1
		end
	
		local pickedup = false
		while not pickedup and failure > 0 do
			Citizen.Wait(1)
			local d1,d2 = GetModelDimensions(GetEntityModel(taskveh))
			local myCrds = GetOffsetFromEntityInWorldCoords(taskveh, 0.0,d1["y"]-0.5,0.0)
			dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),myCrds,true)
			DrawText3DTest(myCrds["x"],myCrds["y"],myCrds["z"], "[E] Take The Package")
			failure = failure - 1
			if IsControlJustPressed(0, 38) then
	
				SetVehicleDoorOpen(taskveh, 2, 1, 1)
				SetVehicleDoorOpen(taskveh, 3, 1, 1) 
				TaskTurnPedToFaceEntity(GetPlayerPed(-1), taskveh, 1.0)
				Citizen.Wait(500)
	
	
				Citizen.Wait(500)
				DetachEntity(obj)
				attachObjPed(obj)
				ClearPedTasks(GetPlayerPed(-1))
				ClearPedSecondaryTask(GetPlayerPed(-1))
				CarryBoxAnim()
	
				SetVehicleDoorShut(taskveh, 2, 1, 1)
				SetVehicleDoorShut(taskveh, 3, 1, 1) 
				pickedup = true
			end
		end
	
		local holdingPackage = true
		dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
		while dst > 0.8 and failure > 0 do
			Citizen.Wait(1)
	
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
			failure = failure - 1
	
			if holdingPackage then
				DrawText3DTest(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"], "Drop Here")
				if not IsEntityPlayingAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "idle", 3) then
					CarryBoxAnim()
				end
			else
				local pedcrds = GetEntityCoords(obj)
				DrawText3DTest(pedcrds["x"],pedcrds["y"],pedcrds["z"], "Pickup Package [E]")
			end
			
			if IsControlJustPressed(0, 38) or (GetHashKey("WEAPON_UNARMED") ~= GetSelectedPedWeapon(GetPlayerPed(-1)) and holdingPackage) then
				holdingPackage = not holdingPackage
				if holdingPackage then
					CarryBoxAnim()
					Citizen.Wait(500)
					attachObjPed(obj)
				else
					ClearPedTasks(GetPlayerPed(-1))
					DetachEntity(obj)
					DetachEntity(GetPlayerPed(-1))
				end
			end
		end	
	
		DetachEntity(obj)
		SetEntityAsNoLongerNeeded(obj)
		ClearPedTasks(GetPlayerPed(-1))
		ClearPedSecondaryTask(GetPlayerPed(-1))
		while dst < 20.0 and failure > 0 do
			Citizen.Wait(1)
			DrawText3DTest(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"], "Leave the Area.")
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
			failure = failure - 1
		end	
	
	
		TriggerEvent("SendAlert", "Thanks for that!")
	
	
		DeleteEntity(obj)
		return failure
	
	end
	
	
	
	function DoObjectTask(TaskNumber,failure,taskveh,obj)
	
		local myCrds = GetEntityCoords(GetPlayerPed(-1))
		local DeliveryLocation = deliveryCoords[math.random(#deliveryCoords)]
		local dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
	
		activeTasks[TaskNumber]["Location"]["x"] = DeliveryLocation["x"]
		activeTasks[TaskNumber]["Location"]["y"] = DeliveryLocation["y"]
		activeTasks[TaskNumber]["Location"]["z"] = DeliveryLocation["z"]
	
	
		TriggerServerEvent("gangTasks:newCoords",TaskNumber,activeTasks)
	
	
	
	
		Citizen.Wait(1000)
		SetGps(TaskNumber)
	
		while dst > 50.0 and failure > 0 do
			Citizen.Wait(1)
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
			failure = failure - 1
		end
	
		local pickedup = false
		while not pickedup and failure > 0 do
			Citizen.Wait(1)
			local d1,d2 = GetModelDimensions(GetEntityModel(taskveh))
			local myCrds = GetOffsetFromEntityInWorldCoords(taskveh, 0.0,d1["y"]-0.5,0.0)
			dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),myCrds,true)
			DrawText3DTest(myCrds["x"],myCrds["y"],myCrds["z"], "[E] Take The Package")
			failure = failure - 1
			if IsControlJustPressed(0, 38) then
	
				SetVehicleDoorOpen(taskveh, 2, 1, 1)
				SetVehicleDoorOpen(taskveh, 3, 1, 1) 
				TaskTurnPedToFaceEntity(GetPlayerPed(-1), taskveh, 1.0)
				Citizen.Wait(500)
	
	
				Citizen.Wait(500)
				DetachEntity(obj)
				attachObjPed(obj)
				ClearPedTasks(GetPlayerPed(-1))
				ClearPedSecondaryTask(GetPlayerPed(-1))
				CarryBoxAnim()
	
				SetVehicleDoorShut(taskveh, 2, 1, 1)
				SetVehicleDoorShut(taskveh, 3, 1, 1) 
				pickedup = true
			end
		end
	
		local holdingPackage = true
		dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
		while dst > 0.8 and failure > 0 do
			Citizen.Wait(1)
	
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
			failure = failure - 1
	
			if holdingPackage then
				DrawText3DTest(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"], "Drop Here")
				if not IsEntityPlayingAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "idle", 3) then
					CarryBoxAnim()
				end
			else
				local pedcrds = GetEntityCoords(obj)
				DrawText3DTest(pedcrds["x"],pedcrds["y"],pedcrds["z"], "Pickup Package [E]")
			end
			
			if IsControlJustPressed(0, 38) or (GetHashKey("WEAPON_UNARMED") ~= GetSelectedPedWeapon(GetPlayerPed(-1)) and holdingPackage) then
				holdingPackage = not holdingPackage
				if holdingPackage then
					CarryBoxAnim()
					Citizen.Wait(500)
					attachObjPed(obj)
				else
					ClearPedTasks(GetPlayerPed(-1))
					DetachEntity(obj)
					DetachEntity(GetPlayerPed(-1))
				end
			end
		end	
	
		DetachEntity(obj)
		SetEntityAsNoLongerNeeded(obj)
		ClearPedTasks(GetPlayerPed(-1))
		ClearPedSecondaryTask(GetPlayerPed(-1))
		while dst < 20.0 and failure > 0 do
			Citizen.Wait(1)
			DrawText3DTest(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"], "Leave the Area.")
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(DeliveryLocation["x"],DeliveryLocation["y"],DeliveryLocation["z"],myCrds,true)
			failure = failure - 1
		end	
	
	
		TriggerEvent("SendAlert", "Thanks for that!")
	
	
	
		DeleteEntity(obj)
		return failure
	
	end
	
	function CarryBoxAnim()
		local dic = "anim@heists@box_carry@"
		local anim = "idle"
		local lPed = GetPlayerPed(-1)
	
		if not IsEntityPlayingAnim(lPed, dic, anim, 3) and not inveh() then
			loadAnim( dic ) 
			TaskPlayAnim(lPed, dic, anim, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
		end
	
	end
	function attachObjPedVeh(obj)
		if inveh() then
			if GetVehiclePedIsUsing(GetPlayerPed(-1)) == workvehicles then
				local bone = GetPedBoneIndex(workvehicles, 1)
				AttachEntityToEntity(obj, workvehicles, GetEntityBoneIndexByName(workvehicles, 'bodyshell'), 0.0, -0.65, 0.47, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
			end
		else
			local bone = GetPedBoneIndex(GetPlayerPed(-1), 28422)
			AttachEntityToEntity(obj, GetPlayerPed(-1), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
		end
	
	end
	
	function attachObjPed(obj)
		local bone = GetPedBoneIndex(GetPlayerPed(-1), 28422)
		AttachEntityToEntity(obj, GetPlayerPed(-1), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
	end
	
	function DoBodyTask(TaskNumber,failure,taskveh,ped)
		local myCrds = GetEntityCoords(GetPlayerPed(-1))
		local tskCrds = GetEntityCoords(taskveh)
		local dst = GetDistanceBetweenCoords(tskCrds,myCrds,true)
		
		SetBlockingOfNonTemporaryEvents(ped, true)		
		SetPedSeeingRange(ped, 0.0)		
		SetPedHearingRange(ped, 0.0)		
		SetPedFleeAttributes(ped, 0, false)		
		SetPedKeepTask(ped, true)		
	
		local taskcomplete = false
		while dst > 15.0 and failure > 0 do
			Citizen.Wait(1)
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(tskCrds,myCrds,true)
			tskCrds = GetEntityCoords(taskveh)
			DrawText3DTest(tskCrds["x"],tskCrds["y"],tskCrds["z"], "Get In Vehicle")
			failure = failure - 1
		end
	
	
		activeTasks[TaskNumber]["Location"]["x"] = 954.92
		activeTasks[TaskNumber]["Location"]["y"] = -2184.58
		activeTasks[TaskNumber]["Location"]["z"] = 30.56
	
	
		TriggerServerEvent("gangTasks:newCoords",TaskNumber,activeTasks)
	
	
	
		SetGps(TaskNumber)
		dst = GetDistanceBetweenCoords(954.92,-2184.58,30.56,myCrds,true)
		while dst > 5.0 and failure > 0 do
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(954.92,-2184.58,30.56,myCrds,true)
			Citizen.Wait(1)
		end
	
		local bodyTaken = false
	
		while not bodyTaken and failure > 0 do
			local d1,d2 = GetModelDimensions(GetEntityModel(taskveh))
			local myCrds = GetOffsetFromEntityInWorldCoords(taskveh, 0.0,d1["y"]-0.5,0.0)
			dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),myCrds,true)
			DrawText3DTest(myCrds["x"],myCrds["y"],myCrds["z"], "[E] Take The Body")
			Citizen.Wait(1)		
			if IsControlJustPressed(0, 38) and dst < 1.5 then
				loadAnim('anim@narcotics@trash')
				TaskPlayAnim(GetPlayerPed(-1),'anim@narcotics@trash', 'drop_front',0.9, -8, 1500, 49, 3.0, 0, 0, 0) 
				TaskTurnPedToFaceEntity(GetPlayerPed(-1), taskveh, 1.0)
				SetVehicleDoorOpen(taskveh, 2, 1, 1)
				SetVehicleDoorOpen(taskveh, 3, 1, 1)   
				Citizen.Wait(1600)
				ClearPedTasks(GetPlayerPed(-1))	  
				bodyTaken = true 
	
				DetachEntity(ped)
				ClearPedTasks(ped)
				loadAnim( "amb@world_human_bum_slumped@male@laying_on_left_side@base" ) 
				TaskPlayAnim(ped, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
				attachCarryPed(ped)
				SetVehicleDoorShut(taskveh, 2, 1, 1)
				SetVehicleDoorShut(taskveh, 3, 1, 1) 
			end
		end
	
	
		local dst = GetDistanceBetweenCoords(975.0, -2165.9, 29.47,myCrds,true)
		local holdingBody = true
	
	
		activeTasks[TaskNumber]["Location"]["x"] = 975.0
		activeTasks[TaskNumber]["Location"]["y"] = -2165.9
		activeTasks[TaskNumber]["Location"]["z"] = 29.47
	
	
		TriggerServerEvent("gangTasks:newCoords",TaskNumber,activeTasks)
	
	
		SetGps(TaskNumber)
		while (dst > 2.0 or not holdingBody) and failure > 0 do
	
			Citizen.Wait(1)
	
			if holdingBody then
				DrawText3DTest(975.0, -2165.9, 29.47, "Dispose of Body")
				if not IsEntityPlayingAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
					loadAnim( "missfinale_c2mcs_1" ) 
					TaskPlayAnim(GetPlayerPed(-1), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)
				end
			else
				local pedcrds = GetEntityCoords(ped)
				DrawText3DTest(pedcrds["x"],pedcrds["y"],pedcrds["z"], "Pickup Body [E]")
			end
			
			if IsControlJustPressed(0, 38) or (GetHashKey("WEAPON_UNARMED") ~= GetSelectedPedWeapon(GetPlayerPed(-1)) and holdingBody)  then
				holdingBody = not holdingBody
				if holdingBody then
					ClearPedTasks(ped)
					loadAnim( "amb@world_human_bum_slumped@male@laying_on_left_side@base" ) 
					TaskPlayAnim(ped, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 8.0, -1, 1, 0, 0, 0, 0)
					attachCarryPed(ped)
				else
					loadAnim('anim@narcotics@trash')
					TaskPlayAnim(GetPlayerPed(-1),'anim@narcotics@trash', 'drop_front',0.9, -8, 1500, 49, 3.0, 0, 0, 0) 
					DetachEntity(ped)
				end
			end
	
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(975.0, -2165.9, 29.47,myCrds,true)
			failure = failure - 1
		end
	
		if failure > 0 then
			loadAnim('anim@narcotics@trash')
			TaskPlayAnim(GetPlayerPed(-1),'anim@narcotics@trash', 'drop_front',0.9, -8, 1500, 49, 3.0, 0, 0, 0) 
			DetachEntity(ped)
			SetEntityCoords(ped, 975.0, -2165.9, 29.47)
			SetEntityHeading(ped, 82.02)
			SetPedAsNoLongerNeeded(ped)
			DeleteEntity(ped)
			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.5, 'deepfried', 0.1)
			TriggerEvent("SendAlert", "You are a sick bastard, exactly what I like!")
		end	
	
		return failure
	
	end
	
	-- delivery / dump task end
	
	
	
	
	
	-- kill task start
	
	RegisterNetEvent("gangTasks:killTask")
	AddEventHandler("gangTasks:killTask", function(cidsent,TaskNumber)
	
		local cid --= exports["isPed"]:isPed("cid") Disabled temp
	
	
		if tonumber(cid) ~= tonumber(cidsent) then
			return
		end
	
		Citizen.Wait(1000)
		TriggerEvent("SendAlert", activeTasks[TaskNumber]["TaskInfo"])
	
		local dst = GetDistanceBetweenCoords(activeTasks[TaskNumber]["Location"]["x"],activeTasks[TaskNumber]["Location"]["y"],activeTasks[TaskNumber]["Location"]["z"],myCrds,true)
	
		SetNewWaypoint(activeTasks[TaskNumber]["Location"]["x"],activeTasks[TaskNumber]["Location"]["y"])
	
		local failure = 180000
		while dst > 150.0 and failure > 0 do
			Citizen.Wait(1)
			local myCrds = GetEntityCoords(GetPlayerPed(-1))
			dst = GetDistanceBetweenCoords(activeTasks[TaskNumber]["Location"]["x"],activeTasks[TaskNumber]["Location"]["y"],activeTasks[TaskNumber]["Location"]["z"],myCrds,true)
			failure = failure - 1
		end
	
		if failure == 0 then
			TriggerServerEvent("task:TaskStateUpdate",TaskNumber,4)
			return
		end
	
		loadModel(activeTasks[TaskNumber]["TaskPedType"])
	
		local ped = CreatePed(GetPedType(activeTasks[TaskNumber]["TaskPedType"]), activeTasks[TaskNumber]["TaskPedType"], activeTasks[TaskNumber]["Location"]["x"],activeTasks[TaskNumber]["Location"]["y"],activeTasks[TaskNumber]["Location"]["z"], activeTasks[TaskNumber]["Location"]["h"], 1, 1)
	
		TaskWanderStandard(ped, 10.0, 10)
		while failure > 0 and not IsEntityDead(ped) do
			local crds = GetEntityCoords(ped)
			DrawText3DTest(crds["x"],crds["y"],crds["z"], "Target")
			Citizen.Wait(1)
		end
	
		if IsEntityDead(ped) and failure > 0 then
			activeTasks[TaskNumber]["TaskState"] = 3
			TriggerServerEvent("task:TaskStateUpdate",TaskNumber,3)
			TriggerEvent("SendAlert", "Well, that worked out.. good job.")
			--give crypto
		else
			activeTasks[TaskNumber]["TaskState"] = 4
			TriggerServerEvent("task:TaskStateUpdate",TaskNumber,4)
		end
	
	end)
	
	function attachCarryPed(ped)
		AttachEntityToEntity(ped, GetPlayerPed(-1), 1, -0.68, -0.2, 0.82, 180.0, 180.0, 60.0, 1, 1, 0, 1, 0, 1)
		loadAnim( "missfinale_c2mcs_1" ) 
		TaskPlayAnim(GetPlayerPed(-1), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)
	end
	
	
	
	function testanim()
		local crds = GetEntityCoords(GetPlayerPed(-1))
		loadModel("prop_cs_cardbox_01")
		local obj = CreateObject(GetHashKey("prop_cs_cardbox_01"),crds["x"],crds["y"],crds["z"] , 1, 0, 0)
	
		local dict = "anim@heists@box_carry@"
		local anim = "idle"
		loadAnim( dict ) 
		TaskPlayAnim(GetPlayerPed(-1), dict, anim, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
	end
	--testanim()
	
	local storageCoords = {
		[1] =  { ["groupid"] = "recycle_shop", ['x'] = 764.18,['y'] = -1400.45,['z'] = 26.51,['h'] = 178.55, ['info'] = ' Recycle Outer Storage' },
		[2] =  { ["groupid"] = "strip_club", ['x'] = 94.42,['y'] = -1293.95,['z'] = 29.27,['h'] = 297.21, ['info'] = ' Strip Club Storage' },
		[3] =  { ["groupid"] = "carpet_factory", ['x'] = 706.54,['y'] = -960.62,['z'] = 30.4,['h'] = 224.69, ['info'] = ' Carpet Factory Storage' },
		[4] =  { ["groupid"] = "parts_shop", ['x'] = 977.09,['y'] = -104.14,['z'] = 74.85,['h'] = 45.95, ['info'] = ' The Lost Storage' },
		[5] =  { ["groupid"] = "life_invader", ['x'] = -1052.56,['y'] = -232.5,['z'] = 44.03,['h'] = 110.66, ['info'] = ' Life Invader Storage' },
		[6] =  { ["groupid"] = "recycle_shop",['x'] = 998.65,['y'] = -3092.11,['z'] = -38.75,['h'] = 257.8, ['info'] = ' Recycle Inner Storage' },
		[7] =  { ["groupid"] = "illegal_carshop", ['x'] = 1010.1,['y'] = -3168.38,['z'] = -38.89,['h'] = 317.49, ['info'] = ' Customs Stash' },
		[8] =  { ["groupid"] = "repairs_harmony", ['x'] = 1174.99,['y'] = 2636.17,['z'] = 37.76,['h'] = 317.49, ['info'] = ' Harmony Stash' },
		[9] =  { ["groupid"] = "chop_shop", ['x'] = 548.708,['y'] = -182.292,['z'] = 54.4813,['h'] = 317.49, ['info'] = 'Stroke Masters Stash' },
		[10] =  { ["groupid"] = "tuner_carshop", ['x'] = 229.01,['y'] = -976.26,['z'] = -98.99,['h'] = 359.39, ['info'] = ' storage tuner' },
	}
	
	--Citizen.CreateThread( function()
	--
	--	while true do 
	--		local dst = 1000.0
	--		for i = 1, #storageCoords do
	--			local storagedist = GetDistanceBetweenCoords(storageCoords[i]["x"],storageCoords[i]["y"],storageCoords[i]["z"],GetEntityCoords(GetPlayerPed(-1)))
	--			if storagedist < 45.0 and storagedist < dst then
	--				dst = storagedist
	--				if GetDistanceBetweenCoords(storageCoords[i]["x"],storageCoords[i]["y"],storageCoords[i]["z"]-0.3,GetEntityCoords(GetPlayerPed(-1)),true) < 1.5 then
	--					DrawText3Ds( storageCoords[i]["x"],storageCoords[i]["y"],storageCoords[i]["z"] , storageCoords[i]["info"])
	--					if IsControlJustReleased(2, 38) then
	--						local rank --= exports["isPed"]:GroupRank(storageCoords[i]["groupid"]) Disabled temp
	--						local myjob --= exports["isPed"]:isPed("myjob") disabled temp
	--						if rank > 1 or myjob == "police" or myjob == "judge" then
	--							--TriggerServerEvent("inv:openUI","playerID","storage-"..storageCoords[i]["groupid"])
	--						else
	--							exports['mythic_notify']:SendAlert('inform', "You dont have permission to use this.")
	--						end
	--					end
	--				end			
	--			end
	--		end
	--		if dst > 15.0 then
	--			Citizen.Wait(math.ceil(dst*10))
	--		else
	--			Citizen.Wait(1)
	--		end
	--	end
	--end)
	
	
	function DrawText3Ds(x,y,z, text)
		local onScreen,_x,_y=World3dToScreen2d(x,y,z)
		local px,py,pz=table.unpack(GetGameplayCamCoords())
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		local factor = (string.len(text)) / 370
		DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
	end
	
	
	
	
	
	
	--bkr_prop_weed_01_small_01b // small
	
	--bkr_prop_weed_med_01b
	
	--bkr_prop_weed_lrg_01b
	
	
	-- weed growing shit brah
	
local crops = {}
local houseId = 0
local cropstatus = {
	[1] = { ["info"] = "Looks Good", ["itemid"] = 0 },
	[2] = { ["info"] = "Needs Water", ["itemid"] = 0 },
	[3] = { ["info"] = "Needs Fertilizer", ["itemid"] = 0 },
}
local isInHouse = false
RegisterNetEvent("house:InHouse")
AddEventHandler("house:InHouse", function(value)
	isInHouse = value
end)

RegisterNetEvent("weed:startcropInsideCheck")
AddEventHandler("weed:startcropInsideCheck", function(weedType)
	if isInHouse then
		TriggerEvent("weed:startcrop",weedType)
	else
		exports['mythic_notify']:SendAlert('inform', "The sun is too bright.")
	end
end)

RegisterNetEvent("weed:setHouseId")
AddEventHandler("weed:setHouseId", function(pass)

houseId = pass

end)



RegisterNetEvent("weed:currentcrops")
AddEventHandler("weed:currentcrops", function(result)
	
	local newcrops = {}
	if result == nil then

	else
		for i = 1, #result do
			--print("#result actually contained a value so crops will contain a tree")
			local table = result[i]
			newcrops[i] = {  ["x"] = tonumber(table.x), ["y"] = tonumber(table.y), ["z"] = tonumber(table.z), ["growth"] = tonumber(table.growth), ["strain"] = table.strain, ["status"] = tonumber(table.status), ["dbID"] = tonumber(table.id)}
			--print("Finished making a tree")
			-- newcrops[i].dbID is Defined!
			--crops[newcrops[i].dbID] = newcrops[i]
		end
	end
	DeleteTrees()
	crops = newcrops
end)

function DeleteTrees()
	for i = 1, #crops do
		local ObjectFound = crops[i]["object"]
		if ObjectFound then
			DeleteObject(ObjectFound)
		end
	end
end

function createTreeObject(num)
	local treeModel = `bkr_prop_weed_med_01b`
	local zm = 3.55
	if (crops[num]["growth"] < 33) then
		zm = 1
		treeModel = `bkr_prop_weed_01_small_01b`
	elseif (crops[num]["growth"] > 66) then
		treeModel = `bkr_prop_weed_lrg_01b`
	end


	RequestModel(treeModel)
	while not HasModelLoaded(treeModel) do
		Citizen.Wait(100)

	end

	local newtree = CreateObject(treeModel,crops[num]["x"],crops[num]["y"],crops[num]["z"]-zm,true,false,false)
	SetEntityCollision(newtree,false,false)
	crops[num]["object"] = newtree
end

function RemoveWeedSeed(seedType)
	TriggerEvent("inventory:removeItem","plastic", 3)
	if seedType == "female" then
	    TriggerEvent("inventory:removeItem", "femaleseed", 1)
	else
		TriggerEvent("inventory:removeItem", "maleseed", 1)
	end
end

function InsertPlant(seed)
	local plyId = PlayerPedId()
	local strain = seed
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(plyId, 0.0, 0.4, 0.0))
	TriggerServerEvent("weed:createplant",x,y,z,strain,houseId)
end



function nearMale()

	local answer = false

	for i = 1, #crops do
		local ply = PlayerPedId()
		local plyCoords = GetEntityCoords(ply)
    	local dst = #(vector3(crops[i]["x"],crops[i]["y"],crops[i]["z"]) - plyCoords)
    	if dst < 10.0 and crops[i]["strain"] == "Male" then
    		answer = true
    	end
	end


	return answer

end

function convertFemales()
	local convertedIds = false
	local convertedTable = {}
	for i = 1, #crops do
		local ply = PlayerPedId()
		local plyCoords = GetEntityCoords(ply)
    	local dst = #(vector3(crops[i]["x"],crops[i]["y"],crops[i]["z"]) - plyCoords)
    	if dst < 10.0 and crops[i]["strain"] == "Kush" and crops[i]["growth"] < 34 then
    		if not convertedIds then
    			convertedIds = crops[i]["dbID"]
    		else
    			convertedIds = convertedIds .. "," .. crops[i]["dbID"]
    			convertedTable[#convertedTable+1] = crops[i]["dbID"]
    		end    		
    	end
	end
	if not convertedIds then
		return
	end
	--print(convertedIds)
	TriggerServerEvent("weed:convert",convertedIds,convertedTable)
end

RegisterNetEvent("weed:startcrop")
AddEventHandler("weed:startcrop", function(seedType)


	if not exports["dsrp-inventory"]:hasEnoughOfItem("plastic",3,true) then
		return
	end

	local Seed = "Kush"

	if seedType == "female" and nearMale() then
		Seed = "Seeded"
	end


	if seedType == "male" then
		convertFemales()
		Seed = "Male"
	end

    local success = true

	for i = 1, #crops do
		local ply = PlayerPedId()
		local plyCoords = GetEntityCoords(ply)
    	local dst = #(vector3(crops[i]["x"],crops[i]["y"],crops[i]["z"]) - plyCoords)
    	if dst < 1.0 then
    		success = false
    	end
    end

    if success then
        RemoveWeedSeed(seedType)
        InsertPlant(Seed)
    end

end)

RegisterCommand("seizeweed", function()
TriggerEvent("weed:destroyplant")
end)


RegisterNetEvent("weed:destroyplant")
AddEventHandler("weed:destroyplant", function()

	local close = 0
	local dst = 1000.0
	for i = 1, #crops do
		local ply = PlayerPedId()
		local plyCoords = GetEntityCoords(ply)
		local storagedist = #(vector3(crops[i]["x"],crops[i]["y"],crops[i]["z"]) - plyCoords)
		if storagedist < 3.0 then
			if storagedist < dst then
				dst = storagedist
				close = i
			end
		end
	end
	local finished = exports["np-taskbar"]:taskBar(6000,"Destroy")
	if finished == 100 then
		TriggerServerEvent("weed:destroy",crops[close]["dbID"])
	end
end)

RegisterNetEvent("weed:updateplantwithID")
AddEventHandler("weed:updateplantwithID", function(ids,newPercent,status)
	--Called from server side.
	if status == "alter" then
		for i = 1, #crops do
			if(crops[i] ~= nil) then
				if crops[i]["dbID"] == ids then
					crops[i]["growth"] = newPercent
					crops[i]["status"] = 1
				end
			end
		end		
	elseif status == "remove" then

		for i = 1, #crops do
			if(crops[i] ~= nil) then
				if crops[i]["dbID"] == ids then
					DeleteObject(crops[i]["object"])
					table.remove(crops,i)
				end
			end
		end

	elseif status == "convert" then
		for d = 1, #ids do
			for i = 1, #crops do
				if(crops[i] ~= nil) then
					if crops[i]["dbID"] == ids then
						crops[i]["strain"] = "seeded"
					end
				end
			end
		end
	elseif status == "new" then
		crops[#crops+1] = ids
	end
end)


RegisterNetEvent("weed:giveitems")
AddEventHandler("weed:giveitems", function(strain)

	if strain == "Seeded" then
        TriggerEvent( "player:receiveItem","femaleseed",math.random(1,12))
		if math.random(100) < 10 then
	        TriggerEvent( "player:receiveItem","maleseed",1)
	    end    
	else
		if strain == "Male" then
			TriggerEvent( "player:receiveItem","femaleseed",math.random(1,2))
			TriggerEvent( "player:receiveItem","weedq",math.random(3,8))
		else

			Citizen.Wait(500)
			TriggerEvent( "player:receiveItem","weedq",math.random(10,25))
		end
	end
end)

local inhouse = true
RegisterNetEvent("inhouse")
AddEventHandler("inhouse", function(status)
	inhouse = status
end)

Citizen.CreateThread( function()
	local counter = 0
	while true do 

		if not inhouse then
			Citizen.Wait(3000)
		else
			Citizen.Wait(1)
			local close = 0
			local dst = 1000.0
			for i = 1, #crops do
				local ply = PlayerPedId()
				local plyCoords = GetEntityCoords(ply)
				local storagedist = #(vector3(crops[i]["x"],crops[i]["y"],crops[i]["z"]) - plyCoords)
				if storagedist < 80.0 then
					if storagedist < dst then
						dst = storagedist
						close = i
					end
					if crops[i]["object"] == nil then
						createTreeObject(i)
					elseif crops[i]["object"] then
						if not DoesEntityExist(crops[i]["object"]) then
							createTreeObject(i)
						end					
					end
				else
					if crops[i]["object"] then
						DeleteObject(crops[i]["object"])
						crops[i]["object"] = nil
					end
				end
			end

			if counter > 0 then
				counter = counter - 1
			end
			if dst > 80.0 then
				if counter > 0 or counter < 0 then
					counter = 0
				end
				Citizen.Wait(math.ceil(dst*3))
			else
				local ply = PlayerPedId()
				local plyCoords = GetEntityCoords(ply)
				if #(vector3(crops[close]["x"],crops[close]["y"],crops[close]["z"]-0.3) - plyCoords) < 5.0 then
					local num = tonumber(crops[close]["status"])
					DrawText3Ds( crops[close]["x"],crops[close]["y"], crops[close]["z"] , "[E] " .. crops[close]["strain"] .. " Strain  @ " .. crops[close]["growth"] .. "% - " .. cropstatus[num]["info"])
					if IsControlJustReleased(0, 153) and #(vector3(crops[close]["x"],crops[close]["y"],crops[close]["z"]-0.3) - plyCoords) < 2.0 and counter == 0 then
						if crops[close]["growth"] >= 100 then
							local finished = exports["np-taskbar"]:taskBar(1000,"Picking")
							TriggerEvent("Evidence:StateSet",4,1600)
							
							TriggerServerEvent("weed:killplant",crops[close]["dbID"])
							TriggerEvent("weed:giveitems",crops[close]["strain"])
						else
							if crops[close]["status"] == 1 then
								TriggerEvent("customNotification","This crop doesnt need any attention.")
							else
								if crops[close]["strain"] == "Seeded" then
									if exports["dsrp-inventory"]:hasEnoughOfItem("fertilizer",1,false) then
										TriggerEvent("Evidence:StateSet",4,1600)
										if math.random(100) > 85 then
											TriggerEvent("customNotification","You just consumed all the Fertilizer.")
											TriggerEvent("inventory:removeItem", "fertilizer", 1)
										end
										local new = crops[close]["growth"] + math.random(25,45)
										if new >= 100 then
											TriggerServerEvent("weed:UpdateWeedGrowth",crops[close]["dbID"],100)
										else
											TriggerServerEvent("weed:UpdateWeedGrowth",crops[close]["dbID"],new)
										end
									else
										TriggerEvent("customNotification","You need Fertilizer for this!")
									end
								else
									if exports["dsrp-inventory"]:hasEnoughOfItem("water",1,false) then
										TriggerEvent("Evidence:StateSet",4,1600)
										TriggerEvent("inventory:removeItem", "water", 1)
										local new = crops[close]["growth"] + math.random(14,17)
										if new >= 100 then
											TriggerServerEvent("weed:UpdateWeedGrowth",crops[close]["dbID"],100)
										else
											TriggerServerEvent("weed:UpdateWeedGrowth",crops[close]["dbID"],new)
										end
									else
										TriggerEvent("customNotification","You need 1 bottle of water for this!")
									end
								end
							end
						end
						counter = 200
					end
				end
			end

		end
	end
end)
