RegisterNetEvent('trp-doors:fetchInitialState')
AddEventHandler('trp-doors:fetchInitialState', function()
	local source = source
	  TriggerClientEvent('trp-doors:setInitialState', source, Config.Doorlist)
	  TriggerClientEvent('trp-doors:sendforpoly', source, Config.Doorlist)
end)

RegisterNetEvent('trp-doors:fetchState')
AddEventHandler('trp-doors:fetchState', function(closestDoorId, doors)
	TriggerClientEvent("SetState", -1, closestDoorId, doors)
end, true)

ESX = nil
local doorInfo = {}

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_doorlock:SaveOnConfig')
AddEventHandler('esx_doorlock:SaveOnConfig', function(name, coords, model, job, entity, distance, garage)
	local xPlayer = ESX.GetPlayerFromId(source)
	if GetPlayerIdentifier(source) == 'steam:11000013bd84d46' or 'steam:11000011c3fe668' or 'steam:110000139236a0a' then
		xPlayer.showNotification("Door Found!")
		
		local path = GetResourcePath(GetCurrentResourceName())
		--------- Remove the } to add the other line ---------
		--------- Open the file ---------
		local file = io.open(path.."/server/svdoors.lua", "a") -- Append mode
		local file2 = io.open(path.."/client/polyzonetest.lua", "a")
		-- Its formatted like that to simply edit (if you have to edit)
		file:write("\n	Config.Doorlist[#Config.Doorlist + 1] = {")
		file:write("\n		name = '"..name.."',")
		file:write("\n		textCoords = "..coords..",")
		file:write("\n		authorizedJobs = '"..job.."',")
		file:write("\n		locked = true,")
		file:write("\n		distance = "..distance..",")
		file:write("\n		objName = "..model..",")
		file:write("\n		objCoords = "..coords.."")
		file:write("\n}")
		file:close()
		local player = source
		local ped = GetPlayerPed(player)
		local playerCoords = GetEntityCoords(ped)
--[[	local vec2 = playerCoords.x - distance ..','..playerCoords.y
		local vec1 = playerCoords.x ..','..playerCoords.y + distance

		local vec3 = playerCoords.x + distance ..','..playerCoords.y
		local vec4 = playerCoords.x  ..','..playerCoords.y - distance
		file2:write("\n	 local "..name.. " = ")
		file2:write("\n		PolyZone:Create({")
		file2:write("\n		vector2("..vec2.."),")
		file2:write("\n		vector2("..vec1.."),")
		file2:write("\n		vector2("..vec3.."),")
		file2:write("\n		vector2("..vec4..")")
		file2:write("\n				}, {")
		file2:write("\n		  name= '"..name.."',")
		file2:write("\n		  minZ = "..playerCoords.z - 2 ..",")
		file2:write("\n		  maxZ = "..playerCoords.z + 2 ..",")
		file2:write("\n		  debugGrid = true")
		file2:write("\n})")

		file2:write("\n	 local nearPoly"..name.." = false")
		file2:write("\n	Citizen.CreateThread(function()")
		file2:write("\n	   	while true do")
		file2:write("\n	 		Citizen.Wait(1200)")
		file2:write("\n	 		local closestDoorDistance, closestDoorId = 9999.9, -1")
		file2:write("\n		    local currentPos = GetEntityCoords(PlayerPedId())")
		file2:write("\n	   	 	  for id, handle in pairs(doors) do")
		file2:write("\n	 		    local currentDoorDistance = #(doors[id].objCoords - currentPos)")
		file2:write("\n	 		if handle and currentDoorDistance < closestDoorDistance then")
		file2:write("\n	 		closestDoorDistance = currentDoorDistance")
		file2:write("\n	 		   closestDoorId = id")
		file2:write("\n	  		      end")
		file2:write("\n	 		end")
		file2:write("\n	 		local plyPed = PlayerPedId()")
		file2:write("\n	 		local coord = GetEntityCoords(plyPed)")
		file2:write("\n	 		nearPoly"..name.." = "..name..":isPointInside(coord)")
		file2:write("\n	  		if nearPoly"..name.." then")
		file2:write("\n	 		   if DoorSystemGetDoorState(closestDoorId) == 1 then")
		file2:write("\n	 		   TriggerEvent('cd_drawtextui:ShowUI', 'show', '[E] Locked')")
		file2:write("\n	 		   else")
		file2:write("\n	 		   TriggerEvent('cd_drawtextui:ShowUI', 'show', '[E] Unlocked')")
		file2:write("\n	 	end")
		file2:write("\n	 	else")
		file2:write("\n	 	 TriggerEvent('cd_drawtextui:HideUI')")
		file2:write("\n	 		end")
		file2:write("\n	 	end")
		file2:write("\n	 end)")]]--
		file2:close()

	else
		xPlayer.showNotification("You dont have permission to do that")
	end
end)

function round2(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function DeleteString(path, before)
    local inf = assert(io.open(path, "r+"), "Failed to open input file")
    local lines = ""
    while true do
        local line = inf:read("*line")
		if not line then break end
		
		if line ~= before then lines = lines .. line .. "\n" end
    end
    inf:close()
    file = io.open(path, "w")
    file:write(lines)
    file:close()
end
