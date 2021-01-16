
ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
local IdentifierTables = {
    {table = "user_licenses", column = "owner"},
    {table = "owned_vehicles", column = "owner"}, 
    {table = "phone_messages", column = "owner"}, 
    {table = "user_licenses", column = "owner"},
    {table = "characters", column = "identifier"},
    {table = "users", column = "identifier"},
    {table = "user_accounts", column = "identifier"},
    {table = "user_inventory2", column = "name"},
    {table = "character_current", column = "cid"},
    {table = "character_face", column = "cid"},
    {table = "character_outfits", column = "cid"},
    {table = "playerstattoos", column = "identifier"},
    {table = "pw_motels", column = "ident"},
    {table = "phone_contacts", column = "identifier"},
}

RegisterServerEvent("kashactersS:SetupCharacters")
AddEventHandler('kashactersS:SetupCharacters', function()
    local src = source
    local LastCharId = GetLastCharacter(src)
    SetIdentifierToChar(GetPlayerIdentifiers(src)[1], LastCharId)
    local Characters = GetPlayerCharacters(src)
    TriggerClientEvent('kashactersC:SetupUI', src, Characters)
end)

RegisterServerEvent("kashactersS:requestCID")
AddEventHandler('kashactersS:requestCID', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local cid = xPlayer.getID()
    TriggerClientEvent('updatecid', src, cid)
end)

RegisterServerEvent("kashactersS:requestPlyName")
AddEventHandler('kashactersS:requestPlyName', function()
    local src = source
    local ident = GetPlayerIdentifier(source)
    local name = GetCharacterName(ident)
    print(src, name)
    TriggerClientEvent('updatefullname', src, name)
end)

RegisterServerEvent("kashactersS:requestSteam")
AddEventHandler('kashactersS:requestSteam', function()
    local src = source
    local steam = GetPlayerIdentifier(src)
    print('trigg', src, Steam)
    TriggerClientEvent('updatesteam', src, steam)
end)

RegisterServerEvent("kashactersS:requestfunds")
AddEventHandler('kashactersS:requestfunds', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local funds = xPlayer.getMoney()
    TriggerClientEvent('np-base:addedMoney', src, funds)
    print('updating funds for', funds)
end)

RegisterServerEvent("kashactersS:CharacterChosen")
AddEventHandler('kashactersS:CharacterChosen', function(charid, ischar, spawnid)
	local spid = spawnid
    local src = source
    local spawn = {}
    SetLastCharacter(src, tonumber(charid))
    SetCharToIdentifier(GetPlayerIdentifiers(src)[1], tonumber(charid))
    if ischar == "true" then
    
        if spid=="1" then
			spawn = GetSpawnPos(src)
        elseif spid=="2" then
            --Stab city
            spawn = { x = 198.79, y = -934.32, z = 30.68 }
        elseif spid=="3" then
            --Sandy Shores
            spawn = { x = 1556.18, y = 3609.20, z = 35.43 }
        elseif spid=="4" then
            --paleto
            spawn = { x = -687.73, y = 5768.60, z = 17.33 }
        else
            spawn = GetSpawnPos(src)
        end
		if spawn.x == nil then
			print("spawn its nill setting default")
			spawn = { x = -1045.42, y = -2750.85, z = 22.31 }
		end
        TriggerClientEvent("kashactersC:SpawnCharacter", src, spawn)

    else	
        spawn = { x = -1045.42, y = -2750.85, z = 22.31 } -- DEFAULT SPAWN POSITION -- EDIT THIS
        TriggerClientEvent("kashactersC:SpawnCharacter", src, spawn,true)
    end
end)

RegisterServerEvent("kashactersS:DeleteCharacter")
AddEventHandler('kashactersS:DeleteCharacter', function(charid)
    local src = source
    DeleteCharacter(GetPlayerIdentifiers(src)[1], charid)
    TriggerClientEvent("kashactersC:ReloadCharacters", src)
end)

function GetPlayerCharacters(source)
    local identifier = GetIdentifierWithoutSteam(GetPlayerIdentifiers(source)[1])
    local Chars = MySQLAsyncExecute("SELECT * FROM `users` WHERE identifier LIKE '%"..identifier.."%'")
    return Chars
end

function GetLastCharacter(source)
    local LastChar = MySQLAsyncExecute("SELECT `charid` FROM `user_lastcharacter` WHERE `steamid` = '"..GetPlayerIdentifiers(source)[1].."'")
    if LastChar[1] ~= nil and LastChar[1].charid ~= nil then
        return tonumber(LastChar[1].charid)
    else
        MySQLAsyncExecute("INSERT INTO `user_lastcharacter` (`steamid`, `charid`) VALUES('"..GetPlayerIdentifiers(source)[1].."', 1)")
        return 1
    end
end

function SetLastCharacter(source, charid)
    MySQLAsyncExecute("UPDATE `user_lastcharacter` SET `charid` = '"..charid.."' WHERE `steamid` = '"..GetPlayerIdentifiers(source)[1].."'")
end

function SetIdentifierToChar(identifier, charid)
    for _, itable in pairs(IdentifierTables) do
        MySQLAsyncExecute("UPDATE `"..itable.table.."` SET `"..itable.column.."` = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."' WHERE `"..itable.column.."` = '"..identifier.."'")
    end
end

function SetCharToIdentifier(identifier, charid)
    for _, itable in pairs(IdentifierTables) do
        MySQLAsyncExecute("UPDATE `"..itable.table.."` SET `"..itable.column.."` = '"..identifier.."' WHERE `"..itable.column.."` = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."'")
    end
end

function DeleteCharacter(identifier, charid)
    for _, itable in pairs(IdentifierTables) do
        MySQLAsyncExecute("DELETE FROM `"..itable.table.."` WHERE `"..itable.column.."` = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."'")
    end
end

function GetSpawnPos(source)
    local SpawnPos = MySQLAsyncExecute("SELECT `position` FROM `users` WHERE `identifier` = '"..GetPlayerIdentifiers(source)[1].."'")
	if SpawnPos[1].position ~= nil then
		return json.decode(SpawnPos[1].position)
    else
		local spawn = { x = -1045.42, y = -2750.85, z = 22.31 }
		return spawn
	end
end

function GetIdentifierWithoutSteam(Identifier)
    return string.gsub(Identifier, "steam", "")
end

function MySQLAsyncExecute(query)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll(query, {}, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end


RegisterNetEvent("dsrp-login:disconnectPlayer")
AddEventHandler("dsrp-login:disconnectPlayer", function()
    local src = source
    DropPlayer(src, 'Disconnected Cya')
end)

function GetCharacterName(identifier)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	})

	if result[1] and result[1].firstname and result[1].lastname then
		return ('%s %s'):format(result[1].firstname, result[1].lastname)
	end
end
