ESX = nil
local hasShot = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        ped = PlayerPedId()
        if IsPedShooting(ped) then
            TriggerServerEvent('GSR:SetGSR', timer)
            hasShot = true
            Citizen.Wait(Config.gsrUpdate)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(2000)
        if Config.waterClean and hasShot then
            ped = PlayerPedId()
            if IsEntityInWater(ped) then
				exports['mythic_notify']:SendAlert('inform', 'You begin cleaning off the Gunshot Residue... stay in the water', 5000)
				Wait(100)
				exports["sway_taskbar"]:taskBar((Config.waterCleanTime), "Washing off GSR") 
        			if not status then
            			if IsEntityInWater(ped) then
                    		hasShot = false
                    		TriggerServerEvent('GSR:Remove')
							exports['mythic_notify']:SendAlert('success', 'You washed off all the Gunshot Residue in the water', 5000)
                		else
							exports['mythic_notify']:SendAlert('error', 'You left the water too early and did not wash off the gunshot residue.', 5000)
                		end
                    end
            end
        end
    end
end)

function status()
    if hasShot then
        ESX.TriggerServerCallback('GSR:Status', function(cb)
            if not cb then
                hasShot = false
            end
        end)
    end
end

function updateStatus()
    status()
    SetTimeout(Config.gsrUpdateStatus, updateStatus)
end

updateStatus()
