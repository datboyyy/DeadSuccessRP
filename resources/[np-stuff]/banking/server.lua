local balances = {}
ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)


AddEventHandler('es:playerLoaded', function(source, user)
    balances[source] = user.getBank()
    local xPlayer = ESX.GetPlayerFromId(source)
    local money
    money = user.getMoney()
    TriggerClientEvent('banking:updateBalance', source, user.getBank())
end)

RegisterServerEvent('bank:getDetails')
AddEventHandler('bank:getDetails', function()
  local _src = source
  local player = ESX.GetPlayerFromId(source)
  xPlayer = player.identifier
  MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
    ['@identifier'] = player.identifier
  }, function (result)
		for _, v in ipairs(result) do
			items = {["firstname"] = v.firstname, ["lastname"] = v.lastname}
      TriggerClientEvent("updateNameClient", _src, items.firstname, items.lastname)
		end
	end)
end)

AddEventHandler('playerDropped', function()
  balances[source] = nil
end)

-- HELPER FUNCTIONS
function bankBalance(player)
  return ESX.GetPlayerFromId(player).getBank()
end

function deposit(player, amount)
  local bankbalance = bankBalance(player)
  local new_balance = bankbalance + math.abs(amount)
  balances[player] = new_balance

  local user = ESX.GetPlayerFromId(player)
  TriggerClientEvent("banking:updateBalance", source, new_balance)
  user.addBank(math.abs(amount))
  user.removeMoney(math.abs(amount))
end

function withdraw(player, amount)
  local bankbalance = bankBalance(player)
  local new_balance = bankbalance - math.abs(amount)
  balances[player] = new_balance

  local user = ESX.GetPlayerFromId(player)
  TriggerClientEvent("banking:updateBalance", source, new_balance)
  user.removeBank(math.abs(amount))
  user.addMoney(math.abs(amount))
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.abs(math.floor(num * mult + 0.5) / mult)
end

local notAllowedToDeposit = {}

AddEventHandler('bank:addNotAllowed', function(pl)
  notAllowedToDeposit[pl] = true

  local savedSource = pl
  SetTimeout(300000, function()
    notAllowedToDeposit[savedSource] = nil
  end)
end)



RegisterServerEvent('bank:depAVACosit')
AddEventHandler('bank:depAVACosit', function(amount)
  local xPlayer = ESX.GetPlayerFromId(source)
   local money
   money = xPlayer.getMoney()

  if not amount then return end

  TriggerEvent('es:getPlayerFromId', source, function(user)
    if notAllowedToDeposit[source] == nil then
      local rounded = math.ceil(tonumber(amount))
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('notification', source, "Input too high", 2)
      else
      	if(rounded <= user.getMoney()) then
          TriggerClientEvent("banking:updateBalance", source, (user.getBank() + rounded))
          TriggerClientEvent("banking:addBalance", source, rounded)
          TriggerClientEvent("banking:removeCash", source, rounded)
          TriggerClientEvent("banking:updateCash", source, (money - rounded))

          deposit(source, rounded)
          TriggerClientEvent('notification', source, "You Deposited  $" ..rounded.. "  into your bank", 1)
          TriggerEvent('DiscordBot:ToDiscord', 'banking', 'Banking', '> ' .. xPlayer.getName() ..' | ' ..xPlayer.identifier ..' deposited ' ..amount .. ' at the bank', 'IMAGE_URL', true)
          local new_balance = user.getBank()
        else
          TriggerClientEvent('notification', source, "Not enough cash", 2)
        end
      end
    else
        TriggerClientEvent('notification', source, "You cannot deposit recently stolen money, please wait 5 minutes", 2)
    end
  end)
end)


RegisterServerEvent('bank:withdAVACraw')
AddEventHandler('bank:withdAVACraw', function(amount)
  local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  local money
  money = xPlayer.getMoney()
  if not amount then return end
  
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('notification', source, "Input too high")
      else
        local bankbalance = user.getBank()
        if(tonumber(rounded) <= tonumber(bankbalance)) then
          TriggerClientEvent("banking:updateBalance", source, (user.getBank() - rounded))
          TriggerClientEvent("banking:removeBalance", source, rounded)

          TriggerClientEvent("banking:addCash", source, rounded)
          TriggerClientEvent("banking:updateCash", source, (money + rounded))

          withdraw(source, rounded)
          TriggerEvent('DiscordBot:ToDiscord', 'banking', 'Banking', '> ' .. xPlayer.getName() ..' | ' ..xPlayer.identifier ..' withdrawed ' ..amount .. ' from the bank', 'IMAGE_URL', true)
          TriggerClientEvent('notification', source, "You withdrew  $" ..rounded.. "  from your bank", 1)
        else
          TriggerClientEvent('notification', source, "Not enough money in account", 2)
        end
      end
  end)
end)

RegisterServerEvent('bank:traAVACnsfer')
AddEventHandler('bank:traAVACnsfer', function(to, amountt)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local zPlayer = ESX.GetPlayerFromId(to)
	local balance = 0
	balance = xPlayer.getAccount('bank').money
	zbalance = xPlayer.getAccount('bank').money
	
	if tonumber(_source) == tonumber(to) then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "You cannot transfer funds to yourself." })
	else
    if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
      TriggerEvent('DiscordBot:ToDiscord', 'banking', 'Banking', '> ' .. xPlayer.getName() ..' | ' ..xPlayer.identifier ..' transfered ' ..amount .. ' to a player', 'IMAGE_URL', true)
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "Invalid amount." })
		else
      xPlayer.removeAccountMoney('bank', amountt)
      TriggerClientEvent("banking:removeBalance", _source, amountt)
      TriggerClientEvent("banking:updateBalance", _source, amountt)
      TriggerClientEvent("banking:updateBalance", to, amountt)
      TriggerClientEvent("banking:addBalance", to, amountt)
			zPlayer.addAccountMoney('bank', amountt)
      TriggerClientEvent("notification", _source "You have transfered $".. amountt .. " to " .. to .. ".")
      TriggerClientEvent("notification", to "You have received $" .. amountt .. " from " .. _source .. ".")

		end
		
	end
end)




RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('currentbalance1', _source, balance)
end)

RegisterServerEvent('police:targetCheckBank')
AddEventHandler('police:targetCheckBank', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(target)
	balance = xPlayer.getAccount('bank').money
  local strng = " Bank: "..balance
  TriggerClientEvent("customNotification",_source,strng)
end)

RegisterServerEvent('bank:active')
AddEventHandler('bank:active', function()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('banking:updateBalance', _source, balance)
end)

RegisterServerEvent('bank:balance2')
AddEventHandler('bank:balance', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('currentbalance2', _source, balance)
end)

RegisterServerEvent('bank:cashbal')
AddEventHandler('bank:cashbal', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  local money

  money = xPlayer.getMoney()
  TriggerClientEvent('banking:updateCash', _source, money)
  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerClientEvent('updateMyCashHere', source, xPlayer.getMoney())
end)



RegisterServerEvent('bank:bankbal')
AddEventHandler('bank:bankbal', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  balance = xPlayer.getAccount('bank').money
  TriggerClientEvent('banking:updateBalance', _source, balance)

end)


RegisterCommand('givecash', function(source, args, rawCommand)
  local sender = source
  local reciever = args[1]
  local amount = args[2]
  local user = ESX.GetPlayerFromId(sender)


  local playerRec = ESX.GetPlayerFromId(reciever)
  TriggerClientEvent('chat:svtocl', source, 'Transfer:', 3, "You have transfered $"..amount)
  TriggerClientEvent("bank:givecash", source, sender, reciever, amount)
  local givecash = {
    {
        ["color"] = 16711680,
        ["title"] = "Dead Success RP",
        ["description"] = "**Player: **" .. GetPlayerName(sender) .. "**\n Steam Hex:** " .. GetPlayerIdentifier(sender) .. "\n **Gave cash to: ** "..GetPlayerName(reciever).. ' amount $' ..amount..'',
        ["footer"] = {
            ["text"] = 'DSRP',
        },
    }
}
PerformHttpRequest('https://discord.com/api/webhooks/788764382393139201/n-ClSYuAumaO2sdI0qDDk7tlWJPpOhibzjHuw6HhKMU_yVjzcAmSQee8lAK_iQCLETBr', function(err, text, headers) end, 'POST', json.encode({username = "Give Cash CMD", embeds = givecash}), {['Content-Type'] = 'application/json'})


end)


RegisterServerEvent('bank:givemecash')
AddEventHandler('bank:givemecash', function(sender, reciever, amount)
    local user = ESX.GetPlayerFromId(sender)
    local playerRec = ESX.GetPlayerFromId(reciever)
    	if GetPlayerName(reciever) then
		if tonumber(amount) > 0 then
			local amount = tonumber(amount)
			if user.getMoney() >= amount then
				user.removeMoney(amount)
				TriggerEvent('es:getPlayerFromId', tonumber(reciever), function(target)
          target.addMoney(amount)
          TriggerClientEvent("banking:addBalance", reciever, amount)
          TriggerClientEvent("banking:updateCash", reciever, (playerRec.getMoney()))
          TriggerClientEvent("banking:removeBalance", source, amount)
          TriggerClientEvent("banking:updateCash", source, (user.getMoney()))
				end)
			else
				TriggerClientEvent('notification', source, "You do not have the required amount", 2)
			end
		else
			TriggerClientEvent('notification', source, "Please enter a valid money amount", 2)
		end
	else
		TriggerClientEvent('notification', source, "Please enter a valid Player ID", 2)
	end
end)

RegisterServerEvent("inventory:takeMyCash")
AddEventHandler("inventory:takeMyCash", function(user, amount)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(user)
  xPlayer.removeMoney(amount)
  TriggerClientEvent("banking:updateCash", user, (xPlayer.getMoney()))
end)


RegisterCommand('cash', function(source, args, rawCommand)
  local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
  cash = xPlayer.getMoney()
  TriggerClientEvent('chat:svtocl', 'Cash:', 3, cash)
  TriggerClientEvent('banking:updateCash', source, cash)
end)

RegisterCommand('bank', function(source, args, rawCommand)
  local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
  bank = xPlayer.getAccount('bank').money
  TriggerClientEvent('chat:svtocl', 'Bank:', 3, bank)
  TriggerClientEvent('banking:updateBalance', source, bank)
end)
