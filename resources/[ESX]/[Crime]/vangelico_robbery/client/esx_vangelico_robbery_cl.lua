local holdingup = false
local store = ""
local blipRobbery = nil

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if (outline) then
        SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

RegisterNetEvent('esx_vangelico_robbery:currentlyrobbing')
AddEventHandler('esx_vangelico_robbery:currentlyrobbing', function(robb)
    holdingup = true
    store = robb
end)

RegisterNetEvent('esx_vangelico_robbery:killblip')
AddEventHandler('esx_vangelico_robbery:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('esx_vangelico_robbery:setblip')
AddEventHandler('esx_vangelico_robbery:setblip', function(position)
    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery, 161)
    SetBlipScale(blipRobbery, 2.0)
    SetBlipColour(blipRobbery, 5)
    PulseBlip(blipRobbery)
end)

RegisterNetEvent('esx_vangelico_robbery:toofarlocal')
AddEventHandler('esx_vangelico_robbery:toofarlocal', function(robb)
    holdingup = false
    ESX.ShowNotification(_U('robbery_cancelled'))
    robbingName = ""
    incircle = false
end)


RegisterNetEvent('esx_vangelico_robbery:robberycomplete')
AddEventHandler('esx_vangelico_robbery:robberycomplete', function(robb)
    holdingup = false
    
    TriggerEvent('skinchanger:getSkin', function(skin)
            
            if skin.sex == 0 then
                
                local clothesSkin = {
                    ['bags_1'] = 41, ['bags_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            
            else
                
                local clothesSkin = {
                    ['bags_1'] = 41, ['bags_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            
            end
    end)
    ESX.ShowNotification(_U('robbery_complete'))
    store = ""
    incircle = false
end)

Citizen.CreateThread(function()
    for k, v in pairs(Stores) do
        local ve = v.position
        
        local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
        SetBlipSprite(blip, 617)
        SetBlipColour(blip, 3)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(_U('shop_robbery'))
        EndTextCommandSetBlipName(blip)
    end
end)


incircle = false

hasrobbed = false
hasrobbed2 = false
hasrobbed3 = false
hasrobbed4 = false
hasrobbed5 = false
hasrobbed6 = false
hasrobbed7 = false
hasrobbed8 = false
hasrobbed9 = false
hasrobbed10 = false
hasrobbed11 = false
hasrobbed12 = false
hasrobbed13 = false
hasrobbed14 = false
hasrobbed15 = false
hasrobbed16 = false
hasrobbed17 = false
hasrobbed18 = false
hasrobbed19 = false
hasrobbed20 = false

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

Citizen.CreateThread(function()
        
        while true do
            local pos = GetEntityCoords(GetPlayerPed(-1), true)
            
            for k, v in pairs(Stores) do
                local pos2 = v.position
                
                if (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0) then
                    if not holdingup then
                        DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
                        
                        if (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0) then
                            if (incircle == false) then
                                DisplayHelpText(_U('press_to_rob'))
                            end
                            incircle = true
                            if IsPedShooting(GetPlayerPed(-1)) then
                                
                                
                                
                                TriggerServerEvent('esx_vangelico_robbery:rob', k)
                            end
                        elseif (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0) then
                            incircle = false
                        end
                    end
                end
            end
            
            if holdingup then
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -626.5326, -238.3758, 38.05, true) < 0.5) then
                    if (hasrobbed == false) then
                        DrawText3Ds(-626.5326, -238.3758, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -626.5326, -238.3758, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli1)
                            TriggerEvent("player:receiveItem", "goldbar", math.random(1, 6))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -625.6032, -237.5273, 38.05, true) < 0.5) then
                    if (hasrobbed2 == false) then
                        DrawText3Ds(-625.6032, -237.5273, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -625.6032, -237.5273, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli2)
                            TriggerEvent("player:receiveItem", "goldbar", math.random(1, 6))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed2 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -626.9178, -235.5166, 38.05, true) < 0.5) then
                    if (hasrobbed3 == false) then
                        DrawText3Ds(-626.9178, -235.5166, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -626.9178, -235.5166, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli3)
                            TriggerEvent("player:receiveItem", "rolexwatch", math.random(1, 5))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed3 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -625.6701, -234.6061, 38.05, true) < 0.5) then
                    if (hasrobbed4 == false) then
                        DrawText3Ds(-625.6701, -234.6061, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -625.6701, -234.6061, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli4)
                            TriggerEvent("player:receiveItem", "goldbar", math.random(1, 6))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed4 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -626.8935, -233.0814, 38.05, true) < 0.5) then
                    if (hasrobbed5 == false) then
                        DrawText3Ds(-626.8935, -233.0814, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -626.8935, -233.0814, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli5)
                            TriggerEvent("player:receiveItem", "goldbar", math.random(1, 5))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed5 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -627.9514, -233.8582, 38.05, true) < 0.5) then
                    if (hasrobbed6 == false) then
                        DrawText3Ds(-627.9514, -233.8582, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -627.9514, -233.8582, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli6)
                            TriggerEvent("player:receiveItem", "rolexwatch", math.random(1, 5))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed6 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -624.5250, -231.0555, 38.05, true) < 0.5) then
                    if (hasrobbed7 == false) then
                        DrawText3Ds(-624.5250, -231.0555, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -624.5250, -231.0555, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli7)
                            TriggerEvent("player:receiveItem", "goldbar", math.random(1, 6))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed7 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -623.0003, -233.0833, 38.05, true) < 0.5) then
                    if (hasrobbed8 == false) then
                        DrawText3Ds(-623.0003, -233.0833, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -623.0003, -233.0833, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli8)
                            TriggerEvent("player:receiveItem", "goldbar", math.random(1, 6))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed8 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -620.1098, -233.3672, 38.05, true) < 0.5) then
                    if (hasrobbed9 == false) then
                        DrawText3Ds(-620.1098, -233.3672, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -620.1098, -233.3672, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli9)
                            TriggerEvent("player:receiveItem", "goldbar", math.random(1, 6))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed9 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -620.2979, -234.4196, 38.05, true) < 0.5) then
                    if (hasrobbed10 == false) then
                        DrawText3Ds(-620.2979, -234.4196, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -620.2979, -234.4196, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli10)
                            TriggerEvent("player:receiveItem", "rolexwatch", math.random(1, 5))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed10 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -619.0646, -233.5629, 38.05, true) < 0.5) then
                    if (hasrobbed11 == false) then
                        DrawText3Ds(-619.0646, -233.5629, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -619.0646, -233.5629, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli11)
                            TriggerEvent("player:receiveItem", "rolexwatch", math.random(1, 5))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed11 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -617.4846, -230.6598, 38.05, true) < 0.5) then
                    if (hasrobbed12 == false) then
                        DrawText3Ds(-617.4846, -230.6598, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -617.4846, -230.6598, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli12)
                            TriggerEvent("player:receiveItem", "rolexwatch", math.random(1, 5))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed12 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -618.3619, -229.4285, 38.05, true) < 0.5) then
                    if (hasrobbed13 == false) then
                        DrawText3Ds(-618.3619, -229.4285, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -618.3619, -229.4285, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli13)
                            TriggerEvent("player:receiveItem", "rolexwatch", math.random(1, 5))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed13 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -619.6064, -230.5518, 38.05, true) < 0.5) then
                    if (hasrobbed14 == false) then
                        DrawText3Ds(-619.6064, -230.5518, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -619.6064, -230.5518, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli14)
                            TriggerEvent("player:receiveItem", "rolexwatch", math.random(1, 5))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed14 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -620.8951, -228.6519, 38.05, true) < 0.5) then
                    if (hasrobbed15 == false) then
                        DrawText3Ds(-620.8951, -228.6519, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -620.8951, -228.6519, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli15)
                            TriggerEvent("player:receiveItem", "rolexwatch", math.random(1, 5))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed15 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -619.7905, -227.5623, 38.05, true) < 0.5) then
                    if (hasrobbed16 == false) then
                        DrawText3Ds(-619.7905, -227.5623, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -619.7905, -227.5623, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli16)
                            TriggerEvent("player:receiveItem", "rolexwatch", math.random(1, 5))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed16 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -620.6110, -226.4467, 38.05, true) < 0.5) then
                    if (hasrobbed17 == false) then
                        DrawText3Ds(-620.6110, -226.4467, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -620.6110, -226.4467, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli17)
                            TriggerEvent("player:receiveItem", "rolexwatch", math.random(1, 5))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed17 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -623.9951, -228.1755, 38.05, true) < 0.5) then
                    if (hasrobbed18 == false) then
                        DrawText3Ds(-623.9951, -228.1755, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -623.9951, -228.1755, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli18)
                            TriggerEvent("player:receiveItem", "rolexwatch", math.random(1, 5))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed18 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -624.8832, -227.8645, 38.05, true) < 0.5) then
                    if (hasrobbed19 == false) then
                        DrawText3Ds(-624.8832, -227.8645, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -624.8832, -227.8645, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli19)
                            TriggerEvent("player:receiveItem", "rolexwatch", math.random(1, 5))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed19 = true
                        end
                    end
                end
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -623.6746, -227.0025, 38.05, true) < 0.5) then
                    if (hasrobbed20 == false) then
                        DrawText3Ds(-623.6746, -227.0025, 38.05, "Press [E] to rob!")
                        if IsControlJustReleased(1, 51) then
                            local player = GetPlayerPed(-1)
                            if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                RequestNamedPtfxAsset("scr_jewelheist")
                            end
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            SetPtfxAssetNextCall("scr_jewelheist")
                            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", -623.6746, -227.0025, 38.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                            loadAnimDict("missheist_jewel")
                            TaskPlayAnim(player, "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'robberyglassbreak', 0.5)
                            DisplayHelpText(_U('collectinprogress'))
                            DrawSubtitleTimed(5000, 1)
                            Citizen.Wait(5000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            RemoveBlip(gioielli20)
                            TriggerEvent("player:receiveItem", "rolexwatch", math.random(1, 5))
                            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            hasrobbed20 = true
                        end
                    end
                end
                
                if (hasrobbed == true) and (hasrobbed2 == true) and (hasrobbed3 == true) and (hasrobbed4 == true) and (hasrobbed5 == true) and (hasrobbed6 == true) and (hasrobbed7 == true) and (hasrobbed8 == true) and (hasrobbed9 == true) and (hasrobbed10 == true) and (hasrobbed11 == true) and (hasrobbed12 == true) and (hasrobbed13 == true) and (hasrobbed14 == true) and (hasrobbed15 == true) and (hasrobbed16 == true) and (hasrobbed17 == true) and (hasrobbed18 == true) and (hasrobbed19 == true) and (hasrobbed20 == true) then
                    holdingup = false
                    
                    hasrobbed = false
                    hasrobbed2 = false
                    hasrobbed3 = false
                    hasrobbed4 = false
                    hasrobbed5 = false
                    hasrobbed6 = false
                    hasrobbed7 = false
                    hasrobbed8 = false
                    hasrobbed9 = false
                    hasrobbed10 = false
                    hasrobbed11 = false
                    hasrobbed12 = false
                    hasrobbed13 = false
                    hasrobbed14 = false
                    hasrobbed15 = false
                    hasrobbed16 = false
                    hasrobbed17 = false
                    hasrobbed18 = false
                    hasrobbed19 = false
                    hasrobbed20 = false
                    TriggerServerEvent('esx_vangelico_robbery:endrob', store)
                    ESX.ShowNotification(_U('lester'))
                    TriggerEvent('skinchanger:getSkin', function(skin)
                            
                            if skin.sex == 0 then
                                
                                local clothesSkin = {
                                    ['bags_1'] = 41, ['bags_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                            
                            else
                                
                                local clothesSkin = {
                                    ['bags_1'] = 41, ['bags_2'] = 0
                                }
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                            
                            end
                    end)
                end
                
                local pos2 = Stores[store].position
                
                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -622.566, -230.183, 38.057, true) > 11.5) then
                    TriggerServerEvent('esx_vangelico_robbery:toofar', store)
                    holdingup = false
                    RemoveBlip(gioielli1)
                    RemoveBlip(gioielli2)
                    RemoveBlip(gioielli3)
                    RemoveBlip(gioielli4)
                    RemoveBlip(gioielli5)
                    RemoveBlip(gioielli6)
                    RemoveBlip(gioielli7)
                    RemoveBlip(gioielli8)
                    RemoveBlip(gioielli9)
                    RemoveBlip(gioielli10)
                    RemoveBlip(gioielli11)
                    RemoveBlip(gioielli12)
                    RemoveBlip(gioielli13)
                    RemoveBlip(gioielli14)
                    RemoveBlip(gioielli15)
                    RemoveBlip(gioielli16)
                    RemoveBlip(gioielli17)
                    RemoveBlip(gioielli18)
                    RemoveBlip(gioielli19)
                    RemoveBlip(gioielli20)
                    
                    hasrobbed = false
                    hasrobbed2 = false
                    hasrobbed3 = false
                    hasrobbed4 = false
                    hasrobbed5 = false
                    hasrobbed6 = false
                    hasrobbed7 = false
                    hasrobbed8 = false
                    hasrobbed9 = false
                    hasrobbed10 = false
                    hasrobbed11 = false
                    hasrobbed12 = false
                    hasrobbed13 = false
                    hasrobbed14 = false
                    hasrobbed15 = false
                    hasrobbed16 = false
                    hasrobbed17 = false
                    hasrobbed18 = false
                    hasrobbed19 = false
                    hasrobbed20 = false
                end
            end
            
            Citizen.Wait(0)
        end
end)

RegisterNetEvent('esx_vangelico_robbery:togliblip')
AddEventHandler('esx_vangelico_robbery:togliblip', function(robb)
    RemoveBlip(gioielli1)
    RemoveBlip(gioielli2)
    RemoveBlip(gioielli3)
    RemoveBlip(gioielli4)
    RemoveBlip(gioielli5)
    RemoveBlip(gioielli6)
    RemoveBlip(gioielli7)
    RemoveBlip(gioielli8)
    RemoveBlip(gioielli9)
    RemoveBlip(gioielli10)
    RemoveBlip(gioielli11)
    RemoveBlip(gioielli12)
    RemoveBlip(gioielli13)
    RemoveBlip(gioielli14)
    RemoveBlip(gioielli15)
    RemoveBlip(gioielli16)
    RemoveBlip(gioielli17)
    RemoveBlip(gioielli18)
    RemoveBlip(gioielli19)
    RemoveBlip(gioielli20)
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

Citizen.CreateThread(function()
    TriggerEvent('lester:createBlip', 77, 706.669, -966.898, 30.413)
    
    while true do
        Citizen.Wait(0)
        playerPed = GetPlayerPed(-1)
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        
        if pos then
            
            if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 706.669, -966.898, 30.413, true) <= 5 then
                TriggerServerEvent('lester:venAVACdita')
                Citizen.Wait(4000)
                TriggerEvent('skinchanger:getSkin', function(skin)
                        
                        if skin.sex == 0 then
                            
                            local clothesSkin = {
                                ['bags_1'] = 0, ['bags_2'] = 0
                            }
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        
                        else
                            
                            local clothesSkin = {
                                ['bags_1'] = 0, ['bags_2'] = 0
                            }
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        
                        end
                end)
            end
        end
    end
end)
