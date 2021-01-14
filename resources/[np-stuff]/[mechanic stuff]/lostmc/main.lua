ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
    Wait(900)
    while true do 
        local rank = exports["isPed"]:isPed("myjob")
        local player = GetEntityCoords(PlayerPedId())
        local distance = #(vector3(975.96069335938,-98.701530456543,74.870124816895) - player)
        local distanceTuner = #(vector3(949.88232421875,-966.78704833984,39.502140045166) - player)
		-- if distance < 3.0 and not hasrobbed[1] and not hasrobbed[5] and not hasrobbed[10] and not hasrobbed[15] and not hasrobbed[20] then
        if distance < 3.0 and rank == "lostmc" and ESX.PlayerData.job.grade_name == 'boss' then
        	Wait(1)
             DrawMarker(27,975.96069335938,-98.701530456543,74.870124816895, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 11, 215, 11, 60, 0, 0, 2, 0, 0, 0, 0) 
             DT(975.96069335938,-98.701530456543,74.870124816895, "[E] Quick Fix")
             if IsControlJustReleased(0,38) and distance < 1.0 then
                TriggerEvent("server-inventory-open", "9", "Craft");
                Wait(1000)	
             end
        elseif distanceTuner < 1.0 and rank == "mechanic" and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'experimente' or ESX.PlayerData.job.grade_name == 'chief' then
        	Wait(1)
             DrawMarker(27,949.88232421875,-966.78704833984,38.502140045166, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 11, 215, 11, 60, 0, 0, 2, 0, 0, 0, 0) 
             DT(949.88232421875,-966.78704833984,39.502140045166, "[E] Tuner Crafting")
             if IsControlJustReleased(0,38) and distanceTuner < 1.0 then
                TriggerEvent("server-inventory-open", "16", "Craft");
                Wait(1000)	
             end
        else
            Wait(3000)
        end        
    end
end)

function DT(x,y,z,text)
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

function DrawText3Ds(x,y,z)
	local text = "Press [E] to rob!"
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