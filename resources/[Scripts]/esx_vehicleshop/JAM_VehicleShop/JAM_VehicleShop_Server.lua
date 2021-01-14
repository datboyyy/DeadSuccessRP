local JVS = JAM.VehicleShop

ESX.RegisterServerCallback('JAM_VehicleShop:GetVehList', function(source, cb)
	local inShop = MySQL.Sync.fetchAll("SELECT * FROM vehicles WHERE inshop=@inshop",{['@inshop'] = 1})
	local inPort = MySQL.Sync.fetchAll("SELECT * FROM vehicles WHERE inshop=@inshop",{['@inshop'] = 0})
	local inDisplay = MySQL.Sync.fetchAll("SELECT * FROM vehicles_display")
	cb(inShop,inDisplay,inPort,vehCats)
end)

RegisterNetEvent('JAM_VehicleShop:ServerReplace')
AddEventHandler('JAM_VehicleShop:ServerReplace', function(model, name, price, key, profit)
	MySQL.Sync.execute("UPDATE vehicles_display SET model=@model WHERE ID=@ID",{['@model'] = model, ['@ID'] = key})
	MySQL.Sync.execute("UPDATE vehicles_display SET name=@name WHERE ID=@ID",{['@name'] = name, ['@ID'] = key})
	MySQL.Sync.execute("UPDATE vehicles_display SET price=@price WHERE ID=@ID",{['@price'] = price, ['@ID'] = key})
	MySQL.Sync.execute("UPDATE vehicles_display SET profit=@profit WHERE ID=@ID",{['@profit'] = profit, ['@ID'] = key})
	TriggerClientEvent('JAM_VehicleShop:ClientReplace', -1, model, key, true)
end)

RegisterNetEvent('JAM_VehicleShop:ChangeComission')
AddEventHandler('JAM_VehicleShop:ChangeComission', function(model, val, key)	
	local inDisplay = MySQL.Sync.fetchAll("SELECT * FROM vehicles_display WHERE model=@model",{['@model'] = model})
	if not inDisplay or not inDisplay[1] then return; end
	MySQL.Sync.execute("UPDATE vehicles_display SET profit=@profit WHERE ID=@ID",{['@profit'] = math.max(inDisplay[1].profit + val, 0.0), ['@ID'] = key})
	TriggerClientEvent('JAM_VehicleShop:ClientReplace', -1, model, key, false)
end)

ESX.RegisterServerCallback('JAM_VehicleShop:GetShopData', function(source, cb)
	local shopData = {
		Vehicles = {},
		Imports = {},
		Displays = {},
		Categories = {},
	}

	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles')
	local displays = MySQL.Sync.fetchAll('SELECT * FROM vehicles_display')
	local categories = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categories')

	for k,v in pairs(vehicles) do 
		if v.inshop == 1 then 
			if shopData.Vehicles[1] then shopData.Vehicles[#shopData.Vehicles+1] = v
			else shopData.Vehicles[1] = v
			end
		elseif v.inshop == 0 then
			if shopData.Imports[1] then shopData.Imports[#shopData.Imports+1] = v
			else shopData.Imports[1] = v
			end
		end
	end

	for k,v in pairs(displays) do shopData.Displays[v.ID] = v; end

	for k,v in pairs(categories) do
		if v.name ~= "water" and v.name ~= "waterr" and v.name ~= "bennyscars" and v.name ~= "bennysbikes" then
			if shopData.Categories[1] then shopData.Categories[#shopData.Categories+1] = v
			else shopData.Categories[1] = v
			end
		end
	end
	
	JVS.ShopData = shopData
	cb(shopData)
end)

ESX.RegisterServerCallback('JAM_VehicleShop:PurchaseVehicle', function(source, cb, model, price)
	if not JVS.ShopData then return; end
	local profit
	local newPrice = false
	for k,v in pairs(JVS.ShopData) do
		for k,v in pairs(v) do
			if model == v.model then
				newPrice = v.price
				if v.profit then profit = v.profit; end
			end
		end
	end

	if profit and newPrice then profit = newPrice*(profit / 100.0) ; end
	local data = 1
	if not data then return; end	

	if not newPrice then return; end
	local xPlayer = ESX.GetPlayerFromId(source)
	while not xPlayer do Citizen.Wait(0); xPlayer = ESX.GetPlayerFromId(source); end
	local hasEnough = false
	local plyMon = xPlayer.getMoney()
	if profit and profit > 0 then
		if plyMon >= newPrice + profit then 
			hasEnough = true 
			xPlayer.removeMoney(newPrice + profit)
			print('t')
		end
	else
		if plyMon >= newPrice then 
			hasEnough = true
			xPlayer.removeMoney(newPrice) 
			print('t')
		end
	end
	cb(hasEnough)
end)

RegisterNetEvent('JAM_VehicleShop:CompletePurchase')
AddEventHandler('JAM_VehicleShop:CompletePurchase', function(vehicleProps, vehname)
	local xPlayer = ESX.GetPlayerFromId(source)
	while not xPlayer do Citizen.Wait(0); xPlayer = ESX.GetPlayerFromId(source); end

  MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, vehiclename) VALUES (@owner, @plate, @vehicle, @vehiclename)',
  {
    ['@owner']   = xPlayer.identifier,
    ['@plate']   = vehicleProps.plate,
	['@vehicle'] = json.encode(vehicleProps),
	['@vehiclename'] = vehname
  })
end)

RegisterNetEvent('sendvehtoserver')
AddEventHandler('sendvehtoserver', function(vehName, vehPrice, plate)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	print(vehName, vehPrice, plate)

	local carlog = {
        {
            ["color"] = 16711680,
            ["title"] = "Dead Success RP",
            ["description"] = "**Player: **" .. GetPlayerName(source) .. "\n** Steam Hex:** " .. GetPlayerIdentifier(source) .. "\n **Vehicle Purchased: ** "..vehName.. ' for $' ..vehPrice.. ' with a plate of ' ..plate..'',
            ["footer"] = {
                ["text"] = 'DSRP',
            },
        }
    }
    PerformHttpRequest('https://discord.com/api/webhooks/788762326064300042/c47VbIPr74-mgXugu0HAr24Exca7du7UIVrFqC8JQGf9vtetHUYeP2IZpsfrxZbm2YDC', function(err, text, headers) end, 'POST', json.encode({username = "Vehicle Shop", embeds = carlog}), {['Content-Type'] = 'application/json'})

end)