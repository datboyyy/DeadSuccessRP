ESX = nil

cachedData = {
	["banks"] = {

	}
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharAVACedObject", function(obj) 
			ESX = obj 
		end)

		Citizen.Wait(0)
	end

	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response

	ESX.TriggerServerCallback("bankrobberies:getCurrentRobbery", function(found)
		if found then
			for bank, bankData in pairs(found) do
				cachedData["banks"][bank] = bankData["trolleys"]

				RobberyThread({
					["bank"] = bank,
					["trolleys"] = bankData["trolleys"]
				})
			end
		end
	end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	ESX.PlayerData["job"] = newJob
end)

RegisterNetEvent("bankrobberies:eventHandler")
AddEventHandler("bankrobberies:eventHandler", function(event, eventData)
	if event == "start_robbery" then
		RobberyThread(eventData)
	elseif event == "alarm_police" then
		if ESX.PlayerData["job"] and ESX.PlayerData["job"]["name"] == "police" then
			SetAudioFlag("LoadMPData", true)
			PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")

			ESX.ShowNotification("Someone is trying to decrypt the lock on bank - " .. eventData .. " waypoint is now set.")

			local bankValues = Config.Banks[eventData]

			SetNewWaypoint(bankValues["start"]["pos"]["x"], bankValues["start"]["pos"]["y"])

			local blipRobbery = AddBlipForCoord(bankValues["start"]["pos"])

			SetBlipSprite(blipRobbery, 161)
			SetBlipScale(blipRobbery, 2.0)
			SetBlipColour(blipRobbery, 8)

			Citizen.CreateThread(function()
				local startedBlip = GetGameTimer()

				while GetGameTimer() - startedBlip < 60000 * 5 do
					Citizen.Wait(0)
				end

				RemoveBlip(blipRobbery)
			end)
		end
	else
		-- print("Wrong event handler.")
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		local sleepThread = 500

	  	local ped = PlayerPedId()
	  	local pedCoords = GetEntityCoords(ped)

		for bank, values in pairs(Config.Banks) do
			local dstCheck = GetDistanceBetweenCoords(pedCoords, values["start"]["pos"], true)

			if dstCheck <= 5.0 then
				sleepThread = 5

				if dstCheck <= 1.0 then
					local usable, displayText = not cachedData["banks"][bank], cachedData["hacking"] and "Hacking..." or cachedData["banks"][bank] and "Robbery ongoing, already destroyed." or "~INPUT_CONTEXT~ Start hacking the device."

					ESX.ShowHelpNotification(displayText)

					if IsControlJustPressed(0, 38) then
						if usable then
							TryHackingDevice(bank)
						end
					end
				end

				DrawScriptMarker({
					["type"] = 6,
					["pos"] = values["start"]["pos"] - vector3(0.0, 0.0, 0.985),
					["r"] = 255,
					["g"] = 0,
					["b"] = 0
				})
			end
		end

	  	Citizen.Wait(sleepThread)
	end
end)

