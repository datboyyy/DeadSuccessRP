ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent("oxydelivery:server")
AddEventHandler('oxydelivery:server', function(price, type, time)
	xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= price then
	xPlayer.removeMoney(price)
	--TriggerClientEvent('oxydelivery:startDealing', source)
	TriggerClientEvent('drugrun:enoughmoney', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Hop in the car G'})

	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You dont have enough money'})
	end
end)

ESX.RegisterServerCallback('startdealingjob', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		cb(true)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Hop in the car G'})
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You dont have enough money'})
		cb(false)
	end
end)

RegisterServerEvent('drugdelivery:server')
AddEventHandler('drugdelivery:server', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= price then
		xPlayer.removeMoney(price)
		TriggerClientEvent("drugdelivery:startDealing", source)
		TriggerClientEvent("banking:removeBalance", source, price)
	else
		TriggerClientEvent('notification', xPlayer, ' ' .. price .. ' Needed')
	end
end)

RegisterServerEvent("drugrun:completed")
AddEventHandler('drugrun:completed', function(payment)
	xPlayer = ESX.GetPlayerFromId(source)
	if payment > 100000 then
		DropPlayer(source)
	else
	xPlayer.addMoney(payment)
	end
end)

--[[
RegisterCommand("pager", function(source, args, rawCommand)
    if (source > 0) then
    	if args then
    		if args[1] == "connect" then
    			TriggerClientEvent('supersecretdialog', source)
    		end
		end
	end
end, false)
]]
RegisterServerEvent("mission:completAVACed")
AddEventHandler('mission:completAVACed', function(payment)
xPlayer = ESX.GetPlayerFromId(source)
local goldbar = 17500
	xPlayer.addMoney(goldbar)
end)


RegisterServerEvent("pixy:done")
AddEventHandler('pixy:done', function(payment)
xPlayer = ESX.GetPlayerFromId(source)
local pixy = math.random(112,540)
	xPlayer.addMoney(pixy)
end)



RegisterServerEvent("band:sold")
AddEventHandler('band:sold', function(payment)
	xPlayer = ESX.GetPlayerFromId(source)
	local bandprice = 7500
	xPlayer.addMoney(bandprice)
end)

RegisterServerEvent("rollcash:sold")
AddEventHandler('rollcash:sold', function(payment)
	xPlayer = ESX.GetPlayerFromId(source)
	local rollcashprice = 3000
	xPlayer.addMoney(rollcashprice)
end)



RegisterServerEvent("markedbills:sold")
AddEventHandler('markedbills:sold', function(payment)
	xPlayer = ESX.GetPlayerFromId(source)
	local markedbillsprice = 350
	xPlayer.addMoney(markedbillsprice)
end)


RegisterServerEvent("oxy:given")
AddEventHandler('oxy:given', function(payment)
	xPlayer = ESX.GetPlayerFromId(source)
	local oxygiven = 78
	xPlayer.addMoney(oxygiven)
end)







