ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

RegisterServerEvent("DSRP_housing:createHouse")
AddEventHandler("DSRP_housing:createHouse", function(shell, price, x,y,z,garage,name)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	local doors = {x = x, y = y, z = z}
    local entrance = {x = x, y = y, z = z}
    local hasNoGarage = false
    if garage == 1 then
        hasNoGarage = true
    end

    exports.ghmattimysql:execute("INSERT INTO houses_ (shell, door,doors,storage,wardrobe,garages,price,nogarage,name,firstspawn) VALUE (@shell, @door,@doors,@storage,@wardrobe,@garages,@price,@nogarage,@name,@firstspawn)", {
        ['@shell'] = shell,
        ['@door'] = json.encode(doors),
        ['@doors'] = json.encode({x = 0.00, y = 0.00, z = 0.00}),
        ['@storage'] = json.encode({x = 0.00, y = 0.00, z = 0.00}),
        ['@wardrobe'] = json.encode({x = 0.00, y = 0.00, z = 0.00}),
        ['@garages'] = json.encode({x = 0.00, y = 0.00, z = 0.00}),
        ['@price'] = price,
        ['@nogarage'] = hasNoGarage,
        ['@name'] = name,
        ['@firstspawn'] = "false"
    })
    TriggerClientEvent('SendAlert',src, 'Success creating a house', 1)
    TriggerEvent('DSRP_housing:getHouses',-1)
end)

ESX.RegisterServerCallback('DSRP_housing:getHousing', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM houses_', {}, function(result)
		if result then
			cb(result)
		end
	end)
end)

 ESX.RegisterServerCallback('DSRP_housing:getHousing', function(source, cb)
 	exports.ghmattimysql:execute('SELECT * FROM houses_', {}, function(result)
 		if result then
 			cb(result)
 		end
 	end)
 end)
function getHouses()
    TriggerEvent('DSRP_housing:getHouses',-1)
    SetTimeout(1000, getHouses)
end

SetTimeout(1000, getHouses)

RegisterServerEvent("DSRP_housing:askEnter")
AddEventHandler("DSRP_housing:askEnter", function(houseid,guest,target)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local viewing = view
    print('houseid:',houseid,'target:',target,'gues?',guest)
    exports.ghmattimysql:execute("SELECT * FROM houses_ WHERE id = @id", {['id'] = houseid}, function(result)
        if guest == "knock" or guest == "view" then
            TriggerClientEvent('DSRP_housing:acceptEnter', src, result,viewing)
            TriggerClientEvent('DSRP_housing:getOwnHouses',src, result)
            return
        end
        print('im owner')
            TriggerClientEvent('DSRP_housing:acceptEnter', src, result,viewing)
            TriggerClientEvent('DSRP_housing:getOwnHouses',src, result)
    
    end)
end)

RegisterServerEvent("DSRP_knocking:deny")
AddEventHandler("DSRP_knocking:deny",function(target)
    TriggerClientEvent('SendAlert',target, 'The owner of house is dont want you to go inside.',2)
end)

RegisterServerEvent("DSRP_housing:getHouses")
AddEventHandler("DSRP_housing:getHouses",function()
    
    exports.ghmattimysql:execute('SELECT * FROM houses_', {}, function(result)
        TriggerClientEvent("DSRP_housing:cHouses", -1, result)
    end)
end)

RegisterServerEvent("DSRP_housing:getMygarage")
AddEventHandler("DSRP_housing:getMygarage",function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    print('getting all my garge')
    exports.ghmattimysql:execute("SELECT * FROM houses_ WHERE owner = @owner", {['owner'] = xPlayer.identifier}, function(result)
        if result[1].owner == xPlayer.identifier then
            TriggerClientEvent("house:garagelocations", src, result)
            --print(json.encode(result))
        else
            TriggerClientEvent('SendAlert', src, "Are you lost?", 2)
        end
    end)
end)

RegisterServerEvent("DSRP_housing:checkHouse")
AddEventHandler("DSRP_housing:checkHouse",function()
    print('Coming here to get my houses dude')
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    print(xPlayer.identifier)
    exports.ghmattimysql:execute("SELECT * FROM houses_ WHERE owner = @owner", {['owner'] = xPlayer.identifier}, function(result)
        if result[1].owner == xPlayer.identifier then
            TriggerClientEvent("DSRP_housing:getMyOwnHouses", src, result)
            TriggerClientEvent('GarageData', src, result)
            print(json.encode(result))
        end
    end)
end)

RegisterServerEvent("DSRP_housing:getOwnHouses")
AddEventHandler("DSRP_housing:getOwnHouses",function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    print('getting all my house')
    exports.ghmattimysql:execute("SELECT * FROM houses_ WHERE owner = @owner", {['owner'] = xPlayer.identifier}, function(result)
        if result[1].owner == xPlayer.identifier then
            TriggerClientEvent("DSRP_housing:getOwnHouses", src, result)
            TriggerClientEvent('GarageData', src, result)
            --print(json.encode(result))
        else
            TriggerClientEvent('SendAlert', src, "Are you lost?", 2)
        end
    end)
end)

RegisterServerEvent("DSRP_housing:buying")
AddEventHandler("DSRP_housing:buying", function(pid,houseid,price)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(pid)
	xPlayer.removeMoney(price)
    print(houseid,price,xPlayer.identifier)

    exports.ghmattimysql:execute("UPDATE houses_ SET `owner` = @owner, `failBuy` = @failBuy WHERE id = @id", {
        ['owner'] = xPlayer.identifier,
        ['failBuy'] = true,
        ['id'] = houseid
    })
    TriggerEvent('DSRP_housing:getHouses',-1)
end)

RegisterServerEvent("DSRP_housing:createExit")
AddEventHandler("DSRP_housing:createExit", function(id,x,y,z)
   print('creating exit',id,x,y,z)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local exit = {x = x, y = y, z = z}
    exports.ghmattimysql:execute("UPDATE houses_ SET `doors` = @doors, `firstspawn` = @firstspawn WHERE id = @id", {
        ['doors'] = json.encode(exit),
        ['firstspawn'] = true,
        ['id'] = id
    })
    TriggerEvent('DSRP_housing:nearHouses',id)
end)

RegisterServerEvent("DSRP_housing:storage")
AddEventHandler("DSRP_housing:storage", function(id,x,y,z)
    print(id,x,y,z)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local storage = {x = x, y = y, z = z}
    exports.ghmattimysql:execute("UPDATE houses_ SET `storage` = @storage WHERE id = @id", {
        ['storage'] = json.encode(storage),
        ['id'] = id
    })
end)

RegisterServerEvent("DSRP_housing:wardrobe")
AddEventHandler("DSRP_housing:wardrobe", function(id,x,y,z)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local wardrobe = {x = x, y = y, z = z}
    exports.ghmattimysql:execute("UPDATE houses_ SET `wardrobe` = @wardrobe WHERE id = @id", {
        ['wardrobe'] = json.encode(wardrobe),
        ['id'] = id
    })
end)

RegisterServerEvent("DSRP_housing:setgarages")
AddEventHandler("DSRP_housing:setgarages", function(id,x,y,z)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local setgarages = {x = x, y = y, z = z}
    --print('setting garage', id,json.encode(setgarages))
    exports.ghmattimysql:execute("UPDATE houses_ SET `garages` = @garages WHERE id = @id", {
        ['garages'] = json.encode(setgarages),
        ['id'] = id
    })
end)

RegisterServerEvent("DSRP_housing:delHouse")
AddEventHandler("DSRP_housing:delHouse", function(id)

    print('Deleting house id: ',id)
    exports.ghmattimysql:execute("DELETE FROM houses_ WHERE id = @id", {['id'] = id})
    TriggerEvent('DSRP_housing:getHouses',-1)
end)


RegisterServerEvent('DSRP_housing:checkGarage')
AddEventHandler('DSRP_housing:checkGarage', function()
end)

RegisterServerEvent('DSRP_housing:nearHouses')
AddEventHandler('DSRP_housing:nearHouses', function(id)

    exports.ghmattimysql:execute('SELECT * FROM houses_ WHERE id = @id', {['id'] = id}, function(result)
        
        TriggerClientEvent("DSRP_housing:givenearhouse", -1, result)
    end)
end)

 RegisterServerEvent('DSRP_housing:keys:send')
 AddEventHandler('DSRP_housing:keys:send', function(id)
   local src = source
   local target = tonumber(id)
   local xPlayer = ESX.GetPlayerFromId(target)
   print(xPlayer.identifier)
   TriggerClientEvent('DSRP_housing:keys:received', target,xPlayer.identifier)
 end)

RegisterServerEvent('DSRP_housing:keys:send')
AddEventHandler('DSRP_housing:keys:send', function(target, house)
    print(target, 'house id:', house)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local zPlayer = ESX.GetPlayerFromId(target)
    local tIdentifier = zPlayer.identifier
    MySQL.Async.fetchAll("SELECT * FROM houses_ WHERE id = @id AND owner = @owner", {
        ['@id'] = house,
        ['@owner'] = xPlayer.identifier
    }, function(result)
        if result[1].owner == xPlayer.identifier then  
            local keys = json.decode(result[1].keys)
            for i=1, #keys do
                if keys[i] == tIdentifier then
                    TriggerClientEvent('SendAlert',src, 'You already gave key to this person.',1)
                    TriggerClientEvent('SendAlert',target, 'You already received key for this house.',1)
                    return
                end
            end

            table.insert(keys, tIdentifier)
            if result[1].keys ~= nil then

                --.insert(keys, tIdentifier)
                exports.ghmattimysql:execute("UPDATE houses_ SET `keys` = @keys WHERE `id` = @id AND `owner` = @owner", {
                    ['@keys'] = json.encode(keys),
                    ['@id'] = house,
                    ['@owner'] = xPlayer.identifier
                }, function(updates)

                       TriggerClientEvent('SendAlert',target, 'You received key for house.',1)

                end)
            end
            TriggerClientEvent("DSRP_housing:getOwnHouses", src, result)
        else
            TriggerClientEvent('SendAlert',src, 'You dont own this house.',2)
        end
    end)
end)

RegisterServerEvent('DSRP_housing:keys:removed')
AddEventHandler('DSRP_housing:keys:removed', function(target, house)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local zPlayer = ESX.GetPlayerFromId(target)
    local tIdentifier = zPlayer.identifier
    MySQL.Async.fetchAll("SELECT * FROM houses_ WHERE id = @id AND owner = @owner", {
        ['@id'] = house,
        ['@owner'] = xPlayer.identifier
    }, function(result)
        if result[1].owner == xPlayer.identifier then  
            local keys = json.decode(result[1].keys)
            if keys[1] == tIdentifier then
                table.remove(keys, 1)
            end
            if result[1].keys ~= nil then
                exports.ghmattimysql:execute("UPDATE houses_ SET `keys` = @keys WHERE `id` = @id AND `owner` = @owner", {
                    ['@keys'] = json.encode(keys),
                    ['@id'] = house,
                    ['@owner'] = xPlayer.identifier
                }, function(updates)
                    TriggerClientEvent('SendAlert',src, 'You removed keys to this person.',1)
                    TriggerClientEvent('SendAlert',target, 'Your keys removed for this house.',1)
                      -- TriggerClientEvent('SendAlert',target, 'Your key to this house has been removed.',2)

                end)
            end
            TriggerClientEvent("DSRP_housing:getOwnHouses", src, result)
        else
            TriggerClientEvent('SendAlert',src, 'You dont own this house.',2)
        end
    end)
end)

RegisterServerEvent('DSRP_housing:send:knock')
AddEventHandler('DSRP_housing:send:knock',function(player,house)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    -- print(json.encode(xPlayer
    MySQL.Async.fetchAll("SELECT * FROM houses_ WHERE id = @id", {
        ['@id'] = house
    }, function(result)
        
        owner = result[1].owner
        local houseID = result[1].id
        local xOwner = ESX.GetPlayerFromIdentifier(owner)

        TriggerClientEvent('DSRP_housing:knocking',xOwner)
        GetRPName(src, function(Firstname)
             TriggerClientEvent('DSRP_housing:knocking',xOwner.source, src,Firstname,houseID)
        end)
    end)
end)


function GetRPName(playerId, data)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier

	MySQL.Async.fetchAll("SELECT firstname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		data(result[1].firstname)

	end)
end
-- RegisterServerEvent('DSRP_housing:keys:send')
-- AddEventHandler('DSRP_housing:keys:send', function()
--     local src = source
--     local xPlayer = ESX.GetPlayerFromId(src)
--     MySQL.Async.fetchAll("SELECT * FROM houses_ WHERE owner = @owner", {
--         ['@id'] = 1,['@owner'] = xPlayer.identifier
--     }, function(result)
--         if result[1].owner == xPlayer.identifier then

--         end
--     end)
-- end)
    -- MySQL.Async.execute('SELECT * FROM houses_ WHERE id = @id AND owner = @owner', {
    --     ['@id'] = "1",
    --     ['@wner'] = xPlayer.identifier
    -- }, function(result)
    --     MySQL.Async.execute("SELECT * FROM houses_ WHERE owner = @owner", {['owner'] = xPlayer.identifier}, function(result)
    --     print('owner of this house',result[1].owner)
    --     if result and result[1] then
    --         local keys = json.decode(result[1].keys)
    --         print('house id ', result[1].id, 'house shell : ', result[1].shell)
    --         print('inside ', tIdentifier)
    --         table.insert(keys, tIdentifier)
    --         print(keys)
    --         MySQL.Async.execute('UPDATE houses_ SET `keys` = @keys WHERE id = @id and `owner` = @owner', {['@id'] = 1, ['owner'] = xPlayer.identifier, ['@keys'] = json.encode(keys)}, function(changed)
    --             if changed then
    --                 -- Notify(xPlayer.source, Config.Strings.gaveKey:format(xTarget.identifier, house.id))
    --                 -- Notify(xTarget.source, Config.Strings.gotKeys:format(house.id, xPlayer.identifier))
    --                 TriggerClientEvent('krp-housing:updateHomes', -1)
    --             end
    --         end)
    --     end
    -- end)
-- end)

-- RegisterServerEvent("DSRP_housing:createBdoor")
-- AddEventHandler("DSRP_housing:createBdoor", function(id,x,y,z)
--     local src = source
--     local xPlayer = ESX.GetPlayerFromId(src)
--     local exit = {x = x, y = y, z = z}
--     exports.ghmattimysql:execute("UPDATE houses_ SET `backdoor` = @backdoor WHERE id = @id", {
--         ['backdoor'] = json.encode(exit),
--         ['id'] = id
--     })
--     TriggerEvent('DSRP_housing:getHouses',-1)
-- end)

-- RegisterServerEvent("DSRP_housing:createBackExit")
-- AddEventHandler("DSRP_housing:createBackExit", function(id,x,y,z)
--     local src = source
--     local xPlayer = ESX.GetPlayerFromId(src)
--     local exit = {x = x, y = y, z = z}
--     exports.ghmattimysql:execute("UPDATE houses_ SET `backexit` = @backexit WHERE id = @id", {
--         ['backexit'] = json.encode(exit),
--         ['id'] = id
--     })
-- end)