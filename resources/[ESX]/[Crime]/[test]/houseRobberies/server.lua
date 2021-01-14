local ESX = nil
local robbableItems = {
 [1] = {chance = 1, id = 0, name = 'Cash', quantity = math.random(1, 89)}, -- really common
 [2] = {chance = 25, id = 'stolen10ctchain', name = 'Oakley Sunglasses (P)', quantity = 1}, -- rare
 [3] = {chance = 5, id = 'lsdtab', name = 'Gameboy (P)', quantity = 1}, -- rare
 [4] = {chance = 5, id = 'rolexwatch', name = 'Casio Watch (P)', quantity = 1}, -- rare
 [5] = {chance = 5, id = 'aluminium', name = 'Nokia Phone (P)', quantity = 1}, -- rare
 [5] = {chance = 5, id = 'mobilephone', name = 'Samsung S8 (P)', quantity = 1}, -- rare
 [6] = {chance = 5, id = 'bandage', name = 'Apple iPhone (P)', quantity = 1}, -- rare
 [7] = {chance = 5, id = 'plastic', name = 'Steel', quantity = 1}, -- rare
 [8] = {chance = 5, id = 'rolexwatch', name = 'Screen', quantity = 1}, -- rare
 [9] = {chance = 5, id = 'badlsdtab', name = 'Scrap Metal', quantity = 1}, -- rare
 [10] = {chance = 5, id = 'copper', name = 'Rubber', quantity = 1}, -- rare
 [11] = {chance = 5, id = 'plastic', name = 'Rolling Paper', quantity = 1}, -- rare
 [12] = {chance = 5, id = 'oxy', name = 'Glass', quantity = 1}, -- rare
 [13] = {chance = 5, id = 'steel', name = 'Fuse', quantity = 1}, -- rare
 [14] = {chance = 5, id = 'rubber', name = 'Clutch', quantity = 1}, -- rare
 [15] = {chance = 5, id = 'electronics', name = 'Battery', quantity = 1}, -- rare
 [16] = {chance = 5, id = 'joint', name = 'Breadboard (P)', quantity = 1}, -- rare
 [17] = {chance = 5, id = '1gcrack', name = 'White Pearl (P)', quantity = 1}, -- rare
 [18] = {chance = 5, id = 'assmeth', name = 'Pistol', quantity = 1}, -- rare
 [19] = {chance = 5, id = 'oxy', name = 'OXY', quantity = 1}, -- rare
 [20] = {chance = 5, id = 'rubber', name = 'Electronics (P)', quantity = 1}, -- rare
 [21] = {chance = 5, id = '1gcocaine', name = 'LockPick', quantity = 1}, -- rare
}

--[[chance = 1 is very common, the higher the value the less the chance]]--

TriggerEvent('esx:getSharAVACedObject', function(obj)
 ESX = obj
end)

ESX.RegisterUsableItem('advancedlockpick', function(source) --Hammer high time to unlock but 100% call cops
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 TriggerClientEvent('houseRobberies:attempt', source, xPlayer.getInventoryItem('advancedlockpick').count)
end)

RegisterServerEvent('houseRobberies:removeLockpick')
AddEventHandler('houseRobberies:removeLockpick', function()
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 TriggerClientEvent("inventory:removeItem","advlockpick", 1)
 --TriggerClientEvent('chatMessage', source, '^1Your lockpick has bent out of shape')
 TriggerClientEvent('notification', source, 'The lockpick bent out of shape.', 2)
end)

RegisterServerEvent('houseRobberies:giveMoney')
AddEventHandler('houseRobberies:giveMoney', function()
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 local cash = math.random(100, 530)
 xPlayer.addMoney(cash)
 --TriggerClientEvent('chatMessage', source, '^4You have found $'..cash)
 TriggerClientEvent('notification', source, 'You found $'..cash)
end)

--tmrw

--[[RegisterServerEvent('dothingythang')
AddEventHandler('dothingythang', function()
 local source = tonumber(source)
 local chance = math.random(1,100)
 if chance < 5 then
    TriggerClientEvent( "player:receiveItem",source, item.id, item.quantity)
 --TriggerClientEvent('chatMessage', source, '^1Your lockpick has bent out of shape')
 TriggerClientEvent('notification', source, 'The lockpick bent out of shape.', 2)
end)]]--


RegisterServerEvent('houseRobberies:searchItem')
AddEventHandler('houseRobberies:searchItem', function()
 local source = tonumber(source)
 local item = {}
 local xPlayer = ESX.GetPlayerFromId(source)
 local gotID = {}

 for i=1, math.random(1, 2) do
  item = robbableItems[math.random(1, #robbableItems)]
  if math.random(1, 10) >= item.chance then
   if tonumber(item.id) == 0 and not gotID[item.id] then
    gotID[item.id] = true
    xPlayer.addMoney(item.quantity)
    TriggerClientEvent('notification', source, 'You found $'..item.quantity)
   elseif not gotID[item.id] then
    gotID[item.id] = true
    print(item.id, item.quantity)
    TriggerClientEvent( "player:receiveItem",source, item.id, item.quantity)
   end
  end
 end
end)
