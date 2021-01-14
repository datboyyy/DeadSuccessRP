local color
RegisterNetEvent('mythic_notify:client:SendAlert')
AddEventHandler('mythic_notify:client:SendAlert', function(data)
	--SendAlert(data.type, data.text, data.length, data.style)
	if data.type == 'inform' then
	 color = 1 elseif data.type == 'error' then color = 2 elseif data.type == 'success' then color = 3 end
	TriggerEvent('notification', data.text, color, data.length)
end)

RegisterNetEvent('mythic_notify:client:SendUniqueAlert')
AddEventHandler('mythic_notify:client:SendUniqueAlert', function(data)
	SendUniqueAlert(data.id, data.type, data.text, data.length, data.style)
end)


RegisterNetEvent('mythic_notify:client:PersistentAlert')
AddEventHandler('mythic_notify:client:PersistentAlert', function(data)
	PersistentAlert(data.action, data.id, data.type, data.text, data.style)
end)

function SendAlert(type, text, length, style)
	if type == 'inform' then
		color = 1 elseif type == 'error' then color = 2 elseif type == 'success' then color = 3 end
	TriggerEvent('notification', text, color, length)
	--[[SendNUIMessage({
		type = type,
		text = text,
		length = length,
		style = style
	})]]
end

function SendUniqueAlert(id, type, text, length, style)
	SendNUIMessage({
		id = id,
		type = type,
		text = text,
		style = style
	})
end

function PersistentAlert(action, id, type, text, style)
	if action:upper() == 'START' then
		SendNUIMessage({
			persist = action,
			id = id,
			type = type,
			text = text,
			style = style
		})
	elseif action:upper() == 'END' then
		SendNUIMessage({
			persist = action,
			id = id
		})
	end
end


RegisterNetEvent('mythic_notify:client:PersistentHudText')
AddEventHandler('mythic_notify:client:PersistentHudText', function(data)
    PersistentAlert(data.action, data.id, data.type, data.text, data.style)
end)

function DoShortHudText(type, text, style)
    SendAlert(type, text, 1000, style)
end

function DoHudText(type, text, style)
    SendAlert(type, text, 2500, style)
end

function DoLongHudText(type, text, style)
    SendAlert(type, text, 5000, style)
end

function DoCustomHudText(type, text, length, style)
    SendAlert(type, text, length, style)
end

function PersistentHudText(action, id, type, text, style)
    PersistentAlert(action, id, type, text, style)
end