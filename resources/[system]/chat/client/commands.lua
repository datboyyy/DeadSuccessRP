

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		PlayerData = ESX.GetPlayerData()
	end
end)

RegisterCommand('testchat', function()
    TriggerEvent("chatMessage", "EMAIL ", "Yo, here are the coords for the drop off, you have 10 minutes - it will cost  Pixerium")
end, false)


RegisterCommand('911', function(source, args, rawCommand)
    local source = GetPlayerServerId(PlayerId())
    local name = GetPlayerName(PlayerId())
    local caller = GetPlayerServerId(PlayerId())
    local msg = rawCommand:sub(4)
    TriggerServerEvent('3dme:shareDisplay', "*Made a 911 call.*")
    TriggerServerEvent('chat:server:911source', source, caller, msg)
    TriggerServerEvent('911', source, caller, msg)
    TriggerServerEvent('DiscordBot:ToDiscord', 'distress', '911 Call', "**"..GetPlayerName(PlayerId()) .. ' [' .. GetPlayerServerId(PlayerId()) .."]** "..msg.."", 'SYSTEM', true)
    local prop_name = prop_name or 'prop_player_phone_01'
				local x,y,z = table.unpack(GetEntityCoords(plyPed))
				prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
				AttachEntityToEntity(prop, plyPed, GetPedBoneIndex(plyPed, 57005), 0.15, 0.02, -0.01, 105.0, -20.0, 90.0, true, true, false, true, 1, true)
				local dict = "cellphone@"
				local anim = "cellphone_call_listen_base"
					if not HasAnimDictLoaded(dict) then
						RequestAnimDict(dict)
						while not HasAnimDictLoaded(dict) do
							Citizen.Wait(0)
						end
					end
				TaskPlayAnim(GetPlayerPed(-1), dict, anim, -1, -8, 0.01, 49, 0, 0, 0, 0)
				Citizen.Wait(5000)
				StopAnimTask(GetPlayerPed(-1), dict, anim, 1.5)	
				DetachEntity(prop, 1, 1)
                DeleteObject(prop)
                exports['mythic_notify']:SendAlert('success', "Local Authorities Have Recieved your call.")
end, false)


RegisterCommand('311', function(source, args, rawCommand)
    local source = GetPlayerServerId(PlayerId())
    local name = GetPlayerName(PlayerId())
    local caller = GetPlayerServerId(PlayerId())
    local msg = rawCommand:sub(4)
    TriggerServerEvent('3dme:shareDisplay', "*Made a 311 call.*")
    TriggerServerEvent(('chat:server:311source'), source, caller, msg)
    TriggerServerEvent('311', source, caller, msg)
    TriggerServerEvent('DiscordBot:ToDiscord', 'distress', '311 Call', "**"..GetPlayerName(PlayerId()) .. ' [' .. GetPlayerServerId(PlayerId()) .."]** "..msg.."", 'SYSTEM', true)
    local prop_name = prop_name or 'prop_player_phone_01'
				local x,y,z = table.unpack(GetEntityCoords(plyPed))
				prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
				AttachEntityToEntity(prop, plyPed, GetPedBoneIndex(plyPed, 57005), 0.15, 0.02, -0.01, 105.0, -20.0, 90.0, true, true, false, true, 1, true)
				local dict = "cellphone@"
				local anim = "cellphone_call_listen_base"
					if not HasAnimDictLoaded(dict) then
						RequestAnimDict(dict)
						while not HasAnimDictLoaded(dict) do
							Citizen.Wait(0)
						end
					end
				TaskPlayAnim(GetPlayerPed(-1), dict, anim, -1, -8, 0.01, 49, 0, 0, 0, 0)
				Citizen.Wait(5000)
				StopAnimTask(GetPlayerPed(-1), dict, anim, 1.5)	
				DetachEntity(prop, 1, 1)
                DeleteObject(prop)
                exports['mythic_notify']:SendAlert('success', "Local Authorities Have Recieved your call.")
end, false)




RegisterNetEvent('chat:EmergencySend911r')
AddEventHandler('chat:EmergencySend911r', function(fal, caller, msg)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message emergency">911r | ({1}) {0}: {2} </div>',
        args = {caller, fal, msg}
        });
    end
end)

RegisterNetEvent('chat:EmergencySend311r')
AddEventHandler('chat:EmergencySend311r', function(fal, caller, msg)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message nonemergency">311r | ({1}) {0}: {2} </div>',
        args = {caller, fal, msg}
        });
    end
end)

RegisterNetEvent('chat:EmergencySend911')
AddEventHandler('chat:EmergencySend911', function(fal, caller, msg)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message emergency">911 | ({1}) {0}: {2} </div>',
        args = {caller, fal, msg}
        });
    end
end)

RegisterNetEvent('chat:EmergencySend311')
AddEventHandler('chat:EmergencySend311', function(fal, caller, msg)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message nonemergency">311 | ({1}) {0}: {2} </div>',
        args = {caller, fal, msg}
        });
    end
end)

RegisterCommand('911r', function(target, args, rawCommand)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        local source = GetPlayerServerId(PlayerId())
        local target = tonumber(args[1])
        local msg = rawCommand:sub(8)
        TriggerServerEvent(('chat:server:911r'), target, source, msg)
        TriggerServerEvent('911r', target, source, msg)
        TriggerServerEvent('DiscordBot:ToDiscord', 'distress', '911 Reply', "**"..GetPlayerName(PlayerId()) .. ' [' .. GetPlayerServerId(PlayerId()) .."]** "..msg.."", 'SYSTEM', true)
    end
end, false)

RegisterCommand('311r', function(target, args, rawCommand)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then 
        local source = GetPlayerServerId(PlayerId())
        local target = tonumber(args[1])
        local msg = rawCommand:sub(8)
        TriggerServerEvent(('chat:server:311r'), target, source, msg)
        TriggerServerEvent('311r', target, source, msg)
        TriggerServerEvent('DiscordBot:ToDiscord', 'distress', '311 Reply', "**"..GetPlayerName(PlayerId()) .. ' [' .. GetPlayerServerId(PlayerId()) .."]** "..msg.."", 'SYSTEM', true)
    end
end, false)


RegisterNetEvent('chat:showCID')
AddEventHandler('chat:showCID', function(cidInformation)
  print('sending here', json.encode(cidInformation))
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
      color = 9,
      multiline = false,
      args = cidInformation
    }
  })
end)

RegisterNetEvent('chat:showFBI')
AddEventHandler('chat:showFBI', function(cidInformation)
  print('sending here fed', json.encode(cidInformation))
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
      color = 10,
      multiline = false,
      args = cidInformation
    }
  })
end)