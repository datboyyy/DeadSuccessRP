ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function (source)
	--GetLicenses(source)
	TriggerEvent("playerSpawned")
end)

RegisterServerEvent('cash:remove')
AddEventHandler('cash:remove', function(source, cash)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer.getMoney() >= cash then
	xPlayer.removeMoney(cash)
	TriggerClientEvent("banking:removeBalance", source, cash)
	end
end)

RegisterCommand("openinventory", function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, "inventory.openinventory") then
		local target = tonumber(args[1])
		local targetXPlayer = ESX.GetPlayerFromId(target)
		if targetXPlayer ~= nil then
			local targetIdentifier = targetXPlayer.identifier
			TriggerClientEvent("server-inventory-open", source, "1", targetIdentifier)
		else
			TriggerClientEvent("notification", source, 'invalid player')
		end
		else
			--TriggerClientEvent("chatMessage", source, "^1" .. _U("no_permissions"))
		end
	end
)

RegisterServerEvent('people-search')
AddEventHandler('people-search', function(target)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(target)
	local identifier = xPlayer.identifier
	if xPlayer.job.name == 'police' or 'sway' then
		TriggerClientEvent("server-inventory-open", source, "1", identifier)
	else
		TriggerEvent('DiscordBot:ToDiscord', 'cheat', 'Cheaters', '@here ``` '.. GetPlayerName(source) .. ' | IP: ' ..GetPlayerEndpoint(source) .. ' | steam: ' .. GetPlayerIdentifier(source) .. ' has been flagged for cheating Method: [ people-search ] ' .. '```', 'IMAGE_URL', true)
	end
end)

RegisterServerEvent("server-item-quality-update")
AddEventHandler("server-item-quality-update", function(player, data)
	local quality = data.quality
	local slot = data.slot
	local itemid = data.item_id

    exports.ghmattimysql:execute("UPDATE user_inventory2 SET `quality` = @quality WHERE name = @name AND slot = @slot AND item_id = @item_id", {['quality'] = quality, ['name'] = player, ['slot'] = slot, ['item_id'] = itemid})
  
end)

RegisterServerEvent("aqua-getcash")
AddEventHandler("aqua-getcash", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local cash = xPlayer.getMoney()
    TriggerClientEvent("aqua-setcash", source, cash)
end)




RegisterCommand("clearinventory",function ()
local src = source
local xPlayer = ESX.GetPlayerFromId(src)
local steam = xPlayer.getIdentifier(src)
print(steam)
TriggerEvent("server-clear-item",source, steam,false)
end)


RegisterServerEvent('Stealtheybread')
AddEventHandler('Stealtheybread', function(target)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local zPlayer = ESX.GetPlayerFromId(target)

    TriggerClientEvent("banking:addBalance", src, zPlayer.getMoney())
    TriggerClientEvent("banking:removeBalance", target, zPlayer.getMoney())
    xPlayer.addMoney(zPlayer.getMoney())
    zPlayer.setMoney(0)
    TriggerClientEvent('notification', target, 'Your cash was robbed off you.', 1)
end)



RegisterServerEvent('police:SeizeCash')
AddEventHandler('police:SeizeCash', function(target)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local zPlayer = ESX.GetPlayerFromId(target)
    TriggerClientEvent("banking:addBalance", src, zPlayer.getMoney())
    TriggerClientEvent("banking:removeBalance", target, zPlayer.getMoney())
    zPlayer.setMoney(0)
    TriggerClientEvent('notification', target, 'Your cash was seized',1)
    TriggerClientEvent('notification', src, 'Seized persons cash', 1)
 

end)



RegisterServerEvent('cash-checksv')
AddEventHandler('cash-checksv', function(target)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local zPlayer = ESX.GetPlayerFromId(target)
    local money = zPlayer.getMoney()
    local money2 = zPlayer.getAccount('bank').money
	TriggerClientEvent('chat:addMessage',  src, {
        template =  '<div style="padding: 0.5vw; padding-left: 0.8vw; background-color: rgba(207, 125, 25, 0.7); border-radius: 6px;"><span style="width: 100%; font-weight: bold;"></span>Cash: ${0}</div>',
        args = {money}
    }) 
	TriggerClientEvent('chat:addMessage',  src, {
        template =  '<div style="padding: 0.5vw; padding-left: 0.8vw; background-color: rgba(207, 125, 25, 0.7); border-radius: 6px;"><span style="width: 100%; font-weight: bold;"></span>Bank: ${0}</div>',
        args = {money2}
    }) 
    TriggerClientEvent("notification", target, "Your Balances were checked")
end)



RegisterServerEvent("grpLockers:sendCaseFileID")
AddEventHandler("grpLockers:sendCaseFileID", function(id)
local src = source
TriggerClientEvent("evLockers:openCaseFile", src, id)
end)
