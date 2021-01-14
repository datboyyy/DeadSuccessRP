RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text, log)
	TriggerClientEvent('3dme:shareDisplay', -1, text, source)
end)

RegisterCommand('me', function(source, args)
    local text = GetCharacterName(source).. "" ..table.concat(args, " ") .. ""
    TriggerClientEvent('3dme:shareDisplay', -1, text, source)
    local threedme = {
        {
            ["color"] = 16711680,
            ["title"] = "Dead Success RP",
            ["description"] = "Player: **" .. GetPlayerName(source) .. "**\n Steam Hex: **" .. GetPlayerIdentifiers(source)[1] .. "\n**3dme message: **" .. text .. "**\n",
            ["footer"] = {
                ["text"] = 'DSRP',
            },
        }
    }
    PerformHttpRequest('https://discord.com/api/webhooks/789314113326415912/pDC9hbCFGf905Qu4aLhqK1L6bGDAYVf48yvEr-UXbJAPVKNQ9a4KXFyNI5RkG2DeXNNG', function(err, text, headers) end, 'POST', json.encode({username = "3dme", embeds = threedme}), {['Content-Type'] = 'application/json'})
end)


function GetCharacterName(source)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] and result[1].firstname and result[1].lastname then
		return ('%s %s'):format(result[1].firstname, result[1].lastname)
	end
end
