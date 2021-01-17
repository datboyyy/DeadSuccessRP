local hospitalCheckin = {x = 312.28, y = -592.88, z = 43.291839599609, h = 180.4409942627}
local pillboxTeleports = {
    {x = 325.48892211914, y = -598.75372314453, z = 43.291839599609, h = 64.513374328613, text = 'Press ~INPUT_CONTEXT~ ~s~to go to lower Pillbox Entrance'},
    {x = 355.47183227539, y = -596.26495361328, z = 28.773477554321, h = 245.85662841797, text = 'Press ~INPUT_CONTEXT~ ~s~to enter Pillbox Hospital'},
    {x = 359.57849121094, y = -584.90911865234, z = 28.817169189453, h = 245.85662841797, text = 'Press ~INPUT_CONTEXT~ ~s~to enter Pillbox Hospital'},
}

local bedOccupying = nil
local bedObject = nil
local bedOccupyingData = nil

local cam = nil

local inBedDict = "anim@gangops@morgue@table@"
local inBedAnim = "ko_front"
local getOutDict = 'switch@franklin@bed'
local getOutAnim = 'sleep_getup_rubeyes'
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
end)

function PrintHelpText(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function LeaveBed()
    TriggerServerEvent('mythic_hospital:server:LeaveBed', bedOccupying)
    FreezeEntityPosition(bedObject, false)
    bedOccupying = nil
    bedObject = nil
    bedOccupyingData = nil
end

RegisterNetEvent('mythic_hospital:client:RPCheckPos')
AddEventHandler('mythic_hospital:client:RPCheckPos', function()
    TriggerServerEvent('mythic_hospital:server:RPRequestBed', GetEntityCoords(PlayerPedId()))
end)

RegisterNetEvent('mythic_hospital:client:RPSendToBed')
AddEventHandler('mythic_hospital:client:RPSendToBed', function(id, data)
    bedOccupying = id
    bedOccupyingData = data
    
    bedObject = GetClosestObjectOfType(data.x, data.y, data.z, 1.0, data.model, false, false, false)
    FreezeEntityPosition(bedObject, true)
    
    SetEntityCoords(PlayerPedId(), data.x, data.y, data.z)
    DoScreenFadeOut(1000)
    TriggerEvent('client:bed')
    DoScreenFadeIn(1000)
end)

RegisterNetEvent('mythic_hospital:client:SendToBed')
AddEventHandler('mythic_hospital:client:SendToBed', function(id, data)
    bedOccupying = id
    bedOccupyingData = data
    
    bedObject = GetClosestObjectOfType(data.x, data.y, data.z, 1.0, data.model, false, false, false)
    FreezeEntityPosition(bedObject, true)
    
    SetEntityCoords(PlayerPedId(), data.x, data.y, data.z)
    TriggerEvent('client:bed')
        
        exports['mythic_notify']:SendAlert('inform', 'Doctors Are Treating You')
        Citizen.Wait(Config.AIHealTimer * 1000)
        TriggerServerEvent('mythic_hospital:server:EnteredBed')
end)

RegisterNetEvent('mythic_hospital:client:FinishServices')
AddEventHandler('mythic_hospital:client:FinishServices', function()
    SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
    TriggerEvent('mythic_hospital:client:RemoveBleed')
    TriggerEvent('mythic_hospital:client:ResetLimbs')
    exports['mythic_notify']:SendAlert('inform', 'You\'ve Been Treated & Billed')
    local source = source
    TriggerEvent('tp_ambulancejob:revive', source)
    TriggerEvent('client:bedleave')
    LeaveBed()
end)

RegisterNetEvent('mythic_hospital:client:ForceLeaveBed')
AddEventHandler('mythic_hospital:client:ForceLeaveBed', function()
    LeaveBed()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local plyCoords = GetEntityCoords(PlayerPedId(), 0)
        local distance = #(vector3(hospitalCheckin.x, hospitalCheckin.y, hospitalCheckin.z) - plyCoords)
        if distance < 10 then
            DrawMarker(27, hospitalCheckin.x, hospitalCheckin.y, hospitalCheckin.z - 0.99, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 1.0, 1, 157, 0, 155, false, false, 2, false, false, false, false)
            
            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                if distance < 3 then
                    --PrintHelpText('Press ~INPUT_CONTEXT~ ~s~to check in')
                    DrawText3Ds(312.29, -592.88, 43.28, "[E] to Check in")
                    if IsControlJustReleased(0, 54) then
                        fuck = exports["ambulancejob"]:GetDeath()
                        if (GetEntityHealth(PlayerPedId()) < 201) or (IsInjuredOrBleeding()) or fuck then
                            TriggerEvent('notepad')
                            exports["sway_taskbar"]:taskBar(7500, "Requesting Bed")
                            if not status then
                                TriggerServerEvent('mythic_hospital:server:RequestBed')
                            end
                        else
                            exports['mythic_notify']:SendAlert('error', 'You do not need medical attention')
                        end
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)




function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end
