ESX                           = nil

local PlayerData              = {}

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()

    LoadMarkers()
end) 

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

local function isNear(pos1, pos2, distMustBe)
    local diff = pos2 - pos1
	local dist = (diff.x * diff.x) + (diff.y * diff.y) + (diff.z * diff.z)

	return (dist < (distMustBe * distMustBe))
end

function LoadMarkers()
    Citizen.CreateThread(function()
    
        while true do
            Citizen.Wait(5)

            local plyCoords = GetEntityCoords(PlayerPedId())

            for location, val in pairs(Config.Teleporters) do

                local Enter = val['Enter']
                local Exit = val['Exit']
                local player = PlayerId()
                local JobNeeded = val['Job']
                local enterPos = vector3(Enter['x'], Enter['y'], Enter['z'])
                local exitPos = vector3(Exit['x'], Exit['y'], Exit['z'])

                if isNear(plyCoords, enterPos, 2.5) then
                    if JobNeeded ~= 'none' then
                        if PlayerData.job.name == JobNeeded then

                            DrawM(Enter['Information'], 25, Enter['x'], Enter['y'], Enter['z'])

                            if isNear(plyCoords, enterPos, 2.0) then
                                if IsControlJustPressed(0, 38) then
                                    Teleport(val, 'enter')
                                    SetPlayerInvincible(player, true)
                                    TriggerEvent("cunt:loadWarehouse")
                                    exports["sway_taskbar"]:taskBar(1000, "Travelled...")
                                    
                                    Citizen.Wait(3000)
                                    SetPlayerInvincible(player, false)
                                end
                            end

                        end
                    else
                        DrawM(Enter['Information'], 25, Enter['x'], Enter['y'], Enter['z'])

                        if isNear(plyCoords, enterPos, 1.2) then

                            if IsControlJustPressed(0, 38) then
                                Teleport(val, 'enter')
                                DoNight()
                                NetworkOverrideClockTime(0, 0, 0)
                                SetPlayerInvincible(player, true)
                                exports["sway_taskbar"]:taskBar(1000, "Travelled...")
                                
                                Citizen.Wait(3000)
                                SetPlayerInvincible(player, false)
                            end

                        end

                    end
                end

                if isNear(plyCoords, exitPos, 2.5) then
                    if JobNeeded ~= 'none' then
                        if PlayerData.job.name == JobNeeded then

                            DrawM(Exit['Information'], 25, Exit['x'], Exit['y'], Exit['z'])

                            if isNear(plyCoords, exitPos, 2.0) then
                                if IsControlJustPressed(0, 38) then
                                    Teleport(val, 'exit')
                                    DoDay()
                                    SetPlayerInvincible(player, true)
                                    exports["sway_taskbar"]:taskBar(1000, "Travelled...")
                                    Citizen.Wait(3000)
                                    SetPlayerInvincible(player, false)
                                end
                            end

                        end
                    else

                        DrawM(Exit['Information'], 25, Exit['x'], Exit['y'], Exit['z'])

                        if isNear(plyCoords, exitPos, 2.0) then

                            if IsControlJustPressed(0, 38) then
                                Teleport(val, 'exit')
                                SetPlayerInvincible(player, true)
                           
                                exports["sway_taskbar"]:taskBar(1000, "Travelled...")
                                Citizen.Wait(3000)
                                SetPlayerInvincible(player, false)
                            end

                        end
                    end
                end

            end

        end

    end)
end


RegisterNetEvent("cunt:loadWarehouse")
AddEventHandler("cunt:loadWarehouse", function()
    renderPropsWhereHouse()
end)


function Teleport(table, location , source)
    if location == 'enter' then
        local Exit = table['Exit']

        DoScreenFadeOut(300)

        Citizen.Wait(800)

        if Exit['vehicleCompatible'] then
            local plyPed = GetPlayerPed(-1)
            
            if IsPedInAnyVehicle(plyPed, false) then
                local plyVeh = GetVehiclePedIsIn(plyPed, false)

                SetEntityCoords(plyVeh, Exit['x'], Exit['y'], Exit['z'])
                DoDay()
   
                TriggerEvent('settonight',source, false)
            else
                ESX.Game.Teleport(PlayerPedId(), table['Exit'])
                TriggerEvent('settonight',source, false)
            end
        else
            ESX.Game.Teleport(PlayerPedId(), table['Exit'])
            TriggerEvent('settonight',source, false)

       
        end

        DoScreenFadeIn(1000)

        renderPropsWhereHouse()
    else
        local Enter = table['Enter']

        DoScreenFadeOut(300)

        Citizen.Wait(800)

        if Enter['vehicleCompatible'] then
            local plyPed = GetPlayerPed(-1)
            
            if IsPedInAnyVehicle(plyPed, false) then
                local plyVeh = GetVehiclePedIsIn(plyPed, false)

                SetEntityCoords(plyVeh, Enter['x'], Enter['y'], Enter['z'])
                DoNight()
          
                
            else
                ESX.Game.Teleport(PlayerPedId(), table['Enter'])
                
            end
        else
            ESX.Game.Teleport(PlayerPedId(), table['Enter'])
            
            
        end

        DoScreenFadeIn(1000)
    
    end

end


function DoDay()
    TriggerEvent('settonight',source, false)
end

function DoNight()
    TriggerEvent('settonight',source, true)
end
    

local loadedprops = false

function renderPropsWhereHouse()
    if not loadedprops then 
        loadedprops = true
	CreateObject(`ex_prop_crate_bull_sc_02`,1003.63013,-3108.50415,-39.9669662,false,false,false)
	CreateObject(`ex_prop_crate_wlife_bc`,1018.18011,-3102.8042,-40.08757,false,false,false)
	CreateObject(`ex_prop_crate_closed_bc`,1006.05511,-3096.954,-37.7579666,false,false,false)
	CreateObject(`ex_prop_crate_wlife_sc`,1003.63013,-3102.8042,-37.85769,false,false,false)
	CreateObject(`ex_prop_crate_jewels_racks_sc`,1003.63013,-3091.604,-37.8579666,false,false,false)

	CreateObject(`ex_Prop_Crate_Closed_BC`,1013.330000003,-3102.80400000,-35.62896000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1015.75500000,-3102.80400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1015.75500000,-3102.80400000,-39.86697000,false,false,false)


	CreateObject(`ex_Prop_Crate_Jewels_BC`,1018.18000000,-3091.60400000,-39.85885000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3111.38400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_BC`,1003.63000000,-3091.60400000,-39.86697000,false,false,false)

	CreateObject(`ex_Prop_Crate_Jewels_BC`,1026.75500000,-3106.52900000,-39.85903000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3106.52900000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_SC`,1010.90500000,-3108.50400000,-39.86585000,false,false,false)

	CreateObject(`ex_Prop_Crate_Art_BC`,1013.33000000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_BC`,1015.75500000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_SC_02`,1010.90500000,-3096.95400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_SC`,993.35510000,-3111.30400000,-39.84156000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_BC`,993.35510000,-3108.95400000,-39.86697000,false,false,false)

	CreateObject(`ex_Prop_Crate_Gems_SC`,1013.33000000,-3096.95400000,-37.6577600,false,false,false)
	CreateObject(`ex_Prop_Crate_clothing_BC`,1018.180000000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_clothing_BC`,1008.48000000,-3096.95400000,-39.83868000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1003.63000000,-3108.50400000,-35.61234000,false,false,false)
	CreateObject(`ex_Prop_Crate_Narc_BC`,1026.75500000,-3091.59400000,-37.65797000,false,false,false)

	CreateObject(`ex_Prop_Crate_Narc_BC`,1026.75500000,-3091.59400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_SC`,1008.48000000,-3108.50400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Tob_SC`,1018.18000000,-3096.95400000,-37.78240000,false,false,false)
	CreateObject(`ex_Prop_Crate_Wlife_BC`,1018.18000000,-3091.60400000,-35.74857000,false,false,false)
	CreateObject(`ex_Prop_Crate_Med_BC`,1008.48000000,-3091.60400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_SC`,1013.33000000,-3108.50400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3108.88900000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_biohazard_BC`,1010.90500000,-3102.80400000,-39.86461000,false,false,false)
	CreateObject(`ex_Prop_Crate_Wlife_BC`,1015.75500000,-3091.60400000,-35.74857000,false,false,false)
	CreateObject(`ex_Prop_Crate_biohazard_BC`,1003.63000000,-3108.50400000,-37.65561000,false,false,false)

	CreateObject(`ex_Prop_Crate_Elec_BC`,1008.48000000,-3096.954000000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,1006.05500000,-3108.50400000,-39.86242000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_RW`,1013.33000000,-3091.60400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Narc_SC`,1026.75500000,-3094.014000000,-37.65684000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_BC`,1015.75500000,-3108.50400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1010.90500000,-3096.95400000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Ammo_BC`,1013.33000000,-3102.80400000,-37.65427000,false,false,false)

	CreateObject(`ex_Prop_Crate_Money_BC`,1003.63000000,-3096.95400000,-39.86638000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1003.63000000,-3096.95400000,-37.65187000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1010.90500000,-3091.60400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_BC`,1013.33000000,-3091.60400000,-35.74885000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_BC`,1026.75500000,-3091.59400000,-35.74885000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_BC`,1026.75500000,-3094.0140000,-35.74885000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_BC`,1026.75500000,-3096.43400000,-35.74885000,false,false,false)
	CreateObject(`ex_Prop_Crate_clothing_SC`,1013.33000000,-3091.604000000,-39.86540000,false,false,false)
	CreateObject(`ex_Prop_Crate_biohazard_SC`,1006.05500000,-3108.50400000,-37.65576000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,993.35510000,-3106.60400000,-35.60529000,false,false,false)

	CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3111.38400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,1026.75500000,-3096.4340000,-39.86242000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1015.75500000,-3096.95400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_HighEnd_pharma_BC`,1003.63000000,-3091.60400000,-35.62571000,false,false,false)
	CreateObject(`ex_Prop_Crate_HighEnd_pharma_SC`,1015.75500000,-3091.60400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_BC`,1013.330000000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_SC`,1018.18000000,-3102.80400000,-37.65776000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_BC`,1013.33000000,-3108.50400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1018.18000000,-3108.50400000,-37.64234000,false,false,false)
	CreateObject(`ex_Prop_Crate_Tob_BC`,1010.90500000,-3108.50400000,-35.75240000,false,false,false)

	CreateObject(`ex_Prop_Crate_Med_SC`,1026.75500000,-3108.88900000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Money_SC`,1010.90500000,-3091.60400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Med_SC`,1008.48000000,-3091.60400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_BC`,1018.180000000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_SC_02`,1008.48000000,-3108.50400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_BC`,993.35510000,-3106.60400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1008.480000000,-3102.804000000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,993.35510000,-3111.30400000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_HighEnd_pharma_BC`,1018.18000000,-3091.60400000,-37.65572000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1015.75500000,-3102.80400000,-37.64234000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_racks_BC`,1003.63000000,-3102.80400000,-39.85903000,false,false,false)
	CreateObject(`ex_Prop_Crate_Money_SC`,1006.05500000,-3096.95400000,-39.86697000,false,false,false)

	CreateObject(`ex_Prop_Crate_Closed_BC`,1003.630000000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_SC`,1006.05500000,-3102.80400000,-37.78544000,false,false,false)
	CreateObject(`ex_Prop_Crate_Expl_bc`,1010.90500000,-3102.80400000,-37.63982000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1006.05500000,-3096.9540000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1006.05500000,-3102.80400000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1010.90500000,-3108.50400000,-37.63529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_BC`,1015.75500000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1010.90500000,-3096.95400000,-37.64234000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1010.90500000,-3102.804000000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1008.48000000,-3102.80400000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,993.35510000,-3106.60400000,-37.65342000,false,false,false)
	CreateObject(`ex_Prop_Crate_Money_SC`,1015.75500000,-3091.604000000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Med_BC`,1026.75500000,-3106.52900000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_SC_02`,1015.75500000,-3096.95400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Tob_SC`,1010.905000000,-3091.60400000,-37.78240000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1006.05500000,-3091.60400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_pharma_SC`,1026.75500000,-3096.43400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1006.05500000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_SC`,1015.75500000,-3108.504000000,-37.65776000,false,false,false)

	CreateObject(`ex_Prop_Crate_Tob_BC`,1018.18000000,-3102.80400000,-35.75240000,false,false,false)
	CreateObject(`ex_Prop_Crate_Tob_BC`,1008.48000000,-3108.50400000,-35.75240000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,993.35510000,-3111.30400000,-37.65342000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_racks_SC`,1026.75500000,-3111.384000000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_SC`,1006.05500000,-3102.80400000,-39.87020000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,1013.33000000,-3096.95400000,-39.86242000,false,false,false)

	CreateObject(`ex_Prop_Crate_Gems_SC`,1013.33000000,1013.33000000,1013.33000000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_BC`,1026.75500000,-3108.889000000,-39.85885000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_SC_02`,993.35510000,-3108.95400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1008.48000000,-3091.60400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_SC`,993.35510000,-3108.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_XLDiam`,1026.75500000,-3094.01400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_watch`,1013.33000000,-3102.80400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_SHide`,1018.18000000,-3096.95400000,-39.87596000,false,false,false)
	CreateObject(`ex_Prop_Crate_Oegg`,1006.05500000,-3091.60400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_MiniG`,1018.18000000,-3108.50400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_FReel`,11008.48000000,-3102.80400000,-39.85903000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_SC`,1006.05500000,-3091.60400000,-37.64985000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,1026.75500000,-3091.59400000,-39.86242000,false,false,false)


	local tool1 = CreateObject(-573669520,1022.6115112305,-3107.1694335938,-39.999912261963,false,false,false)
	local tool2 = CreateObject(-573669520,1022.5317382813,-3095.3305664063,-39.999912261963,false,false,false)
	local tool3 = CreateObject(-573669520,996.60125732422,-3099.2927246094,-39.999923706055,false,false,false)
	local tool4 = CreateObject(-573669520,1002.0411987305,-3108.3645019531,-39.999897003174,false,false,false)
    local door1 =  CreateObject(1693207013,244.64,-402.20,17.47,false,false,false)
    local door2 =  CreateObject(1693207013,249.54,-386.05,17.47,false,false,false)
    
    SetEntityHeading(door1,GetEntityHeading(door1)+180)
    SetEntityHeading(door2,GetEntityHeading(door2)+180)
	SetEntityHeading(tool1,GetEntityHeading(tool1)-130)
	SetEntityHeading(tool2,GetEntityHeading(tool2)-40)
	SetEntityHeading(tool3,GetEntityHeading(tool3)+90)
	SetEntityHeading(tool4,GetEntityHeading(tool4)-90)

    end

end




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

function DrawM(hint, type, x, y, z)
	DrawText3D(x, y, z + 1.0, hint)
end
