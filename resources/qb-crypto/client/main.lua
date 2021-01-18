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

-- Original creator https://forum.fivem.net/t/release-simple-enters-exits-system-updated-v-0-2/9968


-- The array that will be filled with the server data
-- If you want, you can put your array in this file. It should works fine.
interiors = {
	[1] = { ["xe"] = 139.185943603516, ["ye"] = -762.684997558594, ["ze"] = 45.7520523071289, ["he"] = 0.00, ["xo"] = 135.770202636719, ["yo"] = -762.303344726563, ["zo"] = 242.151962280273, ["ho"] = 0.00, ["name"] = 'Bureau', ["locked"] = true },

	[2] = { ["xe"] = 127.321395874023, ["ye"] = -729.368957519531, ["ze"] = 242.151962280273, ["he"] = 0.00, ["xo"] = 116.158660888672, ["yo"] = -741.4140625, ["zo"] = 258.152160644531, ["ho"] = 0.00, ["name"] = 'FBI Zone', ["locked"] = false },

	[3] = { ["xe"] = -908.367492675781, ["ye"] = -368.992370605469, ["ze"] = 113.074188232422, ["he"] = 0.00, ["xo"] = -903.132080078125, ["yo"] = -369.993041992188, ["zo"] = 136.2822265625, ["ho"] = 0.00, ["name"] = 'Helipad', ["locked"] = false },

	[4] = { ["xe"] = -449.56503295898, ["ye"] = 6016.5600585938, ["ze"] = 31.71636962890638, ["he"] = 50.000, ["xo"] = 1677.8208007813, ["yo"] = 2518.6411132813, ["zo"] = -120.841255187996, ["ho"] = 270.0, ["name"] = 'Paleto Holding Cell', ["locked"] = true },

    [5] = { ["xe"] = 1394.48278808594, ["ye"] = 1141.74035644531, ["ze"] = 114.606857299805, ["he"] = 0.000, ["xo"] = 1397.33056640625, ["yo"] = 1142.05017089844, ["zo"] = 114.333587646484, ["ho"] = 0.000, ["name"] = 'Lean Boys Crib', ["locked"] = true },

	[6] = { ["xe"] = -1565.64587402344, ["ye"] = -575.688049316406, ["ze"] = 108.522987365723, ["he"] = 0.00, ["xo"] = -1570.009765625, ["yo"] = -576.172729492188, ["zo"] = 114.449279785156, ["ho"] = 0.00, ["name"] = 'Helipad', ["locked"] = false },

	[7] = { ["xe"] = -428.778, ["ye"] = 1111.61, ["ze"] = 327.689, ["he"] = 0.000, ["xo"] = 135.770202636719, ["yo"] = -762.303344726563, ["zo"] = 242.151962280273, ["ho"] = 0.00, ["name"] = 'Bureau 2'},

	[8] = { ["xe"] = -1388.9089355469, ["ye"] = -585.64733886719, ["ze"] = 30.218830108643, ["he"] = 0.000, ["xo"] = -1387.0108642578, ["yo"] = -588.96197509766, ["zo"] = 30.219615936279, ["ho"] = 0.00, ["name"] = 'Bahamas', ["locked"] = false },

	[9] = { ["xe"] = 383.2, ["ye"] = -1001.2, ["ze"] = 99.0, ["he"] = 0, ["xo"] = -430.0, ["yo"] = 261.539819, ["zo"] = 183.08, ["ho"] = 0.00, ["name"] = 'Comedy Club :)', ["locked"] = false },

 	[10] = { ['xe'] = -674.75909423828,['ye'] = -879.26324462891,['ze'] = 24.448152542114,['he'] = 248.85, ["xo"] = 1110.5560302734, ["yo"] = -3165.8803710938, ["zo"] = -37.518630981445, ["ho"] = 0.00, ["name"] = 'Mr Fix It', ["locked"] = true },  

	[11] = { ['xo'] = 1088.76,['yo'] = -3187.51,['zo'] = -38.99,['ho'] = 176.41, ['xe'] = -1486.63,['ye'] = -909.62,['ze'] = 10.03,['he'] = 131.28, ["name"] = 'Coke And Cola', ["locked"] = true },

	[12] = { ['xe'] = -1430.9,['ye'] = -885.44,['ze'] = 10.94,['he'] = 330.61, ["xo"] = 1064.7233886719, ["yo"] = -3183.572998046, ["zo"] = -39.14842, ["ho"] = 0.00, ["name"] = 'The Greenery' , ["locked"] = true },

	[13] = { ["xe"] = 2188.9, ["ye"] = 2785.98, ["ze"] = -145.5925, ["he"] = 0.000, ["xo"] = 2093.6, ["yo"] = 2196.6, ["zo"] = -138.99841, ["ho"] = 0.00, ["name"] = 'Drug Warehouse', ["locked"] = false },

	[14] = { ["xe"] = -971.26887512207, ["ye"] = -2064.03, ["ze"] = 230.4925, ["he"] = 0, ["xo"] = 1137.9639892578, ["yo"] = -3198.359375, ["zo"] = -39.665657043457, ["ho"] = 0.00, ["name"] = 'The Laundry', ["locked"] = true },

	[15] = { ["xo"] = 0.0, ["yo"] = 0.0, ["zo"] = 0.0, ["ho"] = 220.0, ["xe"] = 0.0, ["ye"] = 0.0, ["ze"] = 0.0, ["he"] = 90.0, ["name"] = 'can be reused', ["locked"] = false }, 

	[16] = { ["xo"] = 0.0, ["yo"] = 0.0, ["zo"] = 0.0, ["ho"] = 220.0, ["xe"] = 0.0, ["ye"] = 0.0, ["ze"] = 0.0, ["he"] = 90.0, ["name"] = 'can be reused', ["locked"] = false }, 

	[17] = { ["xo"] = 0.0, ["yo"] = 0.0, ["zo"] = 0.0, ["ho"] = 250.0, ["xe"] = 0.0, ["ye"] = 0.0, ["ze"] = 0.0, ["he"] = 180.0, ["name"] = 'can be reused', ["locked"] = false },

	[18] = { ["xo"] = 0.0, ["yo"] = 0.0, ["zo"] = 0.0, ["ho"] = 220.0, ["xe"] = 0.0, ["ye"] = 0.0, ["ze"] = 0.0, ["he"] = 90.0, ["name"] = 'can be reused', ["locked"] = false },

	[19] = { ["xo"] = 249.60765075684, ["yo"] = -364.8719787597, ["zo"] = -44.13768386840, ["ho"] = 300, ['xe'] = 314.03,['ye'] = -1612.39,['ze'] = -66.78,['he'] = 226.55, ["name"] = 'Los Santos Courthouse', ["locked"] = false },

	[20] = { ["xe"] = 236.101, ["ye"] = -413.360, ["ze"] = -118.150, ["he"] = 0.000, ["xo"] = -1003.2850341797, ["yo"] = -478.16638183594, ["zo"] =50.027095794678, ["ho"] = 0.00, ["name"] = 'Boss Office', ["locked"] = true },

	[21] = { ["xe"] = -1048.7210693359, ["ye"] = -238.54693603516, ["ze"] = -44.021018981934, ["he"] = 0.000, ["xo"] = -1046.9608154297, ["yo"] = -237.78092956543, ["zo"] = -44.021018981934, ["ho"] = 0.00, ["name"] = 'Invader Office', ["locked"] = false },

	[22] = { ["xe"] = 275.74339294434, ["ye"] = -1361.328516, ["ze"] = 24.5414, ["he"] = 0.00, ['xo'] = 240.68,['yo'] = -1379.53,['zo'] = 33.69, ["ho"] = 0.00, ["name"] = 'Hospital Sciences', ["locked"] = false },

	[23] = { ["xe"] = 360.83041381836, ["ye"] = -585.22747802734, ["ze"] = 28.825454711914, ["he"] = 270.00, ["xo"] = 331.49, ["yo"] = -595.46, ["zo"] = 43.292083740234, ["ho"] = 68.00, ["name"] = 'Hospital Lower Entry', ["locked"] = false },

	[24] = { ['xe'] = 332.89,['ye'] = -569.56,['ze'] = 43.29,['he'] = 68.47, ["xo"] = 340.08938598633, ["yo"] = -584.68481445313, ["zo"] = 74.165634155273, ["ho"] = .00, ["name"] = 'Hospital Helipad', ["locked"] = false },

	[25] = { ['xe'] = 0.89,['ye'] = 0.31,['ze'] = 0.57,['he'] = 293.13, ['xo'] = 0.29,['yo'] = 0.11,['zo'] = 0.11,['ho'] = 90.82, ["name"] = 'CAN BE USED AS ANYTHING ', ["locked"] = false },

	-- Set to below ground, removing causes nil errors
	[26] = { ["xe"] = 1793.08288574228, ["ye"] = 2552.0686035154, ["ze"] = 0, ["he"] = 0.00, ["xo"] = 1786.098266601, ["yo"] = 2675.4948730469, ["zo"] = 0, ["ho"] = 0.00, ["name"] = 'Jail Food Block', ["locked"] = false },

	[27] = { ["xe"] = 1774.618652343, ["ye"] = 2551.939208984, ["ze"] = 0, ["he"] = 0.00, ["xo"] = 1792.108398437, ["yo"] = 2657.515625, ["zo"] = 0, ["ho"] = 0.00, ["name"] = 'Jail Food Block', ["locked"] = false },	

	[28] = { ["xe"] = 6.1114993095398, ["ye"] = -708.26983642578, ["ze"] = 16.13104057312, ["he"] = 0.00, ["xo"] =  1690.85, ["yo"] = 2591.39, ["zo"] = 45.92, ["ho"] =174.95, ["name"] = 'Max Sec Jail', ["locked"] = false},	

	[29] = { ["xe"] = 0.0, ["ye"] = -985.98718261719, ["ze"] = 00.0, ["he"] = 180.00, ["xo"] = 0.0, ["yo"] = 0.0, ["zo"] =0.0, ["ho"] = 180.00, ["name"] = 'Interrogations', ["locked"] = false },	

	[30] = { ["xo"] = 233.38017272949, ["yo"] = -409.87588500977, ["zo"] = 48.111946105957, ["ho"] = 300, ["xe"] = 269.06799316406, ["ye"] = -371.83837890625, ["ze"] = -44.137683868408, ["he"] = 0.00, ["name"] = 'Courthouse', ["locked"] = false },

	[31] = { ["xe"] = 2151.581054687, ["ye"] = 2920.913818359, ["ze"] = -61.901885986328, ["he"] = 180.00, ["xo"] = 638.8463134765, ["yo"] = 1.44993293283, ["zo"] = 82.78640747074, ["ho"] = 180.00, ["name"] = 'Vinewood PD', ["locked"] = false },	

	[32] =  { ['xo'] = -175.39,['yo'] = -259.35,['zo'] = 24.28,['ho'] = 178.33, ['xe'] = -138.06,['ye'] = -256.72,['ze'] = 43.6,['he'] = 220.28, ['name'] = 'Cluckin Bell' },

	[33] = { ["xe"] = 1172.8729248047, ["ye"] = -3196.6640625, ["ze"] = -39.007961273193, ["he"] = 97.41, ["xo"] =992.72039794922, ["yo"] =-3097.9880371094, ["zo"] =-38.995868682861, ["ho"] = 271.6, ["name"] = 'Trading', ["locked"] = false },

	[34] = { ["xe"] = 250.5297088623, ["ye"] = -344.24923706055, ["ze"] = 44.495986938477, ["he"] = 267.41, ["xo"] = -1579.21960449219, ["yo"] = -563.8564453125, ["zo"] = 108.523002624512, ["ho"] = 221.6, ["name"] = 'D.A Office', ["locked"] = false },

	[35] = { ["xe"] = 248.63272094727, ["ye"] = -343.47079467773, ["ze"] = 44.47249984741, ["he"] = 267.41, ["xo"] = -141.1987, ["yo"] = -620.913, ["zo"] = 168.8205, ["ho"] = 221.6, ["name"] = 'Office 2', ["locked"] = false },

	[36] = { ["xe"] = 246.30664062, ["ye"] = -342.6910400390, ["ze"] = 44.44602966308, ["he"] = 267.41, ["xo"] = -75.44054, ["yo"] = -827.1487, ["zo"] = 243.3859, ["ho"] = 311.6, ["name"] = 'Office 3', ["locked"] = false },

	[37] = { ["xe"] = 243.92816162109, ["ye"] = -341.8356628418, ["ze"] = 44.41862106323, ["he"] = 267.41, ["xo"] = -1392.542, ["yo"] = -480.4011, ["zo"] = 72.04211, ["ho"] = 241.6, ["name"] = 'Office 4', ["locked"] = false },

	[38] = { ['xo'] = 334.85,['yo'] = -590.61,['zo'] = 43.3,['ho'] = 69.32, ['xe'] = 334.85,['ye'] = -590.61,['ze'] = 43.3,['he'] = 69.32, ["name"] = 'Hospital Rooms', ["locked"] = true },

	[39] = { ["xe"] = 224.834991455, ["ye"] = -419.5123291015, ["ze"] = -118.1995620727, ["he"] = 0.000, ["xo"] = 238.3043823242, ["yo"] = -412.010040283, ["zo"] = 48.11193847656, ["ho"] = 0.00, ["name"] = 'Judge Offices', ["locked"] = false },

	[40] = { ['xo'] = 930.01,['yo'] = 43.33,['zo'] = 81.1,['ho'] = 52.76, ['xe'] = 889.861,['ye'] = 9.36351,['ze'] = -185.046,['he'] = 283.14, ["name"] = 'Casino', ["locked"] = false },

	[41] = { ['xe'] = 1759.56,['ye'] = 2513.16,['ze'] = 45.78,['he'] = 0.97, ['xo'] = 1747.03,['yo'] = 2644.49,['zo'] = 48.11,['ho'] = 85.94, ["name"] = 'Jail Block Police', ["locked"] = false },

	[42] = { ['xe'] = 1100.15,['ye'] = -3158.99,['ze'] = -37.51,['he'] = 0.16, ['xo'] = 1100.24,['yo'] = -3161.02,['zo'] = -37.49,['ho'] = 179.99, ["name"] = 'Paint Shop', ["locked"] = true },

	[43] = { ["xo"] = 0.0, ["yo"] = 0.0, ["zo"] = 0.0, ["ho"] = 220.0, ["xe"] = 0.0, ["ye"] = 0.0, ["ze"] = 0.0, ["he"] = 90.0, ["name"] = 'can be reused', ["locked"] = false }, 

	[44] = { ['xo'] = -1928.6,['yo'] = 2059.84,['zo'] = 140.84,['ho'] = 345.31, ['xe'] = 997.19,['ye'] = -3200.77,['ze'] = -36.39,['he'] = 264.87, ["name"] = 'The Winery', ["locked"] = false },

	[45] = { ['xe'] = 327.23,['ye'] = -603.38,['ze'] = 43.2,['he'] = 137.62, ['xo'] = 319.85,['yo'] = -559.86,['zo'] = 28.75,['ho'] = 180.67, ["name"] = 'Pillbox Hospital garage', ["locked"] = false },

	[46] =  { ['xe'] = 973.94,['ye'] = -101.37,['ze'] = 74.85,['he'] = 132.36, ['name'] = ' Door', ['xo'] = 965.84,['yo'] = -104.34,['zo'] = 74.36,['ho'] = 318.26 },

	[47] =  { ['xe'] = -785.5,['ye'] = -13.98,['ze'] = -16.77,['he'] = 200.06, ['name'] = ' The Church', ['xo'] = -766.71,['yo'] = -23.78,['zo'] = 41.09,['ho'] = 206.19 },

	[48] =  { ['xe'] = 106.21,['ye'] = 3597.03,['ze'] = 40.73,['he'] = 264.37, ['name'] = ' The Lost', ['xo'] = 105.7,['yo'] = 3604.02,['zo'] = -23.84,['ho'] = 264.72 }, -- LOST Church Room

	[49] =  { ['xo'] = 841.74,['yo'] = -1159.59,['zo'] = 25.26,['ho'] = 182.62, ['name'] = ' Stock Area' , ['xe'] = 890.08,['ye'] = -3243.81,['ze'] = -98.26,['he'] = 85.03 }, -- gun trade for mehdi

	[50] = { ["xe"] = 746.75518798828, ["ye"] = -1400.094482421, ["ze"] = 26.570837020874, ["he"] = 180.31, ["xo"] = 1026.447265625, ["yo"] =-3101.4375, ["zo"] =-38.999881744385, ["ho"] = 91.6, ["name"] = 'Recycling', ["locked"] = false },

	[51] = { ["xe"] = -212.13, ["ye"] = -728.41, ["ze"] = 32.85, ["he"] = 70.27, ["xo"] = -190.92, ["yo"] = -751.12, ["zo"] = 79.52, ["ho"] = 248.239, ["name"] = 'Apartment', ["locked"] = false },
}



function DrawText3DTest(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.25, 0.25)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 175)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

bobbytheobject = 0

function spawnMetalDetector()
	local metd = `ch_prop_ch_metal_detector_01a`
	RequestModel(metd)
	while not HasModelLoaded(metd) do
	Citizen.Wait(0)
	end


	bobbytheobject = CreateObject(metd, 254.1053,-367.8492,-45.14, 0, 0, 0)

	SetEntityHeading( bobbytheobject, 252.03 )
	SetEntityInvincible(bobbytheobject, true)
	SetEntityCanBeDamaged(bobbytheobject, false)
	FreezeEntityPosition(bobbytheobject,true)
    SetModelAsNoLongerNeeded(metd)
end

function delMetalDetector()

	DeleteEntity(bobbytheobject)
	bobbytheobject = 0
end



distance = 10.5999 -- distance to draw
timer = 0
current_int = 0

-- Basic draw text
function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

local policeped = 0


function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end


Controlkey = {["generalUse"] = {38,"E"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["generalUse"] = table["generalUse"]
end)

function fixhead(heading)
	SetGameplayCamRelativeHeading(0.0)
end
 -- standing normal
-- Tick tick tick
local fading = false
Citizen.CreateThread(function()
	SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
	DoScreenFadeIn(300)
	Citizen.Wait(3111)
	local scannedEntry = 0
	local dstchecked = 1000
	while true do

		Citizen.Wait(1)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		if scannedEntry == 0 then
			dstchecked = 1000
			for i=1, #interiors do
				if not IsEntityDead(PlayerPedId()) then
					local comparedst = #(playerCoords - vector3( interiors[i].xe,interiors[i].ye,interiors[i].ze))
					if comparedst < dstchecked then
						dstchecked = comparedst
						scannedEntry = i
					end
					local comparedst2 = #(playerCoords - vector3( interiors[i].xo,interiors[i].yo,interiors[i].zo))
					if comparedst2 < dstchecked then
						dstchecked = comparedst2
						scannedEntry = i
					end
				end
			end
		end
		
		if dstchecked > 4.1 then

			local waittime = math.ceil(dstchecked * 100) 

			Citizen.Wait(waittime)
			scannedEntry = 0
		else
			if scannedEntry ~= 0 then
				local comparedst2 = #(playerCoords - vector3( interiors[scannedEntry].xo,interiors[scannedEntry].yo,interiors[scannedEntry].zo))
				local comparedst = #(playerCoords - vector3( interiors[scannedEntry].xe,interiors[scannedEntry].ye,interiors[scannedEntry].ze))
				if comparedst < 1.1 then
					if not interiors[scannedEntry].locked then
						DrawMarker(27,interiors[scannedEntry].xe,interiors[scannedEntry].ye,interiors[scannedEntry].ze-1.0001, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.3, 0, 0, 0, 35, 0, 0, 2, 0, 0, 0, 0)
						if scannedEntry == 49 then
							local rank = exports["isPed"]:GroupRank("sahara_int")
							if rank > 3 then
								DrawText3DTest(interiors[scannedEntry].xe,interiors[scannedEntry].ye,interiors[scannedEntry].ze, "["..Controlkey["generalUse"][2].."] " .. interiors[scannedEntry].name)
							end
						else
							DrawText3DTest(interiors[scannedEntry].xe,interiors[scannedEntry].ye,interiors[scannedEntry].ze, "["..Controlkey["generalUse"][2].."] " .. interiors[scannedEntry].name)
						end
						
						if comparedst < 1.1 and timer == 0 and IsControlJustReleased(0,Controlkey["generalUse"][1]) then
							EnterXO(scannedEntry)
							Citizen.Wait(1000)
							scannedEntry = 0
						end
					else
						DrawMarker(27,interiors[scannedEntry].xe,interiors[scannedEntry].ye,interiors[scannedEntry].ze-1.0001, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.3, 0, 0, 0, 35, 0, 0, 2, 0, 0, 0, 0)
						DrawText3DTest(interiors[scannedEntry].xe,interiors[scannedEntry].ye,interiors[scannedEntry].ze, "[Locked] " .. interiors[scannedEntry].name)
					end
				elseif comparedst2 < 1.1 then
	
					if not interiors[scannedEntry].locked then
						DrawMarker(27,interiors[scannedEntry].xo,interiors[scannedEntry].yo,interiors[scannedEntry].zo-1.0001, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.3, 0, 0, 0, 35, 0, 0, 2, 0, 0, 0, 0)
						DrawText3DTest(interiors[scannedEntry].xo,interiors[scannedEntry].yo,interiors[scannedEntry].zo, "["..Controlkey["generalUse"][2].."] " .. interiors[scannedEntry].name)						
					
						if comparedst2 < 1.1 and timer == 0 and IsControlJustReleased(0,Controlkey["generalUse"][1]) then
							EnterXE(scannedEntry)
							Citizen.Wait(1000)
							scannedEntry = 0
						end
					else
						DrawMarker(27,interiors[scannedEntry].xo,interiors[scannedEntry].yo,interiors[scannedEntry].zo-1.0001, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.3, 0, 0, 0, 35, 0, 0, 2, 0, 0, 0, 0)
						DrawText3DTest(interiors[scannedEntry].xo,interiors[scannedEntry].yo,interiors[scannedEntry].zo, "[Locked] " .. interiors[scannedEntry].name)
					end
				elseif comparedst > 1.1 and comparedst2 > 1.1 then
					scannedEntry = 0
				end
			end
		end
	end
end)


function EnterXE(i)
	DoScreenFadeOut(300)
	Citizen.Wait(300)
	if ((i == 10) or (i == 11) or (i == 14) or (i == 12)) and interiors[i].locked then
		TriggerEvent("DoShortHudText",'Building locked',7)
		timer = 5
	elseif i == 11 then
		TriggerServerEvent("request:cocainedelete")
		timer = 5

	elseif i == 49 then

		local rank = exports["isPed"]:GroupRank("sahara_int")
		if rank < 3 then
			timer = 5	
		else
			local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
			local entity = PlayerPedId()
			if isInVehicle then
				entity = GetVehiclePedIsUsing(entity)
			end
			SetEntityCoords(entity,interiors[i].xe,interiors[i].ye,interiors[i].ze-0.7)
			SetEntityHeading(entity, interiors[i].he)
			timer = 5	
		end

	elseif i == 42 then
	elseif i == 44 then
		SetEntityCoords(PlayerPedId(),interiors[i].xe,interiors[i].ye,interiors[i].ze-0.7)
		SetEntityHeading(PlayerPedId(), interiors[i].he)
		enterWinery()
		timer = 5
	elseif i == 43 then

		SetEntityCoords(PlayerPedId(),interiors[i].xe,interiors[i].ye,interiors[i].ze-0.7)
		Citizen.Wait(500)
		SetEntityCoords(PlayerPedId(),interiors[i].xo,interiors[i].yo,interiors[i].zo-0.7)
		Citizen.Wait(500)
		SetEntityCoords(PlayerPedId(),interiors[i].xe,interiors[i].ye,interiors[i].ze-0.7)
		timer = 5
	elseif i == 46 then
		if exports["isPed"]:GroupRank("parts_shop") > 0 then
			SetEntityCoords(PlayerPedId(), interiors[i].xe,interiors[i].ye,interiors[i].ze-0.7)
		end
		timer = 5
	elseif i == 48 then
		if exports["isPed"]:GroupRank("lost_mc") > 0 then
			SetEntityCoords(PlayerPedId(), interiors[i].xe,interiors[i].ye,interiors[i].ze-0.7)
		end
		timer = 5
	elseif i == 45 then
		CleanUpArea()
		
		SetEntityCoords(PlayerPedId(), interiors[i].xe,interiors[i].ye,interiors[i].ze-0.7)
		timer = 5


	elseif i == 38 then

		
		SetEntityCoords(PlayerPedId(), interiors[i].xe,interiors[i].ye,interiors[i].ze)

		timer = 5

	elseif i == 15 then

		CleanUpArea()
		
		SetEntityCoords(PlayerPedId(), interiors[i].xe,interiors[i].ye,interiors[i].ze-0.7)
		timer = 5
	--dicks
	elseif i == 19 then
		if interiors[i].locked == false then
			--spawnMetalDetector()
            local myjob = exports["isPed"]:isPed("myjob")
            local cock = true
			if cock == true  then

				SetEntityCoords(PlayerPedId(), 294.98,-1599.13,-66.78)
				Citizen.Wait(1500)
				SetEntityCoords(PlayerPedId(), 285.27,-1592.78,-66.78)
				Citizen.Wait(1100)
				SetEntityCoords(PlayerPedId(), 300.35,-1604.83,-66.78)
				Citizen.Wait(900)
				SetEntityCoords(PlayerPedId(), 311.94,-1614.88,-66.78)


				
				SetEntityHeading(PlayerPedId(), interiors[i].he)
				fixhead(interiors[i].he)
				ClearAreaOfPeds(interiors[i].xe,interiors[i].ye,interiors[i].ze, 45.0, 1)
				--NetworkFadeInEntity(PlayerPedId(), 0)

				current_int = i
				timer = 5
				SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)

			else
				timer = 5
			end
		else
			if timer == 0 then
				TriggerEvent("notification","Its Locked",2)
			end
			timer = 5
		end
	elseif i == 20 then
		if timer == 0 and interiors[i].locked == false then

			while IsScreenFadingOut() do Citizen.Wait(0) end
			--NetworkFadeOutEntity(PlayerPedId(), true, false)

			SetEntityCoords(PlayerPedId(), interiors[i].xe,interiors[i].ye,interiors[i].ze-0.7)
			SetEntityHeading(PlayerPedId(), interiors[i].he)
			fixhead(interiors[i].he)
			ClearAreaOfPeds(interiors[i].xe,interiors[i].ye,interiors[i].ze, 45.0, 1)
			--NetworkFadeInEntity(PlayerPedId(), 0)

			current_int = i
			timer = 5
			SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)

			while IsScreenFadingIn() do Citizen.Wait(0)	end
		else
			if timer == 0 then
				TriggerEvent("notification","Its Locked",2)
			end
			timer = 5
		end

	elseif i == 40 then

		SetEntityCoords(PlayerPedId(),840.77,29.34,-185.04)
		--TriggerServerEvent("request:casinospawn")
		Citizen.Wait(1100)


		SetEntityCoords(PlayerPedId(),868.92,13.34,-185.04)
		Citizen.Wait(1100)
		


		SetEntityCoords(PlayerPedId(),930.01, 43.33, 81.1)
		Citizen.Wait(500)
		SetEntityCoords(PlayerPedId(),889.861, 9.36351, -185.046)
		timer = 5



	elseif i == 17 or i == 18 or i == 25 or i == 26 or i == 27 then
		if timer == 0 and prisonDoors == false then

			while IsScreenFadingOut() do Citizen.Wait(0) end
			--NetworkFadeOutEntity(PlayerPedId(), true, false)

			SetEntityCoords(PlayerPedId(), interiors[i].xe,interiors[i].ye,interiors[i].ze-0.7)
			SetEntityHeading(PlayerPedId(), interiors[i].he)
			fixhead(interiors[i].he)
			ClearAreaOfPeds(interiors[i].xe,interiors[i].ye,interiors[i].ze, 45.0, 1)
			--NetworkFadeInEntity(PlayerPedId(), 0)

			current_int = i
			timer = 5
			SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)

			while IsScreenFadingIn() do Citizen.Wait(0)	end
		else
			if timer == 0 then
				TriggerEvent("notification","Its Locked",2)
			end
			timer = 5
		end
	else

		if timer == 0 then

			while IsScreenFadingOut() do Citizen.Wait(0) end
			--NetworkFadeOutEntity(PlayerPedId(), true, false)

			if i == 29 then
				createProcessPed()	
				timer = 5					
			end
			if i == 50 then
				TriggerEvent("hotel:clearWarehouse")
				timer = 5
			end
			if i == 30 then
				spawnMetalDetector()
				timer = 5
			end



			if i == 31 then
				TriggerServerEvent("request:vinewoodspawn")

				timer = 5

			else									
				SetEntityCoords(PlayerPedId(), interiors[i].xe,interiors[i].ye,interiors[i].ze-0.7)
				SetEntityHeading(PlayerPedId(), interiors[i].he)
				fixhead(interiors[i].he)
				ClearAreaOfPeds(interiors[i].xe,interiors[i].ye,interiors[i].ze, 45.0, 1)

				current_int = i
				timer = 5
				SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)

				while IsScreenFadingIn() do Citizen.Wait(0)	end
			end
		end
	end
	Citizen.Wait(500)
	DoScreenFadeIn(1000)
end



function EnterXO(i)


	if ((i == 10) or (i == 11) or (i == 14) or (i == 12)) and interiors[i].locked then
		TriggerEvent("DoShortHudText",'Building locked.',7)
		Citizen.Wait(2000)
		timer = 5
	elseif i == 11 then

		TriggerServerEvent("request:cocainespawn")
		SetEntityCoords(PlayerPedId(),interiors[i].xo,interiors[i].yo,interiors[i].zo-0.7)
		SetEntityHeading(PlayerPedId(), interiors[i].ho)
		timer = 5
	elseif i == 43 or i == 44 then
		SetEntityCoords(PlayerPedId(),interiors[i].xo,interiors[i].yo,interiors[i].zo-0.7)
		SetEntityHeading(PlayerPedId(), interiors[i].ho)
		Citizen.Wait(2500)
		timer = 5

	elseif i == 50 then

		TriggerEvent("hotel:loadWarehouse")
		SetEntityCoords(GetPlayerPed(-1), interiors[i].xo,interiors[i].yo,interiors[i].zo-0.1)
		timer = 5
	elseif i == 46 then
		
		if exports["isPed"]:GroupRank("parts_shop") > 0 then
			SetEntityCoords(PlayerPedId(), interiors[i].xo,interiors[i].yo,interiors[i].zo-0.7)
		end
		timer = 5

	elseif i == 49 then

		local rank = exports["isPed"]:GroupRank("sahara_int")
		if rank < 3 then
			timer = 5
		else
			local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
			local entity = PlayerPedId()
			if isInVehicle then
				entity = GetVehiclePedIsUsing(entity)
			end
			SetEntityCoords(entity,interiors[i].xo,interiors[i].yo,interiors[i].zo-0.7)
			SetEntityHeading(entity, interiors[i].ho)
			timer = 5	
		end
	elseif i == 48 then
		if exports["isPed"]:GroupRank("lost_mc") > 0 then	
			SetEntityCoords(PlayerPedId(), interiors[i].xo,interiors[i].yo,interiors[i].zo-0.7)
		end
		timer = 5
	elseif i == 45 then
		FreezeEntityPosition(PlayerPedId(),true)
		buildWineOffice()
		Citizen.Wait(1000)
		FreezeEntityPosition(PlayerPedId(),false)
		
		timer = 5
	elseif i == 42 then
		local objFound = GetClosestObjectOfType( GetEntityCoords(PlayerPedId()), 3.0, 1544229216, 0, 0, 0)
		FreezeEntityPosition(objFound,false)
		
		timer = 25
	elseif i == 22 then
		SetEntityCoords(PlayerPedId(), interiors[i].xo,interiors[i].yo,interiors[i].zo)
	elseif i == 19 then

			SetEntityCoords(PlayerPedId(), interiors[i].xo,interiors[i].yo,interiors[i].zo-0.7)
			SetEntityHeading(PlayerPedId(), interiors[i].ho)

			fixhead(interiors[i].ho)

			ClearAreaOfPeds(interiors[i].xo,interiors[i].yo,interiors[i].zo, 45.0, 1)

			--NetworkFadeInEntity(PlayerPedId(), 0)
			courthousescan = false
			current_int = i
			timer = 5
			SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)


	elseif i == 20 then
		if timer == 0 and interiors[i].locked == false then

			while IsScreenFadingOut() do Citizen.Wait(0) end
			--NetworkFadeOutEntity(PlayerPedId(), true, false)

			SetEntityCoords(PlayerPedId(), interiors[i].xo,interiors[i].yo,interiors[i].zo-0.7)
			
			SetEntityHeading(PlayerPedId(), interiors[i].ho)
			fixhead(interiors[i].ho)

			ClearAreaOfPeds(interiors[i].xo,interiors[i].yo,interiors[i].zo, 45.0, 1)

			--NetworkFadeInEntity(PlayerPedId(), 0)

			current_int = i
			timer = 5
			SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)

			while IsScreenFadingIn() do Citizen.Wait(0)	end
		else
			if timer == 0 then
				TriggerEvent("notification","Its Locked",2)
			end
			timer = 5
		end

	elseif i == 41 or i == 42 then
		if timer == 0 then
			-- load in hospital interior?
			DoScreenFadeOut(1)
			SetEntityCoords(PlayerPedId(), interiors[i].xo,interiors[i].yo,interiors[i].zo-0.7)
			Citizen.Wait(700)
			SetEntityCoords(PlayerPedId(), interiors[i].xe,interiors[i].ye,interiors[i].ze-0.7)

			if i == 43 then

				Citizen.Wait(450)
				SetEntityCoords(PlayerPedId(), 918.43,38.95,-180.88)
				Citizen.Wait(450)
				SetEntityCoords(PlayerPedId(), 918.43,38.95,-185.88)
				Citizen.Wait(450)
				SetEntityCoords(PlayerPedId(), 926.65,52.19,-180.88)
				SetEntityHeading(PlayerPedId(),350.0)
			end

			Citizen.Wait(500)
			DoScreenFadeIn(500)
			SetEntityCoords(PlayerPedId(), interiors[i].xo,interiors[i].yo,interiors[i].zo-0.7)
			SetEntityHeading(PlayerPedId(), interiors[i].ho)
			timer = 8
		end
	elseif i == 18 then
		SetEntityCoords(PlayerPedId(),interiors[i].xo-5,interiors[i].yo-5,interiors[i].zo)

		Citizen.Wait(500)
		SetEntityCoords(PlayerPedId(),interiors[i].xo-35,interiors[i].yo-35,interiors[i].zo)
		Citizen.Wait(500)
		SetEntityCoords(PlayerPedId(),interiors[i].xo,interiors[i].yo,interiors[i].zo)
		timer = 5
	elseif i == 38 then

		SetEntityCoords(PlayerPedId(), interiors[i].xo,interiors[i].yo,interiors[i].zo)

		Citizen.Wait(500)

		SetEntityCoords(PlayerPedId(), interiors[i].xe,interiors[i].ye,interiors[i].ze)

		Citizen.Wait(500)

		SetEntityCoords(PlayerPedId(), interiors[i].xo,interiors[i].yo,interiors[i].zo)
		timer = 5

	elseif i == 40 then
		TriggerServerEvent("request:casinodel")
		Citizen.Wait(1000)
		SetEntityCoords(PlayerPedId(),930.01, 43.33, 81.1)
		timer = 5

	elseif i == 17 or i == 18 or i == 25 or i == 26 or i == 27 then
		if timer == 0 and prisonDoors == false then

			while IsScreenFadingOut() do Citizen.Wait(0) end
			--NetworkFadeOutEntity(PlayerPedId(), true, false)

			SetEntityCoords(PlayerPedId(), interiors[i].xo,interiors[i].yo,interiors[i].zo-0.7)
			SetEntityHeading(PlayerPedId(), interiors[i].ho)
			fixhead(interiors[i].ho)

			ClearAreaOfPeds(interiors[i].xo,interiors[i].yo,interiors[i].zo, 45.0, 1)

			--NetworkFadeInEntity(PlayerPedId(), 0)

			current_int = i
			timer = 5
			SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)

			while IsScreenFadingIn() do Citizen.Wait(0)	end
		else
			if timer == 0 then
				TriggerEvent("notification","Its Locked",2)
			end
			timer = 5
		end
	elseif i == 32 then


		SetEntityCoords(PlayerPedId(), interiors[i].xo,interiors[i].yo,interiors[i].zo-0.1)

		timer = 5

	else

		if timer == 0 then

			while IsScreenFadingOut() do Citizen.Wait(0) end
			--NetworkFadeOutEntity(PlayerPedId(), true, false)

			if i == 29 then
				delProcessPed()	
				timer = 5						
			end


			if i == 30 then
				delMetalDetector()
				timer = 5
			end


			if i == 31 then
				TriggerServerEvent("request:vinewooddel")
				timer = 5

			else
				SetEntityCoords(PlayerPedId(), interiors[i].xo,interiors[i].yo,interiors[i].zo-0.7)
				SetEntityHeading(PlayerPedId(), interiors[i].ho)
				fixhead(interiors[i].ho)

				ClearAreaOfPeds(interiors[i].xo,interiors[i].yo,interiors[i].zo, 45.0, 1)
				--NetworkFadeInEntity(PlayerPedId(), 0)
				current_int = i
				timer = 5
				SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
				while IsScreenFadingIn() do 
					Citizen.Wait(0)	
				end
			end
		end

	end

	Citizen.Wait(500)
	DoScreenFadeIn(1000)

end

-- Sick timer by the creator of the original script.
Citizen.CreateThread(function()

	while true do
		Wait(1000)
		if timer > 0 then
			timer=timer-1
			if timer == 0 then current_int = 0 end
		end
	end
end)



function CleanUpArea()

    local playerped = PlayerPedId()
    local plycoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstObject()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(plycoords - pos)
        if distance < 50.0 and ObjectFound ~= playerped then
        	if IsEntityAPed(ObjectFound) then
        		if IsPedAPlayer(ObjectFound) then
        		else
        			SetEntityAsNoLongerNeeded(Objectfound)
        			DeleteObject(ObjectFound)

        		end
        	else
        		if not IsEntityAVehicle(ObjectFound) and not IsEntityAttached(ObjectFound) then
	        		DeleteObject(ObjectFound)
	        	end
        	end            
        end
        success, ObjectFound = FindNextObject(handle)
    until not success
    EndFindObject(handle)
end