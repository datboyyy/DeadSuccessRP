
ESX = nil


TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    MySQL.Async.fetchScalar("SELECT armour FROM users WHERE identifier = @identifier", { 
        ['@identifier'] = xPlayer.getIdentifier()
        }, function(data)
        if (data ~= nil) then
            TriggerClientEvent('LRP-Armour:Client:SetPlayerArmour', playerId, data)
        end
    end)
end)

RegisterServerEvent('LRP-Armour:Server:RefreshCurrentArmour')
AddEventHandler('LRP-Armour:Server:RefreshCurrentArmour', function(updateArmour)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.execute("UPDATE users SET armour = @armour WHERE identifier = @identifier", { 
        ['@identifier'] = xPlayer.getIdentifier(),
        ['@armour'] = tonumber(updateArmour)
    })
end)



ESX.RegisterUsableItem('fixkit', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('fixkit', 1)

	TriggerClientEvent('esx_mechanicjob:onFixkit', source)
end)



-- E N G I N E --
AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/engine off" then
		CancelEvent()
		--------------
		TriggerClientEvent('engineoff', s)
	elseif message == "/engine on" then
		CancelEvent()
		--------------
		TriggerClientEvent('engineon', s)
	elseif message == "/engine" then
		CancelEvent()
		--------------
		TriggerClientEvent('engine', s)
	end
end)






RegisterServerEvent('CarryPeople:sync')
AddEventHandler('CarryPeople:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('CarryPeople:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('CarryPeople:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('CarryPeople:stop')
AddEventHandler('CarryPeople:stop', function(targetSrc)
	TriggerClientEvent('CarryPeople:cl_stop', targetSrc)
end)

  
RegisterServerEvent('cmg2_animations:sync')
AddEventHandler('cmg2_animations:sync', function(target, animationLib, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	print("got to srv cmg2_animations:sync")
	TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	print("triggering to target: " .. tostring(targetSrc))
	TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg2_animations:stop')
AddEventHandler('cmg2_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg2_animations:cl_stop', targetSrc)
end)


RegisterServerEvent('cmg3_animations:sync')
AddEventHandler('cmg3_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget,attachFlag)
	print("got to srv cmg3_animations:sync")
	print("got that fucking attach flag as: " .. tostring(attachFlag))
	TriggerClientEvent('cmg3_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget,attachFlag)
	print("triggering to target: " .. tostring(targetSrc))
	TriggerClientEvent('cmg3_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg3_animations:stop')
AddEventHandler('cmg3_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg3_animations:cl_stop', targetSrc)
end)

RegisterServerEvent("sway:sync_sv")
AddEventHandler("sway:sync_sv", function()
    TriggerClientEvent("sway:peacetime", -1, peacetimeon)
end)

peacetimeon = false

RegisterCommand("peacetime", function(source, args, raw)
if IsPlayerAceAllowed(source, "sway_peacetime") then
	if peacetimeon == true then
		peacetimeon = false
		TriggerEvent("sway:sync_sv", peacetimeon)
	elseif peacetimeon == false then
		peacetimeon = true
		TriggerEvent("sway:sync_sv", peacetimeon)
	end
else
	TriggerClientEvent("chatMessage", source, "^*^1Peacetime: ^3Insufficient Permission", {255, 255, 255})
end
end)



local logs = "https://canary.discordapp.com/api/webhooks/788346969265012746/kaDFvNVBjQm1jg8M7_5lMJTZx0C2TX7uN-s2H9FnBfU_5nypgF-tYJg9aa-OJ0lRexsd"
local communityname = "DeadSuccess RP"
local communtiylogo = "https://i.imgur.com/LRoLTlK.jpeg" --Must end with .png

IpHiddenManage = {
	'steam:11000011c3fe668',
	'steam:11000013bd84d46'
}

AddEventHandler('playerConnecting', function()
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local connect = {
        {
            ["color"] = "0000000",
            ["title"] = "Player Connected to Server #1",
            ["description"] = "Player: **"..name.."**\nIP: **"..ip.."**\n Steam Hex: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
            },
        }
    }
	
local connectstaff = {
        {
            ["color"] = "0000000",
            ["title"] = "Player Connected to Server #1",
            ["description"] = "Player: **"..name.."**\nIP: ** Hidden **\n Steam Hex: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
            },
        }
    }
	if IpHidden(source) then
	PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "DeadSuccessRP", embeds = connectstaff}), { ['Content-Type'] = 'application/json' })
    else
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "DeadSuccessRP", embeds = connect}), { ['Content-Type'] = 'application/json' })
	end
end)

AddEventHandler('playerDropped', function(reason)
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local disconnect = {
        {
            ["color"] = "0000000",
            ["title"] = "Player Disconnected from Server #1",
            ["description"] = "Player: **"..name.."** \nReason: **"..reason.."**\nIP: **"..ip.."**\n Steam Hex: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
            },
        }
    }
	
local disconnectstaff = {
        {
            ["color"] = "0000000",
            ["title"] = "Player Disconnected from Server #1",
            ["description"] = "Player: **"..name.."** \nReason: **"..reason.."**\nIP: ** Hidden **\n Steam Hex: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
            },
        }
    }
    if IpHidden(source) then
	PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "DeadSuccessRP", embeds = disconnectstaff}), { ['Content-Type'] = 'application/json' })
	else
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "DeadSuccessRP", embeds = disconnect}), { ['Content-Type'] = 'application/json' })
	end
end)

function IpHidden(player)
    local allowed = false
    for i,id in ipairs(IpHiddenManage) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end
-----

RegisterNetEvent("shitidk:pulsecheck")
AddEventHandler("shitidk:pulsecheck", function(pleb)
	TriggerClientEvent("shitidk2:pulsecheck", pleb)
end)

RegisterNetEvent("CrashTackle")
AddEventHandler("CrashTackle", function(pleb)
	TriggerClientEvent("playerTackled", pleb)
end)




RegisterCommand('kickall', function(source, args, rawCommand)
    if source == 0 then
    kickPl()
    end
end, true)

function kickPl()
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        xPlayer.kick("DeadSuccessRP: The server is restarting.")
    end
end



RegisterCommand('bill', function(source, args, raw)
    local src = source
    local Target = args[1]
    local amount = args[2]

     local myPed = GetPlayerPed(src)
     local myPos = GetEntityCoords(myPed)
     local pTarget = GetPlayerPed(Target)
     local tPos = GetEntityCoords(pTarget)
     local dist = #(vector3(tPos.x, tPos.y, tPos.z) - myPos)
     local zPlayer = ESX.GetPlayerFromId(Target)
     local xPlayer = ESX.GetPlayerFromId(src)  
    if dist < 8 and xPlayer.job.name == 'police' then
        if tonumber(amount) ~= nil then
        zPlayer.removeAccountMoney('bank', tonumber(amount))
        TriggerClientEvent('chat:svtocl', src, 'Billed:', 3, "You have Billed  " .. Target .. " for $" .. tonumber(amount) .. ".")
        TriggerClientEvent('chat:svtocl', Target, 'Billed:', 3, "BILL: You were billed for " .. tonumber(amount) .. " dollar(s).")
            local name = GetPlayerName(source)
            local hex = GetPlayerIdentifier(source)
            local hex2 = GetPlayerIdentifier(Target)
            local billing = {
                {
                    ["color"] = 16711680,
                    ["title"] = "Dead Success RP",
                    ["description"] = "**Player: **" .. name .. "**\n Steam Hex: **" .. hex .. "\n**Billed: **" .. hex2 ..' for $'..tonumber(amount), "\n",
                    ["footer"] = {
                        ["text"] = 'DSRP',
                    },
                }
            }
            PerformHttpRequest('https://discord.com/api/webhooks/788756976674668573/W2OvAkpUbUh1bL0Ufbngm1P8z5ADrz09jiJ1nWD71tSk8L2Dm5pRMDQjHHcIKUDcvMHO', function(err, text, headers) end, 'POST', json.encode({username = "Billing", embeds = billing}), {['Content-Type'] = 'application/json'})
        
        end
    else
        TriggerClientEvent("notification", src, "Required Job: Police")
    end
end)

