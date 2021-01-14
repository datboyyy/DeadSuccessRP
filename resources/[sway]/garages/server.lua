
ESX = nil

local cachedData = {}

TriggerEvent("esx:getSharAVACedObject", function(library) 
	ESX = library 
end)

ESX.RegisterServerCallback("garage:fetchPlayerVehicles", function(source, callback, garage)
	local player = ESX.GetPlayerFromId(source)

	if player then
		local sqlQuery = [[SELECT plate, vehicle, garage, model, veh_id	FROM owned_vehicles	WHERE owner = @cid]]

		if garage then
			sqlQuery = [[SELECT	plate, vehicle, garage, model, veh_id FROM owned_vehicles WHERE	owner = @cid and garage = @garage AND owned_vehicles.plate NOT IN (SELECT plate from h_impounded_vehicles)]]
		end

		MySQL.Async.fetchAll(sqlQuery, {
			["@cid"] = player["identifier"],
			["@garage"] = garage
		}, function(responses) 
			--print(ESX.DumpTable(responses[4]))
			local playerVehicles = {}

			for key, vehicleData in ipairs(responses) do
				table.insert(playerVehicles, {
					["plate"] = vehicleData["plate"],
					["props"] = json.decode(vehicleData["vehicle"]),
					["garage"] = vehicleData["garage"],
					["model"] = vehicleData["model"],
					["id"] = vehicleData["veh_id"],
				})

				--print(ESX.DumpTable(vehicleData))
			end

			--print(ESX.DumpTable(playerVehicles))
			callback(playerVehicles)
		end)
	else
		callback(false)
	end
end)

function getPlayerVehiclesOut(identifier,cb)
	local vehicles = {}
	local data = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = identifier})	
	cb(data)
end

ESX.RegisterServerCallback('erp_garage:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local deudas = 0
	local result = MySQL.Sync.fetchAll('SELECT * FROM billing WHERE identifier = @identifier',{['@identifier'] = xPlayer.identifier})
	for i=1, #result, 1 do
		amount     = result[i].amount
		deudas = deudas + amount
		if deudas >= 2000 then
			cb("deudas")
		end
	end
	if xPlayer.get('money') >= 200 then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('erp_garage:pay')
AddEventHandler('erp_garage:pay', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(200)
end)

RegisterServerEvent('erp_garage:modifystate')
AddEventHandler('erp_garage:modifystate', function(vehicleProps, state, garage)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local plate = vehicleProps.plate

	if garage == nil then
		MySQL.Sync.execute("UPDATE owned_vehicles SET garage=@garage WHERE plate=@plate",{['@garage'] = "OUT" , ['@plate'] = plate})
		MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle=@vehicle WHERE plate=@plate",{['@vehicle'] = json.encode(vehicleProps) , ['@plate'] = plate})
		MySQL.Sync.execute("UPDATE owned_vehicles SET state=@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})
	else 

		MySQL.Sync.execute("UPDATE owned_vehicles SET garage=@garage WHERE plate=@plate",{['@garage'] = garage , ['@plate'] = plate})
		MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle=@vehicle WHERE plate=@plate",{['@vehicle'] = json.encode(vehicleProps) , ['@plate'] = plate})
		MySQL.Sync.execute("UPDATE owned_vehicles SET state=@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})

	end
end)

RegisterServerEvent('erp_garage:modifyHouse')
AddEventHandler('erp_garage:modifyHouse', function(vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local plate = vehicleProps.plate
	print(json.encode(plate))

	--MySQL.Sync.execute("UPDATE owned_vehicles SET garage=@garage WHERE plate=@plate",{['@garage'] = garage , ['@plate'] = plate})
	MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle=@vehicle WHERE plate=@plate",{['@vehicle'] = json.encode(vehicleProps) , ['@plate'] = plate})

	
end)

RegisterServerEvent("erp_garage:sacarometer")
AddEventHandler("erp_garage:sacarometer", function(vehicle,state,src1)
	local src = source
	if src1 then
		src = src1
	end
	local xPlayer = ESX.GetPlayerFromId(src)
	while xPlayer == nil do Citizen.Wait(1); end
	local plate = all_trim(vehicle)
	local state = state
	MySQL.Sync.execute("UPDATE owned_vehicles SET state =@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})
end)

function all_trim(s)
	return s:match( "^%s*(.-)%s*$" )
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
  end

  RegisterNetEvent("garages:CheckGarageForVeh")
  AddEventHandler("garages:CheckGarageForVeh", function()
	  local src = source
	  local xPlayer = ESX.GetPlayerFromId(src)
	  local identifier = xPlayer.identifier
	  
	  print("cunt")
	  MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier', { ['@identifier'] = identifier }, function(vehicles)
		  TriggerClientEvent('phone:Garage', src, vehicles)
	  end)
  end)

  RegisterNetEvent('garages:CheckGarageForSpawn')
  AddEventHandler('garages:CheckGarageForSpawn', function(vehID, garageCost) 
	local src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	
	--print(identifier)
	MySQL.Async.fetchAll('SELECT model, plate, garage, vehicle, veh_id FROM owned_vehicles WHERE owner = @identifier AND  veh_id = @veh_id', 
	{ 
		['@identifier'] = identifier,
		['@veh_id'] = vehID
	}, function(result)
		if result ~= nil then
			
			local model  = result[1].model
			local plate  = result[1].plate
			local garage = result[1].garage
			local vehicle= json.decode(result[1].vehicle)
			local veh_id = result[1].veh_id
			
			TriggerClientEvent('garages:SpawnVehicle', src, model, plate, garage, vehicle, veh_id)
		else
			print('No car!')
		end
	end)
end)


function returnType(typenr) 
	local x = {
		[0] = 'compacts',
		[1] = 'sedans',
		[2] = "SUV\'s",
		[3] = 'coupes',
		[4] = 'muscle',
		[5] = 'sport classic',
		[6] = 'sport',
		[7] = 'super',
		[8] = 'motorcycle',
		[9] = 'offroad',
		[1] = 'industrial',
		[1] = 'utility',
		[1] = 'vans',
		[1] = 'bicycles',
		[1] = 'boats',
		[1] = 'helicopter',
		[1] = 'plane',
		[1] = 'service',
		[1] = 'emergency',
		[1] = 'military'
	}

	for kv, sl in pairs(x) do
		if kv == typenr then
			return sl
		end
	end

end

RegisterServerEvent('garages:SetVehIn')
AddEventHandler('garages:SetVehIn', function(plate, current_used_garage, vehicleProps, livery, realFuel, type, model, vehId)
	local player = ESX.GetPlayerFromId(source).identifier
	
	local state = "In"
	local date = os.date('%Y-%m-%d %H:%M:%S')
	local type = returnType(type)


    MySQL.Async.execute("INSERT INTO owned_vehicles (`id`, `owner`, `plate`, `vehicle`, `type`, `job`, `stored`, `date`, `paidprice`, `finance`, `model`, `repaytime`, `garage`, `veh_id`) VALUES (@id, @owner, @plate, @vehicle, @type, null, 1, @date, @paidprice, @finance, @model, @repaytime, @garage, @veh_id)",
      	{
			['@id'] = default,
		  	['@owner'] = player,
		  	['@plate'] = plate,
		  	['@vehicle'] = json.encode(vehicleProps),
		  	['@type'] = type,
		  	['@date'] = date,
		  	['@paidprice'] = 0,
		  	['@finance'] = 0,
		  	['@model'] = model,
		  	['@repaytime'] = 0,
		  	['@garage'] = current_used_garage,
		  	['@veh_id'] = vehId,
	  	})

end)




RegisterServerEvent('garages:SetVehOut')
AddEventHandler('garages:SetVehOut', function(plate, vehiD)
	local player = ESX.GetPlayerFromId(source).identifier
    local garage = "OUT"

	--print(plate)
	--print(vehiD)
    MySQL.Async.execute("UPDATE owned_vehicles SET garage = @garage  WHERE owner = @username and veh_id = @veh_id and plate = @plate",
    	{
			['@username'] = player,
			['@garage'] = garage,
			['@veh_id'] = vehiD,
			['@plate'] = plate
		}
	)

	--MySQL.Async.execute("UPDATE owned_vehicles SET stored = @stored  WHERE owner = @username and veh_id = @veh_id and plate = @plate",
	--	{
	--		['@username'] = player,
	--		['@veh_id'] = vehiD,
	--		['@plate'] = plate,
	--		['@stored'] = 0
	--	}
	--)
end)




RegisterServerEvent('garages:SetVehInIn')
AddEventHandler('garages:SetVehInIn', function(plate, vehicleProps, garage)
	local player = ESX.GetPlayerFromId(source).identifier

    MySQL.Sync.execute("UPDATE owned_vehicles SET garage = @garage  WHERE owner = @username and plate = @plate",{['@username'] = player,['@garage'] = garage,['@plate'] = plate})
	MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate=@plate",{['@vehicle'] = json.encode(vehicleProps) , ['@plate'] = plate})
end)



ESX.RegisterServerCallback("garages:checkOwnerPlate", function(source, callback, plate)
	
	print(plate)
	
	local player = ESX.GetPlayerFromId(source).identifier
	if player then
		local sqlQuery = [[SELECT owner	FROM owned_vehicles WHERE plate = @plate]]

		MySQL.Async.fetchAll(sqlQuery, {
			["@plate"] = plate
		}, function(responses)
			if responses[1] then

				if responses[1].owner == player then
					callback(true)
				else
					callback(false)
				end
			else
				print('NO SUCH PLATE')
				callback(false)
			end
		end)
	else
		callback(false)
	end
end)
