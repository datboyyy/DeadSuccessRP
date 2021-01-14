ESX = nil

local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	print(job)
	PlayerData.job = job
end)

HudStage = 1
RegisterNetEvent('notification')
AddEventHandler('notification', function(text,color,length)
    if HudStage > 2 then return end
    if not color then color = 1 end
    if not length then length = 12000 end
    TriggerEvent("tasknotify:guiupdate",color, text, 12000)
end)


RegisterNetEvent('orp_license:license')
AddEventHandler('orp_license:license', function(pID)

	local playerID = GetPlayerServerId(pID)
	TriggerServerEvent('police:Weaponlicense', playerID)
	licenses = exports["isPed"]:isPed("licensestring")

	 TriggerEvent("notification", licenses,1)
	 Citizen.Wait(5000)
	 TriggerEvent("notification", "To add/remove license type <b>/revoke #</b> | <b>/addlicense #</b> ",2)
	 Citizen.Wait(3000)
	 TriggerEvent("notification", "4. Truck License",3)

	 TriggerEvent("notification", "3. Bike License",4)

	 TriggerEvent("notification", "2. Weapon License",5)

	 TriggerEvent("notification", "1. Drivers License",6)

end)

RegisterNetEvent('orp_license:revoke')
AddEventHandler('orp_license:revoke', function(option, job)

	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	local playerID = GetPlayerServerId(closestPlayer)
	if job == 'police' then
	TriggerServerEvent("orp_license:RevokeLicense", option, playerID)
	end
end)

RegisterNetEvent('orp_license:addLic')
AddEventHandler('orp_license:addLic', function(option, job)

	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	local playerID = GetPlayerServerId(closestPlayer)
	if job == 'police' then
	TriggerServerEvent("orp_license:AddLicense", option, playerID)
	end
end)

Citizen.CreateThread(function()
	if job == 'police' then
	TriggerEvent('chat:addSuggestion', '/revoke', '/revoke # | 1 = Drivers, 2 = Weapons, 3 = Bike, 4 = Truck')
	TriggerEvent('chat:addSuggestion', '/addlicense', '/addlicense # | 1 = Drivers, 2 = Weapons, 3 = Bike, 4 = Truck')
	 end
end)