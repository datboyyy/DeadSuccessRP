ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

RegisterServerEvent('police:Weaponlicense')
AddEventHandler('police:Weaponlicense', function(player)
  local _src = source
  local xPlayer = ESX.GetPlayerFromId(player)
  local license = nil
  local drive = nil
  local weapon = nil
  MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
    ['@owner'] = xPlayer.identifier
  }, function (result)
	if result ~= nil then
		license = 'none'
	end
	if result[1].type == 'driver'then
		drive =  'Drive: Yes'
	else
		drive =  'Drive: No'
	end
	if result[1].type == 'weapon'then
		weapon =  'Weapon: Yes'
	else
		weapon =  'Weapon: No'
	end
	license = drive..' | '..weapon
		TriggerClientEvent('updateLicenseString', _src, license)
	end)
end)

function GetRPName(playerId, data)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		data(result[1].firstname, result[1].lastname)

	end)
end
function GetPlayerJob(playerId, data)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier

	MySQL.Async.fetchAll("SELECT job FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		data(result[1].job)

	end)
end

RegisterServerEvent('orp_license:RevokeLicense')
AddEventHandler('orp_license:RevokeLicense', function(option, player)
  local _src = source
  local xPlayer = ESX.GetPlayerFromId(player)

  local license = nil
  if option == "1" then -- Drivers License
    license = "driver"
  elseif option == "2" then --Weapon License
    license = "weapon"
  elseif option == "3" then --Bike License
    license = "drive_bike"
  elseif option == "4" then -- Truck License
    license = "drive_truck"
  end

  GetRPName(player, function(Firstname, Lastname)

  TriggerClientEvent("notification",_src, "You revoke the License of "..Firstname.." "..Lastname,1)
end)
GetRPName(_src, function(Firstname, Lastname)

TriggerClientEvent("notification",player, "Officer "..Lastname.. " revoke your "..license.." license.",2)
end)
MySQL.Async.execute('DELETE FROM user_licenses WHERE type = @type AND owner = @owner', {
  ['@type']  = license,
  ['@owner'] = xPlayer.identifier
}, function(rowsChanged)
  if cb ~= nil then
    cb()
  end
end)
end)


RegisterServerEvent('orp_license:AddLicense')
AddEventHandler('orp_license:AddLicense', function(option, player)
  local _src = source
  local xPlayer = ESX.GetPlayerFromId(player)

  local license = nil
  if option == "1" then -- Drivers License
    license = "driver"
  elseif option == "2" then --Weapon License
    license = "weapon"
  elseif option == "3" then --Bike License
    license = "drive_bike"
  elseif option == "4" then -- Truck License
    license = "drive_truck"
  end

  GetRPName(player, function(Firstname, Lastname, job)

  TriggerClientEvent("notification",_src, "You give <b>"..license.." License</b> to "..Firstname.." "..Lastname,1)
end)
GetRPName(_src, function(Firstname, Lastname)

TriggerClientEvent("notification",player, "Officer "..Lastname.. " give you a <b>"..license.." license</b>.",2)
end)
	MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
		['@type']  = license,
		['@owner'] = xPlayer.identifier
	}, function(rowsChanged)
		if cb ~= nil then
			cb()
		end
	end)
end)

 TriggerEvent('es:addCommand', 'revoke', function(source, args, user)
   local _src = source
  GetPlayerJob(_src, function(job)

  TriggerClientEvent('orp_license:revoke', _src, args[1], job)

   end)
end)

-- TriggerEvent('es:addCommand', 'addlicense', function(source, args, user)
--   local _src = source
--   GetPlayerJob(_src, function(job)

--   TriggerClientEvent('orp_license:addLic', _src, args[1], job)

-- end)
-- end)

