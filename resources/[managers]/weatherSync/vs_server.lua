ESX = nil
TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)

local currentweather = "CLEAR"
local currenttime = 130000


RegisterServerEvent('kGetWeather')
AddEventHandler('kGetWeather', function()
    print('Set Weather', source, currentweather)
    print('Set Time', source, currenttime)
    TriggerClientEvent('kWeatherSync', source, currentweather)
    TriggerClientEvent('kTimeSync', source, currenttime)
end)

RegisterServerEvent('kTimeSync')
AddEventHandler("kTimeSync", function(data)
    currenttime = data
    TriggerClientEvent('kTimeSync', -1, data)
end)

RegisterServerEvent('kWeatherSync')
AddEventHandler("kWeatherSync", function(wfer)
    currentweather = wfer
    TriggerClientEvent('kWeatherSync', -1, wfer)
end)

RegisterServerEvent('weather:time')
AddEventHandler('weather:time', function(src, time)
    currenttime = tonumber(time)
    TriggerClientEvent('kTimeSync', -1, time)
    TriggerClientEvent("timeheader", time)
end)

RegisterServerEvent('weather:setWeather')
AddEventHandler('weather:setWeather', function(src, weather)
    currentweather = tostring(weather)
    TriggerClientEvent('kWeatherSync', -1, weather)
end)

RegisterServerEvent('weather:setCycle')
AddEventHandler('weather:setCycle', function(src, weather)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'superadmin' then
    TriggerClientEvent('weather:setCycle', -1, weather)
    end
end)


RegisterCommand('syncallweather', function()
    TriggerClientEvent('kWeatherSync', -1, currentweather)
    TriggerClientEvent('kTimeSync', -1, currenttime)
end, false)

RegisterCommand('weather', function(source, args)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'superadmin' then
        if args[1] == nil then
            print('No Args')
        else
            currentweather = string.upper(args[1])
            print(currentweather)
            TriggerClientEvent('kWeatherSync', -1, currentweather)
        end
    end
end)


RegisterServerEvent('weather:receivefromcl')
AddEventHandler('weather:receivefromcl', function(secondsofday)
currenttime = secondsofday
end)

