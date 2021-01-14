ESX = nil
TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)

RegisterCommand("setcryptoworth", function(source, args)
    local src = source
    local crypto = tostring(args[1])
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.identifier == 'steam:11000013bd84d46' then
        if crypto ~= nil then
            if Crypto.Worth[crypto] ~= nil then
                local NewWorth = math.ceil(tonumber(args[2]))
                
                if NewWorth ~= nil then
                    local PercentageChange = math.ceil(((NewWorth - Crypto.Worth[crypto]) / Crypto.Worth[crypto]) * 100)
                    local ChangeLabel = "+"
                    if PercentageChange < 0 then
                        ChangeLabel = "-"
                        PercentageChange = (PercentageChange * -1)
                    end
                    if Crypto.Worth[crypto] == 0 then
                        PercentageChange = 0
                        ChangeLabel = ""
                    end
                    
                    table.insert(Crypto.History[crypto], {
                        PreviousWorth = Crypto.Worth[crypto],
                        NewWorth = NewWorth
                    })
                    
                    TriggerClientEvent('notification', src, "You set the worth of " .. Crypto.Labels[crypto] .. " from: ($" .. Crypto.Worth[crypto] .. " to: $" .. NewWorth .. ") (" .. ChangeLabel .. " " .. PercentageChange .. "%)")
                    Crypto.Worth[crypto] = NewWorth
                    TriggerClientEvent('qb-crypto:client:UpdateCryptoWorth', -1, crypto, NewWorth)
                    ExecuteSql(false, "UPDATE `crypto` SET `worth` = '" .. NewWorth .. "', `history` = '" .. json.encode(Crypto.History[crypto]) .. "' WHERE `crypto` = '" .. crypto .. "'")
                    TriggerEvent('qb-crypto:server:FetchWorth')
                else
                    TriggerClientEvent('notification', src, "You have not given a new value.. Current worth: " .. Crypto.Worth[crypto])
                end
            else
                TriggerClientEvent('notification', src, "This Crypto does not exist :(, available crypto: Qbit")
            end
        else
            TriggerClientEvent('notification', src, "You didnt insert a Crypto, available crypto: Qbit")
        end
    end
end)
--[[

QBCore.Commands.Add("checkcryptoworth", "", {}, false, function(source, args)
local src = source
TriggerClientEvent('notification', src, "The Qbit has a value of: €"..Crypto.Worth["qbit"])
end, "admin")

QBCore.Commands.Add("crypto", "", {}, false, function(source, args)
local src = source
local xPlayer = ESX.GetPlayerFromId(src)
local MyPocket = math.ceil(xPlayer.getCrypto() * Crypto.Worth["qbit"])

TriggerClientEvent('notification', src, "You have: "..xPlayer.getCrypto().." QBit, with a worth of: €"..MyPocket..",-")
end, "admin")]]
--
RegisterServerEvent('qb-crypto:server:FetchWorth')
AddEventHandler('qb-crypto:server:FetchWorth', function()
    for name, _ in pairs(Crypto.Worth) do
        ExecuteSql(false, "SELECT * FROM `crypto` WHERE `crypto` = '" .. name .. "'", function(result)
            if result[1] ~= nil then
                Crypto.Worth[name] = result[1].worth
                if result[1].history ~= nil then
                    Crypto.History[name] = json.decode(result[1].history)
                    TriggerClientEvent('qb-crypto:client:UpdateCryptoWorth', -1, name, result[1].worth, json.decode(result[1].history))
                else
                    TriggerClientEvent('qb-crypto:client:UpdateCryptoWorth', -1, name, result[1].worth, nil)
                end
            end
        end)
    end
end)

RegisterServerEvent('qb-crypto:server:ExchangeFail')
AddEventHandler('qb-crypto:server:ExchangeFail', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    xPlayer.removeinventoryitem("bread", 1)
    TriggerClientEvent('notification', src, "Attempt failed, the stick crashed..", 'error', 5000)
end)

RegisterServerEvent('qb-crypto:server:Rebooting')
AddEventHandler('qb-crypto:server:Rebooting', function(state, percentage)
    Crypto.Exchange.RebootInfo.state = state
    Crypto.Exchange.RebootInfo.percentage = percentage
end)

RegisterServerEvent('qb-crypto:server:GetRebootState')
AddEventHandler('qb-crypto:server:GetRebootState', function()
    local src = source
    TriggerClientEvent('qb-crypto:client:GetRebootState', src, Crypto.Exchange.RebootInfo)
end)

RegisterServerEvent('qb-crypto:server:SyncReboot')
AddEventHandler('qb-crypto:server:SyncReboot', function()
    TriggerClientEvent('qb-crypto:client:SyncReboot', -1)
end)

RegisterServerEvent('qb-crypto:server:ExchangeSuccess')
AddEventHandler('qb-crypto:server:ExchangeSuccess', function(LuckChance, HasItem)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local randomluckyness = math.random(1,5)
        if HasItem then 
            if randomluckyness <= 1 then
                xPlayer.addCrypto(2)
                TriggerClientEvent('notification', src, "You have exchanged your Cryptostick for: 2 QBit(\'s)", "success", 3500)
                TriggerClientEvent('MI-phone:client:AddTransaction', src, Player, {}, "There are 2 Qbit('s) credited!", "Transferred")
            else 
                TriggerClientEvent('notification', src, "You have exchanged your Cryptostick for: 1 QBit(\'s)", "success", 3500)
                xPlayer.addCrypto(1)
                TriggerClientEvent('MI-phone:client:AddTransaction', src, Player, {}, "There are 1 Qbit('s) credited!", "Transferred")
        end
    end
end)

ESX.RegisterServerCallback('qb-crypto:server:HasSticky', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ItemQTY = exports['np_inventory']:itemCount('bread', xPlayer.identifier)
    if ItemQTY ~= nil and ItemQTY >= 1 then
        cb(true)
    else
        cb(false)
    end
end)


ESX.RegisterServerCallback('qb-crypto:server:GetCryptoData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    local CryptoData = {
        History = Crypto.History["qbit"],
        Worth = Crypto.Worth["qbit"],
        Portfolio = xPlayer.getCrypto(),
        WalletId = xPlayer.getIBAN(),
    }
    
    cb(CryptoData)
end)

ESX.RegisterServerCallback('qb-crypto:server:BuyCrypto', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    print(json.encode(data))
    print(xPlayer.getBank(), data.Coins)
    
    if xPlayer.getBank() >= tonumber(data.Price) then
        local CryptoData = {
            History = Crypto.History["qbit"],
            Worth = Crypto.Worth["qbit"],
            Portfolio = xPlayer.getCrypto() + tonumber(data.Coins),
            WalletId = xPlayer.getIBAN(),
        }
        xPlayer.removeBank(tonumber(data.Price))
        TriggerClientEvent('MI-phone:client:AddTransaction', source, Player, data, "You bought " .. tonumber(data.Coins) .. " Qbit('s)!", "Purchase")
        print("Adding " .. data.Coins .. "x Crypto")
        xPlayer.addCrypto(tonumber(data.Coins))
        cb(CryptoData)
    else
        cb(false)
    end
end)



ESX.RegisterServerCallback('qb-crypto:server:SellCrypto', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    print(xPlayer.getBank(), data.Coins)
    if xPlayer.getCrypto() >= tonumber(data.Coins) then
        local CryptoData = {
            History = Crypto.History["qbit"],
            Worth = Crypto.Worth["qbit"],
            Portfolio = xPlayer.getCrypto() - tonumber(data.Coins),
            WalletId = xPlayer.getIBAN(),
        }
        xPlayer.removeCrypto(tonumber(data.Coins))
        TriggerClientEvent('MI-phone:client:AddTransaction', source, Player, data, "You sold " .. tonumber(data.Coins) .. " Qbit('s)!", "Sale")
        xPlayer.addMoney(tonumber(data.Price))
        cb(CryptoData)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('qb-crypto:server:TransferCrypto', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getCrypto() >= tonumber(data.Coins) then

        ExecuteSql(false, "SELECT * FROM `users` WHERE `iban` = '"..data.WalletId.."'", function(result)
            if result[1] ~= nil then
                local CryptoData = {
                    History = Crypto.History["qbit"],
                    Worth = Crypto.Worth["qbit"],
                    Portfolio = xPlayer.getCrypto() - tonumber(data.Coins),
                    WalletId = xPlayer.getIBAN(),
                }
                local Target = ESX.GetPlayerFromIdentifier(result[1].identifier)

                if Target ~= nil then
                    xPlayer.removeCrypto(tonumber(data.Coins))
                    print("Removing " ..data.Coins .."x Crypto")
                    TriggerClientEvent('MI-phone:client:AddTransaction', source, Player, data, "You transfered "..tonumber(data.Coins).." Qbit('s)!", "Sale")

                    Target.addCrypto(tonumber(data.Coins))
                    print("Adding " ..data.Coins .."x Crypto")
                    TriggerClientEvent('MI-phone:client:AddTransaction', Target.source, Player, data, "There are "..tonumber(data.Coins).." Qbit('s) credited!", "Purchase")
                    cb(CryptoData)
                else
                    cb("notvalid")
                end
            else
                cb("notvalid")
            end
        end)
    else
        cb("notenough")
    end
end)


function ExecuteSql(wait, query, cb)
    local rtndata = {}
    local waiting = true
    MySQL.Async.fetchAll(query, {}, function(data)
        if cb ~= nil and wait == false then
            cb(data)
        end
        rtndata = data
        waiting = false
    end)
    if wait then
        while waiting do
            Citizen.Wait(5)
        end
        if cb ~= nil and wait == true then
            cb(rtndata)
        end
    end
    
    return rtndata
end
