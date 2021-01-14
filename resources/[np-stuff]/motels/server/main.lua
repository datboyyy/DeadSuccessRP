ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

RegisterServerEvent('pw-motels:rentRoom')
AddEventHandler('pw-motels:rentRoom', function(room, motel)
 local src = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(src)
 local ident = xPlayer.getIdentifier()
 MySQL.Async.fetchAll('SELECT * FROM pw_motels WHERE motelid = @motelid AND room = @room', {['@motelid'] = motel, ['@room'] = room}, function(spamCheck)
  MySQL.Async.fetchAll('SELECT * FROM pw_motels WHERE ident = @ident', {['@ident'] = ident}, function(motelowner)
   if tonumber(xPlayer.getBank()) >= tonumber(Config.Complexs[motel].price) then
    if motelowner[1] == nil and spamCheck[1] == nil then
     xPlayer.removeAccountMoney('bank', Config.Complexs[motel].price)
     MySQL.Sync.execute('INSERT INTO pw_motels (ident, motelid, room, days_left) VALUES (@ident, @motel, @room, @days_left)', { ["@ident"] = ident, ["@motel"] = motel, ["@room"] = room, ['@days_left'] = 7})
     TriggerClientEvent('notification', src, 'You have rented room '..room..' at '..Config.Complexs[motel].name)
     local motellog = {
        {
            ["color"] = 16711680,
            ["title"] = "Dead Success RP",
            ["description"] = "Player: **" .. GetPlayerName(src) .. "**\n Steam Hex: **" .. GetPlayerIdentifier(src) .. "\n Motel Purchased: ** "..room.. ' at ' ..Config.Complexs[motel].name'**',
            ["footer"] = {
                ["text"] = 'DSRP',
            },
        }
    }
    PerformHttpRequest('https://discord.com/api/webhooks/788344624384704512/SjqhvX6Ua6NifOZV3jhxukSgXzbPmyEvBA72wYNRaYqz9LV7FtmgmADUtfBRmJ3ysQ2A', function(err, text, headers) end, 'POST', json.encode({username = "Motels", embeds = motellog}), {['Content-Type'] = 'application/json'})

     TriggerEvent('pw-motels:updateRooms')
    elseif motelowner[1] ~= nil then
     if motelowner[1].days_left <= 3 then
      if Config.Complexs[motel].name == Config.Complexs[tonumber(motelowner[1].motelid)].name then
       xPlayer.removeAccountMoney('bank', Config.Complexs[motel].price)
       TriggerClientEvent('notification', src, 'Motel room '..room..' at '..Config.Complexs[motel].name..' has been renewed for $'..Config.Complexs[motel].price)
       MySQL.Sync.execute("UPDATE `pw_motels` SET `days_left` = 7 WHERE ident = @ident", {['@ident'] = ident})
      else
       TriggerClientEvent('notification', src, "You can only renew your motel room at "..Config.Complexs[tonumber(motelowner[1].motelid)].name)
      end
     else
      TriggerClientEvent('notification', src, 'You can only renew motel rooms 3 days before it runs out.', 2)
     end
    end
   else
    TriggerClientEvent('notification', src, 'You do not have enough money in the bank.', 2)
   end
  end)
 end)
end)

RegisterServerEvent('pw-motels:cancelRoom')
AddEventHandler('pw-motels:cancelRoom', function(room, motel)
 src = source
 local xPlayer = ESX.GetPlayerFromId(src)
 local ident = xPlayer.getIdentifier()
 for k,v in pairs(Config.Rooms) do
  if tostring(room) == tostring(v.roomno) and motel == v.motelid then
   v.lock = true
   v.owner = nil
   v.ident = nil
  end
 end
 MySQL.Sync.execute('DELETE FROM pw_motels WHERE ident = @ident AND motelid = @motel AND room = @room', { ["@ident"] = ident, ["@motel"] = motel, ["@room"] = room})
 TriggerEvent('pw-motels:updateRooms')
end)

RegisterServerEvent('pw-motels:toggleLock')
AddEventHandler('pw-motels:toggleLock', function(motel, room, lock)
    for k,v in pairs(Config.Rooms) do
        if tostring(room) == tostring(v.roomno) and motel == v.motelid then
            v.lock = lock
        end
    end
    TriggerClientEvent('pw-motels:receiveOwners', -1, Config.Rooms)
end)

ESX.RegisterServerCallback('pw-motels:myIdent', function(source, cb)
    src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local ident = xPlayer.getIdentifier()
    cb(ident)
end)


ESX.RegisterServerCallback('motels:mycash', function(source, cb)
    src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local ident = xPlayer.getBank()
    cb(ident)
end)

RegisterServerEvent('pw-motels:updateRooms')
AddEventHandler('pw-motels:updateRooms', function(source)
    MySQL.Async.fetchAll('SELECT * FROM pw_motels', {}, function(owners)
        for i=1, #owners, 1 do
            local motel = owners[i].motelid
            local room = owners[i].room
            local owner = owners[i].ident
            for k,v in pairs(Config.Rooms) do
                if owners[i].room == tostring(v.roomno) and owners[i].motelid == v.motelid then
                    local xPlayer = ESX.GetPlayerFromIdentifier(owner)
                    if xPlayer then
                        -- Set as Rented, and allocate the users ServerID so they can access it.
                        v.owner = xPlayer.source
                        v.ident = owner
                    else
                        -- Set as Ident so the Motel Room Appears as Rented to Other Players
                        v.owner = owner
                        v.ident = owner
                    end
                end
            end
        end
        TriggerClientEvent('pw-motels:receiveOwners', -1, Config.Rooms)
    end)
end)

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM pw_motels', {}, function(owners)
        for i=1, #owners, 1 do
            local motel = owners[i].motelid
            local room = owners[i].room
            local owner = owners[i].ident
            for k,v in pairs(Config.Rooms) do

               if owners[i].room == tostring(v.roomno) and owners[i].motelid == v.motelid then
                    local xPlayer = ESX.GetPlayerFromIdentifier(owner)
                    if xPlayer then
                        -- Set as Rented, and allocate the users ServerID so they can access it.
                        v.owner = xPlayer.source
                        v.ident = owner
                    else
                        -- Set as Ident so the Motel Room Appears as Rented to Other Players
                        v.owner = owner
                        v.ident = owner
                    end
                end
            end
        end

        TriggerClientEvent('pw-motels:receiveOwners', -1, Config.Rooms)
        forcePush()
    end)

end)

ESX.RegisterServerCallback('pw-motels:checkUserOnline', function(source, cb, motel, room)
    for k,v in pairs(Config.Rooms) do
        if motel == v.motelid and room == v.roomno then
            if v.ident == nil then
                cb(true)
            else
                local xPlayer = ESX.GetPlayerFromIdentifier(v.ident)
                if xPlayer then
                    cb(true)
                else
                    cb(false)
                end
            end
        end
    end
end)
--[[
MySQL.ready(function()
    setupComplete = false
    for k,v in pairs(Config.Rooms) do
        local storageName = nil
        local motelNormal = nil
        local roomNo = nil
        for km, vm in pairs(Config.Complexs) do
            if km == v.motelid then
                local motelname = string.gsub(vm.name, " ", "")
                storageName = motelname..'_'..v.roomno..'_bed'
                motelNormal = string.upper(vm.name)
                roomNo = v.roomno
            end
        end
        Wait(200)
        MySQL.Async.fetchAll('SELECT * FROM addon_account WHERE name = @name', {['@name'] = storageName..'_black_money'}, function(addon_account)
            if addon_account[1] == nil then
                MySQL.Sync.execute("INSERT INTO addon_account (name, label, shared) VALUES (@name, @label, 1)", {['@name'] = storageName..'_black_money', ['@label'] = motelNormal..' Room '..roomNo..' Motel Bed Black Money Storage'})
                setupComplete = true
                Wait(500)
            end
        end)
        Wait(200)
        MySQL.Async.fetchAll('SELECT * FROM addon_inventory WHERE name = @name', {['@name'] = storageName}, function(addon_inventory)
            if addon_inventory[1] == nil then
                MySQL.Sync.execute("INSERT INTO addon_inventory (name, label, shared) VALUES (@name, @label, 1)", {['@name'] = storageName, ['@label'] = motelNormal..' Room '..roomNo..' Motel Bed Storage'})
                setupComplete = true
                Wait(500)
            end
        end)
        Wait(200)
        MySQL.Async.fetchAll('SELECT * FROM datastore WHERE name = @name', {['@name'] = storageName}, function(datastore)
            if datastore[1] == nil then
                MySQL.Sync.execute("INSERT INTO datastore (name, label, shared) VALUES (@name, @label, 1)", {['@name'] = storageName, ['@label'] = motelNormal..' Room '..roomNo..' Motel Bed Datastore Storage'})
                setupComplete = true
                Wait(500)
            end
        end)
    end

    for k,v in pairs(Config.Rooms) do
        local storageName = nil
        local motelNormal = nil
        local roomNo = nil
        for km, vm in pairs(Config.Complexs) do
            if km == v.motelid then
                local motelname = string.gsub(vm.name, " ", "")
                storageName = motelname..'_'..v.roomno
                motelNormal = string.upper(vm.name)
                roomNo = v.roomno
            end
        end

        Wait(200)
        MySQL.Async.fetchAll('SELECT * FROM addon_account WHERE name = @name', {['@name'] = storageName..'_black_money'}, function(addon_account)
            if addon_account[1] == nil then
                MySQL.Sync.execute("INSERT INTO addon_account (name, label, shared) VALUES (@name, @label, 1)", {['@name'] = storageName..'_black_money', ['@label'] = motelNormal..' Room '..roomNo..' Motel Black Money Storage'})
                setupComplete = true
                Wait(1000)
            end
        end)
        Wait(200)
        MySQL.Async.fetchAll('SELECT * FROM addon_inventory WHERE name = @name', {['@name'] = storageName}, function(addon_inventory)
            if addon_inventory[1] == nil then
                MySQL.Sync.execute("INSERT INTO addon_inventory (name, label, shared) VALUES (@name, @label, 1)", {['@name'] = storageName, ['@label'] = motelNormal..' Room '..roomNo..' Motel Storage'})
                setupComplete = true
                Wait(1000)
            end
        end)
        Wait(200)
        MySQL.Async.fetchAll('SELECT * FROM datastore WHERE name = @name', {['@name'] = storageName}, function(datastore)
            if datastore[1] == nil then
                MySQL.Sync.execute("INSERT INTO datastore (name, label, shared) VALUES (@name, @label, 1)", {['@name'] = storageName, ['@label'] = motelNormal..' Room '..roomNo..' Motel Datastore Storage'})
                setupComplete = true
                Wait(1000)
            end
        end)
    end

    Wait(2000)
end)
--]]

function forcePush()
    TriggerEvent('pw-motels:updateRooms')
    SetTimeout(60000, forcePush)
end


AddEventHandler('hotel:check', function(source)
 Wait(1000)
 local src = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(src)
 local ident = xPlayer.getIdentifier()
 MySQL.Async.fetchAll('SELECT * FROM pw_motels WHERE ident = @ident', {['@ident'] = ident}, function(motelowner)
  if motelowner[1] ~= nil then
   if motelowner[1].days_left <= 3 then
    if motelowner[1].days_left ~= 1 then
     TriggerClientEvent('notification', src, 'Motel room '..motelowner[1].room..' at '..Config.Complexs[tonumber(motelowner[1].motelid)].name..' runs out in '..motelowner[1].days_left..' days. Renew it at the reception.')
    else
     TriggerClientEvent('notification', src, 'Motel room '..motelowner[1].room..' at '..Config.Complexs[tonumber(motelowner[1].motelid)].name..' runs out in '..motelowner[1].days_left..' day. Renew it at the reception.')
    end
   end
  end
 end)
end)


local builtRooms = {}

RegisterServerEvent('hotel:createRoom')
AddEventHandler('hotel:createRoom', function(data)
 local source = tonumber(source)
 if builtRooms[data.id] ~= nil and builtRooms[data.id].id ~= nil then
  builtRooms[data.id].people = builtRooms[data.id].people + 1
  TriggerClientEvent('hotel:sendToRoom', source, builtRooms[data.id])
  Wait(700)
  TriggerClientEvent('qb-weathersync:client:DisableSync')
 else
  builtRooms[data.id] = data
  builtRooms[data.id].people = 1
  TriggerClientEvent('hotel:sendToRoom', source, data)
  Wait(700)
  TriggerClientEvent('qb-weathersync:client:DisableSync')
 end
end)

RegisterServerEvent('hotel:deleteRoom')
AddEventHandler('hotel:deleteRoom', function(id)
 local source = tonumber(source)
 if builtRooms[id].people == 1 then
  TriggerClientEvent('hotel:deleteRoom', source, builtRooms[id])
  TriggerClientEvent('qb-weathersync:client:EnableSync')
  Wait(1000)
  builtRooms[id] = nil
 else
  TriggerClientEvent('hotel:deleteRoom', source, builtRooms[id])
  TriggerClientEvent('qb-weathersync:client:EnableSync')
  Wait(1000)
  builtRooms[id].people = builtRooms[id].people - 1
 end
end)




function CronTask(d, h, m)
 MySQL.Async.fetchAll('SELECT * FROM pw_motels', {}, function(res)
  for id,v in pairs(res) do
   if v.days_left > 0 then
    MySQL.Sync.execute("UPDATE `pw_motels` SET `days_left` = days_left-1 WHERE ident = @ident", {['@ident'] = v.ident})
   else
    MySQL.Sync.execute('DELETE FROM pw_motels WHERE ident = @ident AND motelid = @motel AND room = @room', { ["@ident"] = v.ident, ["@motel"] = v.motel, ["@room"] = v.room})
   end
  end
  TriggerEvent('pw-motels:updateRooms')
 end)
end

TriggerEvent('cron:runAt', 22, 00, CronTask)
