
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
local overTime = 0
local imjailed = false
local canLeave = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
    -- LoadTeleporters()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
    PlayerData = newData
    Citizen.Wait(25000)

    ESX.TriggerServerCallback("erpjailsystem:retrieveJailTime", function(inJail, newJailTime)
        if inJail then
            jailTime = newJailTime
            JailLogin()
        else
            canLeave = true
        end
    end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
    PlayerData["job"] = response
end)

curTaskType = "None"
jobProcess = false
finalTask = nil
-- repair weld
local repaircoords = {
    [1] = { ["x"] = 1737.442, ["y"] = 2505.051, ["z"] = 45.56503},
    [2] = { ["x"] = 1696.098, ["y"] = 2536.137, ["z"] = 45.56489},
    [3] = { ["x"] = 1643.723, ["y"] = 2491.223, ["z"] = 45.5649},
    [4] = { ["x"] = 1630.292, ["y"] = 2527.271, ["z"] = 45.56485},
    [5] = { ["x"] = 1609.171, ["y"] = 2566.858, ["z"] = 45.56485},
    [6] = { ["x"] = 1630.145, ["y"] = 2564.175, ["z"] = 45.56486},
    [7] = { ["x"] = 1634.835, ["y"] = 2555.029, ["z"] = 45.56486},
    [8] = { ["x"] = 1652.523, ["y"] = 2564.075, ["z"] = 45.56485},
    [9] = { ["x"] = 1686.004, ["y"] = 2553.587, ["z"] = 45.56485},
    [10] = { ["x"] = 1718.63, ["y"] = 2527.791, ["z"] = 45.56485},
    [11] = { ["x"] = 1686.486, ["y"] = 2533.447, ["z"] = 45.56485},
    [12] = { ["x"] = 1706.598, ["y"] = 2481.381, ["z"] = 45.56492}
}

eatenRecently = false
cleanedRecently = false
repairedRecently = false

-- dirty trays
local cleancoords = {
    [1] = { ["x"] = 1785.0008544922, ["y"] = 2668.4755859375, ["z"] = -71.025829772949},
    [2] = { ["x"] = 1781.8439941406, ["y"] = 2667.4321289063, ["z"] = -71.025829772949},
    [3] = { ["x"] = 1784.1990966797, ["y"] = 2671.9880371094, ["z"] = -71.025829772949},
    [4] = { ["x"] = 1780.8930664063, ["y"] = 2670.93359375, ["z"] = -71.025829772949},
    [5] = { ["x"] = 1788.9401855469, ["y"] = 2672.4692382813, ["z"] = -71.025829772949},
    [6] = { ["x"] = 1792.6455078125, ["y"] = 2671.3923339844, ["z"] = -71.025829772949},
    [8] = { ["x"] = 1791.1920166016, ["y"] = 2675.6555175781, ["z"] = -71.025829772949},
    [9] = { ["x"] = 1790.8732910156, ["y"] = 2676.7114160156, ["z"] = -71.025829772949},
    [10] = { ["x"] = 1790.3718261719, ["y"] = 2677.2524414063, ["z"] = -71.025829772949},
    [11] = { ["x"] = 1786.3077392578, ["y"] = 2664.9624023438, ["z"] = -71.025829772949},
    [12] = { ["x"] = 1787.1925048828, ["y"] = 2662.208984375, ["z"] = -71.025829772949},
    [13] = { ["x"] = 1787.7763671875, ["y"] = 2660.2878417969, ["z"] = -71.025829772949},
    [14] = { ["x"] = 1788.0771263672, ["y"] = 2659.4565429688, ["z"] = -71.025829772949},
    [15] = { ["x"] = 1785.3857421875, ["y"] = 2659.6887207131, ["z"] = -71.025829772949},
    [16] = { ["x"] = 1784.6643066406, ["y"] = 2662.1413574219, ["z"] = -71.025829772949},
    [17] = { ["x"] = 1783.7952880859, ["y"] = 2664.9189453125, ["z"] = -71.025829772949},
    [18] = { ["x"] = 1782.0529785156, ["y"] = 2664.2622071313, ["z"] = -71.025829772949}
}

local foodTrays = {
    [1] = "prop_food_cb_tray_01",
    [2] = "prop_food_cb_tray_02",
    [3] = "prop_food_cb_tray_03",
    [4] = "prop_food_cb_tray_04",
    [5] = "prop_food_cb_tray_05",
    [6] = "prop_food_cb_tray_06",
    [7] = "prop_food_bs_tray_01",
    [8] = "prop_food_bs_tray_02",
    [9] = "prop_food_bs_tray_03",
    [10] = "prop_food_bs_tray_04",
    [11] = "prop_food_bs_tray_05",
    [12] = "prop_food_bs_tray_06",
    [13] = "prop_food_tray_01",
    [14] = "prop_food_tray_02",
    [15] = "prop_food_tray_03",
    [16] = "prop_food_tray_04",
    [17] = "prop_food_tray_05",
    [18] = "prop_food_tray_06"
}



local eatTask = {
    ["x"] = 17775.86, ["y"] = 2587.87, ["z"] = 45.71
}

local finishCleanTask = {
    ["x"] = 1796.5484619141, ["y"] = 2666.2395019531, ["z"] = -71.988594055176
}

local checkJailTime = {
    ["x"] = 1827.249, ["y"] = 2589.802, ["z"] = 45.80
}

workoutAreas = {
  [1] = { ["x"] = 1647.381, ["y"] = 2527.725, ["z"] = 45.5649, ["h"] = 229.51, ["workType"] = "Pushups", ["animDict"] = "amb@world_human_push_ups@male@base", ["anim"] = "base" },
  [2] = { ["x"] = 1645.441, ["y"] = 2525.555, ["z"] = 45.5649, ["h"] = 229.51, ["workType"] = "Pushups", ["animDict"] = "amb@world_human_push_ups@male@base", ["anim"] = "base" },
  [3] = { ["x"] = 1636.394, ["y"] = 2523.749, ["z"] = 45.56, ["h"] = 229.51, ["workType"] = "Situps", ["animDict"] = "amb@world_human_sit_ups@male@base", ["anim"] = "base" },    
  [4] = { ["x"] = 1638.497, ["y"] = 2526.01, ["z"] = 45.56489, ["h"] = 229.51, ["workType"] = "Situps", ["animDict"] = "amb@world_human_sit_ups@male@base", ["anim"] = "base" },
  [5] =  { ['x'] = 1648.909, ['y'] = 2529.731, ['z'] = 45.56488, ['h'] = 229.51, ["workType"] = "Chinups", ["animDict"] = "amb@prop_human_muscle_chin_ups@male@base", ["anim"] = "base" },
  [6] =  { ['x'] = 1643.148, ['y'] = 2527.889, ['z'] = 45.56491, ['h'] = 229.51, ["workType"] = "Chinups", ["animDict"] = "amb@prop_human_muscle_chin_ups@male@base", ["anim"] = "base" },
}

function DrawText3DTest(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

local inprocess = false
local workoutType = 0

Citizen.CreateThread(function()
    while true do
        local playerped = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(playerped)        
        local waitCheck2 = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 1647.703,2534.061,45.56489)
        local waitCheck = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 1639.173,2523.785,45.5649)

        if (waitCheck > 40.0 and waitCheck2 > 40.0 ) or inprocess then
            Citizen.Wait(math.ceil(waitCheck))
        else
            Citizen.Wait(1)
            for i = 1, #workoutAreas do
                local distCheck = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), workoutAreas[i]["x"], workoutAreas[i]["y"], workoutAreas[i]["z"])
                if distCheck < 2.0 and not inprocess then
                    DrawText3DTest(workoutAreas[i]["x"], workoutAreas[i]["y"], workoutAreas[i]["z"], "[E] to do " .. workoutAreas[i]["workType"] .. "" )
                end
                if distCheck < 1.0 then
                    if (IsControlJustReleased(1, 38)) then
                        workoutType = i
                        TriggerEvent("erpjailsystem:doworkout")
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('erpjailsystem:doworkout')
AddEventHandler('erpjailsystem:doworkout', function()
    inprocess = true
    workoutActivity = tostring(workoutAreas[workoutType]["workType"])

    if workoutActivity == 'Pushups' or workoutActivity == 'Situps' then Citizen.Wait(500) end  
    if workoutActivity == 'Chinups' then
        local playerPed = GetPlayerPed(-1)
        print('Starting task scenario')
        SetEntityCoords(GetPlayerPed(-1), workoutAreas[workoutType]["x"],workoutAreas[workoutType]["y"],workoutAreas[workoutType]["z"]-1.03)
        SetEntityHeading(GetPlayerPed(-1),workoutAreas[workoutType]["h"]) 
        TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_MUSCLE_CHIN_UPS", 0, true)
        local finished = exports["sway_taskbar"]:taskBar(10000, "Exercising")  
        ClearPedTasks(playerPed)
        TriggerEvent('esx_status:remove', 'stress', 200)
        inprocess = false   
    else    
        SetEntityCoords(GetPlayerPed(-1), workoutAreas[workoutType]["x"],workoutAreas[workoutType]["y"],workoutAreas[workoutType]["z"])
        SetEntityHeading(GetPlayerPed(-1),workoutAreas[workoutType]["h"]) 
        local finished = exports["sway_taskbar"]:taskBar(10000, "Exercising")  
        TaskPlayAnim(playerPed, workoutAreas[workoutType]["animDict"],workoutAreas[workoutType]["anim"], 8.0, 8.0, 10000, -1, 0, 0.0)
        ClearPedTasks(playerPed)
        TriggerEvent('esx_status:remove', 'stress', 200)
        inprocess = false       
    Citizen.Wait(30000)
    inprocess = false  
    end 
end)



-- animDict = workoutAreas[workoutType]["animDict"],
-- anim = workoutAreas[workoutType]["anim"],
function deleteClosestTray()--foodTrays
    local closestDist = 9999.9
    local ped = GetPlayerPed(-1)
    local closesttray
    local obj
    local curDist
    for i=1,#foodTrays do
        obj = GetClosestObjectOfType(GetEntityCoords(ped).x, GetEntityCoords(ped).y, GetEntityCoords(ped).z, 3.0, GetHashKey(foodTrays[i]), false, true ,true)
        curDist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), GetEntityCoords(obj).x, GetEntityCoords(obj).y, GetEntityCoords(obj).z)
        if curDist < closestDist then
            closestDist = curDist
            closesttray = obj
        end
    end
    SetEntityVisible(closesttray, false)
end

function addBlipForJob(x,y,z)
    RemoveBlip(Blip)
    if curTaskType == "Eat" then
        x = 1798.2548828125
        y = 2552.34375
        z = 45.564987182617
    end     
    Blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(Blip, 430)
    SetBlipScale(blip, 0.45)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Next Jail Task")
    EndTextCommandSetBlipName(Blip)
end

cleaninginprogress = false
function finishTask(jailTime)
    local minutes = math.random(1,2)
    local factor = 25
    if curTaskType == "Clean" then
        TriggerEvent("erpjailsystem:cleananim")
        factor = 10
        deleteClosestTray()
    end

    if curTaskType == "Repair" then
        TriggerEvent("erpjailsystem:repairanim")
        Citizen.Wait(180000)
        factor = 5
    end

    if curTaskType == "Eat" then
        TriggerServerEvent("erpjailsystem:prisonfoodtask") 
        TriggerEvent('notification', "Take a Short Break!", 1)
        drink()
        factor = 0
        Citizen.Wait(40000)
        TriggerEvent('notification', "You feel Refreshed and Re-Energized", 1)
    end

    if math.random(100) > factor then
        TriggerEvent("erpjailsystem:reducesentence")
    end

    jobProcess = false
    curTask = nil
    curTaskType = "None"
end

secondOfDay = 19801
RegisterNetEvent('krp_sync:client:SyncTime')
AddEventHandler('krp_sync:client:SyncTime', function( offset )
    secondOfDay = offset
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
      if jailTime > 0 then
        DisableControlAction(0, 244, true)
        DisableControlAction(0, 243, true)
      end
    end
  end)

Citizen.CreateThread(function()
    local workCount = 0
    while true do
        if imjailed then
            Citizen.Wait(10000)
            if curTask == nil then
                local curTime = math.floor( secondOfDay / 3600 )
                if curTime >= 6 and curTime <= 7 and not eatenRecently then 
                    curTask = eatTask
                    curTaskType = "Eat"
                    eatenRecently = true
                elseif curTime >= 11 and curTime <= 12 and not eatenRecently then 
                    curTask = eatTask
                    curTaskType = "Eat"
                    eatenRecently = true
                elseif curTime >= 17 and curTime <= 16 and not eatenRecently then 
                    curTask = eatTask
                    curTaskType = "Eat"
                    eatenRecently = true
                else
                    if eatenRecently then
                        eatenRecently = false
                        if workCount > 12 then
                            curTask = repaircoords[math.random(#repaircoords)]
                            curTaskType = "Repair"                            
                            workCount = 0
                        else
                            curTask = cleancoords[math.random(#cleancoords)]
                            curTaskType = "Clean"
                        end
                    else
                        if workCount > 5 then
                            curTask = eatTask
                            curTaskType = "Eat"
                            eatenRecently = true
                            workCount = 0
                        else
                            curTask = repaircoords[math.random(#repaircoords)]
                            curTaskType = "Repair"
                        end
                    end
                end
                workCount = workCount + 1
            end
        else
            Citizen.Wait(20000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100000)
        if jailTime > 0 then
            
        end
    end
  end)

function drink()
    ClearPedSecondaryTask(GetPlayerPed(-1))
    loadAnimDict( "mp_player_intdrink" ) 
    TaskPlayAnim( GetPlayerPed(-1), "mp_player_intdrink", "loop_bottle", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(5000)
    endanimation()
end

function endanimation()
    ClearPedSecondaryTask(GetPlayerPed(-1))
end

RegisterNetEvent("erpjailsystem:jailPlayer")
AddEventHandler("erpjailsystem:jailPlayer", function(newJailTime)
    jailTime = newJailTime
    Cutscene()
    canLeave = false
end)

RegisterNetEvent("erpjailsystem:unJailPlayer")
AddEventHandler("erpjailsystem:unJailPlayer", function()
    jailTime = 0
    UnJail()
end)

RegisterNetEvent("erpjailsystem:reducesentence")
AddEventHandler("erpjailsystem:reducesentence", function()
    --print('Current Jailtime Remaining (' .. jailTime .. ') months')
    jailTime = jailTime - 2
    TriggerServerEvent("erpjailsystem:updateJailTime", reduction)
    TriggerEvent('notification', "Your Jail Sentence was Reduced", 1)
end)

function JailLogin()
    Citizen.Wait(500)
    InJail()
    if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 1689.189, 2594.825, 45.56483, true) > 150 ) then    
        local JailPosition = Config.JailPositions["Cell"]
        SetEntityCoords(PlayerPedId(), JailPosition["x"], JailPosition["y"], JailPosition["z"] - 1)
        TriggerEvent('notification', "Last time you went to sleep you were in jail, now you have been put back in", 1)
        canLeave = false
    end
end

RegisterNetEvent('erpjailsystem:returntojail')
AddEventHandler('erpjailsystem:returntojail', function()
    local jailed = exports["isPed"]:isPed("jailed")

    if jailed then
        canLeave = false
        local JailPosition = Config.JailPositions["Cell"]
        SetEntityCoords(PlayerPedId(), JailPosition["x"], JailPosition["y"], JailPosition["z"] - 1)
        TriggerEvent('notification', "Last time you went to sleep you were jailed, because of that you are now put back!", 1)
    end
end)

function UnJail()
    InJail()
    canLeave = true
    imjailed = false 
    TriggerEvent('notification', "You are now released; remember crime dont pay!", 1)
    SetEntityCoords(PlayerPedId(), 1838.9486083984, 2587.6079101563, 45.891925811768 - 1)
    TriggerEvent('erpped:isJailed', false) 
    TimeServed()

end


function InJail()
    --Jail Timer--
    canLeave = false
    imjailed = true
    Citizen.CreateThread(function()
        while jailTime > 0 do
            jailTime = jailTime - 1
            canLeave = false
            TriggerServerEvent("erpjailsystem:updateJailTime", jailTime)
            TriggerEvent('erpped:isJailed', true)

            if jailTime == 0 then
                UnJail()
                TriggerServerEvent("erpjailsystem:updateJailTime", 0)
            end
            Citizen.Wait(60000)
        end
    end)
    
    Citizen.CreateThread(function()
        local jobmessage = "Waiting for new task.."
        while jailTime > 0 do
            if imjailed then
                Citizen.Wait(0)         
                if curTask ~= nil and curTaskType ~= "None" then
                    if not jobProcess then
                        jobProcess = true
                        addBlipForJob(curTask["x"],curTask["y"],curTask["z"])
                    end

                    if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), curTask["x"],curTask["y"],curTask["z"]) > 1.5) then
                        DrawMarker(27, curTask["x"],curTask["y"],curTask["z"], 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 70, 0, 0, 0, 0)
                        DisplayHelpText(" Your current job is marked: ~r~ " .. curTaskType .. "")
                    end

                    if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), curTask["x"],curTask["y"],curTask["z"]) < 1.5) then
                        DrawMarker(27, curTask["x"],curTask["y"],curTask["z"], 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 70, 0, 0, 0, 0)
                        DisplayHelpText('Currently Working!')
                        finishTask()
                    end
                end

                if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), checkJailTime["x"],checkJailTime["y"],checkJailTime["z"]) < 1.5) then
                    DrawText3D(1827.249, 2589.802, 45.80, "[E] to Check Jail Time")
                    if IsControlJustPressed(1, Keys["E"]) then
                        if jailTime > 0 then
                 
                            TriggerEvent('chat:addMessage', { template = '<div style="padding: 0.475vw; padding-left: 0.8vw; padding-right: 0.7vw; margin: 0.1vw; background-color: rgba(51, 112, 165, 0.85); border-radius: 10px 10px 10px 10px;"><span style="font-weight: bold;">DOC|: You have</b> {0} months remaining </div>', args = { jailTime } })
                            Wait(5000)
        
                        end
                    end
                end

            else
                Citizen.Wait(10000)
            end         
        end

    end)
end





function TimeServed()
    local playerPed = PlayerPedId()
    jailTime = 0
    imjailed = false
    canLeave = true
    jobProcess = false
    curTask = nil
    curTaskType = "None"  
    addBlipForJob(1830.968, 2593.678, 45.89194) 
    TriggerEvent('erpped:isJailed', false)    
    ESX.Game.Teleport(PlayerPedId(), Config.Teleports["Boiling Broke"])
end


RegisterNetEvent('erpjailsystem:cleananim')
AddEventHandler('erpjailsystem:cleananim', function()

end)

RegisterNetEvent('erpjailsystem:repairanim')
AddEventHandler('erpjailsystem:repairanim', function()
    local playerPed = PlayerPedId()
    local lib, anim = 'mini@repair', 'fixing_a_player' -- TODO better animations
    local duration = 120000
    ESX.Streaming.RequestAnimDict(lib, function()
    TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, duration, 49, 0, false, false, false)
    FreezeEntityPosition(playerPed, true)
    local finished = exports["sway_taskbar"]:taskBar(duration, "Repairing Panel")  
    FreezeEntityPosition(playerPed, false)
    TriggerEvent('chat:addMessage', { template = '<div style="padding: 0.475vw; padding-left: 0.8vw; padding-right: 0.7vw; margin: 0.1vw; background-color: rgba(51, 112, 165, 0.85); border-radius: 10px 10px 10px 10px;"><span style="font-weight: bold;">DOC|: You have</b> {0} months remaining </div>', args = { jailTime } })
    end)
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
        SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

-- Teleporters into cafeteria
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local dstDiner = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),1775.62, 2551.987, 45.56502, true )
        local dstDinerExit = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),1786.072, 2675.984, -70.04592, true )

        local dstFreedom = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),1830.968, 2593.678, 45.89194, true )

        if dstDiner < 1.0 then
            DrawText3D(1775.62, 2551.987, 45.56502, '[~w~E~s~] Enter' )
            if dstDiner < 1.0 then
                if IsControlJustReleased(0,38) then
                    SetEntityCoords(GetPlayerPed(-1), 1786.14, 2675.889, -70.54585) 
                    SetEntityHeading(GetPlayerPed(-1), 199.371)
                end
            end
        elseif dstDinerExit < 1.0 then
            DrawText3D(1786.072, 2675.984, -70.04592, '[~w~E~s~] Leave' )
            if dstDinerExit < 1.0 then
                if IsControlJustReleased(0,38) then
                    SetEntityCoords(GetPlayerPed(-1), 1775.62,2551.987,45.56502)  
                    SetEntityHeading(GetPlayerPed(-1), 87.34)
                end
            end
        end

        if dstFreedom < 5.0 and jailTime <= 0 then
            DrawText3D(1830.968, 2593.678, 45.89194, '[~w~G~s~] Leave Prison' )
            if dstFreedom < 1.0 then
                if IsControlJustReleased(0,47) then
                    UnJail()
                    SetEntityCoords(GetPlayerPed(-1), 1838.843, 2587.375, 45.89) 
                    SetEntityHeading(GetPlayerPed(-1), 230.88)
                end
            end
        end
   end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local coords = vector3(1827.249, 2589.802, 45.80)
        local pedcoords = GetEntityCoords(ped)
        if Vdist2(coords, ped) < 5 then
        DrawText3D(1827.249, 2589.802, 45.80, "[E] to Check Jail Time")
        if IsControlJustPressed(1, Keys["E"]) then
            if jailTime > 0 then
                print(jailTime)
                TriggerEvent('chat:addMessage', { template = '<div style="padding: 0.475vw; padding-left: 0.8vw; padding-right: 0.7vw; margin: 0.1vw; background-color: rgba(51, 112, 165, 0.85); border-radius: 10px 10px 10px 10px;"><span style="font-weight: bold;">DOC|: You have</b> {0} months remaining </div>', args = { jailTime } })
                Wait(10000)
            else
                Wait(10000)
        end
    end
    end
end
end)



function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

RegisterNetEvent('krp:badmeth')
AddEventHandler('krp:badmeth', function(source)
    local methhead = GetPlayerPed(-1)
    if GetPedArmour(methhead) < 100 then
	SetPedArmour(methhead, 100)
    SetTimecycleModifier("drug_drive_blend02")
    SetPedMotionBlur(methhead, true)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
    DoScreenFadeIn(2000)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedArmour(crackhead, 0)
    SetPedMotionBlur(crackhead, false)
    ClearTimecycleModifier()
    end
end)

RegisterNetEvent('krp:methAnim')
AddEventHandler('krp:methAnim', function(source)
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        ESX.Streaming.RequestAnimDict('switch@trevor@trev_smoking_meth', function()
            TaskPlayAnim(playerPed, 'switch@trevor@trev_smoking_meth', 'trev_smoking_meth_loop', 1.0, -1.0, 350000, 49, 1, false, false, false)
            ClearPedTask(playerPed)
        end)
    end)
end)

RegisterNetEvent('krp:meth')
AddEventHandler('krp:meth', function(source)
    local methhead = GetPlayerPed(-1)
    local finished = exports["sway_taskbar"]:taskBar(2500, "Smoking...")
    if finished == 100 then
	SetPedArmour(methhead, 100)
    SetTimecycleModifier("drug_drive_blend02")
    SetPedMotionBlur(methhead, true)
    Citizen.Wait(25000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
    DoScreenFadeIn(2000)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedArmour(crackhead, 0)
    SetPedMotionBlur(crackhead, false)
    ClearTimecycleModifier()
    end
end)


RegisterNetEvent('bed:anim')
AddEventHandler('bed:anim', function()
local playerPed = PlayerPedId()
local lib, anim = 'mini@repair', 'fixing_a_player' -- TODO better animations
local duration = 120000
ESX.Streaming.RequestAnimDict(lib, function()
TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, duration, 49, 0, false, false, false)
end)
end)

Citizen.CreateThread(function()
local bed1 = vector3(1786.2155761719, 2584.7265625, 45.704963684082)
local searched = "false"
local ped = GetPlayerPed(-1)
    while true do
        Citizen.Wait(5)
        if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), bed1.x, bed1.y, bed1.z) < 1.0) then
            DrawText3D(bed1.x, bed1.y, bed1.z, "[E] to Clean the Bed")
                if IsControlJustPressed(1, 355) then
                    if searched == "false" then
                        FreezeEntityPosition(ped, true)
                        TriggerEvent('bed:anim', source)
                        local finished = exports["sway_taskbar"]:taskBar(60000, "Cleaning Bed...") 
                        if finished == 100 then
                            FreezeEntityPosition(ped, false)
                            ClearPedTasks(ped)
                            TriggerEvent("server-inventory-open", "25", "Shop");
                                local searched = "true"
                                Citizen.Wait(10000)
                                local searched = "false"
                        end
                        end
                    end
                end
        end
end)

Citizen.CreateThread(function()
    local bed1 = vector3(1786.62109375, 2580.7177734375, 45.706649780273)
    local searched = "false"
    local ped = GetPlayerPed(-1)
        while true do
            Citizen.Wait(5)
            if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), bed1.x, bed1.y, bed1.z) < 1.0) then
                DrawText3D(bed1.x, bed1.y, bed1.z, "[E] to Clean the Bed")
                    if IsControlJustPressed(1, 355) then
                        if searched == "false" then
                            FreezeEntityPosition(ped, true)
                            TriggerEvent('bed:anim', source)
                            local finished = exports["sway_taskbar"]:taskBar(60000, "Cleaning Bed...") 
                            if finished == 100 then
                                FreezeEntityPosition(ped, false)
                                ClearPedTasks(ped)
                                TriggerEvent("server-inventory-open", "25", "Shop");
                                    local searched = "true"
                                    Citizen.Wait(10000)
                                    local searched = "false"
                            end
                        end
                    end
            end
        end
end)


Citizen.CreateThread(function()
    local bed1 = vector3(1786.5467529297,2576.5986328125,45.708782196045)
    local searched = "false"
    local ped = GetPlayerPed(-1)
        while true do
            Citizen.Wait(5)
            if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), bed1.x, bed1.y, bed1.z) < 1.0) then
                DrawText3D(bed1.x, bed1.y, bed1.z, "[E] to Clean the Bed")
                    if IsControlJustPressed(1, 355) then
                        if searched == "false" then
                            FreezeEntityPosition(ped, true)
                            TriggerEvent('bed:anim', source)
                            local finished = exports["sway_taskbar"]:taskBar(60000, "Cleaning Bed...") 
                            if finished == 100 then
                                FreezeEntityPosition(ped, false)
                                ClearPedTasks(ped)
                                TriggerEvent("server-inventory-open", "25", "Shop");
                                    local searched = "true"
                                    Citizen.Wait(10000)
                                    local searched = "false"
                            end
                        end
                    end
            end
        end
end)

Citizen.CreateThread(function()
    local bed1 = vector3(1786.5364990234,2572.4877929688,45.710723876953)
    local searched = "false"
    local ped = GetPlayerPed(-1)
        while true do
            Citizen.Wait(5)
            if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), bed1.x, bed1.y, bed1.z) < 1.0) then
                DrawText3D(bed1.x, bed1.y, bed1.z, "[E] to Clean the Bed")
                    if IsControlJustPressed(1, 355) then
                        if searched == "false" then
                            FreezeEntityPosition(ped, true)
                            TriggerEvent('bed:anim', source)
                            local finished = exports["sway_taskbar"]:taskBar(60000, "Cleaning Bed...") 
                            if finished == 100 then
                                FreezeEntityPosition(ped, false)
                                ClearPedTasks(ped)
                                TriggerEvent("server-inventory-open", "25", "Shop");
                                    local searched = "true"
                                    Citizen.Wait(10000)
                                    local searched = "false"
                            end
                        end
                    end
            end
        end
end)

Citizen.CreateThread(function()

    local bed1 = vector3(1786.5158691406,2568.3830566406,45.712825775146)
    local searched = "false"
    local ped = GetPlayerPed(-1)
        while true do
        
            Citizen.Wait(5)
            if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), bed1.x, bed1.y, bed1.z) < 1.0) then
                DrawText3D(bed1.x, bed1.y, bed1.z, "[E] to Clean the Bed")
                    if IsControlJustPressed(1, 355) then
                        if searched == "false" then
                            FreezeEntityPosition(ped, true)
                            TriggerEvent('bed:anim', source)
                            local finished = exports["sway_taskbar"]:taskBar(60000, "Cleaning Bed...") 
                            if finished == 100 then
                                FreezeEntityPosition(ped, false)
                                ClearPedTasks(ped)
                                TriggerEvent("server-inventory-open", "25", "Shop");
                                    local searched = "true"
                                    Citizen.Wait(10000)
                                    local searched = "false"
                            end
                        end
                    end
            end
        end
end)


Citizen.CreateThread(function()
    local bed1 = vector3(1765.2056884766,2570.2448730469,45.730564117432)
    local searched = "false"
    local ped = GetPlayerPed(-1)
        while true do
            Citizen.Wait(5)
            if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), bed1.x, bed1.y, bed1.z) < 1.0) then
                DrawText3D(bed1.x, bed1.y, bed1.z, "[E] to Clean the Bed")
                    if IsControlJustPressed(1, 355) then
                        if searched == "false" then
                            FreezeEntityPosition(ped, true)
                            TriggerEvent('bed:anim', source)
                            local finished = exports["sway_taskbar"]:taskBar(60000, "Cleaning Bed...") 
                            if finished == 100 then
                                FreezeEntityPosition(ped, false)
                                ClearPedTasks(ped)
                                TriggerEvent("server-inventory-open", "25", "Shop");
                                    local searched = "true"
                                    Citizen.Wait(10000)
                                    local searched = "false"
                            end
                        end
                    end
            end
        end
end)

Citizen.CreateThread(function()
    local bed1 = vector3(1765.2155761719,2574.3605957031,45.728538513184)
    local searched = "false"
    local ped = GetPlayerPed(-1)
        while true do
            Citizen.Wait(5)
            if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), bed1.x, bed1.y, bed1.z) < 1.0) then
                DrawText3D(bed1.x, bed1.y, bed1.z, "[E] to Clean the Bed")
                    if IsControlJustPressed(1, 355) then
                        if searched == "false" then
                            FreezeEntityPosition(ped, true)
                            TriggerEvent('bed:anim', source)
                            local finished = exports["sway_taskbar"]:taskBar(60000, "Cleaning Bed...") 
                            if finished == 100 then
                                FreezeEntityPosition(ped, false)
                                ClearPedTasks(ped)
                                TriggerEvent("server-inventory-open", "25", "Shop");
                                    local searched = "true"
                                    Citizen.Wait(10000)
                                    local searched = "false"
                            end
                        end
                    end
            end
        end
end)

Citizen.CreateThread(function()
    local bed1 = vector3(1765.3677978516,2578.4731445313,45.726356506348)
    local searched = "false"
    local ped = GetPlayerPed(-1)
        while true do
            Citizen.Wait(5)
            if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), bed1.x, bed1.y, bed1.z) < 1.0) then
                DrawText3D(bed1.x, bed1.y, bed1.z, "[E] to Clean the Bed")
                    if IsControlJustPressed(1, 355) then
                        if searched == "false" then
                            FreezeEntityPosition(ped, true)
                            TriggerEvent('bed:anim', source)
                            local finished = exports["sway_taskbar"]:taskBar(60000, "Cleaning Bed...") 
                            if finished == 100 then
                                FreezeEntityPosition(ped, false)
                                ClearPedTasks(ped)
                                TriggerEvent("server-inventory-open", "25", "Shop");
                                    local searched = "true"
                                    Citizen.Wait(10000)
                                    local searched = "false"
                            end
                        end
                    end
            end
        end
end)

Citizen.CreateThread(function()
    local bed1 = vector3(1765.2026367188,2582.5776367188,45.72444152832)
    local searched = "false"
    local ped = GetPlayerPed(-1)
        while true do
            Citizen.Wait(5)
            if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), bed1.x, bed1.y, bed1.z) < 1.0) then
                DrawText3D(bed1.x, bed1.y, bed1.z, "[E] to Clean the Bed")
                    if IsControlJustPressed(1, 355) then
                        if searched == "false" then
                            FreezeEntityPosition(ped, true)
                            TriggerEvent('bed:anim', source)
                            local finished = exports["sway_taskbar"]:taskBar(60000, "Cleaning Bed...") 
                            if finished == 100 then
                                FreezeEntityPosition(ped, false)
                                ClearPedTasks(ped)
                                TriggerEvent("server-inventory-open", "25", "Shop");
                                    local searched = "true"
                                    Citizen.Wait(10000)
                                    local searched = "false"
                            end
                        end
                    end
                end
        end
end)

Citizen.CreateThread(function()
    local bed1 = vector3(1765.1706542969,2586.6953125,45.722389221191)
    local searched = "false"
    local ped = GetPlayerPed(-1)
        while true do
            Citizen.Wait(5)
            if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), bed1.x, bed1.y, bed1.z) < 1.0) then
                DrawText3D(bed1.x, bed1.y, bed1.z, "[E] to Clean the Bed")
                    if IsControlJustPressed(1, 355) then
                        if searched == "false" then
                            FreezeEntityPosition(ped, true)
                            TriggerEvent('bed:anim', source)
                            local finished = exports["sway_taskbar"]:taskBar(60000, "Cleaning Bed...") 
                            if finished == 100 then
                                FreezeEntityPosition(ped, false)
                                ClearPedTasks(ped)
                
                                TriggerEvent("server-inventory-open", "25", "Shop")	
                                    local searched = "true"
                                    Citizen.Wait(10000)
                                    local searched = "false"
                            end
                        end
                    end
                end
        end
end)


