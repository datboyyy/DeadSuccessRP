local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

PlayerData = {}

local jailTime = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end
    
    PlayerData = ESX.GetPlayerData()


end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
    PlayerData = newData
    
    Citizen.Wait(25000)
    
    ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailTime", function(inJail, newJailTime)
        if inJail then
            
            jailTime = newJailTime
            
            JailLogin()
        end
    end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
    PlayerData["job"] = response
end)

RegisterNetEvent("esx-qalle-jail:openJailMenu")
AddEventHandler("esx-qalle-jail:openJailMenu", function()
    OpenJailMenu()
end)

RegisterNetEvent("esx-qalle-jail:jaAVACilPlayer")
AddEventHandler("esx-qalle-jail:jaAVACilPlayer", function(newJailTime, name)
        
        jailTime = newJailTime
        JailIntro(name, newJailTime, cid, date)
end)

function JailIntro(name, newJailTime, cid, date)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'handcuff', 1.0)
    
    TriggerEvent("police:remmaskAccepted")
    
    --local scaleform = RequestScaleformMovie("mugshot_board_01")
    --local objFound = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, `prop_police_id_board`, 0, 0, 0)
    --scaleformPaste(scaleform,objFound,name,newJailTime,cid,date)
    --print(scaleform,objFound,name,newJailTime,cid,date)
    SetEntityCoords(PlayerPedId(), 472.99, -1011.51, 26.27)
    SetEntityHeading(PlayerPedId(), 179.72)
    Citizen.Wait(1500)
    DoScreenFadeIn(500)
    FreezeEntityPosition(PlayerPedId(), true)
    Wait(1000)
    TriggerEvent("attachItemCONLOL", "con1", name, newJailTime, cid, date)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'photo', 0.4)
    Citizen.Wait(3000)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'photo', 0.4)
    Citizen.Wait(3000)
    SetEntityHeading(PlayerPedId(), 266.38)
    
    TriggerEvent('InteractSound_CL:PlayOnOne', 'photo', 0.4)
    Citizen.Wait(3000)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'photo', 0.4)
    Citizen.Wait(3000)
    SetEntityHeading(PlayerPedId(), 82.45)
    
    TriggerEvent('InteractSound_CL:PlayOnOne', 'photo', 0.4)
    Citizen.Wait(3000)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'photo', 0.4)
    Citizen.Wait(3000)
    
    SetEntityHeading(PlayerPedId(), 186.08)
    
    TriggerEvent('InteractSound_CL:PlayOnOne', 'jaildoor', 1.0)
    SetEntityHeading(PlayerPedId(), 87.39)
    SetEntityCoords(PlayerPedId(), 1785.99, 2577.46, 45.71)
    ExecuteCommand("e c")
    FreezeEntityPosition(PlayerPedId(), false)
    InJail()
end
DoScreenFadeIn(1500)
SwappingCharacters = false
outofrange = false
minutes = 0
function GroupRank(groupid)
    local rank = 0
    local mypasses = exports["isPed"]:isPed("passes")
    for i = 1, #mypasses do
        if mypasses[i]["pass_type"] == groupid then
            rank = mypasses[i]["rank"]
        end
    end
    return rank
end


RegisterNetEvent("esx-qalle-jail:unJailPlayer")
AddEventHandler("esx-qalle-jail:unJailPlayer", function()
    if jailTime > 0 then
        jailTime = 0
        UnJail()
    end
end)

function JailLogin()
    local JailPosition = Config.JailPositions["Cell"]
    SetEntityCoords(PlayerPedId(), JailPosition["x"], JailPosition["y"], JailPosition["z"] - 1)
    
    ESX.ShowNotification("Last time you went to sleep you were jailed, because of that you are now put back!")
    
    InJail()
end





function UnJail()
    InJail()
    
    ESX.Game.Teleport(PlayerPedId(), Config.Teleports["Boiling Broke"])
    
    ESX.ShowNotification("You are released, stay calm outside! Good LucK!")
end

function InJail()
    
    --Jail Timer--
    Citizen.CreateThread(function()
            
            while jailTime > 0 do
                
                jailTime = jailTime - 1
                
                ESX.ShowNotification("You have " .. jailTime .. " minutes left in jail!")
                
                TriggerServerEvent("esx-qalle-jail:updateJailTime", jailTime)
                
                if jailTime == 0 then
                    UnJail()
                    
                    TriggerServerEvent("esx-qalle-jail:updateJailTime", 0)
                end
                
                Citizen.Wait(60000)
            end
    
    end)

--Jail Timer--
end



function OpenJailMenu()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'jail_prison_menu',
        {
            title = "Prison Menu",
            align = 'center',
            elements = {
                {label = "Jail Closest Person", value = "jail_closest_player"},
                {label = "Unjail Person", value = "unjail_player"}
            }
        },
        function(data, menu)
            
            local action = data.current.value
            
            if action == "jail_closest_player" then
                
                menu.close()
                
                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'jail_choose_time_menu',
                    {
                        title = "Jail Time (minutes)"
                    },
                    function(data2, menu2)
                        
                        local jailTime = tonumber(data2.value)
                        
                        if jailTime == nil then
                            ESX.ShowNotification("The time needs to be in minutes!")
                        else
                            menu2.close()
                            
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification("No players nearby!")
                            else
                                ESX.UI.Menu.Open(
                                    'dialog', GetCurrentResourceName(), 'jail_choose_reason_menu',
                                    {
                                        title = "Jail Reason"
                                    },
                                    function(data3, menu3)
                                        
                                        local reason = data3.value
                                        
                                        if reason == nil then
                                            ESX.ShowNotification("You need to put something here!")
                                        else
                                            menu3.close()
                                            
                                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                            
                                            if closestPlayer == -1 or closestDistance > 3.0 then
                                                ESX.ShowNotification("No players nearby!")
                                            else
                                                TriggerServerEvent("esx-qalle-jail:jaAVACilPlayer", GetPlayerServerId(closestPlayer), jailTime, reason)
                                            end
                                        
                                        end
                                    
                                    end, function(data3, menu3)
                                        menu3.close()
                                    end)
                            end
                        
                        end
                    
                    end, function(data2, menu2)
                        menu2.close()
                    end)
            elseif action == "unjail_player" then
                
                local elements = {}
                
                ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailedPlayers", function(playerArray)
                        
                        if #playerArray == 0 then
                            ESX.ShowNotification("Your jail is empty!")
                            return
                        end
                        
                        for i = 1, #playerArray, 1 do
                            table.insert(elements, {label = "Prisoner: " .. playerArray[i].name .. " | Jail Time: " .. playerArray[i].jailTime .. " minutes", value = playerArray[i].identifier})
                        end
                        
                        ESX.UI.Menu.Open(
                            'default', GetCurrentResourceName(), 'jail_unjail_menu',
                            {
                                title = "Unjail Player",
                                align = "center",
                                elements = elements
                            },
                            function(data2, menu2)
                                
                                local action = data2.current.value
                                
                                TriggerServerEvent("esx-qalle-jail:unJailPlayer", action)
                                
                                menu2.close()
                            
                            end, function(data2, menu2)
                                menu2.close()
                            end)
                end)
            
            end
        
        end, function(data, menu)
            menu.close()
        end)
end

local function draw3DText(x, y, z, str, multiLine, r, g, b, a, font, scaleSize, enableProportional, enableCentre, enableOutline, enableShadow, sDist, sR, sG, sB, sA, enableBackground, bR, bG, bB, bA)
    local onScreen, worldX, worldY = World3dToScreen2d(x, y, z)
    local gameplayCamX, gameplayCamY, gameplayCamZ = table.unpack(GetGameplayCamCoords())
    
    if onScreen then
        SetTextScale(1.0, scaleSize)
        SetTextFont(font)
        SetTextColour(r, g, b, a)
        SetTextEdge(2, 0, 0, 0, 150)
        
        if enableProportional then
            SetTextProportional(1)
        end
        
        if enableOutline then
            SetTextOutline()
        end
        
        if enableShadow then
            SetTextDropshadow(sDist, sR, sG, sB, sA)
            SetTextDropShadow()
        end
        
        if enableCentre then
            SetTextCentre(1)
        end
        
        BeginTextCommandWidth("STRING")
        AddTextComponentString(str)
        local height = GetTextScaleHeight(scaleSize, font)
        
        if multiLine then
            height = GetTextScaleHeight(scaleSize, font) + (GetTextScaleHeight(scaleSize, font) / 2) + GetTextScaleHeight(scaleSize, font)
        end
        
        local width = EndTextCommandGetWidth(font)
        
        SetTextEntry("STRING")
        AddTextComponentString(str)
        EndTextCommandDisplayText(worldX, worldY)
        
        DrawText(worldX, worldY)
        
        if enableBackground then
            if not multiLine then
                DrawRect(worldX, worldY + scaleSize / 29, width + 0.008, height + 0.008, bR, bG, bB, bA)
            else
                DrawRect(worldX, worldY + scaleSize / 15.5, width + 0.008, height + 0.008, bR, bG, bB, bA)
            end
        end
    end
end




local function isNear(pos1, pos2, distMustBe)
    local diff = pos2 - pos1
    local dist = (diff.x * diff.x) + (diff.y * diff.y) + (diff.z * diff.z)
    
    return (dist < (distMustBe * distMustBe))
end




Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local plyPos = GetEntityCoords(GetPlayerPed(-1))
        local prisonphones = vector3(1827.29, 2589.70, 46.1)
        if isNear(plyPos, prisonphones, 2) then
            draw3DText(prisonphones.x, prisonphones.y, prisonphones.z, "[H] Check your prison time left.\nDo not use during prison break.", true, 255, 255, 255, 255, 4, 0.40, true, true, true, true, 0, 0, 0, 0, 255, true, 43, 17, 64, 100, 0.01)
            if IsControlJustPressed(0, 74) then -- "E"
                TriggerEvent('notification', 'You have: ' .. jailTime .. ' months left')
            end
        else
            Wait(1000)
        end
    end
end)


local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}




function DrawText2(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

local function draw3DText(x, y, z, str, multiLine, r, g, b, a, font, scaleSize, enableProportional, enableCentre, enableOutline, enableShadow, sDist, sR, sG, sB, sA, enableBackground, bR, bG, bB, bA)
    local onScreen, worldX, worldY = World3dToScreen2d(x, y, z)
    local gameplayCamX, gameplayCamY, gameplayCamZ = table.unpack(GetGameplayCamCoords())
    
    if onScreen then
        SetTextScale(1.0, scaleSize)
        SetTextFont(font)
        SetTextColour(r, g, b, a)
        SetTextEdge(2, 0, 0, 0, 150)
        
        if enableProportional then
            SetTextProportional(1)
        end
        
        if enableOutline then
            SetTextOutline()
        end
        
        if enableShadow then
            SetTextDropshadow(sDist, sR, sG, sB, sA)
            SetTextDropShadow()
        end
        
        if enableCentre then
            SetTextCentre(1)
        end
        
        BeginTextCommandWidth("STRING")
        AddTextComponentString(str)
        local height = GetTextScaleHeight(scaleSize, font)
        
        if multiLine then
            height = GetTextScaleHeight(scaleSize, font) + (GetTextScaleHeight(scaleSize, font) / 2) + GetTextScaleHeight(scaleSize, font)
        end
        
        local width = EndTextCommandGetWidth(font)
        
        SetTextEntry("STRING")
        AddTextComponentString(str)
        EndTextCommandDisplayText(worldX, worldY)
        
        DrawText(worldX, worldY)
        
        if enableBackground then
            if not multiLine then
                DrawRect(worldX, worldY + scaleSize / 29, width + 0.008, height + 0.008, bR, bG, bB, bA)
            else
                DrawRect(worldX, worldY + scaleSize / 15.5, width + 0.008, height + 0.008, bR, bG, bB, bA)
            end
        end
    end
end

local function isNear(pos1, pos2, distMustBe)
    local diff = pos2 - pos1
    local dist = (diff.x * diff.x) + (diff.y * diff.y) + (diff.z * diff.z)
    
    return (dist < (distMustBe * distMustBe))
end

local showerstaken = 0

local places =
    {
        ["prisonShower"] = -- Roof up
        {
            vector3(1759.28, 2586.96, 45.72)
        }
    
    }


Citizen.CreateThread(function()
    while true do
        local plyPed = GetPlayerPed(-1)
        local plyPos = GetEntityCoords(plyPed)
        
        for k, v in pairs(places) do
            for m, n in pairs(places[k]) do
                if isNear(plyPos, n, 2) and plyPos.z <= 50 and plyPos.z >= 40 then
                    draw3DText(n.x, n.y, n.z, "[E] Take a shower.\nGet clean, smelly.", true, 255, 255, 255, 255, 4, 0.40, true, true, true, true, 0, 0, 0, 0, 255, true, 43, 17, 64, 100, 0.01)
                    
                    if IsControlJustPressed(0, Keys['E']) then -- "E"
                        local whatshower = math.random(1, 5)
                        if whatshower == 1 then
                            SetEntityCoords(GetPlayerPed(-1), vector3(1760.0, 2585.28, 45.72))
                            SetEntityHeading(GetPlayerPed(-1), 88.34)
                        elseif whatshower == 2 then
                            SetEntityCoords(GetPlayerPed(-1), vector3(1760.24, 2584.12, 45.72))
                            SetEntityHeading(GetPlayerPed(-1), 88.34)
                        elseif whatshower == 3 then
                            SetEntityCoords(GetPlayerPed(-1), vector3(1760.24, 2582.28, 45.72))
                            SetEntityHeading(GetPlayerPed(-1), 88.34)
                        elseif whatshower == 4 then
                            SetEntityCoords(GetPlayerPed(-1), vector3(1758.56, 2584.08, 45.72))
                            SetEntityHeading(GetPlayerPed(-1), 263.64)
                        end
                        
                        while not HasAnimDictLoaded("anim@mp_yacht@shower@male@") do
                            RequestAnimDict("anim@mp_yacht@shower@male@")
                            Citizen.Wait(5)
                        end
                        
                        TaskPlayAnim(plyPed, "anim@mp_yacht@shower@male@", "male_shower_idle_a", 5.0, 1.0, -1, 1, 0, 0, 0, 0)
                        Citizen.Wait(1000)
                        FreezeEntityPosition(GetPlayerPed(-1), true)
                        exports["sway_taskbar"]:taskBar(20000, "Showering.. ")
                        FreezeEntityPosition(GetPlayerPed(-1), false)
                        ClearPedTasks(GetPlayerPed(-1))
                        if showerstaken == 3 then
                            showerstaken = 0
                            exports['mythic_notify']:SendAlert('success', "Thank god you cleaned up, the smell was horendous. I've told the warden you're no longer a stinkfest.")
                        end
                    end
                else
                    Wait(1000)
                end
            
            
            end
        end
        
        Citizen.Wait(1)
    end
end)


function scaleformPaste(scaleform, obj, name, newJailTime, cid, date)
    local position = GetOffsetFromEntityInWorldCoords(obj, -0.2, -0.0132 - (GetEntitySpeed(PlayerPedId()) / 50), 0.105)
    local scale = vector3(0.41, 0.23, 1.0)
    local push = GetEntityRotation(obj, 2)
    
    Citizen.InvokeNative(0x87D51D72255D4E78, scaleform, position, 180.0 + push["x"], 0.0 - GetEntityRoll(obj), GetEntityHeading(obj), 1.0, 0.8, 4.0, scale, 0)
    
    if not date then
        date = "Department of Corrections"
    end
    
    if not newJailTime then
        newJailTime = 0
    end
    
    if not name then
        name = "No Name"
    end
    
    PushScaleformMovieFunction(scaleform, "SET_BOARD")
    PushScaleformMovieFunctionParameterString("LOS SANTOS POLICE DEPARTMENT")
    PushScaleformMovieFunctionParameterString(date)
    PushScaleformMovieFunctionParameterString("Sentenced to " .. newJailTime .. " Months")
    PushScaleformMovieFunctionParameterString(name)
    PushScaleformMovieFunctionParameterFloat(0.0)
    PushScaleformMovieFunctionParameterString(cid)
    PushScaleformMovieFunctionParameterFloat(0.0)
    PopScaleformMovieFunctionVoid()
end



attachedProp = 0
function removeAttachedProp()
    DeleteEntity(attachedProp)
    attachedProp = 0
end

--missfinale_c2mcs_2_b mcs_2_b_takeout_phone_peda
function runAnimation()
    RequestAnimDict("mp_character_creation@lineup@male_a")
    while not HasAnimDictLoaded("mp_character_creation@lineup@male_a") do
        Citizen.Wait(0)
    end
    if not IsEntityPlayingAnim(PlayerPedId(), "mp_character_creation@lineup@male_a", "loop_raised", 3) then
        TaskPlayAnim(PlayerPedId(), "mp_character_creation@lineup@male_a", "loop_raised", 8.0, -8, -1, 49, 0, 0, 0, 0)
    end
end
RegisterNetEvent('attachPropCon')
AddEventHandler('attachPropCon', function(attachModelSent, boneNumberSent, x, y, z, xR, yR, zR)
    runAnimation()
    removeAttachedProp()
    attachModel = GetHashKey(attachModelSent)
    boneNumber = boneNumberSent
    SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
    local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
    --local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    RequestModel(attachModel)
    while not HasModelLoaded(attachModel) do
        Citizen.Wait(100)
    end
    attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
    AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
    exit = false
    local plyCoords = GetEntityCoords(PlayerPedId())
    while not exit do
        
        Citizen.Wait(1)
        plyCoords2 = GetEntityCoords(PlayerPedId())
        if not IsEntityPlayingAnim(PlayerPedId(), "mp_character_creation@lineup@male_a", "loop_raised", 3) then
            exit = true
        end
        if (#(plyCoords2 - plyCoords) > 1.5) then
            exit = true
        end
    end
    ClearPedTasksImmediately(PlayerPedId())
    removeAttachedProp()
end)


Citizen.CreateThread(function()
    Wait(900)
    while true do
        local player = GetEntityCoords(PlayerPedId())
        local distance = #(vector3(2740.40, 1530.90, 24.50) - player)
        if distance < 3.0 then
            Wait(1)
            DrawMarker(27, 2740.40, 1530.90, 23.80, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 255, 0, 0, 60, 0, 0, 2, 0, 0, 0, 0)
            DT(2740.40, 1530.90, 24.50, "[E] Use Power Plant Security Card")
            if IsControlJustReleased(0, 38) and distance < 1.0 then
                if exports["dsrp-inventory"]:hasEnoughOfItem("Gruppe6Card", 1, false) then
                    TriggerEvent("inventory:removeItem", "Gruppe6Card", 1)
                    TriggerEvent('prisonbreaktest')
                end
            end
        else
            Wait(3000)
        end
    end
end)


RegisterNetEvent('prisonbreaktest')
AddEventHandler('prisonbreaktest', function()
    TriggerEvent("utk_fingerprint:Start", 3, 1, 2, HackFinished)
end)




function HackFinished(outcome, reason)
    if outcome == true then
        FreezeEntityPosition(PlayerPedId(), false)
        TriggerEvent('fixfroze')
        TriggerEvent('esx-dispatch:jailbreak')
        TriggerServerEvent('SetPrisonWeather')
        DoorSystemSetDoorState(29, false, false, true)
        DoorSystemSetDoorState(24, false, false, true)
        DoorSystemSetDoorState(23, false, false, true)
        TriggerServerEvent('trp-doors:fetchState', 29, false)
        TriggerServerEvent('trp-doors:fetchState', 24, false)
        TriggerServerEvent('trp-doors:fetchState', 23, false)
        Wait(120000)
        DoorSystemSetDoorState(29, true, false, true)
        DoorSystemSetDoorState(24, true, false, true)
        DoorSystemSetDoorState(23, true, false, true)
        TriggerServerEvent('trp-doors:fetchState', 29, true)
        TriggerServerEvent('trp-doors:fetchState', 24, true)
        TriggerServerEvent('trp-doors:fetchState', 23, true)
    elseif outcome == false then
        print("Failed! Reason: " .. reason)
    end
end

function DT(x, y, z, text)
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

RegisterCommand('retrivejail', function()
    ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailedPlayers", function(playerArray)
        print('Array', json.encode(playerArray))
    end)
end)
