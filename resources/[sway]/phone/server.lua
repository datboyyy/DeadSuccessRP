ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

MySQL.ready(function ()
    TriggerEvent('deleteAllYP')
end)



local callID = nil

--[[ Twitter Stuff ]]
RegisterNetEvent('GetTweets')
AddEventHandler('GetTweets', function(onePlayer)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll('SELECT * FROM (SELECT * FROM tweets ORDER BY `time` DESC LIMIT 50) sub ORDER BY time ASC', {}, function(tweets) -- Get most recent 100 tweets
        if onePlayer then
            TriggerClientEvent('Client:UpdateTweets', src, tweets)
        else
            TriggerClientEvent('Client:UpdateTweets', src, tweets)
        end
    end)
end)

RegisterNetEvent('Tweet')
AddEventHandler('Tweet', function(handle, data, time)
    local handle = handle
    local src = source
    MySQL.Async.execute('INSERT INTO tweets (handle, message, time) VALUES (@handle, @message, @time)', {
        ['@handle'] = handle,
        ['@message'] = data,
        ['@time'] = time
    }, function(result)
        
        TriggerEvent('GetTweets', src, true)
    end)
    local newtwat = { ['handle'] = handle, ['message'] = data, ['time'] = time}
    TriggerClientEvent('Client:UpdateTweet', -1, newtwat)
end)

RegisterServerEvent('AllowTweet')
AddEventHandler('AllowTweet', function(tweetinfo, message)
    TriggerClientEvent("chatMessagess", -1, tweetinfo, 2, message)
end)

RegisterNetEvent('Server:GetHandle')
AddEventHandler('Server:GetHandle', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local name = getIdentity(src)	
    fal = "@" .. name.firstname .. "_" .. name.lastname
    local handle = fal
    TriggerClientEvent('givemethehandle', src, handle)
    TriggerClientEvent('updateNameClient', src, name.firstname, name.lastname)
end)

function getIdentity(target)
    local identifier = GetPlayerIdentifiers(target)[1]

	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			firstname = identity['firstname'],
			lastname = identity['lastname'],
		}
	else
		return nil
	end
end

--[[ Contacts stuff ]]

RegisterNetEvent('phone:addContact')
AddEventHandler('phone:addContact', function(name, number)
    local xPlayer = ESX.GetPlayerFromId(source)
    local handle = handle
    local src = source

    MySQL.Async.execute('INSERT INTO phone_contacts (identifier, name, number) VALUES (@identifier, @name, @number)', {
        ['@identifier'] = xPlayer.getIdentifier(),
        ['@name'] = name,
        ['@number'] = number
    }, function(result)
        TriggerEvent('getContacts', true, src)
        TriggerClientEvent('refreshContacts', src)
        TriggerClientEvent('phone:newContact', src, name, number)
    end)
end)

RegisterNetEvent('deleteContact')
AddEventHandler('deleteContact', function(name, number)
    local xPlayer = ESX.GetPlayerFromId(source)
    local src = source
    local myIdent = xPlayer.getIdentifier()

    MySQL.Async.execute('DELETE FROM phone_contacts WHERE name = @name AND number = @number LIMIT 1', {
        ['@name'] = name,
        ['@number'] = number
    }, function (result)
        TriggerEvent('getContacts', true, src)
        TriggerClientEvent('refreshContacts', src)
        TriggerClientEvent('phone:deleteContact', src, name, number)
    end)
end)

-- RegisterNetEvent('getContacts')
-- AddEventHandler('getContacts', function(identifier, opt)
--     local src = source

--     local xPlayer = ESX.GetPlayerFromId(src)
--     local myIdent = xPlayer.getIdentifier()

--     MySQL.Async.fetchAll('SELECT * FROM phone_contacts WHERE identifier = @identifier', { ['@identifier'] = myIdent }, function(contacts)
--         TriggerClientEvent('phone:loadContacts', src, contacts)
--     end)
-- end)

RegisterNetEvent('phone:getContacts')
AddEventHandler('phone:getContacts', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local myIdent = xPlayer.getIdentifier()

    if (xPlayer == nil) then
        TriggerClientEvent('phone:loadContacts', src, json.encode({}))
        print('no contacts')
    else
        local contacts = getContacts(myIdent, function(contacts)
            if (contacts) then
                TriggerClientEvent('phone:loadContacts', src, contacts)
            else
                print('no contacts 2')
                TriggerClientEvent('phone:loadContacts', src, {})
            end
        end)
    end
end)

function getMessagesBetweenUsers(sender, recipient, callback)
    exports.ghmattimysql:execute("SELECT id, sender, receiver, message, date FROM user_messages WHERE (receiver = @from OR sender = @from) and (receiver = @to or sender = @to)", {
    ['from'] = sender,
    ['to'] = recipient
    }, function(result) callback(result) end)
end

function saveSMS(receiver, sender, message, callback)
    -- Receiver and Sender are phone numbers, not id's or identifier
    exports.ghmattimysql:execute("INSERT INTO phone_messages (`receiver`, `sender`, `message`) VALUES (@receiver, @sender, @msg)",
    {['receiver'] = tonumber(receiver), ['sender'] = tonumber(sender), ['msg'] = message}, function(rowsChanged)
        exports.ghmattimysql:execute("SELECT id FROM phone_messages WHERE receiver = @receiver AND sender = @sender AND message = @msg",
    {['receiver'] = tonumber(receiver), ['sender'] = tonumber(sender), ['msg'] = message}, function(result) if callback then callback(result) end end)
    end)
end


-- Contact Queries
function getContacts(identifier, callback)
    exports.ghmattimysql:execute("SELECT name,number FROM phone_contacts WHERE identifier = @identifier ORDER BY name ASC", {
        ['identifier'] = identifier
    }, function(result) callback(result) end)
end

-- function saveContact(identifier, name, number)
--     execute.ghmattimysql:execute("INSERT INTO phone_contacts (`identifier`, `name`, `number) VALUES (@identifier, @name, @number)", 
--     {['identifier'] = identifier, ['name'] = name, ['number'] = tonumber(number)})
-- end



-- function removeContact(identifier, name, number)
--     -- Remove the contact to our users list
--     exports.ghmattimysql:execute("DELETE FROM phone_contacts WHERE identifier = @identifier AND name = @name AND number = @number", {['identifier'] = identifier, ['name'] = name, ['number'] = tonumber(number)
--     })
-- end

RegisterNetEvent('getNM')
AddEventHandler('getNM', function(pNumber)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local pNumber = getNumberPhone(xPlayer.getIdentifier())
    TriggerClientEvent("client:updatePNumber",src,pNumber)
end)

RegisterNetEvent('phone:deleteCP')
AddEventHandler('phone:deleteCP', function(number, adv)
    local xPlayer = ESX.GetPlayerFromId(source)
    local src = source
    local myNumber = getNumberPhone(xPlayer.getIdentifier())
    print(number,adv)
    MySQL.Async.execute('DELETE FROM phone_cp WHERE phoneNumber = @phoneNumber AND advert = @advert', {
        ['@phoneNumber'] = number,
        ['@advert'] = adv
    }, function (result)
        
        TriggerClientEvent('refreshCP', src)
    end)
end)


RegisterNetEvent('phone:deleteYP')
AddEventHandler('phone:deleteYP', function(number)
    local xPlayer = ESX.GetPlayerFromId(source)
    local src = source
    local myNumber = getNumberPhone(xPlayer.getIdentifier())
    MySQL.Async.execute('DELETE FROM phone_yp WHERE phoneNumber = @phoneNumber', {
        ['@phoneNumber'] = myNumber
    }, function (result)
        TriggerClientEvent('refreshYP', src)
  
    end)
end)

--[[ Phone calling stuff ]]

function getNumberPhone(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.phone_number FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end
function getIdentifierByPhoneNumber(phone_number) 
    local result = MySQL.Sync.fetchAll("SELECT users.identifier FROM users WHERE users.phone_number = @phone_number", {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].identifier
    end
    return nil
end

RegisterServerEvent('requestPing')
AddEventHandler('requestPing', function(target, x,y,z, pIsAnon)
    local src = source
    --local player = exports["np-base"]:getModule("Player"):GetUser(src) --getting id xPlayer.GetPlayerID
    --local char = player:getCurrentCharacter()  -- getting character name
    -- local playername = ""..char.firstname.." "..char.last_name"
    TriggerClientEvent('AllowedPing', tonumber(target), x,y,z, src, name, pIsAnon)
end)

RegisterServerEvent('pingAccepted')
AddEventHandler('pingAccepted', function(target)
    local target = tonumber(target)
    TriggerClientEvent('SendAlert', target, "You ping was accepted!", 5)
end)

RegisterServerEvent('pingDeclined')
AddEventHandler('pingDeclined', function(target)
    local target = tonumber(target)
    TriggerClientEvent('SendAlert', target, "You ping was declined!", 5)
end)


--Calling Taxi /taxi
-- RegisterServerEvent('phone:callAiTaxi')
-- AddEventHandler('phone:callAiTaxi', function(src)
--     local src = tonumber(src)
--     local activeTaxi = exports["np-base"]:getModule("jobManager"):CountJob("taxi")
--     local user = exports["np-base"]:getModule("Player"):GetUser(src)
--     if activeTaxi ~= 0 then
--         if tonumber( user:getCash()) < 250 then
--             TriggerClientEvent("SendAlert", src, "You need $250 to do this as a players is logged in as taxi.",2)
--                 return
--             end
--             user:removeMoney(250)
--         end
--         TriggerClientEvent("startAITaxi",src)
-- end)

RegisterNetEvent('phone:callContact')
AddEventHandler('phone:callContact', function(targetnumber, toggle)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local targetIdentifier = getIdentifierByPhoneNumber(targetnumber)
    local xPlayers = ESX.GetPlayers()
    local srcIdentifier = xPlayer.getIdentifier()
    local srcPhone = getNumberPhone(srcIdentifier)

    TriggerClientEvent('phone:initiateCall', src, src)
    
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
          if xPlayer.identifier == targetIdentifier then
            playerID = xPlayer.source
          end
        end
    end
    TriggerClientEvent('phone:receiveCall', playerID, targetnumber, src, srcPhone)

    local callcontact = {
        {
            ["color"] = 16711680,
            ["title"] = "Dead Success RP",
            ["description"] = "Player: **" .. GetPlayerName(src) .. "**\n Steam Hex: **" .. GetPlayerIdentifier(src) .. "**\n Called:  **"..targetIdentifier.. '**',
            ["footer"] = {
                ["text"] = 'DSRP',
            },
        }
    }
    PerformHttpRequest('https://discord.com/api/webhooks/788344562506137602/4tx4owaWtlN9rHYjQw-x2ge1N32q_6aGa0eGhK6HF79swYt_WzpjczdbTmh9L11UkIl_', function(err, text, headers) end, 'POST', json.encode({username = "Phone Calls", embeds = callcontact}), {['Content-Type'] = 'application/json'})


end)

RegisterNetEvent('phone:messageSeen')
AddEventHandler('phone:messageSeen', function(id)
    id = tonumber(id)
    if id ~= nil then
        exports.ghmattimysql:execute("UPDATE phone_messages SET seen = 1 WHERE id = @id", {['id'] = tonumber(id)})
    end
end)

RegisterNetEvent('phone:getSMS')
AddEventHandler('phone:getSMS', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local mynumber = getNumberPhone(xPlayer.identifier)

    local result = MySQL.Sync.fetchAll("SELECT * FROM phone_messages WHERE receiver = @mynumber OR sender = @mynumber ORDER BY id DESC", {['@mynumber'] = mynumber})

    local numbers ={}
    local convos = {}
    local valid
    if result ~= nil then
    for k, v in pairs(result) do
        valid = true
        if v.sender == mynumber then
            for i=1, #numbers, 1 do
                if v.receiver == numbers[i] then
                    valid = false
                end
            end
            if valid then
                table.insert(numbers, v.receiver)
            end
        elseif v.receiver == mynumber then
            for i=1, #numbers, 1 do
                if v.sender == numbers[i] then
                    valid = false
                end
            end
            if valid then
                table.insert(numbers, v.sender)
            end
        end
    end
    
    for i, j in pairs(numbers) do
        for g, f in pairs(result) do
            if j == f.sender or j == f.receiver then
                table.insert(convos, {
                    id = f.id,
                    sender = f.sender,
                    receiver = f.receiver,
                    message = f.message,
                    date = f.date
                })
                break
            end
        end
    end

        local data = ReverseTable(convos)
        TriggerClientEvent('phone:loadSMS', src, data, mynumber)
    else

        TriggerClientEvent('phone:loadSMS', src, {}, mynumber)
    end
 
end)

function ReverseTable(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

-- function getIdentifierFromPhone(number, callback)
--     --Get a users identifier from a phone number
--     exports.ghmattimysql.execute("SELECT identifier FROM users WHERE phone_number = @number", {['number'] = tonumber(number)}, function(result)
--         if #result == 0 then
--             callback(nil)
--         else
--             if(result[1].identifier ~= '') then
--                 callback(result[1].identifier)
--             else
--                 callback(nil)
--             end
--         end
--     end)
-- end

-- function reverse(tbl)
--     for i=1, math.floor(#tbl / 2) do
--         tbl[1], tbl[#tbl - i + 1] - tbl[#tbl - i + 1], tbl[i]
--     end
--     return tbl
-- end

-- SetTimeout(5000, requestStockChangeTable)

-- SetTimeout(600000, stockvalueincrease)

-- local activePhoneNumbers = {

-- }
-- local activeUsers = {}

RegisterServerEvent('phone:getServerTime')
AddEventHandler('phone:getServerTime', function()
    local src= source
    TriggerClientEvent('phone:setServerTime', src, os.date('%H:%M:%S', os.time()))
end)

RegisterNetEvent('phone:sendSMS')
AddEventHandler('phone:sendSMS', function(receiver, message)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local mynumber = getNumberPhone(xPlayer.identifier)

    local target = getIdentifierByPhoneNumber(receiver)
    
    local xPlayers = ESX.GetPlayers()
    --if receiver ~= mynumber then
    MySQL.Async.execute('INSERT INTO phone_messages (sender, receiver, message) VALUES (@sender, @receiver, @message)', {
        ['@sender'] = mynumber,
        ['@receiver'] = receiver,
        ['@message'] = message
    }, function(result)
    end)
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
            if xPlayer.identifier == target then
                local receiverID = xPlayer.source
                TriggerClientEvent('phone:newSMS', receiverID, 1, mynumber)
                TriggerClientEvent('SendAlert', src, "Messege send.", 16)
            end
        end
    end

end)

RegisterNetEvent('phone:serverGetMessagesBetweenParties')
AddEventHandler('phone:serverGetMessagesBetweenParties', function(sender, receiver, displayName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local mynumber = getNumberPhone(xPlayer.identifier)
    local result = MySQL.Sync.fetchAll("SELECT * FROM phone_messages WHERE (sender = @sender AND receiver = @receiver) OR (sender = @receiver AND receiver = @sender) ORDER BY id ASC", {['@sender'] = sender, ['@receiver'] = receiver})

    TriggerClientEvent('phone:clientGetMessagesBetweenParties', src, result, displayName, mynumber)
end)

RegisterNetEvent('phone:StartCallConfirmed')
AddEventHandler('phone:StartCallConfirmed', function(mySourceID)
    local channel = math.random(10000, 99999)
    local src = source

    TriggerClientEvent('phone:callFullyInitiated', mySourceID, mySourceID, src)
    TriggerClientEvent('phone:callFullyInitiated', src, src, mySourceID)

    -- After add them to the same channel or do it from server.
    TriggerClientEvent('phone:addToCall', source, channel)
    TriggerClientEvent('phone:addToCall', mySourceID, channel)

    TriggerClientEvent('phone:id', src, channel)
    TriggerClientEvent('phone:id', mySourceID, channel)
end)

-- local activeCalls = {}

-- local function StartCall(caaler, callee)
--     local callId = caller + 101 --avoid idx 1 - 100
--     TriggerClientEvent('Tokovoip:addPlayerToRadio', caller, callId)
--     TriggerClientEvent('Tokovoip:addPlayerToRadio', callee, callId)
--     TriggerClientEvent('phone:id', caller, callId)
--     TriggerClientEvent('phone:id', callee, callId)
-- end

-- RegisterNetEvent('phone:EndCall')
-- AddEventHandler('phone:EndCall', function(mySourceID, callId)
--     TriggerClientEvent("phone:otherClientEndCall", tonumber(mySourceID))
--     TriggerClientEvent("phone:ResetRadioChannel", source)
-- end)

-- TriggerEvent("ResetRadioChannel")
-- RegisterNetEvent('phone:ResetRadioChannel')
-- AddEventHandler('phone:ResetRadioChannel', function(mySourceID)
--     local pn = tonumber(mySourceID)
--     local src = tonumber(source)

--     StartCall(src, pn)
--     TriggerClientEvent('phone:callFullyInitiated',pn,pn,src)
-- end)

RegisterNetEvent('phone:EndCall')
AddEventHandler('phone:EndCall', function(mySourceID, stupidcallnumberidk, somethingextra)
    local src = source
    TriggerClientEvent('phone:removefromToko', source, stupidcallnumberidk)

    if mySourceID ~= 0 or mySourceID ~= nil then
        TriggerClientEvent('phone:removefromToko', mySourceID, stupidcallnumberidk)
        TriggerClientEvent('phone:otherClientEndCall', mySourceID)
    end

    if somethingextra then
        TriggerClientEvent('phone:otherClientEndCall', src)
    end
end)

RegisterCommand("answer", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('phone:answercall', src)
end, false)

RegisterCommand("a", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('phone:answercall', src)
end, false)

RegisterCommand("h", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('phone:endCalloncommand', src)
end, false)


RegisterCommand("hangup", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('phone:endCalloncommand', src)
end, false)

RegisterCommand("lawyer", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('yellowPages:retrieveLawyersOnline', src, true)
end, false)
RegisterCommand("ph", function(source, args, rawCommand)
     local src = source
     local xPlayer = ESX.GetPlayerFromId(src)
     local identifier = xPlayer.getIdentifier()
     local srcPhone = getNumberPhone(identifier)


   TriggerClientEvent('sendMessagePhoneN', src, srcPhone)
 end, false)

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

AddEventHandler('es:playerLoaded',function(source)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    getOrGeneratePhoneNumber(sourcePlayer, identifier, function (myPhoneNumber)
    end)
end)

function getOrGeneratePhoneNumber (sourcePlayer, identifier, cb)
    local sourcePlayer = sourcePlayer
    local identifier = identifier
    local myPhoneNumber = getNumberPhone(identifier)
    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = getIdentifierByPhoneNumber(myPhoneNumber)
        until id == nil
        MySQL.Async.insert("UPDATE users SET phone_number = @myPhoneNumber WHERE identifier = @identifier", {
            ['@myPhoneNumber'] = myPhoneNumber,
            ['@identifier'] = identifier
        }, function ()
            cb(myPhoneNumber)
        end)
    else
        cb(myPhoneNumber)
    end
end

function getPhoneRandomNumber()
    local numBase0 = 4
    local numBase1 = math.random(10,99)
    local numBase2 = math.random(100,999)
    local numBase3 = math.random(1000,9999)
    local num = string.format(numBase0 .. "" .. numBase1 .. "" .. numBase2 .. "" .. numBase3)
    return num
end

RegisterNetEvent('message:inDistanceZone')
AddEventHandler('message:inDistanceZone', function(somethingsomething, messagehueifh)
    local src = source		
    local first = messagehueifh:sub(1, 3)
    local second = messagehueifh:sub(4, 6)
    local third = messagehueifh:sub(7, 11)

    local msg = first .. "-" .. second .. "-" .. third
	TriggerClientEvent('chat:addMessage', somethingsomething, {
		template = '<div style = "display: inline-block !important;padding: 0.6vw;padding-top: 0.6vw;padding-bottom: 0.7vw;margin: 0.1vw;margin-left: 0.4vw;border-radius: 10px;background-color: #be6112d9;width: fit-content;max-width: 100%;overflow: hidden;word-break: break-word;"><b>Phone</b>: #{1}</div>',
		args = { fal, msg }
	})
end)

RegisterNetEvent('message:tome')
AddEventHandler('message:tome', function(messagehueifh)
    local src = source		
    local first = messagehueifh:sub(1, 3)
    local second = messagehueifh:sub(4, 6)
    local third = messagehueifh:sub(7, 11)

    local msg = first .. "-" .. second .. "-" .. third
	TriggerClientEvent('chat:addMessage', src, {
		template = '<div style = "display: inline-block !important;padding: 0.6vw;padding-top: 0.6vw;padding-bottom: 0.7vw;margin: 0.1vw;margin-left: 0.4vw;border-radius: 10px;background-color: #be6112d9;width: fit-content;max-width: 100%;overflow: hidden;word-break: break-word;"><b>Phone</b>: #{1}</div>',
		args = { fal, msg }
	})
end)




-- function getIdentity(target)
-- 	local identifier = GetPlayerIdentifiers(target)[1]
-- 	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
-- 	if result[1] ~= nil then
-- 		local identity = result[1]

-- 		return {
-- 			firstname = identity['firstname'],
-- 			lastname = identity['lastname'],
-- 		}
-- 	else
-- 		return nil
-- 	end
-- end

--[[ Others ]]
--[[]]
RegisterNetEvent('getAccountInfo')
AddEventHandler('getAccountInfo', function()
    local src = source
    local player = ESX.GetPlayerFromId(source)

    local money = player.getMoney()
    local inbank = player.getBank()
    local licenceTable = {}

    TriggerEvent('esx_license:getLicenses', source, function(licenses)
        licenceTable = licenses
    end)

    Citizen.Wait(100)

    -- print(licenceTable)
    
    TriggerClientEvent('getAccountInfo', src, money, inbank, licenceTable)
end)


--]]
--[[ Yellow Pages ]]

RegisterNetEvent('getYP')
AddEventHandler('getYP', function()
    local source = source
    MySQL.Async.fetchAll('SELECT * FROM phone_yp LIMIT 30', {}, function(yp)
        local deorencoded = json.encode(yp)
       -- print(json.encode(yp))
        --TriggerClientEvent('YellowPageArray', source, yp)
        TriggerClientEvent('YellowPageArray', -1, yp)
        TriggerClientEvent('YPUpdatePhone', source)
    end)
    --[[
    if userjob == "police" or userjob == "ems" then
        emergencyofficer = true
    end

    YellowPageArray[#YellowPageArray + 1] = {
        ["name"] = name,
        ["job"] = job,
        ["phonenumber"] = phonenumber,
        ["emergencyofficer"] = emergencryoffer,
        ["src"] = src
    }
    TriggerClientEvent('YellowPageArray', -1, YellowPageArray)
    TriggerClientEvent('YPUpdatePhone,src')
    ]]
end)

RegisterNetEvent('getCP')
AddEventHandler('getCP', function()
    local source = source
    MySQL.Async.fetchAll('SELECT * FROM phone_cp LIMIT 30', {}, function(yp)
        local deorencoded = json.encode(yp)
        TriggerClientEvent('CriminalPageArray', source, yp)
    end)
end)

RegisterNetEvent('phone:updatePhoneJob')
AddEventHandler('phone:updatePhoneJob', function(advert)
    --local handle = handle
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local mynumber = getNumberPhone(xPlayer.identifier)
    local name = getIdentity(src)

    fal = name.firstname .. " " .. name.lastname

    MySQL.Async.execute('INSERT INTO phone_yp (name, advert, phoneNumber) VALUES (@name, @advert, @phoneNumber)', {
        ['@name'] = fal,
        ['@advert'] = advert,
        ['@phoneNumber'] = mynumber
    }, function(result)
        TriggerClientEvent('refreshYP', src)
    end)
end)

RegisterNetEvent('phone:SubmitMsgCP')
AddEventHandler('phone:SubmitMsgCP', function(advert)
    --local handle = handle
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local mynumber = getNumberPhone(xPlayer.identifier)
    local name = getIdentity(src)

    fal = name.firstname .. " " .. name.lastname

    MySQL.Async.execute('INSERT INTO phone_cp (name, advert, phoneNumber) VALUES (@name, @advert, @phoneNumber)', {
        ['@name'] = fal,
        ['@advert'] = advert,
        ['@phoneNumber'] = mynumber
    }, function(result)
        TriggerClientEvent('refreshCP', src)
    end)
end)

RegisterNetEvent('phone:foundLawyer')
AddEventHandler('phone:foundLawyer', function(name, phoneNumber)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style = "display: inline-block !important;padding: 0.6vw;padding-top: 0.6vw;padding-bottom: 0.7vw;margin: 0.1vw;margin-left: 0.4vw;border-radius: 10px;background-color: #1e2dff9c;width: fit-content;max-width: 100%;overflow: hidden;word-break: break-word;"><b>YP</b>: ⚖️ {0} ☎️ {1}</div>',
        args = { name, phoneNumber }
    })
end)

RegisterNetEvent('phone:foundLawyerC')
AddEventHandler('phone:foundLawyerC', function(name, phoneNumber)
    local src = source
    TriggerClientEvent('chat:addMessage', src, {
        template = '<div style = "display: inline-block !important;padding: 0.6vw;padding-top: 0.6vw;padding-bottom: 0.7vw;margin: 0.1vw;margin-left: 0.4vw;border-radius: 10px;background-color: #1e2dff9c;width: fit-content;max-width: 100%;overflow: hidden;word-break: break-word;"><b>YP</b>: ⚖️ {0} ☎️ {1}</div>',
        args = { name, phoneNumber }
    })
end)

RegisterNetEvent('deleteAllYP')
AddEventHandler('deleteAllYP', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local src = source
    MySQL.Async.execute('DELETE FROM phone_yp', {}, function (result) end)
 --   MySQL.Async.execute('DELETE FROM tweets', {}, function (result) end)
end)

RegisterServerEvent('tp:checkPhoneCount')
AddEventHandler('tp:checkPhoneCount', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	--if xPlayer.getInventoryItem('phone').count >= 1 then
		TriggerClientEvent('tp:heHasPhone', _source)
    -- else 
    --     TriggerClientEvent('SendAlert', _source, 'You dont have a phone, Buy one at your local store', 2)
     
    -- end
end)



RegisterServerEvent('testdispatch')
AddEventHandler('testdispatch', function()
    print('test dispatch')
end)

--Racing
local BuiltMaps = {}
local Races = {}

RegisterServerEvent('racing-global-race')
AddEventHandler('racing-global-race', function(map,laps,counter,reverseTrack,uniqueid,cid,raceName, startTime, mapCreator, mapDistance, mapDescription, street1, street2)
    Races[uniqueid] = { ["identifier"] = uniqueid, ["map"] = map, ["laps"] = laps, ["counter"] = counter, ["reverseTrack"] = reverseTrack, ["cid"] = cid, ["racer"] = {}, ["open"] = true, ["startTime"] = startTime, ["mapCreator"] = mapCreator, ["mapDistance"] = mapDistance, ["mapDescription"] = mapDescription, ["street1"] = street1, ["street2"] = street2 }
    TriggerEvent('racing:server:sendData', uniqueid, -1, 'event', 'open')
    local waitperiod = (counter * 1000)
    Wait(waitperiod)
    Races[uniqueid]["open"] = false
    if(math.random(1,10) >= 5) then
        TriggerEvent("dispatch:svNotify", {
            dispatchCode = "10-94",
            firstStreet = street1,
            secondStreet = street2,
            origin = {
                x = BuiltMaps[map]["checkpoint"][1].x,
                y = BuiltMaps[map]["checkpoint"][1].y,
                z = BuiltMaps[map]["checkpoint"][1].z
            }

        })
    end
    TriggerClientEvent('racing:server:sendData', uniqueid, -1, 'event', 'close')
end)

function GetCharacterName(source)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] and result[1].firstname and result[1].lastname then
		return ('%s %s'):format(result[1].firstname, result[1].lastname)
	end
end


RegisterServerEvent('racing-join-race')
AddEventHandler('racing-join-race', function(identifier)
    local src = source
    local cid = xPlayer.cid
    local realname = GetCharacterName(source)
    local playername = GetCharacterName(source)
    Races[identifier]["racers"][cid] = { ["name"] = playername, ["cid"] = cid, ["total"] = 0, ["fastest"] = 0}
    TriggerEvent('racing:server:sendData', identifier, src, 'event')
end)

RegisterServerEvent('race:completed2')
AddEventHandler('race:completed2', function(fasterlap, overall, sprint, identifier)
    local src = source
    local cid = xPlayer.cid
    local playername = GetCharacterName(source)
    Races[identifier]["racers"][cid] = { ["name"] = playername, ["cid"] = cid, ["total"] = overall, ["fastest"] = fastestlap}
    Races[identifier].raceEnding = os.time()+5
    Races[identifier].sprint = sprint
    TriggerEvent('racing:server:sendData', identifier, -1, 'event')
end)

Citizen.CreateThread(function()
    while true do
        for index, race in pairs(Races) do
            if(race.finished == false) then
                local countRacers = #race["racers"]
                local finishedRacers = -1;
                local currFast = -1
                local fastestObject = {}
                for k,v in pairs(race["racers"]) do
                    if(v.total ~= 0 and finishedRacers ~= countRacers) then
                        finishedRacers = finishedRacers + 1
                        local potentialFast = race.sprint and v.total or v.fastest
                        if currFast == -1 or potentialFast < currFast then
                            fastestObject = v
                        end
                    end
                end
                if (countRacers == finishedRacers) then
                    race.finished = true
                    race.fastest = fastestObject
                end
                if(race.finished == false) then
                    if(race.raceEnding ~= nil) then
                        if os.time() >= race.raceEnding then
                            race.finished = true
                            if(race.fastest ~= falase or race.fastest ~= -1) then
                                race.fastest = fastestObject
                            end
                        end
                    end
                end
            elseif(race.finished == true and race.saved == false) then
                if((race.sprint and race.fastest.total ~= 0) or (not race.sprint and race.fastest.fastest ~= 0)) then
                    exports.ghmattimysql:exports("UPDATE racing_tracks SET races = races+1 WHERE id = @id", {
                        ['id'] = race.map
                    })
                    Wait(300)
                    local updateString = "";
                    if(race.sprint) then
                        updateString = "UPDATE racing_tracks SET fastest_sprint = @fastest_lap, fastest_sprint_name = @fastestLapName WHERE id = @id and (fastest_lap = -1 or fatest_lap > @fastestLap)"
                    else
                        updateString = "UPDATE racing_tracks SET fastest_lap = @fastestLap, fastest_name = @fastestLapName WHERE id = @id and (fastest_lap = -1 or fatest_lap > @fastestLap)"
                    end 
                    exports.ghmattimysql:execute(updateString, {
                        ['fastestLap'] = (race.sprint and race.fastest.total or race.fastest.fastest),
                        ['fastestLapName'] = race.fastest.name,
                        ['id'] = race.map
                    })
                end
                race.saved = trueend
                end
            end
        Citizen.Wait(10000)
    end
end)

RegisterServerEvent('racing:server:sendData')
AddEventHandler('racing:server:sendData', function(pEventId, clientId, changeType,pSubEvent)
local dataObject = {
    eventId = pEventId,
    event = changeType,
    subEvent = pSubEvent,
    data = {}
}
    if (changeType == "event") then
        dataObject.data = (pEventId == -1 and Races[pEventId] or Races)
    elseif (changeType == "map") then
        dataObject.data = (pEventId == -1 and BuiltMaps[pEventId] or BuiltMaps)
    end
    TriggerClientEvent("racing:data:set", clientId, dataObject)
end)

function buildMaps(subEvent,src)
    local src = source
    print(subEvent)
    subEvent = subEvent or nil
    BuiltMaps = {}
    exports.ghmattimysql:execute("SELECT * FROM racing_tracks", {}, function(result)
      
        for i = 1, #result do
            local correctId = tostring(result[i].id)
            print(correctId)
            BuiltMaps[correctId] = {
                checkPoints = json.decode(result[i].checkPoints),
                track_name = result[i].track_name,
                creator = result[i].creater,
                distance = result[i].distance,
                races = result[i].races,
                fastest_car = result[i].fastest_car,
                fastest_name = result[i].fastest_name,
                fastest_lap = result[i].fastest_lap,
                fastest_sprint = result[i].fastest_sprint,
                fastest_sprint_name = result[i].fastest_sprint_name,
                description = result[i].description,
            }
            print(json.encode(BuiltMaps[correctId]))
        end
        local target = -1
        if(subEvent == 'mapupdate' or subEvent == 'noNUI') then
            target = src
        end
        TriggerEvent('racing:server:sendData', -1, target, 'map', subEvent)
    end)
end

RegisterServerEvent('racing-build-maps')
AddEventHandler('racing-build-maps', function()
    print('print in server')
    local src = source 
    buildMaps('mapUpdate', src)
end)

RegisterServerEvent('racing-map-delete')
AddEventHandler('racing-map-delete', function()
    exports.ghmattimysql:execute("DELETE FROM racing_tracks WHERE id = @id", {
        ['id'] = deleteID
    })
    Wait(1000)
    buildMaps('kevin', src)
end)

RegisterServerEvent('racing-retreive-maps')
AddEventHandler('racing-retreive-maps', function()
    local src = source
    buildMaps('noNUI', src)
end)

RegisterServerEvent('racing-save-map')
AddEventHandler('racing-save-map', function(currentMap, name, description, distanceMap)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local cid = xPlayer.cid
    local playername = xPlayer.getName()
    exports.ghmattimysql:execute("INSERT INTO racing_tracks (`currentMap`, `creator`, `track_names`, `description`) VALUES (@currentMap, @creator, @trackname, @distance, @description)",
        {['currentMap'] = json.encode(currentMap), ['creator'] = playername, ['trackname'] = name, ['distance'] = distanceMap, ['description'] = description})

--[[        MySQL.Async.insert('INSERT INTO `racing_tracks` (`checkpoints`, `creator`, `track_names`) VALUES (@checkpoints, @creator, @trackname)', {
            ['@checkpoints'] = json.encode(currentMap),
            ['@creator'] = playername,
            ['@trackname'] = name,
        })]]--

    Wait(1000)
    buildMaps()
end)


RegisterCommand("payphone", function(source, args, raw)
    local src = source
    local pnumber = args[1]
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.get('money') >= 25 then
        TriggerClientEvent('phone:makepayphonecall', src, pnumber)
        xPlayer.removeMoney(25)
    else
        TriggerClientEvent('SendAlert', _source, 'You dont have $25 for the payphone', 2)
       
    end
end, false)


RegisterServerEvent('phone:RemovePhoneJobSourceSend')
AddEventHandler('phone:RemovePhoneJobSourceSend', function(srcsent)
    local src = srcsent
    for i = 1, #YellowPageArray do
        if YellowPageArray[i]
        then 
          local a = tonumber(YellowPageArray[i]["src"])
          local b = tonumber(src)

          if a == b then
            table.remove(YellowPageArray,i)
          end
        end
    end
    TriggerClientEvent("YellowPageArray", -1 , YellowPageArray)
end)

RegisterServerEvent('phone:RemovePhoneJob')
AddEventHandler('phone:RemovePhoneJob', function()
    local src = srcsent
    for i = 1, #YellowPageArray do
        if YellowPageArray[i]
        then 
          local a = tonumber(YellowPageArray[i]["src"])
          local b = tonumber(src)

          if a == b then
            table.remove(YellowPageArray,i)
          end
        end
    end
    TriggerClientEvent("YellowPageArray", -1 , YellowPageArray)
    TriggerClientEvent("YPUpdatePhone",src)
end)

-- RegisterServerEvent('phone:updatePhoneJob')
-- AddEventHandler('phone:updatePhoneJob', function(job)
--     local job = job
--     if source == nil then
--         return
--     end
--     local src = source
--     local jobout = ""

--     for i = 1, #YellowPageArray do
--         if YellowPageArray[i] ~= nil
--         then
--             if tonumber(YellowPageArray[i]["src"]) == tonumber(src) then
--                 table.remove(YellowPageArray,i)
--             end
--         end

 --   local player = --getting id here
 --  local phonenumbner = get number here
 -- local userjob = false
 -- local name = --name here and last name
 --userjob = -- get job here
 --[[
     if userjob == "police" or userjob == "ems" then
        emergencyofficer = true
    end

    YellowPageArray[#YellowPageArray + 1 ] = {
        ["name"] = name,
        ["name"] = job,
        ["name"] = phonenumber,
        ["name"] = emergencyofficer,
        ["name"] = src
    }

    TriggerClientEvent('YellowPageArray', -1, YellowPageArray)
    TriggerClientEvent('YPUpdatePhone', src)

 ]]
-- end)
