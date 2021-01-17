ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
		}
	else
		return nil
	end
end

RegisterCommand('clear', function(source, args, rawCommand)
    TriggerClientEvent('chat:client:ClearChat', source)
end, false)

RegisterCommand('clear', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'superadmin' then
    TriggerClientEvent('chat:client:ClearChat', -1)
    end
end, false)

RegisterCommand('ooc', function(source, args, rawCommand, suggestions)
    local src = source
    local msg = rawCommand:sub(5)
    local suggestions = {}
	local source = tonumber(source)
    if player ~= false then
        local user = GetPlayerName(src)
        TriggerEvent('DiscordBot:ToDiscord', 'chat', 'OOC LOG', '> ' .. '[' .. src ..'] ' .. GetPlayerName(src) .. ' ```' .. msg .. '```', 'IMAGE_URL', true)
        GetRPName(source, function(Firstname, Lastname)
            TriggerClientEvent('chat:addMessageOOC', -1, {
            template = '<div class="chat-message"><b>OOC ' ..GetPlayerName(src).. ':</b> {1}</div>',
            args = { user, msg }
        })
    end)
    end
end, false)

-- RegisterCommand('server', function(source, args, rawCommand, suggestions)
--     local src = source
--     local msg = rawCommand:sub(5)
--     local suggestions = {}
-- 	local source = tonumber(source)
--     if player ~= false then
--         local user = GetPlayerName(src)
--         GetRPName(source, function(Firstname, Lastname)
--             TriggerClientEvent('chat:addMessageOOC', -1, {
--             template = '<div class="chat-message"><b>Serv:</b>{1}</div>',
--             args = { user, msg }
--         })
--     end)
--     end
-- end, false)

-- RegisterCommand('announce', function(source, args, rawCommand)
--     local src = source
--     local msg = rawCommand:sub(7)
--     if player ~= false then
--         local user = GetPlayerName(-1)
--             TriggerClientEvent('chat:addMessages', -1, {
--             template = '<div class="chat-message server"><b>Announcement:</b> {0}</div>',
--             args = { msg }
--         })
--     end
-- end)

RegisterCommand("say", function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        local user = GetPlayerName(-1)
            TriggerClientEvent('chat:addMessages', -1, {
            template = '<div class="chat-message-system"><b>Console:</b> {0}</div>',
            args = { msg }
        })
    end
end, true)
--[[
RegisterCommand('say', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        local user = GetPlayerName(-1)
            TriggerClientEvent('chat:addMessages', -1, {
            template = '<div class="chat-message server"><b>Console:</b> {0}</div>',
            args = { msg }
        })
    end
end)
--]]
--RegisterCommand('say2', function(source, args, rawCommand)
  --  TriggerClientEvent('chatMessage', -1, (source == 0) and 'console' or GetPlayerName(source), { 255, 255, 255 }, rawCommand:sub(5))
--end)

function GetRPName(playerId, data)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		data(result[1].firstname, result[1].lastname)

	end)
end