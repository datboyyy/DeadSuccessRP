ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
local repayTime = 7 -- hours * 60
local timer = ((60 * 1000) * 60) -- 10 minute timer

local carTable = {
    [1] = {["model"] = "unicycle", ["baseprice"] = 2000, ["commission"] = 15},
    [2] = {["model"] = "lp700r", ["baseprice"] = 1000000, ["commission"] = 15},
    [3] = {["model"] = "chargerscat", ["baseprice"] = 550000, ["commission"] = 15},
    [4] = {["model"] = "subwrx", ["baseprice"] = 150000, ["commission"] = 15},
    [5] = {["model"] = "19ramoffroad", ["baseprice"] = 150000, ["commission"] = 15},
    [6] = {["model"] = "c8", ["baseprice"] = 400000, ["commission"] = 10},
    [7] = {["model"] = "r820", ["baseprice"] = 680000, ["commission"] = 15},
}

-- Update car table to server
RegisterServerEvent('carshop:table')
AddEventHandler('carshop:table', function(table)
    if table ~= nil then
        carTable = table
        TriggerClientEvent('veh_shop:returnTable', -1, carTable)
        updateDisplayVehicles()
    end
end)

-- Enables finance for 60 seconds
RegisterServerEvent('finance:enable')
AddEventHandler('finance:enable', function(plate)
    if plate ~= nil then
        TriggerClientEvent('finance:enableOnClient', -1, plate)
    end
end)

RegisterServerEvent('buy:enable')
AddEventHandler('buy:enable', function(plate)
    if plate ~= nil then
        TriggerClientEvent('buy:enableOnClient', -1, plate)
    end
end)

-- return table
-- TODO (return db table)
RegisterServerEvent('carshop:requesttable')
AddEventHandler('carshop:requesttable', function()
    local src = source
    local user = source
    exports.ghmattimysql:execute('SELECT * FROM vehicle_display', function(result)
    TriggerClientEvent('veh_shop:returnTable', user, result)
    end)
end)

-- Check if player has enough money
RegisterServerEvent('CheckMoneyForVeh')
AddEventHandler('CheckMoneyForVeh', function(name, model,price,financed)
    local user = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getMoney()
    if financed then
        local financedPrice = math.ceil(price / 4)
        if money >= financedPrice then
                xPlayer.removeMoney(financedPrice)
                cash = xPlayer.getMoney()
                TriggerClientEvent('banking:removeCash', source, financedPrice)
                TriggerClientEvent('banking:updateCash', source, cash)
            TriggerClientEvent('FinishMoneyCheckForVeh', source, name, model, price, financed)
        else
            TriggerClientEvent('notification', source, 'You dont have enough money on you!', 2)
            TriggerClientEvent('carshop:failedpurchase', source)
        end
    else
        if money >= price then
            xPlayer.removeMoney(price)
            cash = xPlayer.getMoney()
            TriggerClientEvent('banking:removeCash', source, price)
            TriggerClientEvent('banking:updateCash', source, cash)
            TriggerClientEvent('FinishMoneyCheckForVeh', source, name, model, price, financed)
        else
            TriggerClientEvent('notification', source, 'You dont have enough money on you!', 2)
            TriggerClientEvent('carshop:failedpurchase', source)
        end
    end
end)


-- Add the car to database when completed purchase
RegisterServerEvent('BuyForVeh')
AddEventHandler('BuyForVeh', function(platew, name, vehicle, price, financed)
    local src = source
    local user = source
    local char = 1
    local player = GetPlayerIdentifier(source)
    if financed then
        local cols = 'owner,  plate, purchase_price, financed, last_payment, vehiclename, payments_left'
        local val = '@owner,  @plate, @buy_price, @financed, @last_payment, @vehiclename, @payments_left'
        local downPay = math.ceil(price / 4)
        exports.ghmattimysql:execute('INSERT INTO owned_vehicles ( '..cols..' ) VALUES ( '..val..' )',{
            ['@owner'] = player,
            ['@plate']   = platew,
            ['@vehiclename'] = vehicle,
            ['@buy_price'] = price,
            ['@financed'] = price - downPay,
            ['@last_payment'] = 7,
            ['@payments_left'] = 12,
        })
    else
        exports.ghmattimysql:execute('INSERT INTO owned_vehicles (owner,  plate, vehiclename, purchase_price) VALUES (@owner,  @plate,  @vehiclename, @buy_price)',{
            ['@owner']   = player,
            ['@plate']   = platew,
            ['@vehiclename'] = vehicle,
            ['@buy_price'] = price,
        })
    end
end)

    
function updateDisplayVehicles()
    for i=1, #carTable do
        exports.ghmattimysql:execute("UPDATE vehicle_display SET model=@model, commission=@commission, baseprice=@baseprice WHERE ID=@ID",{
            ['@ID'] = i,
            ['@model'] = carTable[i]["model"],
            ['@commission'] = carTable[i]["commission"],
            ['@baseprice'] = carTable[i]["baseprice"]
        })
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        updateDisplayVehicles()
    end
end)


RegisterServerEvent('car:dopayment')
AddEventHandler('car:dopayment', function(vehicleplate)
    PayVehicleFinance(vehicleplate)
end)

function PayVehicleFinance(vehicleplate)
    local user = source
    local char = 1
    local player = GetPlayerIdentifier(source)

    exports.ghmattimysql:execute("SELECT * FROM `owned_vehicles` WHERE plate = @plate", {['plate'] = vehicleplate}, function(result)
       local vehiclepaymentsleft = result[1].payments_left
       local vehicletotalamount = result[1].financed
       if tonumber(result[1].last_payment) <= 0 then
       exports.ghmattimysql:execute("UPDATE owned_vehicles SET payments_left = @payments_left, last_payment = @last_payment WHERE plate = @plate",
          {['plate'] = vehicleplate,
          ['@payments_left'] = vehiclepaymentsleft - 1,
          ['@last_payment'] = 7,
        })
        exports.ghmattimysql:execute("UPDATE owned_vehicles SET financed = @financed WHERE plate = @plate",
        {['plate'] = vehicleplate,
        ['@financed'] = vehicletotalamount - vehicletotalamount / 12,
      })

      xPlayer.removeMoney(vehicletotalamount / 12)
      cash = xPlayer.getMoney()
      TriggerClientEvent('banking:removeCash', source, vehicletotalamount / 12)
      TriggerClientEvent('banking:updateCash', source, cash)
    else
        TriggerClientEvent('notification', source, 'It is Not The Due Date for The Payment', 2)
    end
      end)
end

function updateCarDueDates() 
    local changed = 0
    exports.ghmattimysql:execute('SELECT * FROM owned_vehicles', {
    }, function(result)
        for k,v in pairs(result) do
            local new_last_payment = tonumber(v.last_payment - 1)
            if new_last_payment >= 0 then
                changed = changed + 1
                exports.ghmattimysql:execute("UPDATE owned_vehicles SET last_payment = @timer WHERE plate = @plate",
                    {['plate'] = tostring(v.plate),
                    ['@timer'] = new_last_payment,
                })
            end
        end
        print('^1[GBB] ^5Updated all Financing Due Dates for ^2' ..changed ..'^5 vehicles.^7')
    end)
end

TriggerEvent('cron:runAt', 16, 0, updateCarDueDates)

--RegisterCommand("penisfuck", function()
  --  updateCarDueDates()
---end)