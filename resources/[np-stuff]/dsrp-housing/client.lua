ESX = nil
local houses = {}
local myHouse = {}
local objects = {}
local houseID = 0
local enterHouse = false
local garageSet = false
local currentJob = "none"
local NearhouseID = 0
local viewHouse = false
local nearHouses = {}
local downHouse = 24.0
local actionDress = false
local keys = {}
local displayHouse = {}
local houseOwner =  ""
local firstSpawn = false
local ViewersExit = {}

Keys = {
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

-- AddEventHandler("dsrp-base:initialSpawnModelLoaded", function()
--     TriggerServerEvent("DSRP_housing:checkHouse")
-- end)

RegisterNetEvent("rp:playerBecameJob")
AddEventHandler("rp:playerBecameJob", function(job, name, notify)
    currentJob = job
end)


Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(5)
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			local cid = exports["isPed"]:isPed("cid")
			for k,v in pairs(nearHouses) do
				local door = json.decode(v.door)
				local keys = json.decode(v.keys)
				--print(keys[k])
				local entrance = #(pos - vector3(door.x,door.y,door.z))
				local doorEntrance = #(pos - vector3(door.x,door.y,door.z))
				if entrance < 1.0  then
					if v.owner == cid or keys[k] == cid and doorEntrance < 1.0 then
						if IsControlJustReleased(0, Keys['E']) then
							TriggerServerEvent("DSRP_housing:askEnter",v.id,false,0)
						end
					end
					--print(v.failBuy)
					if v.failBuy == "false" then
						
						DrawText3Ds( door.x,door.y,door.z, 'This house for sale you /view or /buy this house for ~g~$'..v.price )
						RegisterCommand('view', function(source, args)
							-- print('im vewiing house')
							TriggerServerEvent("DSRP_housing:askEnter",v.id,"view",0)
						end)
						
							RegisterCommand('sale', function(source, args)
								if currentJob == "realestateagent" then
									-- print('selling house')
									local playerId = args[1]
									TriggerEvent("DSRP_housing:SaleHouse",v.id,v.price,playerId)
								else
									TriggerEvent('notification', 'are you lost boy?',2)
								end
							end)
							RegisterCommand('delhouse', function(source, args)
						
								if currentJob == "realestateagent" then
									TriggerServerEvent("DSRP_housing:delHouse",v.id)
								else
									TriggerEvent('notification', 'are you lost boy?',2)
								end
							end)
						
					end
				else
				 	if entrance > 10.0 and doorEntrance > 10.0 then
					  Citizen.Wait(2000)
					end
				end
			end
	end
end)

RegisterNetEvent("DSRP_housing:SaleHouse")
AddEventHandler("DSRP_housing:SaleHouse", function(houseid,price,pid)
	TriggerServerEvent("DSRP_housing:buying", pid, houseid,price)
end)

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

RegisterNetEvent("DSRP_housing:getOwnHouses")
AddEventHandler("DSRP_housing:getOwnHouses",function(ownHouse)
	myHouse = ownHouse
end)

RegisterNetEvent("DSRP_housing:getMyOwnHouses")
AddEventHandler("DSRP_housing:getMyOwnHouses",function(ownHouse)
	displayHouse = ownHouse
	displayBlips()
end)

RegisterNetEvent("DSRP_housing:acceptEnter")
AddEventHandler("DSRP_housing:acceptEnter",function(ownHouse,target,view)
	print(target,view)
	myHouse = ownHouse
	if view == "view" or view == "knock" then
		viewHouse = true
	end
	actionDress = true
	TriggerEvent("inhouse",true)
	if viewHouse then
		enterHouse = false
	else
		enterHouse = true
	end
	TriggerEvent('notification', 'Please wait!')
	TriggerEvent('dooranim')
	TriggerEvent('InteractSound_CL:PlayOnOne', 'doorenter', 0.8)
    TriggerEvent('settonight',source, true)
	-- Citizen.Wait(1000)
	-- DoScreenFadeOut(500)

	while IsScreenFadingOut() do
		Citizen.Wait(100)
	end
	DoScreenFadeOut(1000)
	for k,v in ipairs(ownHouse) do
		firstSpawn = v.firstspawn
		
		local doors = json.decode(v.door)
		-- print(doors.x, doors.y, doors.z)
		if v.shell == "mid" or v.shell == "Mid" then
			CreateMidHosuse(doors, v.id)
		elseif v.shell == "low" or v.shell == "Low" then
			CreateLowHouse(doors, v.id)
		elseif v.shell == "trevor" or v.shell == "trevor" then
			CreateTrevorHouse(doors, v.id)
		elseif v.shell == "lester" or v.shell == "Lester" then
			CreateLesterHouse(doors, v.id)
		elseif v.shell == "ranch" or v.shell == "Ranch" then
			CreateRanchHouse(doors, v.id)
		end
		-- print('this is the house id: ', v.id)
		houseID = v.id
		houseOwner = v.owner
		
	end
	DoScreenFadeIn(1000)
	--EnteringMyHouse()
end)

local sendGarages = false

Citizen.CreateThread(function()
	--if garageSet then
		while true do 
			Citizen.Wait(0)
			--print('this is garage')
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			for k,v in ipairs(nearHouses) do
				local garages = json.decode(v.garages)
				local garageLoc = #(pos - vector3(garages.x,garages.y,garages.z))
				if garageLoc < 5.0 and not sendGarages then
					TriggerEvent('house:garagelocations',v.garages, v.id, v.shell)
					sendGarages = true
				else
					if garageLoc > 10.0 then
						if sendGarages then
							TriggerEvent('house:usingGarage')
						end
					Citizen.Wait(2000)
					sendGarages = false
					end
				end
			end
		end
	--end
end)

RegisterCommand('givehkey', function()
	TriggerEvent('DSRP_housing:giveKey')
end)

RegisterCommand('removehkey', function()
	TriggerEvent('DSRP_housing:removeKey')
end)

RegisterCommand('myhouse', function()
	TriggerServerEvent('DSRP_housing:myhouse')
end)

RegisterCommand('knock', function()
	TriggerEvent('DSRP_housing:knock')
end)

RegisterNetEvent('DSRP_housing:giveKey')
AddEventHandler('DSRP_housing:giveKey', function()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 5) then
		-- print('someone is near me')
		TriggerEvent("SendAlert", "You just gave keys to your house!",1)
		TriggerServerEvent('DSRP_housing:keys:send', GetPlayerServerId(t),NearhouseID)
	else
		TriggerEvent("SendAlert", "No player near you!",2)
	end
end)

RegisterNetEvent('DSRP_housing:removeKey')
AddEventHandler('DSRP_housing:removeKey', function()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 5) then
		-- print('someone is near me')
		TriggerEvent("SendAlert", "You just remove keys!",1)
		TriggerServerEvent('DSRP_housing:keys:removed', GetPlayerServerId(t),NearhouseID)
	else
		TriggerEvent("SendAlert", "No player near you!",2)
	end
end)

RegisterNetEvent('DSRP_housing:knock')
AddEventHandler('DSRP_housing:knock', function()
	TriggerEvent('InteractSound_CL:PlayOnOne','doorknock', 0.6)
	local animDict = "timetable@jimmy@doorknock@"
	local animation = "knockdoor_idle"
	if IsPedArmed(ped, 7) then
		SetCurrentPedWeapon(ped, 0xA2719263, true)
	end

	if IsEntityPlayingAnim(ped, animDict, animation, 3) then
		ClearPedSecondaryTask(ped)
	else
		loadAnimDict(animDict)
		local animLength = GetAnimDuration(animDict, animation)
		TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,
					 animLength, 0, 0, 0, 0, 0)
	end
		-- print('someone is near me')
		-- TriggerEvent("SendAlert", "You just remove keys!",1)
	TriggerServerEvent('DSRP_housing:send:knock', GetPlayerServerId(t),NearhouseID)

end)

local pTarget = 0
local canAccept = false
local knockHid = 0
RegisterNetEvent('DSRP_housing:knocking')
AddEventHandler('DSRP_housing:knocking', function(player,name,houseid)
	print(player,name,houseid)
	pTarget = player
	canAccept = true
	knockHid = houseid
	TriggerEvent('SendAlert', '<b>'..name..'</b> is knocking on you door. type /paccept or /pdeny',1)
	Citizen.Wait(30000)
	TriggerServerEvent('DSRP_knocking:deny',player)
	pTarget = 0
	canAccept = false
end)

RegisterCommand('paccept', function()
	if canAccept then
		TriggerServerEvent('DSRP_housing:askEnter',knockHid,"knock",pTarget)
	else
		TriggerEvent('SendAlert', 'You cant accept now. Time is expired.',2)
	end
end)

RegisterCommand('pdeny', function()
	if canAccept then
		TriggerServerEvent('DSRP_knocking:deny',pTarget)
		pTarget = 0
		canAccept = false
	else
		TriggerEvent('SendAlert', 'You cant accept now. Time is expired.',2)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		--print(viewHouse)
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		--if viewHouse then
			for k,v in ipairs(nearHouses) do
				local door = json.decode(v.door)
				local spawn = { x = door.x , y = door.y, z = door.z - downHouse}
				local indoor = #(pos - vector3(spawn.x + 3.69693000, spawn.y - 15.080020100, spawn.z + 1.5))
				if indoor < 1.0 then
					DrawText3Ds( spawn.x + 3.69693000, spawn.y - 15.080020100, spawn.z + 2.5, '[E] to Leave' )
					if IsControlJustReleased(0, Keys['E']) then
						TriggerEvent("inhouse",false)	
						TriggerEvent('settonight',source, false)
						houseID = 0
						enterHouse = false
						viewHouse = false
						TriggerServerEvent('DSRP_housing:getHouses')	
						TeleportToInterior(door.x, door.y, door.z, 0.0)
						Citizen.Wait(1000)
						DespawnInterior(objects)
					end

				else
					if indoor > 10.0 then
						Citizen.Wait(1000)
					end
				end
			end
		--end
	end
end)
-- 1225.150390625,-684.0361328125,41.792110443115
-- {"x":1221.4543457031,"z":63.493137359619,"y":-668.95806884766}
--print('x : ', (1225 - 1221), '\n', 'y : ',(684.0361328125 - 668.95806884766), '\n y :',(63.493137359619 - 41.792110443115)  )
Citizen.CreateThread(function()
	
		while true do 
			Citizen.Wait(0)
			
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			for k,v in ipairs(myHouse) do
				if enterHouse then
				
					local door = json.decode(v.doors)
					local storage = json.decode(v.storage)
					local wardrobe = json.decode(v.wardrobe)
					local updoor = json.decode(v.door)
					local indoor = #(pos - vector3(door.x,door.y,door.z))
					local storageLoc = #(pos - vector3(storage.x,storage.y,storage.z))
					local wardrobeLoc = #(pos - vector3(wardrobe.x,wardrobe.y,wardrobe.z))
					if indoor < 1.0  then
						
						DrawText3Ds( door.x,door.y,door.z, '[E] to Leave' )
						if IsControlJustReleased(0, Keys['E']) then
							TriggerEvent("inhouse",false)	
							houseID = 0
							enterHouse = false
							TriggerServerEvent('DSRP_housing:getHouses')	
							TeleportToInterior(updoor.x, updoor.y, updoor.z, 0.0)
							Citizen.Wait(1000)
							DespawnInterior(objects)
						end
					elseif storageLoc < 1.0  then
						if not viewHouse then
							DrawText3Ds( storage.x,storage.y,storage.z, '[E] to Open storage' )
							if IsControlJustReleased(0, Keys['E']) then
								TriggerEvent("server-inventory-open", "1", v.shell.."-"..v.id)
							end
						end
					elseif wardrobeLoc < 1.5  then
						if not viewHouse then
							DrawText3Ds( wardrobe.x,wardrobe.y,wardrobe.z, 'Dressing Room' )
							if actionDress then
								TriggerEvent('DSRP_clothing:enable', true)
								actionDress = false
							end
						end
					else
						if indoor > 100.0 and storageLoc > 100.0 and wardrobeLoc > 100.00 then
						Citizen.Wait(2000)
						if not actionDress then
							TriggerEvent('DSRP_clothing:enable', false)
							break;
						end
						end
					end
				end
			end
		end
end)


function CreateTrevorHouse(spawns,id)
	local spawn = { x = spawns.x , y = spawns.y, z = spawns.z - downHouse}
	
	local building = CreateObject(`shell_trevor`,spawn.x+2.29760700,spawn.y-1.33191200,spawn.z+1.26253700,false,false,false)
	FreezeEntityPosition(building,true)
	Citizen.Wait(500)

	SetEntityCoords(PlayerPedId(), spawn.x + 2.5, spawn.y - 5.1, spawn.z+3.5)
	if firstSpawn == "false" then
		print('trevor')
		Citizen.Wait(100)
		TriggerEvent('DSRP_housing:creatingExit',id)
	end
end

function CreateLesterHouse(spawns,id)
	local spawn = { x = spawns.x , y = spawns.y, z = spawns.z - downHouse}
	SetEntityCoords(PlayerPedId(), spawn.x + 0.8, spawn.y - 7.1, spawn.z+1.8)
	local building = CreateObject(`shell_lester`,spawn.x+2.29760700,spawn.y-1.33191200,spawn.z+1.26253700,false,false,false)
	FreezeEntityPosition(building,true)
	Citizen.Wait(100)
end

function CreateLowHouse(spawns,id)
	local spawn = { x = spawns.x , y = spawns.y, z = spawns.z - downHouse}
	print(json.encode(spawn))
	local building = CreateObject(`furnitured_lowapart`,spawn.x+2.29760700,spawn.y-1.33191200,spawn.z+1.26253700,false,false,false)
	FreezeEntityPosition(building,true)
	Citizen.Wait(1000)
	TeleportToInterior(spawn.x + 5.0, spawn.y - 1.2, spawn.z + 11.0, spawn.h)
	print('my interrior spawn ',spawn.x+2.29760700,spawn.y-1.33191200,spawn.z+1.26253700)
	print('my ped spawn',spawn.x + 5.0, spawn.y - 1.2, spawn.z + 1.0)
	if firstSpawn == "false" then
		print('trevor')
		Citizen.Wait(100)
		TriggerEvent('DSRP_housing:creatingExit',id)
	end
end

function CreateRanchHouse(spawns,id)
	local spawn = { x = spawns.x , y = spawns.y, z = spawns.z - downHouse}
	SetEntityCoords(PlayerPedId(), spawn.x + 1.0, spawn.y - 7.0, spawn.z+2.8)
	local building = CreateObject(`shell_ranch`,spawn.x+2.29760700,spawn.y-1.33191200,spawn.z+1.26253700,false,false,false)
	FreezeEntityPosition(building,true)
	Citizen.Wait(100)
end

function CreateMidHosuse(spawns,id)
	
    local plyCoord = GetEntityCoords(PlayerPedId())
    local spawn = { x = spawns.x , y = spawns.y, z = spawns.z - downHouse}
	local shell = CreateObject(`furnitured_midapart`, spawn.x, spawn.y, spawn.z, false, false, false)
	table.insert(objects, shell)
	FreezeEntityPosition(shell, true)
	TriggerEvent('SendAlert', 'Please wait.')
    Citizen.Wait(1500)
	FreezeEntityPosition(PlayerPedId(),false)
	Citizen.Wait(1500)
	TeleportToInterior(spawn.x + 1.5, spawn.y - 10.0, spawn.z, spawn.h)
	if firstSpawn == "false" then
		Citizen.Wait(100)
		TriggerEvent('DSRP_housing:creatingExit',id)
	end
end

function makefuckingapt(spawns)
	
    local plyCoord = GetEntityCoords(PlayerPedId())
    local spawn = { x = spawns.x , y = spawns.y, z = spawns.z - downHouse}
    local shell = CreateObject(`furnitured_lowapart`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    Citizen.Wait(500)
    TeleportToInterior(spawn.x + 5.0, spawn.y - 1.2, spawn.z + 2.00, spawn.h)
    FreezeEntityPosition(PlayerPedId(),false)
end

-- Thanks Stroudy <3
function CreateTier1HouseFurnished(spawns, isBackdoor)
	--local objects = {}
	-- SetEntityCoords(PlayerPedId(),347.04724121094,-1000.2844848633,-99.194671630859)
	-- Wait(50)
	--print('myhouse id',houseID)
	local spawn = { x = spawns.x , y = spawns.y, z = spawns.z - downHouse}
    local POIOffsets = {}
    POIOffsets.exit = json.decode('{"z":2.5,"y":-15.901171875,"x":4.251012802124,"h":2.2633972168}')
    POIOffsets.backdoor = json.decode('{"z":2.5,"y":4.3798828125,"x":0.88999176025391,"h":182.2633972168}')

    local shell = CreateObject(`playerhouse_tier1`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)
    local dt = CreateObject(`V_16_DT`,spawn.x-1.21854400,spawn.y-1.04389600,spawn.z+1.39068600,false,false,false)
	local mpmid01 = CreateObject(`V_16_mpmidapart01`,spawn.x+0.52447510,spawn.y-5.04953700,spawn.z+1.32,false,false,false)
	local mpmid09 = CreateObject(`V_16_mpmidapart09`,spawn.x+0.82202150,spawn.y+2.29612000,spawn.z+1.88,false,false,false)
	local mpmid07 = CreateObject(`V_16_mpmidapart07`,spawn.x-1.91445900,spawn.y-6.61911300,spawn.z+1.45,false,false,false)
	local mpmid03 = CreateObject(`V_16_mpmidapart03`,spawn.x-4.82565300,spawn.y-6.86803900,spawn.z+1.14,false,false,false)
	local midData = CreateObject(`V_16_midapartdeta`,spawn.x+2.28558400,spawn.y-1.94082100,spawn.z+1.288628,false,false,false)
	local glow = CreateObject(`V_16_treeglow`,spawn.x-1.37408500,spawn.y-0.95420070,spawn.z+1.135,false,false,false)
	local curtins = CreateObject(`V_16_midapt_curts`,spawn.x-1.96423300,spawn.y-0.95958710,spawn.z+1.280,false,false,false)
	local mpmid13 = CreateObject(`V_16_mpmidapart13`,spawn.x-4.65580700,spawn.y-6.61684000,spawn.z+1.259,false,false,false)
	local mpcab = CreateObject(`V_16_midapt_cabinet`,spawn.x-1.16177400,spawn.y-0.97333810,spawn.z+1.27,false,false,false)
	local mpdecal = CreateObject(`V_16_midapt_deca`,spawn.x+2.311386000,spawn.y-2.05385900,spawn.z+1.297,false,false,false)
	local mpdelta = CreateObject(`V_16_mid_hall_mesh_delta`,spawn.x+3.69693000,spawn.y-5.80020100,spawn.z+1.293,false,false,false)
	local beddelta = CreateObject(`V_16_mid_bed_delta`,spawn.x+7.95187400,spawn.y+1.04246500,spawn.z+1.28402300,false,false,false)
	local bed = CreateObject(`V_16_mid_bed_bed`,spawn.x+6.86376900,spawn.y+1.20651200,spawn.z+1.36589100,false,false,false)
	local beddecal = CreateObject(`V_16_MID_bed_over_decal`,spawn.x+7.82861300,spawn.y+1.04696700,spawn.z+1.34753700,false,false,false)
	local bathDelta = CreateObject(`V_16_mid_bath_mesh_delta`,spawn.x+4.45460500,spawn.y+3.21322800,spawn.z+1.21116100,false,false,false)
	local bathmirror = CreateObject(`V_16_mid_bath_mesh_mirror`,spawn.x+3.57740800,spawn.y+3.25032000,spawn.z+1.48871300,false,false,false)

	--props
	local beerbot = CreateObject(`Prop_CS_Beer_Bot_01`,spawn.x+1.73134600,spawn.y-4.88520200,spawn.z+1.91083000,false,false,false)
	local couch = CreateObject(`v_res_mp_sofa`,spawn.x-1.48765600,spawn.y+1.68100600,spawn.z+1.21640500,false,false,false)
	local chair = CreateObject(`v_res_mp_stripchair`,spawn.x-4.44770800,spawn.y-1.78048800,spawn.z+1.21640500,false,false,false)
	local chair2 = CreateObject(`v_res_tre_chair`,spawn.x+2.91325400,spawn.y-5.27835100,spawn.z+1.22746400,false,false,false)
	local plant = CreateObject(`Prop_Plant_Int_04a`,spawn.x+2.78941300,spawn.y-4.39133900,spawn.z+2.12746400,false,false,false)
	local lamp = CreateObject(`v_res_d_lampa`,spawn.x-3.61473100,spawn.y-6.61465100,spawn.z+2.08382800,false,false,false)
	local fridge = CreateObject(`v_res_fridgemodsml`,spawn.x+1.90339700,spawn.y-3.80026800,spawn.z+1.29917900,false,false,false)
	local micro = CreateObject(`prop_micro_01`,spawn.x+2.03442400,spawn.y-4.61585100,spawn.z+2.30395600,false,false,false)
	local sideBoard = CreateObject(`V_Res_Tre_SideBoard`,spawn.x+2.84053000,spawn.y-4.30947100,spawn.z+1.24577300,false,false,false)
	local bedSide = CreateObject(`V_Res_Tre_BedSideTable`,spawn.x-3.50363200,spawn.y-6.55289400,spawn.z+1.30625800,false,false,false)
	local lamp2 = CreateObject(`v_res_d_lampa`,spawn.x+2.69674700,spawn.y-3.83123500,spawn.z+2.09373700,false,false,false)
	local plant2 = CreateObject(`v_res_tre_tree`,spawn.x-4.96064800,spawn.y-6.09898500,spawn.z+1.31631400,false,false,false)
	local tableObj = CreateObject(`V_Res_M_DineTble_replace`,spawn.x-3.50712600,spawn.y-4.13621600,spawn.z+1.29625800,false,false,false)
	local tv = CreateObject(`Prop_TV_Flat_01`,spawn.x-5.53120400,spawn.y+0.76299670,spawn.z+2.17236000,false,false,false)
	local plant3 = CreateObject(`v_res_tre_plant`,spawn.x-5.14112800,spawn.y-2.78951000,spawn.z+1.25950800,false,false,false)
	local chair3 = CreateObject(`v_res_m_dinechair`,spawn.x-3.04652400,spawn.y-4.95971200,spawn.z+1.19625800,false,false,false)
	local lampStand = CreateObject(`v_res_m_lampstand`,spawn.x+1.26588400,spawn.y+3.68883900,spawn.z+1.30556700,false,false,false)
	local stool = CreateObject(`V_Res_M_Stool_REPLACED`,spawn.x-3.23216300,spawn.y+2.06159000,spawn.z+1.20556700,false,false,false)
	local chair4 = CreateObject(`v_res_m_dinechair`,spawn.x-2.82237200,spawn.y-3.59831300,spawn.z+1.25950800,false,false,false)
	local chair5 = CreateObject(`v_res_m_dinechair`,spawn.x-4.14955100,spawn.y-4.71316600,spawn.z+1.19625800,false,false,false)
	local chair6 = CreateObject(`v_res_m_dinechair`,spawn.x-3.80622900,spawn.y-3.37648300,spawn.z+1.19625800,false,false,false)

	local plant4 = CreateObject(`v_res_fa_plant01`,spawn.x+2.97859200,spawn.y+2.55307400,spawn.z+1.85796300,false,false,false)
	local storage = CreateObject(`v_res_tre_storageunit`,spawn.x+8.47819500,spawn.y-2.50979300,spawn.z+1.19712300,false,false,false)
	local storage2 = CreateObject(`v_res_tre_storagebox`,spawn.x+9.75982700,spawn.y-1.35874100,spawn.z+1.29625800,false,false,false)
	local basketmess = CreateObject(`v_res_tre_basketmess`,spawn.x+8.70730600,spawn.y-2.55503600,spawn.z+1.94059590,false,false,false)
	local lampStand2 = CreateObject(`v_res_m_lampstand`,spawn.x+9.54306000,spawn.y-2.50427700,spawn.z+1.30556700,false,false,false)
	local plant4 = CreateObject(`Prop_Plant_Int_03a`,spawn.x+9.87521400,spawn.y+3.90917400,spawn.z+1.20829700,false,false,false)

	local basket = CreateObject(`v_res_tre_washbasket`,spawn.x+9.39091500,spawn.y+4.49676300,spawn.z+1.19625800,false,false,false)
	local wardrobe = CreateObject(`V_Res_Tre_Wardrobe`,spawn.x+8.46626300,spawn.y+4.53223600,spawn.z+1.19425800,false,false,false)
	local basket2 = CreateObject(`v_res_tre_flatbasket`,spawn.x+8.51593000,spawn.y+4.55647300,spawn.z+3.46737300,false,false,false)
	local basket3 = CreateObject(`v_res_tre_basketmess`,spawn.x+7.57797200,spawn.y+4.55198800,spawn.z+3.46737300,false,false,false)
	local basket4 = CreateObject(`v_res_tre_flatbasket`,spawn.x+7.12286400,spawn.y+4.54689200,spawn.z+3.46737300,false,false,false)
	local wardrobe2 = CreateObject(`V_Res_Tre_Wardrobe`,spawn.x+7.24382000,spawn.y+4.53423500,spawn.z+1.19625800,false,false,false)
	local basket5 = CreateObject(`v_res_tre_flatbasket`,spawn.x+8.03364600,spawn.y+4.54835500,spawn.z+3.46737300,false,false,false)

	local switch = CreateObject(`v_serv_switch_2`,spawn.x+6.28086900,spawn.y-0.68169880,spawn.z+2.30326000,false,false,false)

	local table2 = CreateObject(`V_Res_Tre_BedSideTable`,spawn.x+5.84416200,spawn.y+2.57377400,spawn.z+1.22089100,false,false,false)
	local lamp3 = CreateObject(`v_res_d_lampa`,spawn.x+5.84912100,spawn.y+2.58001100,spawn.z+1.95311890,false,false,false)
	local laundry = CreateObject(`v_res_mlaundry`,spawn.x+5.77729800,spawn.y+4.60211400,spawn.z+1.19674400,false,false,false)

	local ashtray = CreateObject(`Prop_ashtray_01`,spawn.x-1.24716200,spawn.y+1.07820500,spawn.z+1.89089300,false,false,false)

	local candle1 = CreateObject(`v_res_fa_candle03`,spawn.x-2.89289900,spawn.y-4.35329700,spawn.z+2.02881310,false,false,false)
	local candle2 = CreateObject(`v_res_fa_candle02`,spawn.x-3.99865700,spawn.y-4.06048500,spawn.z+2.02530190,false,false,false)
	local candle3 = CreateObject(`v_res_fa_candle01`,spawn.x-3.37733400,spawn.y-3.66639800,spawn.z+2.02526200,false,false,false)
	local woodbowl = CreateObject(`v_res_m_woodbowl`,spawn.x-3.50787400,spawn.y-4.11983000,spawn.z+2.02589900,false,false,false)
	local tablod = CreateObject(`V_Res_TabloidsA`,spawn.x-0.80513000,spawn.y+0.51389600,spawn.z+1.18418800,false,false,false)


	local tapeplayer = CreateObject(`Prop_Tapeplayer_01`,spawn.x-1.26010100,spawn.y-3.62966400,spawn.z+2.37883200,false,false,false)
	local woodbowl2 = CreateObject(`v_res_tre_fruitbowl`,spawn.x+2.77764900,spawn.y-4.138297000,spawn.z+2.10340100,false,false,false)
	local sculpt = CreateObject(`v_res_sculpt_dec`,spawn.x+3.03932200,spawn.y+1.62726400,spawn.z+3.58363900,false,false,false)
	local jewlry = CreateObject(`v_res_jewelbox`,spawn.x+3.04164100,spawn.y+0.31671810,spawn.z+3.58363900,false,false,false)

	local basket6 = CreateObject(`v_res_tre_basketmess`,spawn.x-1.64906300,spawn.y+1.62675900,spawn.z+1.39038500,false,false,false)
	local basket7 = CreateObject(`v_res_tre_flatbasket`,spawn.x-1.63938900,spawn.y+0.91133310,spawn.z+1.39038500,false,false,false)

	local basket8 = CreateObject(`v_res_tre_flatbasket`,spawn.x-1.19923400,spawn.y+1.69598600,spawn.z+1.39038500,false,false,false)
	local basket9 = CreateObject(`v_res_tre_basketmess`,spawn.x-1.18293800,spawn.y+0.91436380,spawn.z+1.39038500,false,false,false)
	local bowl = CreateObject(`v_res_r_sugarbowl`,spawn.x-0.26029210,spawn.y-6.66716800,spawn.z+3.77324900,false,false,false)
	local breadbin = CreateObject(`Prop_Breadbin_01`,spawn.x+2.09788500,spawn.y-6.57634000,spawn.z+2.24041900,false,false,false)
	local knifeblock = CreateObject(`v_res_mknifeblock`,spawn.x+1.82084700,spawn.y-6.58438500,spawn.z+2.27399500,false,false,false)

	local toaster = CreateObject(`prop_toaster_01`,spawn.x-1.05790700,spawn.y-6.59017400,spawn.z+2.26793200,false,false,false)
	local wok = CreateObject(`prop_wok`,spawn.x+2.01728800,spawn.y-5.57091500,spawn.z+2.26793200,false,false,false)
	local plant5 = CreateObject(`Prop_Plant_Int_03a`,spawn.x+2.55015600,spawn.y+4.60183900,spawn.z+1.20829700,false,false,false)

	local tumbler = CreateObject(`p_tumbler_cs2_s`,spawn.x-0.90916440,spawn.y-4.24099100,spawn.z+2.26793200,false,false,false)
	local wisky = CreateObject(`p_whiskey_bottle_s`,spawn.x-0.92809300,spawn.y-3.99099100,spawn.z+2.26793200,false,false,false)
	local tissue = CreateObject(`v_res_tissues`,spawn.x+7.95889300,spawn.y-2.54847100,spawn.z+1.94013400,false,false,false)

	local pants = CreateObject(`V_16_Ap_Mid_Pants4`,spawn.x+7.55366500,spawn.y-0.25457100,spawn.z+1.33009200,false,false,false)
	local pants2 = CreateObject(`V_16_Ap_Mid_Pants5`,spawn.x+7.76753200,spawn.y+3.00476500,spawn.z+1.33052800,false,false,false)
	local hairdryer = CreateObject(`v_club_vuhairdryer`,spawn.x+8.12616000,spawn.y-2.50562000,spawn.z+1.96009390,false,false,false)


	FreezeEntityPosition(dt,true)
	FreezeEntityPosition(mpmid01,true)
	FreezeEntityPosition(mpmid09,true)
	FreezeEntityPosition(mpmid07,true)
	FreezeEntityPosition(mpmid03,true)
	FreezeEntityPosition(midData,true)
	FreezeEntityPosition(glow,true)
	FreezeEntityPosition(curtins,true)
	FreezeEntityPosition(mpmid13,true)
	FreezeEntityPosition(mpcab,true)
	FreezeEntityPosition(mpdecal,true)
	FreezeEntityPosition(mpdelta,true)
	FreezeEntityPosition(couch,true)
	FreezeEntityPosition(chair,true)
	FreezeEntityPosition(chair2,true)
	FreezeEntityPosition(plant,true)
	FreezeEntityPosition(lamp,true)
	FreezeEntityPosition(fridge,true)
	FreezeEntityPosition(micro,true)
	FreezeEntityPosition(sideBoard,true)
	FreezeEntityPosition(bedSide,true)
	FreezeEntityPosition(plant2,true)
	FreezeEntityPosition(tableObj,true)
	FreezeEntityPosition(tv,true)
	FreezeEntityPosition(plant3,true)
	FreezeEntityPosition(chair3,true)
	FreezeEntityPosition(lampStand,true)
	FreezeEntityPosition(chair4,true)
	FreezeEntityPosition(chair5,true)
	FreezeEntityPosition(chair6,true)
    FreezeEntityPosition(plant4,true)
    FreezeEntityPosition(storage,true)
	FreezeEntityPosition(storage2,true)
	FreezeEntityPosition(basket,true)
	FreezeEntityPosition(wardrobe,true)
	FreezeEntityPosition(wardrobe2,true)
	FreezeEntityPosition(table2,true)
	FreezeEntityPosition(lamp3,true)
	FreezeEntityPosition(laundry,true)
	FreezeEntityPosition(beddelta,true)
	FreezeEntityPosition(bed,true)
	FreezeEntityPosition(beddecal,true)
	FreezeEntityPosition(tapeplayer,true)
	FreezeEntityPosition(basket7,true)
	FreezeEntityPosition(basket6,true)
	FreezeEntityPosition(basket8,true)
    FreezeEntityPosition(basket9,true)
    
    
    table.insert(objects, dt)
    table.insert(objects, mpmid01)
    table.insert(objects, mpmid09)
    table.insert(objects, mpmid07)
    table.insert(objects, mpmid03)
    table.insert(objects, midData)
    table.insert(objects, glow)
    table.insert(objects, curtins)
    table.insert(objects, mpmid13)
    table.insert(objects, mpcab)
    table.insert(objects, mpdecal)
    table.insert(objects, mpdelta)
    table.insert(objects, couch)
    table.insert(objects, chair)
    table.insert(objects, chair2)
    table.insert(objects, plant)
    table.insert(objects, lamp)
    table.insert(objects, fridge)
    table.insert(objects, micro)
    table.insert(objects, sideBoard)
    table.insert(objects, bedSide)
    table.insert(objects, plant2)
    table.insert(objects, tableObj)
    table.insert(objects, tv)
    table.insert(objects, plant3)
    table.insert(objects, chair3)
    table.insert(objects, lampStand)
    table.insert(objects, chair4)
    table.insert(objects, chair5)
    table.insert(objects, chair6)
    table.insert(objects, plant4)
    table.insert(objects, storage2)
    table.insert(objects, basket)
    table.insert(objects, wardrobe)
    table.insert(objects, wardrobe2)
    table.insert(objects, table2)
    table.insert(objects, lamp3)
    table.insert(objects, laundry)
    table.insert(objects, beddelta)
    table.insert(objects, bed)
    table.insert(objects, beddecal)
    table.insert(objects, tapeplayer)
    table.insert(objects, basket7)
    table.insert(objects, basket6)
    table.insert(objects, basket8)
    table.insert(objects, basket9)

	SetEntityHeading(beerbot,GetEntityHeading(beerbot)+90)
	SetEntityHeading(couch,GetEntityHeading(couch)-90)
	SetEntityHeading(chair,GetEntityHeading(chair)+getRotation(0.28045480))
	SetEntityHeading(chair2,GetEntityHeading(chair2)+getRotation(0.3276100))
	SetEntityHeading(fridge,GetEntityHeading(chair2)+160)
	SetEntityHeading(micro,GetEntityHeading(micro)-80)
	SetEntityHeading(sideBoard,GetEntityHeading(sideBoard)+90)
	SetEntityHeading(bedSide,GetEntityHeading(bedSide)+180)
	SetEntityHeading(tv,GetEntityHeading(tv)+90)
	SetEntityHeading(plant3,GetEntityHeading(plant3)+90)
	SetEntityHeading(chair3,GetEntityHeading(chair3)+200)
	SetEntityHeading(chair4,GetEntityHeading(chair3)+100)
	SetEntityHeading(chair5,GetEntityHeading(chair5)+135)
	SetEntityHeading(chair6,GetEntityHeading(chair6)+10)
	SetEntityHeading(storage,GetEntityHeading(storage)+180)
	SetEntityHeading(storage2,GetEntityHeading(storage2)-90)
	SetEntityHeading(table2,GetEntityHeading(table2)+90)
	SetEntityHeading(tapeplayer,GetEntityHeading(tapeplayer)+90)
    SetEntityHeading(knifeblock,GetEntityHeading(knifeblock)+180)
	Citizen.Wait(100)
	floatSafePlayer(shell,spawn)
	Citizen.Wait(500)
	FreezeEntityPosition(PlayerPedId(),false)
	return { objects, POIOffsets }

end

function floatSafePlayer(buildingsent,spawn)
	--print(buildingsent,spawn.x,spawn.y,spawn.z)
		SetEntityInvincible(PlayerPedId(),true)
	FreezeEntityPosition(PlayerPedId(),true)
	local plyCoord = GetEntityCoords(PlayerPedId())
	local processing = 3
	local counter = 100
	local building = buildingsent

		while processing == 3 do
		Citizen.Wait(100)
		if DoesEntityExist(building) then

			processing = 2
		end
		if counter == 0 then
			processing = 1
		end
		counter = counter - 1
	end

	if counter > 0 then
		
		TeleportToInterior(spawn.x + 3.69693000, spawn.y - 15.080020100, spawn.z + 1.5, spawn.h)
	elseif processing == 1 then
		FreezeEntityPosition(PlayerPedId(),false)
		SetEntityCoords(PlayerPedId(), spawn.x , spawn.y, spawn.z )
		TriggerEvent("SendAlert","Failed to load property.",2)
	end

	Citizen.Wait(1000)
	SetEntityInvincible(PlayerPedId(),false)
end



function DespawnInterior(objects)
	for i,v in ipairs(objects) do
		DeleteEntity(v)
	end
end

function TeleportToInterior(x, y, z, h)
	Citizen.CreateThread(function()
		TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.8)
		DoScreenFadeOut(500)

        while not IsScreenFadedOut() do
            Citizen.Wait(150)
        end

        SetEntityCoords(PlayerPedId(), x, y, z, 0, 0, 0, false)
        SetEntityHeading(PlayerPedId(), h)

        Citizen.Wait(100)

        DoScreenFadeIn(1000)
    end)
end

function getRotation(input)
    return 360 / (10 * input)
end
RegisterNetEvent("DSRP_housing:cHouses")
AddEventHandler("DSRP_housing:cHouses",function(myhouses)
	houses = myhouses
end)
local nearTest = {}
local insertT = false
RegisterNetEvent("DSRP_housing:givenearhouse")
AddEventHandler("DSRP_housing:givenearhouse",function(nearhouses)
	nearHouses = nearhouses
	--nearTests = {}
	-- print('am i not coming here to give 1 houses?')
	-- print(json.encode(nearh ouses))
	-- print('test : ', nearhouses[1].id)
	-- print(nearTest == nil)
	-- if nearTest ~= nil and not false then
	-- 	table.insert(nearTest, nearhouses)
	-- 	insertT = true
	-- 	return	
	-- end

	-- for _, house in ipairs(nearTest) do
	-- 	print('compare id',nearhouses[1].id,house.id)
	-- 	if nearhouses[1].id == nearTest[1].id then
	-- 		print('added?')
	-- 	else
	-- 		table.insert(nearTest, nearhouses)
	-- 	end
	-- end
	-- for i,k in ipairs(nearTest) do
	-- 	print(i)
	-- 	print('house id:',nearTest[i].name)
	-- end
end)

-- Citizen.CreateThread(function()
-- 	Citizen.Wait(2000)
-- 	while true do
-- 		Citizen.Wait(1000)
-- 		print('NEAR TEST',json.encode(nearTest),'\n')
-- 		for i,k in ipairs(nearTest) do
-- 			--print(json.encode(k))
-- 			for _, house in ipairs(k) do
-- 				print(house.name)
-- 			end
-- 		end
-- 	end
-- end)

RegisterNetEvent('DSRP_housing:creatingHouse')
AddEventHandler('DSRP_housing:creatingHouse', function(name,prices,garage,shells)
print('creating house',name,prices,garage,shells)
local playerPos = GetEntityCoords(PlayerPedId(), true)
	local type = shells
	local price = prices
	local shell = ""
	if type == "mid" or type == "Mid" then
		shell = "mid"
	elseif type == "low" or type == "Low" then
		shell = "low"
	elseif type == "trevor" or type == "Trevor" then
		shell = "trevor"
	elseif type == "lester" or type == "Lester" then
		shell = "lester"
	elseif type == "ranch" or type == "Ranch" then
		shell = "ranch"
	end
	-- print(playerPos.x, playerPos.y, playerPos.z)
	if currentJob == "realestateagent" then
		TriggerServerEvent("DSRP_housing:createHouse", shell, price, playerPos.x, playerPos.y, playerPos.z,garage,name)
	else
		TriggerEvent('SendAlert', 'You are not a realestate agent.')
	end
end)

RegisterCommand('createhouse', function(source, args)
	local playerPos = GetEntityCoords(PlayerPedId(), true)
	local type = args[1]
	local price = args[2]
	local garage = args[3]
	local name =  args[4]
	local shell = ""
	if type == "mid" or type == "Mid" then
		shell = "mid"
	elseif type == "low" or type == "Low" then
		shell = "low"
	elseif type == "trevor" or type == "Trevor" then
		shell = "trevor"
	elseif type == "lester" or type == "Lester" then
		shell = "lester"
	elseif type == "ranch" or type == "Ranch" then
		shell = "ranch"
	end
	-- print(playerPos.x, playerPos.y, playerPos.z)
	if currentJob == "realestateagent" then
		TriggerServerEvent("DSRP_housing:createHouse", shell, price, playerPos.x, playerPos.y, playerPos.z,garage,name)
	else
		TriggerEvent('SendAlert', 'You are not a realestate agent.')
	end
end)

RegisterCommand('cexit', function()
	if enterHouse then
		local playerPos = GetEntityCoords(PlayerPedId(), true)
		TriggerServerEvent('DSRP_housing:createExit',houseID,playerPos.x, playerPos.y, playerPos.z)
		LeaveAfterSave()
	else
		TriggerEvent("SendAlert", "You are not in your house",2)
	end
end)

RegisterNetEvent('DSRP_housing:creatingExit')
AddEventHandler('DSRP_housing:creatingExit', function(id)
	TriggerEvent('SendAlert','Exit is creating you will leave in a sec.',2)
	local playerPos = GetEntityCoords(PlayerPedId(), true)
		TriggerServerEvent('DSRP_housing:createExit',id,playerPos.x, playerPos.y, playerPos.z)
		Citizen.Wait(1500)
		LeaveAfterSave()
end)
RegisterCommand('storage', function()
	if enterHouse then
		local cid = exports["isPed"]:isPed("cid")
		if houseOwner == cid or currentJob == "realestateagent" then
		local playerPos = GetEntityCoords(PlayerPedId(), true)
			TriggerServerEvent('DSRP_housing:storage',houseID,playerPos.x, playerPos.y, playerPos.z)
			Citizen.Wait(100)
			LeaveAfterSave()
		end
	else
		TriggerEvent("SendAlert", "You are not in your house",2)
	end
end)

RegisterNetEvent('DSRP_housing:storage')
AddEventHandler('DSRP_housing:storage', function(id)
	print('seting up storage')
	if enterHouse then
		
		local cid = exports["isPed"]:isPed("cid")
		for _,house in pairs(nearHouses) do
			if houseOwner == cid or currentJob == "realestateagent" then
				local playerPos = GetEntityCoords(PlayerPedId(), true)
				TriggerServerEvent('DSRP_housing:storage',houseID,playerPos.x, playerPos.y, playerPos.z)
				Citizen.Wait(100)
				LeaveAfterSave()
			else
				TriggerEvent("SendAlert", "You can't do that!",2)
			end
		end
	else
		TriggerEvent("SendAlert", "You are not in your house",2)
	end
end)

RegisterCommand('wardrobe', function()
	if enterHouse then
		local playerPos = GetEntityCoords(PlayerPedId(), true)
		TriggerServerEvent('DSRP_housing:wardrobe',houseID,playerPos.x, playerPos.y, playerPos.z)
		LeaveAfterSave()
	else
		TriggerEvent("SendAlert", "You are not in your house",2)
	end
end)

RegisterCommand('setgarage', function()
		local playerPos = GetEntityCoords(PlayerPedId(), true)
		if garageSet then
			if (IsOwnHouse() == true ) then
				TriggerServerEvent('DSRP_housing:setgarages',houseID,playerPos.x, playerPos.y, playerPos.z)
			else
				TriggerEvent("SendAlert", "You are too far on your house", 2)
			end
		else
			TriggerEvent("SendAlert", "Setting Garage/Parking is not enabled", 2)
		end
end)

RegisterCommand('parking', function()
	garageSet = true
	TriggerServerEvent('DSRP_housing:getOwnHouses')
end)

function LeaveAfterSave()
	TriggerEvent("inhouse",false)
	for i,v in ipairs(myHouse) do
		local door = json.decode(v.door)
		TeleportToInterior(door.x, door.y, door.z, 0.0)
	end
end

Citizen.CreateThread(function()
	TriggerServerEvent('DSRP_housing:getHouses')
	
end)

function FloatTilSafeR(buildingsent)
	SetEntityInvincible(PlayerPedId(),true)
	FreezeEntityPosition(PlayerPedId(),true)
	local plyCoord = GetEntityCoords(PlayerPedId())
	local processing = 3
	local counter = 100
	local building = buildingsent
	
	while processing == 3 do
		Citizen.Wait(100)
		if DoesEntityExist(building) then

			processing = 2
		end
		if counter == 0 then
			processing = 1
		end
		counter = counter - 1
	end

	if counter > 0 then
		SetEntityCoords(PlayerPedId(),plyCoord)
	elseif processing == 1 then
		FreezeEntityPosition(PlayerPedId(),false)
		SetEntityCoords(PlayerPedId(), spawn.x , spawn.y, spawn.z )
		TriggerEvent("SendAlert","Failed to load property.",2)
	end

	Citizen.Wait(1000)
	SetEntityInvincible(PlayerPedId(),false)
end

local imNearHouse = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(15)
		-- print('this is running')
		if (NearHouse() == true) then
			-- print('near houses')
			imNearHouse = true
			
			
			if imNearHouse then
				Citizen.Wait(2000)
				-- print('SENDIN ID IN NEAR HOUSES')
				TriggerServerEvent('DSRP_housing:nearHouses',NearhouseID)
				imNearHouse = false
			end
		else
			if imNearHouse then
				print('is this optimization runnong?')
				imNearHouse = false
			end
		end
		
	end
end)
-- Check if player is near a house
function NearHouse()
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	for _, item in pairs(houses) do
		local door = json.decode(item.door)
	  local distance = #(vector3(door.x, door.y, door.z) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
	  if(distance <= 5) then
		NearhouseID = item.id
		return true
	--   else
	-- 		if(distance >= 50) then
	-- 			return false
	-- 		end
	  end
	end
end

-- Check if player is near a house
function IsOwnHouse()
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	for _, item in pairs(myHouse) do
		local door = json.decode(item.door)
	  local distance = #(vector3(door.x, door.y, door.z) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
	  if(distance <= 20) then
		houseID = item.id
		return true
	  end
	end
end

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end



function displayBlips()
	for i=1, #displayHouse, 1 do
		local myHouse = json.decode(displayHouse[i].door)
		Complex = AddBlipForCoord(tonumber(myHouse.x), tonumber(myHouse.y), tonumber(myHouse.z))
		SetBlipSprite (Complex, 350)
		SetBlipColour(Complex, 2)
		SetBlipDisplay(Complex, 4)
		SetBlipScale  (Complex, 0.6)
		SetBlipAsShortRange(Complex, true)
		BeginTextCommandSetBlipName("STRING")
		if displayHouse[i].shell == "mid" then
			AddTextComponentString("Mid Apartment-"..displayHouse[i].id)
		elseif displayHouse[i].shell == "house" then
			AddTextComponentString("House-"..displayHouse[i].id)
		end
		EndTextCommandSetBlipName(Complex)
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        TriggerEvent('chat:addSuggestion', '/createhouse', '/createhouse [house(type)] [price] [garage](true|false) type /housetype for more info.')
        TriggerEvent('chat:addSuggestion', '/storage', 'Adding Storage for you house.')
        TriggerEvent('chat:addSuggestion', '/wardrobe', 'Adding wardrobe for your house to use /outfits.')
		TriggerEvent('chat:addSuggestion', '/cexit', 'Creating exit for your house.')
		TriggerEvent('chat:addSuggestion', '/parking', 'To enable setting storage')
		TriggerEvent('chat:addSuggestion', '/setgarage', 'Creating garage for your house. [parking] must be enabled.')
    end
end)

RegisterCommand('housetype', function()
	if currentJob == "realestateagent" then
		TriggerEvent("customNotification","\nmid - Mid house apartment.\nlow - Low house apartmentl.\ntrevor - Nice Tier 1 house.\nlester - Nice Tier 2 house. \nranch - Nice Tier 3 house.")
		else
		TriggerEvent('SendAlert', 'you are not real estate agent.')
	end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end