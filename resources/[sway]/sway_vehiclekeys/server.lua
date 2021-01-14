local vehicleKeys = {}
local myVehicleKeys = {}

esx = nil

TriggerEvent('esx:getSharAVACedObject', function(obj)
 esx = obj
end)

local robbableItems = {
 [1] = {chance = 3, id = 0, name = 'Cash', quantity = math.random(30, 75)}, -- really common
 [2] = {chance = 5, id = 1, name = 'Keys', isWeapon = false}, -- rare
}

RegisterServerEvent('garage:searchItem')
AddEventHandler('garage:searchItem', function(plate)
 local source = tonumber(source)
 local item = {}
 local xPlayer = esx.GetPlayerFromId(source)
 local ident = xPlayer.getIdentifier()

  item = robbableItems[math.random(1, #robbableItems)]
  if math.random(1, 10) >= item.chance then
   if tonumber(item.id) == 0 then
    xPlayer.addMoney(item.quantity)
    TriggerClientEvent('notification', source, 'You found $'..item.quantity)
   elseif item.isWeapon then
    xPlayer.addWeapon(item.id, 50)
    TriggerClientEvent('notification', source, 'Item Added!', 2)
   elseif tonumber(item.id) == 1 then
    TriggerClientEvent('notification', source, 'You have found the keys to the vehicle!', 1)
    vehicleKeys[plate] = {}
    table.insert(vehicleKeys[plate], {id = ident})
    TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident)
    TriggerClientEvent('vehicle:start', source)
   else
    xPlayer.addInventoryItem(item.id, item.quantity)
    TriggerClientEvent('notification', source, 'Item Added!', 2)
   end
  end
end)

RegisterServerEvent('garage:giveKey')
AddEventHandler('garage:giveKey', function(target, plate)
 local targetSource = tonumber(target)
 local xPlayer = esx.GetPlayerFromId(targetSource)
 local ident = xPlayer.getIdentifier()
 local xPlayer2 = esx.GetPlayerFromId(source)
 local ident2 = xPlayer2.getIdentifier()
 local plate = tostring(plate)

 vehicleKeys[plate] = {}
 table.insert(vehicleKeys[plate], {id = ident})
 TriggerClientEvent('notification', targetSource, 'You just recieved keys to a vehicle', 1)
 TriggerClientEvent('garage:updateKeys', targetSource, vehicleKeys, ident)
 TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident2)
end)

RegisterServerEvent('garage:addKeys')
AddEventHandler('garage:addKeys', function(plate)
 local source = tonumber(source)
 local xPlayer = esx.GetPlayerFromId(source)
 local ident = xPlayer.getIdentifier()

 if vehicleKeys[plate] ~= nil then
  table.insert(vehicleKeys[plate], {id = ident})
  TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident)
 else
  vehicleKeys[plate] = {}
  --print(vehicleKeys[plate])
  table.insert(vehicleKeys[plate], {id = ident})
  TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident)
 end
end)

RegisterServerEvent('garage:removeKeys')
AddEventHandler('garage:removeKeys', function(plate)
 local source = tonumber(source)
 local xPlayer = esx.GetPlayerFromId(source)
 local ident = xPlayer.getIdentifier()
 if vehicleKeys[plate] ~= nil then
  for id,v in pairs(vehicleKeys[plate]) do
   if v.id == ident then
    table.remove(vehicleKeys[plate], id)
   end
  end
 end
 TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident)
end)

RegisterServerEvent('removelockpick')
AddEventHandler('removelockpick', function()
 local source = tonumber(source)
 local xPlayer = esx.GetPlayerFromId(source)
 if math.random(1, 20) == 1 then
  xPlayer.removeInventoryItem("lockpick", 1)
  TriggerClientEvent('notification', source, 'The lockpick bent out of shape.', 2)
 end
end)

esx.RegisterUsableItem('lockpick', function(source)
 TriggerClientEvent('lockpick:vehicleUse', source, "lockpick")
end)
