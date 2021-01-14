

ESX = nil


TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

if GetCurrentResourceName() == 'chopshop' then


    ESX.RegisterServerCallback('Lenzh_chopshop:anycops',function(source, cb)
        local anycops = 0
        local playerList = GetPlayers()
        for i=1, #playerList, 1 do
            local _source = playerList[i]
            local xPlayer = ESX.GetPlayerFromId(_source)
            local playerjob = xPlayer.job.name
            if playerjob == 'police' then
                anycops = anycops + 1
            end
        end
        cb(anycops)
    end)

    RegisterServerEvent("lenzh_chopshop:rewards")
    AddEventHandler("lenzh_chopshop:rewards", function(rewards)
        --Rewards()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if not xPlayer then return; end
        for k,v in pairs(Config.Items) do
            local randomCount = math.random(1, 2)
              --  xPlayer.addInventoryItem(v, randomCount)
                TriggerClientEvent('player:receiveItem', source, v, randomCount)
                local name = GetPlayerName(_source)
    
                           local connect = {
                            {
                                ["color"] = 16711680,
                                ["title"] = "DeadSuccessRP",
                                ["description"] = "Player: **"..name.."**\nChop Shop: Received "..v..' amount: '..randomCount.."",
                                ["footer"] = {
                                    ["text"] = 'DSRP',
                                },
                            }
                        }
                           PerformHttpRequest('https://canary.discordapp.com/peniswebhooks/680384865090535491/36enC7-ugXBU9SLpo1MazOLBmqBCF4HJwSl32dDwbBFY8P3WSep85-b7uyR7DNHcZpjP', function(err, text, headers) end, 'POST', json.encode({username = "Chopshop", embeds = connect}), { ['Content-Type'] = 'application/json' })
             end

    end)


    RegisterServerEvent('chopNotify')
    AddEventHandler('chopNotify', function()
        TriggerClientEvent("chopEnable", source)
    end)


    RegisterServerEvent('ChopInProgress')
    AddEventHandler('ChopInProgress', function()
        TriggerClientEvent("outlawChopNotify", -1, "")
    end)

    RegisterServerEvent('ChoppingInProgressPos')
    AddEventHandler('ChoppingInProgressPos', function(gx, gy, gz)
        TriggerClientEvent('Choplocation', -1, gx, gy, gz)
    end)
end