ESX = nil
isLoggedIn = false
local requiredItemsShowed = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
end)

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        local inRange = false
        
        if ESX ~= nil then
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            local dist = GetDistanceBetweenCoords(pos, Crypto.Exchange.coords.x, Crypto.Exchange.coords.y, Crypto.Exchange.coords.z, true)
            
            if dist < 15 then
                inRange = true
                
                if dist < 1.5 then
                    if not Crypto.Exchange.RebootInfo.state then
                        DrawText3Ds(Crypto.Exchange.coords.x, Crypto.Exchange.coords.y, Crypto.Exchange.coords.z, '~g~E~w~ - to use pixerium')
                        
                        if IsControlJustPressed(0, Keys["E"]) then
                            local HasItem = exports["dsrp-inventory"]:hasEnoughOfItem("pix1", 1, false)
                            local HasItem2 = exports["dsrp-inventory"]:hasEnoughOfItem("pix2", 1, false)
                            if HasItem then
                                TriggerEvent("inventory:removeItem", "pix1", 1)
                                ExchangeSuccess(HasItem)
                            else
                                if HasItem2 then
                                    TriggerEvent("inventory:removeItem", "pix2", 1)
                                    ExchangeSuccess(HasItem)
                                else
                                    TriggerEvent('notification', 'You cannot perform this hack', 2)
                                end
                            end
                        end
                    end
                end
            end
        end
        
        if not inRange then
            Citizen.Wait(5000)
        end
        
        Citizen.Wait(3)
    end
end)

function ExchangeSuccess(HasItem)
    TriggerServerEvent('qb-crypto:server:ExchangeSuccess', math.random(1, 10), HasItem)
end

function ExchangeFail()
    local Odd = 5
    local RemoveChance = math.random(1, Odd)
    local LosingNumber = math.random(1, Odd)
    
    if RemoveChance == LosingNumber then
        TriggerServerEvent('qb-crypto:server:ExchangeFail')
        TriggerServerEvent('qb-crypto:server:SyncReboot')
    -- Crypto.Exchange.RebootInfo.state = true
    -- SystemCrashCooldown()
    end
end

RegisterNetEvent('qb-crypto:client:SyncReboot')
AddEventHandler('qb-crypto:client:SyncReboot', function()
    Crypto.Exchange.RebootInfo.state = true
    SystemCrashCooldown()
end)

function SystemCrashCooldown()
    Citizen.CreateThread(function()
        while Crypto.Exchange.RebootInfo.state do
            
            if (Crypto.Exchange.RebootInfo.percentage + 1) <= 100 then
                Crypto.Exchange.RebootInfo.percentage = Crypto.Exchange.RebootInfo.percentage + 1
                TriggerServerEvent('qb-crypto:server:Rebooting', true, Crypto.Exchange.RebootInfo.percentage)
            else
                Crypto.Exchange.RebootInfo.percentage = 0
                Crypto.Exchange.RebootInfo.state = false
                TriggerServerEvent('qb-crypto:server:Rebooting', false, 0)
            end
            
            Citizen.Wait(1200)
        end
    end)
end

function HackingSuccess(success, timeremaining)
    if success then
        TriggerEvent('mhacking:hide')
        ExchangeSuccess()
    else
        TriggerEvent('mhacking:hide')
        ExchangeFail()
    end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    isLoggedIn = true
    TriggerServerEvent('qb-crypto:server:FetchWorth')
    TriggerServerEvent('qb-crypto:server:GetRebootState')
end)

RegisterNetEvent('qb-crypto:client:UpdateCryptoWorth')
AddEventHandler('qb-crypto:client:UpdateCryptoWorth', function(crypto, amount, history)
    Crypto.Worth[crypto] = amount
    if history ~= nil then
        Crypto.History[crypto] = history
    end
end)

RegisterNetEvent('qb-crypto:client:GetRebootState')
AddEventHandler('qb-crypto:client:GetRebootState', function(RebootInfo)
    if RebootInfo.state then
        Crypto.Exchange.RebootInfo.state = RebootInfo.state
        Crypto.Exchange.RebootInfo.percentage = RebootInfo.percentage
        SystemCrashCooldown()
    end
end)

Citizen.CreateThread(function()
    isLoggedIn = true
    TriggerServerEvent('qb-crypto:server:FetchWorth')
    TriggerServerEvent('qb-crypto:server:GetRebootState')
end)


