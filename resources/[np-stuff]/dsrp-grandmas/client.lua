--- calls esx for money etc
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
end)
--- draw text function
function DrawText3D(x, y, z, text)
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


--- cords for drawtext and grandmas
local coords = {x = 2436.0734863281, y = 4958.904296875, z = 46.236435699463, h = 46.936435699463}

--- threard for money as well as item check to pickup homie
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), 0)
        local distance = #(vector3(coords.x, coords.y, coords.z) - plyCoords)
        if distance < 10 then
            if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                if distance < 3 then
                    DrawText3D(coords.x, coords.y, coords.z + 0.5, '~g~H~w~ - Have Grandma Treat you for $400 and 5(P)')
                    if IsControlJustReleased(0, 74) then
                        --[[if had this item]] --exports["dsrp-inventory"]:hasEnoughOfItem("pix1",5) then
                        if (GetEntityHealth(GetPlayerPed(-1)) <= 200) then
                            local finished = exports["sway_taskbar"]:taskBar(60000, "You are being treated")
                            if (finished == 100) then
                                TriggerEvent('tp_ambulancejob:revive')
                                TriggerEvent('mythic_hospital:client:RemoveBleed')
                                TriggerEvent('mythic_hospital:client:ResetLimbs')
                                TriggerEvent('notification', 'Successful!')
                                TriggerServerEvent('erp-grandmas:payBill')
                            --- if not then notify
                            elseif not exports["dsrp-inventory"]:hasEnoughOfItem("pix1", 5) then
                                TriggerEvent("notification", "Grandma does not want to Treat you")
                            end
                        end
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)
