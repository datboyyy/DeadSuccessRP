server_name = GetConvar("server_num", "UNK") -- should be a CONVAR in server.cfg

playerList = {}

AddEventHandler("onResourceStart", function(name)
    if name == GetCurrentResourceName() then
        -- update player without a leave date, server must have crashed
        local data = {}
        data["server"] = server_name
        Citizen.Wait(17500)
        MySQL.Async.execute("update player_log set leave_date = NOW() where server_name = @server and leave_date IS NULL", data)
    end
end)

RegisterNetEvent("Log:Joined")
AddEventHandler('Log:Joined', function()
    playerId = source
    local data = {}
    data["discord"] = nil
    data["license"] = nil
    data["steam"] = nil
    data["ip"] = nil
    for k, v in pairs(GetPlayerIdentifiers(playerId)) do
        identifier = stringsplit(v, ':')
        data[identifier[1]] = identifier[2]   
    end
    data["server_name"] = server_name
    data["server_id"] = playerId
    data["user_name"] = GetPlayerName(playerId)
    playerList[playerId] = data["license"]
    MySQL.Async.execute("insert into player_log (server_name, server_id, user_name, fivem_license, steam_hex, discord_id, ip, join_date) values (@server_name, @server_id, @user_name, @license, @steam, @discord, @ip, NOW())", data)
end)

AddEventHandler("playerDropped", function(player, disconnectReason)
    local playerId = source
    local data = {}
    data["server_name"] = server_name
    data["server_id"] = playerId
    data["license"] = playerList[playerId]
    MySQL.Async.execute("update player_log set leave_date = NOW() where server_name = @server_name and server_id = @server_id and fivem_license = @license and leave_date IS NULL", data)
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
