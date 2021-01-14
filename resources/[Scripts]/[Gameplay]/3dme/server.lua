RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text)
    local source = source
    local realname = GetCharacterName(source)
    local args = realname..' '..text
    TriggerClientEvent('Do3DText', -1, args, source)


    local name = GetPlayerName(source)
    local hex = GetPlayerIdentifier(source)
    local threedme = {
        {
            ["color"] = 16711680,
            ["title"] = "Dead Success RP",
            ["description"] = "Player: **" .. name .. "**\n Steam Hex: **" .. hex .. "\n**3dme message: **" .. args .. "**\n",
            ["footer"] = {
                ["text"] = 'DSRP',
            },
        }
    }
    PerformHttpRequest('https://discord.com/api/webhooks/789314113326415912/pDC9hbCFGf905Qu4aLhqK1L6bGDAYVf48yvEr-UXbJAPVKNQ9a4KXFyNI5RkG2DeXNNG', function(err, text, headers) end, 'POST', json.encode({username = "3dme", embeds = threedme}), {['Content-Type'] = 'application/json'})

end)


RegisterServerEvent('3dme:shareDisplayforlater')
AddEventHandler('3dme:shareDisplayforlater', function(text)
	TriggerClientEvent('Do3DText', -1, text, source)
end)


function GetCharacterName(source)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] and result[1].firstname and result[1].lastname then
		return ('%s %s'):format(result[1].firstname, result[1].lastname)
	end
end
