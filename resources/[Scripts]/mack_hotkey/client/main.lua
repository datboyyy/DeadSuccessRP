local debug = false

RegisterNetEvent('mack_hotkey:client:HotKey')
AddEventHandler('mack_hotkey:client:HotKey', function(data)
	SendHotKey(data.text, data.hotkey, data.id, data.exit)
	ExitHotKey(data.id, data.exit)
end)

function SendHotKey(text, hotkey, id, exit)
	SendNUIMessage({
		text = text,
		hotkey = hotkey,
		id = id,
		exit = false
	})
end

function ExitHotKey(id, exit)
	SendNUIMessage({
		id = id,
		exit = true
	})
end

RegisterCommand("hotkey1", function(source , args, rawCommand)
	if debug then
		exports['mack_hotkey']:SendHotKey('Accessories', 'E', 1)
	end
end)

RegisterCommand("exithotkey1", function(source , args, rawCommand)
	if debug then
		exports['mack_hotkey']:ExitHotKey(1)
	end
end)

RegisterCommand("hotkey2", function(source , args, rawCommand)
	if debug then
		exports['mack_hotkey']:SendHotKey('Clotheshop', 'E', 2)
	end
end)

RegisterCommand("exithotkey2", function(source , args, rawCommand)
	if debug then
		exports['mack_hotkey']:ExitHotKey(2)
	end
end)
