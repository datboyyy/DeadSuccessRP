ESX = nil
TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

function GetCharacterName(source)
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	return ('%s %s'):format(result[1].firstname, result[1].lastname) or GetPlayerName(source)
end



function GetCharacterNameFromIdentifier(identifier)
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	})

	return ('%s %s'):format(result[1].firstname, result[1].lastname)
end

Citizen.CreateThread(function()
	local HouseGarages = {}
	exports['ghmattimysql']:execute("SELECT * FROM `houselocations`", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				local owned = false
				if tonumber(v.owned) == 1 then
					owned = true
				end
				local garage = v.garage ~= nil and json.decode(v.garage) or {}
				Config.Houses[v.name] = {
					id = id,
					coords = json.decode(v.coords),
					owned = v.owned,
					price = v.price,
					locked = true,
					adress = v.label,
					tier = v.tier,
					garage = garage,
					decorations = {},
				}
				HouseGarages[v.name] = {
					label = v.label,
					takeVehicle = garage,
				}
			end
		end
		TriggerClientEvent("cash-garagesystem:client:houseGarageConfig", -1, HouseGarages)
		TriggerClientEvent("qb-houses:client:setHouseConfig", -1, Config.Houses)
	end)
end)

local houseowneridentifier = {}
local houseownercid = {}
local housekeyholders = {}

RegisterServerEvent('qb-houses:server:setHouses')
AddEventHandler('qb-houses:server:setHouses', function()
	local src = source
	TriggerClientEvent("qb-houses:client:setHouseConfig", src, Config.Houses)
end)

RegisterServerEvent('qb-houses:server:addNewHouse')
AddEventHandler('qb-houses:server:addNewHouse', function(street, coords, price, tier)
	local src = source
	local street = street:gsub("%'", "")
	local price = tonumber(price)
	local tier = tonumber(tier)
	local houseCount = GetHouseStreetCount(street)
	local name = street:lower() .. tostring(houseCount)
	local label = street .. " | " .. tostring(houseCount)
	exports['ghmattimysql']:execute("INSERT INTO `houselocations` (`name`, `label`, `coords`, `owned`, `price`, `tier`) VALUES ('"..name.."', '"..label.."', '"..json.encode(coords).."', 0,"..price..", "..tier..")")
	Config.Houses[name] = {
		coords = coords,
		owned = false,
		price = price,
		locked = true,
		adress = label, 
		tier = tier,
		garage = {},
		decorations = {},
	}
	TriggerClientEvent("qb-houses:client:setHouseConfig", -1, Config.Houses)
	TriggerClientEvent('notification', src, "You have added a house: "..label)
end)

RegisterServerEvent('qb-houses:server:addGarage')
AddEventHandler('qb-houses:server:addGarage', function(house, coords)
	local src = source
	exports['ghmattimysql']:execute("UPDATE `houselocations` SET `garage` = '"..json.encode(coords).."' WHERE `name` = '"..house.."'")
	local garageInfo = {
		label = Config.Houses[house].adress,
		takeVehicle = coords,
	}
	TriggerClientEvent("cash-garagesystem:client:addHouseGarage", -1, house, garageInfo)
	TriggerClientEvent('notification', src, "You have added a garage at: "..garageInfo.label)
end)

RegisterServerEvent('qb-houses:server:viewHouse')
AddEventHandler('qb-houses:server:viewHouse', function(house)
	local src     		= source
	local pData 		= ESX.GetPlayerFromId(src)

	local houseprice   	= Config.Houses[house].price
	local brokerfee 	= (houseprice / 100 * 5)
	local bankfee 		= (houseprice / 100 * 10) 
	local taxes 		= (houseprice / 100 * 6)

	TriggerClientEvent('qb-houses:client:viewHouse', src, houseprice, brokerfee, bankfee, taxes, GetCharacterName(source))
end)

RegisterServerEvent('qb-houses:server:buyHouse')
AddEventHandler('qb-houses:server:buyHouse', function(house)
	local src     	= source
	local steam = GetPlayerIdentifiers(src)[1]
	local license = GetPlayerIdentifiers(src)[2]
	local pData 	= ESX.GetPlayerFromId(src)
	local price   	= Config.Houses[house].price
	local HousePrice = math.ceil(price * 1.21)
	local bankBalance = pData.getMoney()

	if (bankBalance >= HousePrice) then
		exports['ghmattimysql']:execute("INSERT INTO `player_houses` (`house`, `identifier`, `citizenid`, `keyholders`) VALUES ('"..house.."', '"..license.."', '"..steam.."', '"..json.encode(keyyeet).."')")
		houseowneridentifier[house] = license
		houseownercid[house] = steam
		housekeyholders[house] = {
			[1] = steam
		}
		exports['ghmattimysql']:execute("UPDATE `houselocations` SET `owned` = 1 WHERE `name` = '"..house.."'")
		TriggerClientEvent('qb-houses:client:SetClosestHouse', src)
		pData.removeMoney(HousePrice) -- 21% Extra house costs
	else
		TriggerClientEvent('notification', source, "You do not have enough money..")
	end
end)

RegisterServerEvent('qb-houses:server:lockHouse')
AddEventHandler('qb-houses:server:lockHouse', function(bool, house)
	TriggerClientEvent('qb-houses:client:lockHouse', -1, bool, house)
end)

RegisterServerEvent('qb-houses:server:SetRamState')
AddEventHandler('qb-houses:server:SetRamState', function(bool, house)
	Config.Houses[house].IsRaming = bool
	TriggerClientEvent('qb-houses:server:SetRamState', -1, bool, house)
end)

--------------------------------------------------------------

--------------------------------------------------------------

ESX.RegisterServerCallback('qb-houses:server:hasKey', function(source, cb, house)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local license = GetPlayerIdentifiers(src)[2]
	local steam = GetPlayerIdentifiers(src)[1]
	local retval = false
	if Player ~= nil then 
		local identifier = license
		local CharId = steam
		if hasKey(identifier, CharId, house) then
			retval = true
		elseif Player["job"]["name"] == "realestateagent" then
			retval = true
		else
			retval = false
		end
	end
	
	cb(retval)
end)

ESX.RegisterServerCallback('qb-houses:server:isOwned', function(source, cb, house)
	if houseowneridentifier[house] ~= nil and houseownercid[house] ~= nil then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('qb-houses:server:getHouseOwner', function(source, cb, house)
	cb(houseownercid[house])
end)

ESX.RegisterServerCallback('qb-houses:server:getHouseKeyHolders', function(source, cb, house)
	local retval = {}
	local Player = ESX.GetPlayerFromId(source)
	local license = GetPlayerIdentifiers(source)[1]
	if housekeyholders[house] ~= nil then 
		for i = 1, #housekeyholders[house], 1 do
			if license ~= housekeyholders[house][i] then
				exports['ghmattimysql']:execute("SELECT * FROM `users` WHERE `identifier` = '"..housekeyholders[house][i].."'", function(result)
					print(json.encode(result))
					if result[1] ~= nil then
						table.insert(retval, {
							firstname = result[1].firstname..' '..result[1].lastname,
							--lastname = charinfo.lastname,
							citizenid = housekeyholders[house][i],
						})
					end
					cb(retval)
				end)
			end
		end
	else
		cb(nil)
	end
end)

function hasKey(identifier, cid, house)
	if houseowneridentifier[house] ~= nil and houseownercid[house] ~= nil then
		if houseowneridentifier[house] == identifier and houseownercid[house] == cid then
			return true
		else
			if housekeyholders[house] ~= nil then 
				for i = 1, #housekeyholders[house], 1 do
					if housekeyholders[house][i] == cid then
						return true
					end
				end
			end
		end
	end
	return false
end

function getOfflinePlayerData(source)
	local citizenid = GetPlayerIdentifiers(source)[1]
	exports['ghmattimysql']:execute("SELECT *  FROM `users` WHERE `identifier` = '"..citizenid.."'", function(result)
		Citizen.Wait(100)
		if result[1] ~= nil then 
			local charinfo = result[1].firstname..' '..result[1].lastname
			return charinfo
		else
			return nil
		end
	end)
end

RegisterServerEvent('qb-houses:server:giveKey')
AddEventHandler('qb-houses:server:giveKey', function(house, target)
	local pData = ESX.GetPlayerFromId(target)
	local citizenid = GetPlayerIdentifiers(target)[1]
	table.insert(housekeyholders[house], citizenid)
	exports['ghmattimysql']:execute("UPDATE `player_houses` SET `keyholders` = '"..json.encode(housekeyholders[house]).."' WHERE `house` = '"..house.."'")
end)

RegisterServerEvent('qb-houses:server:removeHouseKey')
AddEventHandler('qb-houses:server:removeHouseKey', function(house, citizenData)
	local src = source
	local newHolders = {}
	if housekeyholders[house] ~= nil then 
		for k, v in pairs(housekeyholders[house]) do
			if housekeyholders[house][k] ~= citizenData.citizenid then
				table.insert(newHolders, housekeyholders[house][k])
			end
		end
	end
	housekeyholders[house] = newHolders
	print('removed key from', json.encode(newHolders))
	TriggerClientEvent('Notification', src,  'You have removed players house key!', 2)
	exports['ghmattimysql']:execute("UPDATE `player_houses` SET `keyholders` = '"..json.encode(housekeyholders[house]).."' WHERE `house` = '"..house.."'")
end)

function typeof(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end

local housesLoaded = false

Citizen.CreateThread(function()
	while true do
		if not housesLoaded then
			exports['ghmattimysql']:execute('SELECT * FROM player_houses', function(houses)
				if houses ~= nil then
					for _,house in pairs(houses) do
						houseowneridentifier[house.house] = house.identifier
						houseownercid[house.house] = house.citizenid
						housekeyholders[house.house] = json.decode(house.keyholders)
					end
				end
			end)
			housesLoaded = true
		end
		Citizen.Wait(7)
	end
end)

RegisterServerEvent('qb-houses:server:OpenDoor')
AddEventHandler('qb-houses:server:OpenDoor', function(target, house)
    local src = source
    local OtherPlayer = ESX.GetPlayerFromId(target)
    if OtherPlayer ~= nil then
        TriggerClientEvent('qb-houses:client:SpawnInApartment', OtherPlayer.source, house)
    end
end)

RegisterServerEvent('qb-houses:server:RingDoor')
AddEventHandler('qb-houses:server:RingDoor', function(house)
    local src = source
    TriggerClientEvent('qb-houses:client:RingDoor', -1, src, house)
end)

RegisterServerEvent('qb-houses:server:RingDoor2')
AddEventHandler('qb-houses:server:RingDoor2', function(house)
    local src = source
    TriggerClientEvent('qb-houses:client:RingDoor2', -1, src, house)
end)

RegisterServerEvent('qb-houses:server:savedecorations')
AddEventHandler('qb-houses:server:savedecorations', function(house, decorations)
	local src = source
	exports['ghmattimysql']:execute("UPDATE `player_houses` SET `decorations` = '"..json.encode(decorations).."' WHERE `house` = '"..house.."'")
	TriggerClientEvent("qb-houses:server:sethousedecorations", -1, house, decorations)
end)

ESX.RegisterServerCallback('qb-houses:server:getHouseDecorations', function(source, cb, house)
	local retval = nil
	exports['ghmattimysql']:execute("SELECT * FROM `player_houses` WHERE `house` = '"..house.."'", function(result)
		if result[1] ~= nil then
			if result[1].decorations ~= nil then
				retval = json.decode(result[1].decorations)
			end
		end
		cb(retval)
	end)
end)

ESX.RegisterServerCallback('qb-houses:server:getHouseLocations', function(source, cb, house)
	local retval = nil
	exports['ghmattimysql']:execute("SELECT * FROM `player_houses` WHERE `house` = '"..house.."'", function(result)
		if result[1] ~= nil then
			retval = result[1]
		end
		cb(retval)
	end)
end)

ESX.RegisterServerCallback('qb-houses:server:getHouseKeys', function(source, cb)
	local src = source
	local pData = GetPlayerIdentifiers(src)[1]
	local cid = pData
end)

function mysplit (inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end

ESX.RegisterServerCallback('qb-houses:server:getOwnedHouses', function(source, cb)
	local src = source
	local pData = {identifier = GetPlayerIdentifiers(src)[1], license = GetPlayerIdentifiers(src)[1]}

	if pData then
		exports['ghmattimysql']:execute('SELECT * FROM player_houses WHERE identifier = @identifier AND citizenid = @citizenid', {['@identifier'] = pData.license, ['@citizenid'] = pData.identifier}, function(houses)
			local ownedHouses = {}

			for i=1, #houses, 1 do
				table.insert(ownedHouses, houses[i].house)
			end

			if houses ~= nil then
				cb(ownedHouses)
			else
				cb(nil)
			end
		end)
	end
end)

ESX.RegisterServerCallback('qb-houses:server:getSavedOutfits', function(source, cb)
	local src = source
	local pData = GetPlayerIdentifiers(src)[1]

	if pData then
		exports['ghmattimysql']:execute('SELECT * FROM player_outfits WHERE citizenid = @citizenid', {['@citizenid'] = pData}, function(result)
			if result[1] ~= nil then
				cb(result)
			else
				cb(nil)
			end
		end)
	end
end)

RegisterCommand("decorate", function(source, args)
	TriggerClientEvent("qb-houses:client:decorate", source)
end)

function GetHouseStreetCount(street)
    local found = nil
    local count = 1
    exports['ghmattimysql']:execute("SELECT * FROM `houselocations` WHERE `name` LIKE '%"..street.."%'", function(result)
        if result[1] ~= nil then 
            for i = 1, #result, 1 do
                count = count + 1
            end
        end
        found = true
    end)
    while found == nil do
        Wait(0)
    end
    return count
end

--[[RegisterServerEvent('qb-houses:server:LogoutLocation')
AddEventHandler('qb-houses:server:LogoutLocation', function()
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local data = {identifier = GetPlayerIdentifiers(src)[1], license = GetPlayerIdentifiers(src)[1]}
	local MyItems = Player.PlayerData.items
	exports['ghmattimysql']:execute("UPDATE `players` SET `inventory` = '"..CashoutCore.EscapeSqli(json.encode(MyItems)).."' WHERE `citizenid` = '"..data.identifier.."'")
	CashoutCore.Player.Logout(src)
    TriggerClientEvent('cash-multiplecharacters:client:chooseChar', src)
end)]]--

RegisterServerEvent('qb-houses:server:giveHouseKey')
AddEventHandler('qb-houses:server:giveHouseKey', function(target, house)
	local xPlayer = ESX.GetPlayerFromId(target)
	local ident = GetPlayerIdentifier(target)
	local tPlayer = ESX.GetPlayerFromId(target)
	local data = {identifier = GetPlayerIdentifier(target)}
	local src = source
	if tPlayer ~= nil then
		if housekeyholders[house] ~= nil then
			for _, cid in pairs(housekeyholders[house]) do
				if cid == ident then
					TriggerClientEvent('notification', src, 'This person already has the keys to this house!')
					return
				end
			end		
			table.insert(housekeyholders[house], ident)
			exports['ghmattimysql']:execute("UPDATE `player_houses` SET `keyholders` = '"..json.encode(housekeyholders[house]).."' WHERE `house` = '"..house.."'")
			TriggerClientEvent('qb-houses:client:refreshHouse', src)
			TriggerClientEvent('notification', source ,'You have given the keys to '..Config.Houses[house].adress..' !', 1)
			TriggerClientEvent('notification', target ,'You have received the keys to '..Config.Houses[house].adress..' !', 1)
		else
			--local sourceTarget = ESX.GetPlayerFromId(src)
			housekeyholders[house] = {
				[1] =  ident
			}
			table.insert(housekeyholders[house],  ident)
			exports['ghmattimysql']:execute("UPDATE `player_houses` SET `keyholders` = '"..json.encode(housekeyholders[house]).."' WHERE `house` = '"..house.."'")
			TriggerClientEvent('qb-houses:client:refreshHouse', src)
			TriggerClientEvent('notification', src, 'You have the keys to '..Config.Houses[house].adress..' !', 1)
		end
	else
		TriggerClientEvent('notification', src, 'Something went wrong .. Please try again!')
	end
end)

RegisterServerEvent('test:test')
AddEventHandler('test:test', function(msg)
	print(msg)
end)

RegisterServerEvent('qb-houses:server:setLocation')
AddEventHandler('qb-houses:server:setLocation', function(coords, house, type)
	local src = source
	local Player = ESX.GetPlayerFromId(src)

	if type == 1 then
		exports['ghmattimysql']:execute("UPDATE `player_houses` SET `stash` = '"..json.encode(coords).."' WHERE `house` = '"..house.."'")
	elseif type == 2 then
		exports['ghmattimysql']:execute("UPDATE `player_houses` SET `outfit` = '"..json.encode(coords).."' WHERE `house` = '"..house.."'")
	elseif type == 3 then
		exports['ghmattimysql']:execute("UPDATE `player_houses` SET `logout` = '"..json.encode(coords).."' WHERE `house` = '"..house.."'")
	end

	TriggerClientEvent('qb-houses:client:refreshLocations', -1, house, json.encode(coords), type)
end)

RegisterCommand("createhouse", function(source, args)
    local Player = ESX.GetPlayerFromId(source)
    local price = tonumber(args[1])
    local tier = tonumber(args[2])
    local authtiers = {1, 2, 3, 4, 5, 6, 7}
    local found = false

    if Player["job"]["name"] == "realestateagent" then
        for k, v in pairs(authtiers) do 
            if v == tier then 
                TriggerClientEvent("qb-houses:client:createHouses", source, price, tier)
                found = true
                break
            end
        end
        if not found then
			TriggerClientEvent('notification', source, 'House Tier not found!', 2)
			TriggerClientEvent('notification', source, '1 - Regular House | 2 - Trevors Cousin | 3 - Michael | 4 - Apartment | 5 - Trailer | 6 - Franklins Crib | 7 - Franklins Moms !', 1)
        end

    else
        TriggerClientEvent('notification', source, 'Your Not A realestateagent.', 2)
    end
end)


--[[RegisterServerEvent('qb-houses:server:SetInsideMeta')
AddEventHandler('qb-houses:server:SetInsideMeta', function(insideId, bool)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local insideMeta = Player["inside"]

    if bool then
        apartmentType = nil
        apartmentId = nil
        house = insideId

        Player("inside", insideMeta)
    else
        insideMeta.apartment.apartmentType = nil
        insideMeta.apartment.apartmentId = nil
        insideMeta.house = nil

        Player("inside", insideMeta)
    end
end)]]--

ESX.RegisterServerCallback('cash-telephone:server:GetPlayerHouses', function(source, cb)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local info = {identifier = GetPlayerIdentifiers(src)[1], license = GetPlayerIdentifiers(src)[1]}
	local MyHouses = {}
	local keyholders = {}

	exports['ghmattimysql']:execute("SELECT * FROM `player_houses` WHERE `citizenid` = '"..info.identifier.."'", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				v.keyholders = json.decode(v.keyholders)
				for z, u in pairs(result) do
					v.keyholdersnames = GetCharacterNameFromIdentifier(v.keyholders)
				if v.keyholders ~= nil and next(v.keyholders) then
					for f, data in pairs(v.keyholders) do
						exports['ghmattimysql']:execute("SELECT * FROM `users` WHERE `identifier` = '"..data.."'", function(keyholderdata)
							if keyholderdata[1] ~= nil then
								keyholders[f] = keyholderdata[1]
							end
						end)
					end
				else
					keyholders[1] = Player.PlayerData
				end

				table.insert(MyHouses, {
					name = v.house,
					keyholders = v.keyholders,
					keyholdersnames = json.encode(v.keyholdersnames),
					owner = v.citizenid,
					price = Config.Houses[v.house].price,
					label = Config.Houses[v.house].adress,
					tier = Config.Houses[v.house].tier,
					garage = Config.Houses[v.house].garage,
				})
			end
		end
			cb(MyHouses)
		end
	end)
end)

function escape_sqli(source)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return source:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end

ESX.RegisterServerCallback('cash-telephone:server:MeosGetPlayerHouses', function(source, cb, input)
	local src = source
	if input ~= nil then
		local search = escape_sqli(input)
		local searchData = {}

		exports['ghmattimysql']:execute('SELECT * FROM `players` WHERE `citizenid` = "'..search..'" OR `charinfo` LIKE "%'..search..'%"', function(result)
			if result[1] ~= nil then
				exports['ghmattimysql']:execute("SELECT * FROM `player_houses` WHERE `citizenid` = '"..result[1].citizenid.."'", function(houses)
					if houses[1] ~= nil then
						for k, v in pairs(houses) do
							table.insert(searchData, {
								name = v.house,
								keyholders = keyholders,
								owner = v.citizenid,
								price = Config.Houses[v.house].price,
								label = Config.Houses[v.house].adress,
								tier = Config.Houses[v.house].tier,
								garage = Config.Houses[v.house].garage,
								charinfo = json.decode(result[1].charinfo),
								coords = {
									x = Config.Houses[v.house].coords.enter.x,
									y = Config.Houses[v.house].coords.enter.y,
									z = Config.Houses[v.house].coords.enter.z,
								}
							})
						end

						cb(searchData)
					end
				end)
			else
				cb(nil)
			end
		end)
	else
		cb(nil)
	end
end)

RegisterCommand('raidhouse', function(source)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "police" then
		TriggerClientEvent("qb-houses:client:HomeInvasion", source)
	else
		TriggerClientEvent('notification', source, "This is only possible for emergency services!", 2)
	end
end)

RegisterServerEvent('qb-houses:server:SetHouseRammed')
AddEventHandler('qb-houses:server:SetHouseRammed', function(bool, house)
	Config.Houses[house].IsRammed = bool
	TriggerClientEvent('qb-houses:client:SetHouseRammed', -1, bool, house)
end)

RegisterCommand("enter", function(source, args)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
 
    TriggerClientEvent('qb-houses:client:EnterHouse', src)
end)



RegisterCommand("ring", function(source, args)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
 
    TriggerClientEvent('qb-houses:client:RequestRing', src)
end)