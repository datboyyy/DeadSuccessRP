local msgCount2 = 0
local scary2 = 0
local scaryloop2 = false
local dicks2 = 0
local dicks3 = 0
local dicks = 0
local ped = PlayerPedId()
local isInVehicle = IsPedInAnyVehicle(ped, true)
local chatMessage = false

Citizen.CreateThread( function()
    while true do
        Wait(1000)
        ped = PlayerPedId()
        isInVehicle = IsPedInAnyVehicle(ped, true)
    end
end)


Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/me', 'Can show personal actions, face expressions & much more.')
    TriggerEvent('chat:addSuggestion', '/menu', 'Admin menu.')
    TriggerEvent('chat:addSuggestion', '/atm', 'use near a ATM to use it.')
    TriggerEvent('chat:addSuggestion', '/carry', 'Carry The Nearest Person / or drop them.')
end)


RegisterCommand('me', function(source, args)
    local text = '' -- edit here if you want to change the language : EN: the person / FR: la personne
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
    text = text .. ''
	TriggerServerEvent('3dme:shareDisplay', text)
end)



RegisterNetEvent('Do3DText')
AddEventHandler("Do3DText", function(text, source)
    TriggerEvent('DoHudTextCoords', GetPlayerFromServerId(source), text)
    Display(GetPlayerFromServerId(source), text)
end)


function Display(mePlayer, text, offset)
    local displaying = true

    -- Chat message
    if chatMessage then
        local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
        local coords = GetEntityCoords(PlayerPedId(), false)

        if GetDistanceBetweenCoords(coordsMe, coords, true) < 20 then
            TriggerEvent("chatMessage", "", 5, text)
        end
    end
end

RegisterNetEvent('DoHudTextCoords')
AddEventHandler('DoHudTextCoords', function(mePlayer, text)
    dicks2 = 600
    msgCount2 = msgCount2 + 0.22
    local mycount2 = msgCount2

    scary2 = 600 - (msgCount2 * 100)
    TriggerEvent("scaryLoop2")
    local power2 = true
    while dicks2 > 0 do

        dicks2 = dicks2 - 1
        local plyCoords2 = GetEntityCoords(GetPlayerPed(-1))
        local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
        local dist = Vdist2(coordsMe, plyCoords2)

        output = dicks2

        if output > 255 then
            output = 255
        end
        if dist < 500 then
            if HasEntityClearLosToEntity(PlayerPedId(), GetPlayerPed(mePlayer), 17 ) then

                if not isInVehicle and GetFollowPedCamViewMode() == 0 then
                    DrawText3DTest(coordsMe["x"],coordsMe["y"],coordsMe["z"]+(mycount2/2) - 0.2, text, output,power2)
                elseif not isInVehicle and GetFollowPedCamViewMode() == 4 then
                    DrawText3DTest(coordsMe["x"],coordsMe["y"],coordsMe["z"]+(mycount2/7) - 0.1, text, output,power2)
                elseif GetFollowPedCamViewMode() == 4 then
                    DrawText3DTest(coordsMe["x"],coordsMe["y"],coordsMe["z"]+(mycount2/7) - 0.2, text, output,power2)
                else
                    DrawText3DTest(coordsMe["x"],coordsMe["y"],coordsMe["z"]+mycount2 - 1.25, text, output,power2)
                end
            end
        end

        Citizen.Wait(1)
    end

end)

function DrawText3DTest(x,y,z, text, dicks,power)

    local onScreen,_x,_y=World3dToScreen2d(x,y,z + 0.1)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    if dicks > 255 then
        dicks = 255
    end
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 155)
        SetTextEdge(1, 0, 0, 0, 250)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        SetTextColour(255, 255, 255, dicks)

        DrawText(_x,_y)
        local factor = (string.len(text)) / 250
        if dicks < 115 then
            DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 11, 1, 11, dicks)
        else
            DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 11, 1, 11, 115)
        end
    end
end

RegisterNetEvent('scaryLoop2')
AddEventHandler('scaryLoop2', function()
    if scaryloop2 then return end
    scaryloop2 = true
    while scary2 > 0 do
        if msgCount2 > 2.6 then
            scary2 = 0
        end
        Citizen.Wait(1)
        scary2 = scary2 - 1
    end
    dicks2 = 0
    scaryloop2 = false
    scary2 = 0
    msgCount2 = 0
end)

RegisterCommand('roll', function(source, args)
    RequestAnimDict('mp_player_int_upperwank')
    local myPed = PlayerPedId(-1)
    local animation = 'mp_player_int_wank_01_enter'
    local animation2 = 'mp_player_int_wank_01_exit'
    local flags = 48
    local argh = tonumber(args[2])
    local dice = tonumber(args[1])
    TaskPlayAnim(myPed, 'mp_player_int_upperwank', animation, 8.0, -8, -1, flags, 0, 0, 0, 0)
    Wait(650)
    TaskPlayAnim(myPed, 'mp_player_int_upperwank', animation2, 8.0, -8, -1, flags, 0, 0, 0, 0)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 15, "dice", 1.0)
    Citizen.Wait(700)
    if argh == nil then
    num = math.random(1,6)
    num2 = math.random(1,6)
    num3 = math.random(1,6)
    max = 6
    else
    num = math.random(1, argh)
    num2 = math.random(1, argh)
    num3 = math.random(1, argh)
    max = argh
    end
    if dice == nil or dice == 1 then
        total = num
        text = 'Rolled: '..num..'/'..max..' Total: '..total
    elseif dice == 2 then
        total = num + num2
        text = 'Rolled: '..num..'/'..max..' | '..num2..'/'..max..' Total: '..total
    elseif dice >= 3 then
        total = num + num2 + num3
        text = 'Rolled: '..num..'/'..max..' | '..num2..'/'..max..' | '..num3..'/'..max..'Total: '..total
    end
    for i = 1,#args do
        text = text .. ''
    end
    text = text .. ' '
    TriggerServerEvent('3dme:shareDisplay', text)
end)

Citizen.CreateThread(function()
	TriggerEvent("chat:addSuggestion", "/roll", "Usage /roll dice(1-3) dicefaces | Roll dice, accumulating a number from 1 to 6 by default.", {
	})
end)


RegisterNetEvent("roll-1")
AddEventHandler("roll-1", function(source, dice)
    RequestAnimDict('mp_player_int_upperwank')
    local myPed = PlayerPedId(-1)
    local animation = 'mp_player_int_wank_01_enter'
    local animation2 = 'mp_player_int_wank_01_exit'
    local flags = 48
    local dice = dice
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 15, "dice", 1.0)
    TaskPlayAnim(myPed, 'mp_player_int_upperwank', animation, 8.0, -8, -1, flags, 0, 0, 0, 0)
    Wait(650)
    TaskPlayAnim(myPed, 'mp_player_int_upperwank', animation2, 8.0, -8, -1, flags, 0, 0, 0, 0)
    Citizen.Wait(700)
    num = math.random(1,6)
    num2 = math.random(1,6)
    num3 = math.random(1,6)
    max = 6
    if dice == nil or dice == 1 then
        total = num
        text = 'Rolled: '..num..'/'..max..' Total: '..total
    elseif dice == 2 then
        total = num + num2
        text = 'Rolled: '..num..'/'..max..' | '..num2..'/'..max..' Total: '..total
    elseif dice >= 3 then
        total = num + num2 + num3
        text = 'Rolled: '..num..'/'..max..' | '..num2..'/'..max..' | '..num3..'/'..max..' Total: '..total
    end
    
    text = text .. ' '
    TriggerServerEvent('3dme:shareDisplay', text)
end)