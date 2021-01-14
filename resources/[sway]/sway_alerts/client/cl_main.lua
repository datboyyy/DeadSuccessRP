ESX = nil

local timing, isPlayerWhitelisted = math.ceil(1 * 60000), false
local streetName, playerGender

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	TriggerEvent('skinchanger:getSkin', function(skin)
		playerGender = skin.sex
	end)

	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)
local zoneNames = {
	AIRP = "Los Santos International Airport",
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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)

		if NetworkIsSessionStarted() then
			DecorRegister('isOutlaw', 3)
			DecorSetInt(PlayerPedId(), 'isOutlaw', 1)

			return
		end
	end
end)

-- Gets the player's current street.
-- Aaalso get the current player gender
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)

		local playerCoords = GetEntityCoords(PlayerPedId())
		streetName,street2 = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		 zone = tostring(GetNameOfZone(playerCoords))
			playerStreetsLocation = zoneNames[tostring(zone)]
			streetName = GetStreetNameFromHashKey(streetName)..' | '..GetStreetNameFromHashKey(street2)..' | '..playerStreetsLocation
			if street2 == 0 then
				streetName,street2 = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
				streetName = GetStreetNameFromHashKey(streetName)..' | '..playerStreetsLocation
			end
	end
end)

AddEventHandler('skinchanger:loadSkin', function(character)
	playerGender = character.sex
end)

function refreshPlayerWhitelisted()
	if not ESX.PlayerData then
		return false
	end

	if not ESX.PlayerData.job then
		return false
	end

	for k,v in ipairs(Config.WhitelistedCops) do
		if v == ESX.PlayerData.job.name then
			return true
		end
	end

	return false
end


RegisterNetEvent('esx_outlawalert:outlawNotify')
AddEventHandler('esx_outlawalert:outlawNotify', function(type, data, length)
	if isPlayerWhitelisted then
		SendNUIMessage({action = 'display', style = type, info = data, length = length})
    	PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)

		if DecorGetInt(PlayerPedId(), 'isOutlaw') == 2 then
			Citizen.Wait(timing)
			DecorSetInt(PlayerPedId(), 'isOutlaw', 1)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local coords = GetEntityCoords(playerPed)

			-- is shootin'
		if IsPedShooting(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) and Config.GunshotAlert then

			Citizen.Wait(3000)

			if (isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted then
				DecorSetInt(playerPed, 'isOutlaw', 2)

				TriggerServerEvent('esx_outlawalert:gunshotInProgress', {
					x = ESX.Math.Round(playerCoords.x, 1),
					y = ESX.Math.Round(playerCoords.y, 1),
					z = ESX.Math.Round(playerCoords.z, 1)
				}, streetName)
				
				TriggerServerEvent('esx_phone:send', 'police', 'Gun Shot In Progress', false, {
					x = coords.x,
					y = coords.y,
					z = coords.z
				})
			end

		end
	end
end)




RegisterNetEvent('esx_outlawalert:carJackInProgress')
AddEventHandler('esx_outlawalert:carJackInProgress', function(targetCoords)
	if isPlayerWhitelisted then
		if Config.CarJackingAlert then
			local alpha = 250
			local thiefBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipJackingRadius)

			SetBlipHighDetail(thiefBlip, true)
			SetBlipColour(thiefBlip, 1)
			SetBlipAlpha(thiefBlip, alpha)
			SetBlipAsShortRange(thiefBlip, true)

			while alpha ~= 0 do
				Citizen.Wait(Config.BlipJackingTime * 4)
				alpha = alpha - 1
				SetBlipAlpha(thiefBlip, alpha)

				if alpha == 0 then
					RemoveBlip(thiefBlip)
					return
				end
			end

		end
	end
end)

RegisterNetEvent('esx_outlawalert:gunshotInProgress')
AddEventHandler('esx_outlawalert:gunshotInProgress', function(targetCoords)
	if isPlayerWhitelisted and Config.GunshotAlert then
		local alpha = 190
		local gunshotBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
		SetBlipSprite(gunshotBlip, 119)
		SetBlipScale(gunshotBlip, 2.0)
		SetBlipHighDetail(gunshotBlip, true)
		SetBlipColour(gunshotBlip, 0)
		SetBlipAlpha(gunshotBlip, alpha)
		SetBlipAsShortRange(gunshotBlip, false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Shooting in Progress")
		EndTextCommandSetBlipName(gunshotBlip)

		while alpha ~= 0 do
			Citizen.Wait(50 * 8)
			alpha = alpha - 1
			SetBlipAlpha(gunshotBlip, alpha)

			if alpha == 0 then
				RemoveBlip(gunshotBlip)
				return
			end
		end
	end
end)


RegisterNetEvent('esx_outlawalert:ems')
AddEventHandler('esx_outlawalert:ems', function(targetCoords)
	if isPlayerWhitelisted and Config.GunshotAlert then
		local alpha = 190
		local deadblip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
		SetBlipSprite(deadblip, 310)
		SetBlipScale(deadblip, 2.0)
		SetBlipHighDetail(deadblip, true)
		SetBlipColour(deadblip, 1)
		SetBlipAlpha(deadblip, alpha)
		SetBlipAsShortRange(deadblip, false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Civilian Down")
		EndTextCommandSetBlipName(deadblip)

		while alpha ~= 0 do
			Citizen.Wait(40 * 8)
			alpha = alpha - 1
			SetBlipAlpha(deadblip, alpha)

			if alpha == 0 then
				RemoveBlip(deadblip)
				return
			end
		end
	end
end)

RegisterNetEvent('esx_outlawalert:robberyinprogress')
AddEventHandler('esx_outlawalert:robberyinprogress', function(targetCoords)
	if isPlayerWhitelisted and Config.MeleeAlert then
		local alpha = 190
		local meleeBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
		SetBlipSprite(meleeBlip,618)
		SetBlipScale(meleeBlip, 2.0)
		SetBlipHighDetail(meleeBlip, true)
		SetBlipColour(meleeBlip, 5)
		SetBlipAlpha(meleeBlip, alpha)
		SetBlipAsShortRange(meleeBlip, false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Robbery In Progress")
		EndTextCommandSetBlipName(meleeBlip)

		while alpha ~= 0 do
			Citizen.Wait(70 * 4)
			alpha = alpha - 1
			SetBlipAlpha(meleeBlip, alpha)
			if alpha == 0 then
				RemoveBlip(meleeBlip)
				return
			end
		end
	end
end)


RegisterNetEvent('esx_outlawalert:emspanicdown')
AddEventHandler('esx_outlawalert:emspanicdown', function(targetCoords)
	if isPlayerWhitelisted and Config.GunshotAlert then
		local alpha = 190
		local deadblip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
		SetBlipSprite(deadblip, 310)
		SetBlipScale(deadblip, 2.0)
		SetBlipHighDetail(deadblip, true)
		SetBlipColour(deadblip, 1)
		SetBlipAlpha(deadblip, alpha)
		SetBlipAsShortRange(deadblip, false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("EMS Down")
		EndTextCommandSetBlipName(deadblip)

		while alpha ~= 0 do
			Citizen.Wait(40 * 8)
			alpha = alpha - 1
			SetBlipAlpha(deadblip, alpha)

			if alpha == 0 then
				RemoveBlip(deadblip)
				return
			end
		end
	end
end)



RegisterNetEvent('esx_outlawalert:officerpanicdown')
AddEventHandler('esx_outlawalert:officerpanicdown', function(targetCoords)
	if isPlayerWhitelisted and Config.GunshotAlert then
		local alpha = 190
		local deadblip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
		SetBlipSprite(deadblip, 310)
		SetBlipScale(deadblip, 2.0)
		SetBlipHighDetail(deadblip, true)
		SetBlipColour(deadblip, 1)
		SetBlipAlpha(deadblip, alpha)
		SetBlipAsShortRange(deadblip, false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("EMS Down")
		EndTextCommandSetBlipName(deadblip)

		while alpha ~= 0 do
			Citizen.Wait(40 * 8)
			alpha = alpha - 1
			SetBlipAlpha(deadblip, alpha)

			if alpha == 0 then
				RemoveBlip(deadblip)
				return
			end
		end
	end
end)