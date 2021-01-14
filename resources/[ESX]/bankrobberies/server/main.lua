local ESX = nil

local cachedData = {}

TriggerEvent('esx:getSharAVACedObject', function(obj) 
	ESX = obj 
end)

ESX.RegisterServerCallback("bankrobberies:getCurrentRobbery", function(source, callback)
	callback(cachedData)
end)

ESX.RegisterServerCallback("bankrobberies:fetchCops", function(source, callback)
	local players = ESX.GetPlayers()

	local policeMen = 0

	for index, player in ipairs(players) do
		local player = ESX.GetPlayerFromId(player)

		if player then
			if player["job"]["name"] == "police" then
				policeMen = policeMen + 1
			end
		end
	end

	callback(policeMen >= Config.CopsNeeded)
end)

RegisterServerEvent("bankrobberies:globalEvent")
AddEventHandler("bankrobberies:globalEvent", function(options)
	if type(options["data"]) == "table" then
		if options["data"]["save"] then
			cachedData[options["data"]["bank"]] = {
				["started"] = os.time(),
				["robber"] = source,
				["trolleys"] = options["data"]["trolleys"]
			}
		end
	end

    TriggerClientEvent("bankrobberies:eventHandler", -1, options["event"] or "none", options["data"] or nil)
end)

RegisterServerEvent("getthebankroll")
AddEventHandler("getthebankroll", function()
	local player = ESX.GetPlayerFromId(source)

if player then
local source = source 
		TriggerClientEvent('player:receiveItem' , source, "markedbills",13 )

    end
end)