ESX = nil
PlayerData = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local tasking = false
local mygang = "local"
local watching = "local"
local watchinglist = {}
local drugStorePed = 0
local cashPayment = 420


local GoldBarTime = true




local dropoffpoints = {
	[1] =  { ['x'] = 483.17,['y'] = -1827.35,['z'] = 27.86,['h'] = 135.87, ['info'] = ' East Side 1' },
	[2] =  { ['x'] = 475.87,['y'] = -1798.45,['z'] = 28.49,['h'] = 229.85, ['info'] = ' East Side 2' },
	[3] =  { ['x'] = 503.54,['y'] = -1765.06,['z'] = 28.51,['h'] = 67.61, ['info'] = ' East Side 3' },
	[4] =  { ['x'] = 512.0,['y'] = -1842.13,['z'] = 27.9,['h'] = 138.1, ['info'] = ' East Side 4' },
	[5] =  { ['x'] = 466.89,['y'] = -1852.81,['z'] = 27.72,['h'] = 310.97, ['info'] = ' East Side 5' },
	[6] =  { ['x'] = 431.33,['y'] = -1882.85,['z'] = 26.85,['h'] = 39.7, ['info'] = ' East Side 6' },
	[7] =  { ['x'] = 410.64,['y'] = -1908.57,['z'] = 25.46,['h'] = 80.03, ['info'] = ' East Side 7' },
	[8] =  { ['x'] = 192.93,['y'] = -2027.95,['z'] = 18.29,['h'] = 251.25, ['info'] = ' East Side 8' },
	[9] =  { ['x'] = 184.05,['y'] = -2004.77,['z'] = 18.31,['h'] = 49.81, ['info'] = ' East Side 9' },
	[10] =  { ['x'] = 212.4,['y'] = -1971.66,['z'] = 20.31,['h'] = 63.83, ['info'] = ' East Side 10' },
	[11] =  { ['x'] = 266.85,['y'] = -1964.41,['z'] = 23.0,['h'] = 49.59, ['info'] = ' East Side 11' },
	[12] =  { ['x'] = 313.05,['y'] = -1918.57,['z'] = 25.65,['h'] = 315.88, ['info'] = ' East Side 12' },
	[13] =  { ['x'] = 282.63,['y'] = -1948.96,['z'] = 24.39,['h'] = 40.21, ['info'] = ' East Side 13' },
	[14] =  { ['x'] = 250.44,['y'] = -1995.9,['z'] = 20.32,['h'] = 324.5, ['info'] = ' East Side 14' },
	[15] =  { ['x'] = 270.54,['y'] = -1706.13,['z'] = 29.31,['h'] = 46.82, ['info'] = ' Central 1' },
	[16] =  { ['x'] = 167.78,['y'] = -1635.0,['z'] = 29.3,['h'] = 22.04, ['info'] = ' Central 2' },

	[17] =  { ['x'] = 175.98,['y'] = -1542.48,['z'] = 29.27,['h'] = 316.21, ['info'] = ' Central 3' },

	[18] =  { ['x'] = -99.69,['y'] = -1577.74,['z'] = 31.73,['h'] = 231.66, ['info'] = ' Central 4' },
	[19] =  { ['x'] = -171.68,['y'] = -1659.11,['z'] = 33.47,['h'] = 85.41, ['info'] = ' Central 5' },
	[20] =  { ['x'] = -209.75,['y'] = -1632.29,['z'] = 33.9,['h'] = 177.99, ['info'] = ' Central 6' },
	[21] =  { ['x'] = -262.65,['y'] = -1580.04,['z'] = 31.86,['h'] = 251.02, ['info'] = ' Central 7' },
	[22] =  { ['x'] = -182.0,['y'] = -1433.79,['z'] = 31.31,['h'] = 210.92, ['info'] = ' Central 8' },
	[23] =  { ['x'] = -83.37,['y'] = -1415.39,['z'] = 29.33,['h'] = 180.98, ['info'] = ' Central 9' },
	[24] =  { ['x'] = -39.13,['y'] = -1473.67,['z'] = 31.65,['h'] = 5.17, ['info'] = ' Central 10' },
	[25] =  { ['x'] = 45.16,['y'] = -1475.65,['z'] = 29.36,['h'] = 136.92, ['info'] = ' Central 11' },
	[26] =  { ['x'] = 158.52,['y'] = -1496.02,['z'] = 29.27,['h'] = 133.49, ['info'] = ' Central 12' },
	[27] =  { ['x'] = 43.58,['y'] = -1599.87,['z'] = 29.61,['h'] = 50.3, ['info'] = ' Central 13' },
	[28] =  { ['x'] = 7.97,['y'] = -1662.14,['z'] = 29.33,['h'] = 318.63, ['info'] = ' Central 14' },
	[29] =  { ['x'] = -726.92,['y'] = -854.64,['z'] = 22.8,['h'] = 2.0, ['info'] = ' West 1' },
	[30] =  { ['x'] = -713.09,['y'] = -886.66,['z'] = 23.81,['h'] = 357.65, ['info'] = ' West 2' },
	[31] =  { ['x'] = -591.45,['y'] = -891.2,['z'] = 25.95,['h'] = 91.53, ['info'] = ' West 3' },
	[32] =  { ['x'] = -683.59,['y'] = -945.62,['z'] = 20.85,['h'] = 180.74, ['info'] = ' West 4' },
	[33] =  { ['x'] = -765.92,['y'] = -920.94,['z'] = 18.94,['h'] = 180.44, ['info'] = ' West 5' },
	[34] =  { ['x'] = -807.45,['y'] = -957.09,['z'] = 15.29,['h'] = 340.4, ['info'] = ' West 6' },
	[35] =  { ['x'] = -822.88,['y'] = -973.96,['z'] = 14.72,['h'] = 126.28, ['info'] = ' West 7' },
	[36] =  { ['x'] = -657.53,['y'] = -729.91,['z'] = 27.84,['h'] = 309.58, ['info'] = ' West 8' },
	[37] =  { ['x'] = -618.39,['y'] = -750.71,['z'] = 26.66,['h'] = 85.6, ['info'] = ' West 9' },
	[38] =  { ['x'] = -548.36,['y'] = -854.53,['z'] = 28.82,['h'] = 352.84, ['info'] = ' West 10' },
	[39] =  { ['x'] = -518.18,['y'] = -804.65,['z'] = 30.8,['h'] = 267.32, ['info'] = ' West 11' },
	[40] =  { ['x'] = -509.05,['y'] = -737.77,['z'] = 32.6,['h'] = 174.97, ['info'] = ' West 12' },
	[41] =  { ['x'] = -567.5,['y'] = -717.77,['z'] = 33.43,['h'] = 268.02, ['info'] = ' West 13' },
	[42] =  { ['x'] = -654.89,['y'] = -732.13,['z'] = 27.56,['h'] = 309.15, ['info'] = ' West 14' },
}

local OxyDropOffs = {
	[1] =  { ['x'] = 74.5,['y'] = -762.17,['z'] = 31.68,['h'] = 160.98, ['info'] = ' 1' },
	[2] =  { ['x'] = 100.58,['y'] = -644.11,['z'] = 44.23,['h'] = 69.11, ['info'] = ' 2' },
	[3] =  { ['x'] = 175.45,['y'] = -445.95,['z'] = 41.1,['h'] = 92.72, ['info'] = ' 3' },
	[4] =  { ['x'] = 130.3,['y'] = -246.26,['z'] = 51.45,['h'] = 219.63, ['info'] = ' 4' },
	[5] =  { ['x'] = 198.1,['y'] = -162.11,['z'] = 56.35,['h'] = 340.09, ['info'] = ' 5' },
	[6] =  { ['x'] = 341.0,['y'] = -184.71,['z'] = 58.07,['h'] = 159.33, ['info'] = ' 6' },
	[7] =  { ['x'] = -26.96,['y'] = -368.45,['z'] = 39.69,['h'] = 251.12, ['info'] = ' 7' },
	[8] =  { ['x'] = -155.88,['y'] = -751.76,['z'] = 33.76,['h'] = 251.82, ['info'] = ' 8' },

	[9] =  { ['x'] = -305.02,['y'] = -226.17,['z'] = 36.29,['h'] = 306.04, ['info'] = ' penis1' },
	[10] =  { ['x'] = -347.19,['y'] = -791.04,['z'] = 33.97,['h'] = 3.06, ['info'] = ' penis2' },
	[11] =  { ['x'] = -703.75,['y'] = -932.93,['z'] = 19.22,['h'] = 87.86, ['info'] = ' penis3' },
	[12] =  { ['x'] = -659.35,['y'] = -256.83,['z'] = 36.23,['h'] = 118.92, ['info'] = ' penis4' },
	[13] =  { ['x'] = -934.18,['y'] = -124.28,['z'] = 37.77,['h'] = 205.79, ['info'] = ' penis5' },
	[14] =  { ['x'] = -1214.3,['y'] = -317.57,['z'] = 37.75,['h'] = 18.39, ['info'] = ' penis6' },
	[15] =  { ['x'] = -822.83,['y'] = -636.97,['z'] = 27.9,['h'] = 160.23, ['info'] = ' penis7' },
	[16] =  { ['x'] = 308.04,['y'] = -1386.09,['z'] = 31.79,['h'] = 47.23, ['info'] = ' penis8' },

}


local drugLocs = {
	[1] =  { ['x'] = 131.94,['y'] = -1937.95,['z'] = 20.61,['h'] = 118.59, ['info'] = ' Grove Stash' },
	[2] =  { ['x'] = 1390.84,['y'] = -1507.94,['z'] = 58.44,['h'] = 29.6, ['info'] = ' East Side' },
	[3] =  { ['x'] = -676.81,['y'] = -877.94,['z'] = 24.48,['h'] = 324.9, ['info'] = ' Wei Cheng' },
}

local pillWorker = { ['x'] = 67.63,['y'] = -1570.74,['z'] = 29.60,['h'] = 268.58, ['info'] = ' lol' }


local rnd = 0
local blip = 0
local deliveryPed = 0


local eastpedtypes = {
	'g_m_y_mexgang_01',
	'g_m_y_mexgoon_01',
	'g_m_y_mexgoon_02',
	'g_m_y_mexgoon_03',
}

local centpedtypes = {
	'g_m_y_ballaeast_01',
	'g_m_y_ballaorig_01',
	'g_m_y_famca_01',
	'g_m_y_famdnf_01',
	'g_m_y_famfor_01',
}

local westpedtypes = {
	'g_m_y_korean_01',
	'g_m_y_korean_02',
	'g_m_m_chiboss_01',
	'g_m_m_chicold_01',
	'g_m_m_chigoon_01',
	'g_m_m_chigoon_02',
	'g_m_m_korboss_01',
}




local carpick = {
    [1] = "felon",
    [2] = "kuruma",
    [3] = "sultan",
    [4] = "granger",
    [5] = "tailgater",
}

local carspawns = {
	[1] =  { ['x'] = 79.85,['y'] = -1544.99,['z'] = 29.47,['h'] = 51.55, ['info'] = ' car 8' },
	[2] =  { ['x'] = 66.93,['y'] = -1561.73,['z'] = 29.47,['h'] = 45.73, ['info'] = ' car 1' },
	[3] =  { ['x'] = 68.57,['y'] = -1559.53,['z'] = 29.47,['h'] = 50.6, ['info'] = ' car 2' },
	[4] =  { ['x'] = 70.4,['y'] = -1557.12,['z'] = 29.47,['h'] = 51.18, ['info'] = ' car 3' },
	[5] =  { ['x'] = 72.22,['y'] = -1554.63,['z'] = 29.47,['h'] = 50.32, ['info'] = ' car 4' },
	[6] =  { ['x'] = 73.99,['y'] = -1552.22,['z'] = 29.47,['h'] = 52.47, ['info'] = ' car 5' },
	[7] =  { ['x'] = 76.06,['y'] = -1549.87,['z'] = 29.47,['h'] = 51.53, ['info'] = ' car 6' },
	[8] =  { ['x'] = 77.9,['y'] = -1547.45,['z'] = 29.47,['h'] = 53.24, ['info'] = ' car 7' },
}





function CreateDrugPed()
	

    local hashKey = `g_m_y_salvagoon_01`

    local pedType = 5

    RequestModel(hashKey)
    while not HasModelLoaded(hashKey) do
        RequestModel(hashKey)
        Citizen.Wait(100)
    end


	deliveryPed = CreatePed(pedType, hashKey, dropoffpoints[rnd]["x"],dropoffpoints[rnd]["y"],dropoffpoints[rnd]["z"], dropoffpoints[rnd]["h"], 1, 1)

    ClearPedTasks(deliveryPed)
    ClearPedSecondaryTask(deliveryPed)
    TaskSetBlockingOfNonTemporaryEvents(deliveryPed, true)
    SetPedFleeAttributes(deliveryPed, 0, 0)
    SetPedCombatAttributes(deliveryPed, 17, 1)

    SetPedSeeingRange(deliveryPed, 0.0)
    SetPedHearingRange(deliveryPed, 0.0)
    SetPedAlertness(deliveryPed, 0)
    searchPockets()
    SetPedKeepTask(deliveryPed, true)
end

function DeleteCreatedPed()
	print("Deleting Ped?")
	if DoesEntityExist(deliveryPed) then 
		SetPedKeepTask(deliveryPed, false)
		TaskSetBlockingOfNonTemporaryEvents(deliveryPed, false)
		ClearPedTasks(deliveryPed)
		TaskWanderStandard(deliveryPed, 10.0, 10)
		SetPedAsNoLongerNeeded(deliveryPed)

		Citizen.Wait(20000)
		DeletePed(deliveryPed)
	end
end

function DeleteBlip()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
	end
end

function CreateBlip()
	DeleteBlip()
	if OxyRun then
		blip = AddBlipForCoord(OxyDropOffs[rnd]["x"],OxyDropOffs[rnd]["y"],OxyDropOffs[rnd]["z"])
	else
		blip = AddBlipForCoord(dropoffpoints[rnd]["x"],dropoffpoints[rnd]["y"],dropoffpoints[rnd]["z"])
	end
    
    SetBlipSprite(blip, 514)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Drop Off")
    EndTextCommandSetBlipName(blip)
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function searchPockets()
    if ( DoesEntityExist( deliveryPed ) and not IsEntityDead( deliveryPed ) ) then 
        loadAnimDict( "random@mugging4" )
        TaskPlayAnim( deliveryPed, "random@mugging4", "agitated_loop_a", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
    end
end

function giveAnim()
    if ( DoesEntityExist( deliveryPed ) and not IsEntityDead( deliveryPed ) ) then 
        loadAnimDict( "mp_safehouselost@" )
        if ( IsEntityPlayingAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 3 ) ) then 
            TaskPlayAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        else
            TaskPlayAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        end     
    end
end



Citizen.CreateThread(function()

    while true do

		Citizen.Wait(1)
		local GoldBars = #(GetEntityCoords(PlayerPedId()) - vector3(-101.08, 6464.0, 31.64))


		if GoldBars < 1.5 then

			if GoldBarTime then

				DrawText3Ds(-101.08, 6464.0, 31.64, "[E] to Exchange 70 Gold Bars for $35000") 
								
				if IsControlJustReleased(0,38) then
					if exports["dsrp-inventory"]:hasEnoughOfItem("goldbar",70,true) then
						local finished = exports["sway_taskbar"]:taskBar(100000,"Trading Bars")
						if finished == 100 then
						TriggerEvent("goldtrade")
						TriggerServerEvent("mission:completAVACed")
						end
					end
					Citizen.Wait(1000)
				end

			end

		end

	end


end)



RegisterNetEvent('goldtrade')
AddEventHandler('goldtrade', function()
	if exports["dsrp-inventory"]:hasEnoughOfItem("goldbar",70,true) then
		TriggerEvent("inventory:removeItem", "goldbar", 70)
		TriggerServerEvent('mission:completAVACed', 17500)
	end
end)

local stolenGoodsTable = {
	[84] = "stolencasiowatch",
	[85] = "rolexwatch",
	[86] = "stoleniphone",
	[87] = "stolens8",
	[88] = "stolennokia",
	[89] = "stolenpixel3",
	[90] = "stolen2ctchain",
	[91] = "stolen5ctchain",
	[92] = "stolen8ctchain",
	[93] = "stolen10ctchain",
	[94] = "stolenraybans",
	[95] = "stolenoakleys",
	[96] = "stolengameboy",
	[97] = "stolenpsp",
}


hasdenoms = false
RegisterNetEvent("denoms")
AddEventHandler("denoms", function(denomsp)
    if not hasdenoms and not denomsp then
        return
    end
  hasdenoms = denomsp
  if hasdenoms then
    TriggerEvent('chatMessage', 'STATUS: ', 1, "Your currency has Multiple Denominations" )
  else
    TriggerEvent('chatMessage', 'STATUS: ', 1, "Your currency no longer has Multiple Denominations" )
  end
end)


function HasStolenGoods()
	if OxyRun then
		
		TriggerEvent("attachItemDrugs","cashcase01")
		return true
	else
		for i = 84, 97 do
			local itemcount = exports["dsrp-inventory"]:hasEnoughOfItem(stolenGoodsTable[i],1,false)
			if itemcount then
				TriggerEvent("inventory:removeItem",stolenGoodsTable[i],math.random(5))
				TriggerEvent("attachItemDrugs","cashcase01")
				return true
			end
		end
	end
	return false
end


local bandprice = 5000
local rollcashprice = 500

local inkedmoneybagprice = 50000
local markedbillsprice = 350

function DoDropOff(requestMoney)
	local success = true

	searchPockets()
	Citizen.Wait(1500)

	PlayAmbientSpeech1(deliveryPed, "Chat_State", "Speech_Params_Force")

	if DoesEntityExist(deliveryPed) and not IsEntityDead(deliveryPed) then

		if HasStolenGoods() then

			if math.random(10) == 1 then
				if OxyRun then
				TriggerEvent( "player:receiveItem", "Gruppe6Card", 1 )
				TriggerEvent( "player:receiveItem", "advlockpick", math.random(4) )
				TriggerEvent('esx_status:add','stress',(25000))
				TriggerEvent( "player:receiveItem", "rollcash", math.random(4) )
				exports['mythic_notify']:SendAlert('error', 'Stress Gained!')
				end
			end
			
			if math.random(49) == 49 then
				TriggerEvent( "player:receiveItem", "rollcash", math.random(4) )
			end

			if OxyRun then

				TriggerEvent( "player:receiveItem", "rollcash", math.random(4) )
				
		     if exports["dsrp-inventory"]:hasEnoughOfItem("band",10,false) then     
					TriggerEvent("inventory:removeItem","band", 10)  
					TriggerServerEvent("band:sold") 
					cashPayment = cashPayment + bandprice          
		            TriggerEvent("notification","Thanks for the extra sauce!")
		        elseif exports["dsrp-inventory"]:hasEnoughOfItem("markedbills",1,false) then     
					TriggerEvent("inventory:removeItem","markedbills", 1) 
					TriggerServerEvent("markedbills:sold")
		            cashPayment = cashPayment + markedbillsprice            
		            TriggerEvent("notification","Thanks for the extra sauce!")
		        else
					TriggerEvent("notification","Thanks, no extra sauce though?!")
		        end

				if math.random(100) > 45 then
					TriggerEvent( "player:receiveItem", "rollcash", math.random(4) )
					TriggerEvent( "player:receiveItem", "oxy", math.random(5) )
					exports['mythic_notify']:SendAlert('error', 'Stress Gained!')
				end
			else
				cashPayment = math.random(200,580)
			end
			
		else

			if not OxyRun then
				TriggerEvent("loseGangReputationSpecific","robbery")
				TriggerEvent("notification","The drop off failed - you need stolen items.",2)
			else
				TriggerEvent("notification","The drop off failed - you need Oxy.",2)
			end
			
			success = false
			return

		end

	end

	local counter = math.random(50,200)
	while counter > 0 do
		local crds = GetEntityCoords(deliveryPed)
		counter = counter - 1
		Citizen.Wait(1)
	end

	if success then
		searchPockets()
		local counter = math.random(100,300)
		while counter > 0 do
			local crds = GetEntityCoords(deliveryPed)
			counter = counter - 1
			Citizen.Wait(1)
		end
		giveAnim()
	end

	local crds = GetEntityCoords(deliveryPed)
	local crds2 = GetEntityCoords(PlayerPedId())

	if #(crds - crds2) > 5.0 or not DoesEntityExist(deliveryPed) or IsEntityDead(deliveryPed) then
		success = false
	end


	if success then

		PlayAmbientSpeech1(deliveryPed, "Generic_Thanks", "Speech_Params_Force_Shouted_Critical")
		if math.random(7) == 5 then
			TriggerEvent("player:receiveItem","pix1",2)
			
			exports['mythic_notify']:SendAlert('error', 'Stress Gained!')
		end

		if math.random(55) == 5 then
			TriggerEvent("player:receiveItem","pix2",1)
			exports['mythic_notify']:SendAlert('error', 'Stress Gained!')
		end

	
		TriggerServerEvent("police:multipledenominators",true)
		TriggerEvent("denoms",true)
		TriggerEvent('esx_status:add','stress',(35000))
		TriggerEvent( "player:receiveItem", "rollcash", math.random(4) )
		exports['mythic_notify']:SendAlert('error', 'Stress Gained!')

	else
		TriggerEvent("notification","The drop off failed.",2)
	end
	
	DeleteBlip()
	if success then
		Citizen.Wait(2000)
		TriggerEvent("notification", "I got the call in, delivery was on point, go await the next one! ",1)
	else
		TriggerEvent("notification","The drop off failed - you need stolen items.",2)
	end

	DeleteCreatedPed()
end

local fighting = 0
function startAiFight()

    if fighting > 0 then
        return
    end    
    DeleteBlip()
    local killerPed = deliveryPed  
    fighting = 10000

    TaskCombatPed(deliveryPed, PlayerPedId(), 0, 16) 
    Citizen.Wait(700) 

    while fighting > 0 do
        Citizen.Wait(1)
        fighting = fighting - 1
        if IsEntityDead(killerPed) then          
            SearchPockets(killerPed)
            fighting = 0
        end
        if not DoesEntityExist(killerPed) or IsEntityDead(PlayerPedId()) or fighting < 10 then
            ClearPedTasks(killerPed)
            Citizen.Wait(10000)
            fighting = 0
        end
    end

    fighting = 0
end

function DropItemPed(ai)
    local ai = ai
    local chance = math.random(50)
    if chance > 41 then
        DropDrugs(ai,true)
    elseif chance > 35 then
        DropDrugs(ai,false)
    end
    TriggerServerEvent('drugrun:completed', cashPayment)
end

function DropDrugs(ai,highvalue)
    local highvalue = highvalue
    local pos = GetEntityCoords(PlayerPedId())
    if highvalue then
		TriggerEvent("inv:CreatedropItem",90,math.random(4))
	else
		TriggerEvent("inv:CreatedropItem",85,1)
	end
end
function SearchPockets(ai)
    local timer = 3000
    local ai = ai
    local searching = false
    
    while timer > 0 do
        timer = timer - 1
        local pos = GetEntityCoords(ai)
        Citizen.Wait(1)

        if not searching then
            DrawText3Ds(pos["x"], pos["y"],pos["z"], "Press E to search person.")
            if IsControlJustReleased(1,38) and #(pos - GetEntityCoords(PlayerPedId())) < 3.0 then
                searching = true
                TriggerEvent("animation:PlayAnimation","search")
                local finished = exports["sway_taskbar"]:taskBar(15000,"Searching Thug")

                if tonumber(finished) == 100 then
                    DropItemPed(ai)
                end
                ClearPedTasks(PlayerPedId())
                timer = 0
            end
        end
    end
    searching = false
end

function DrawText3Ds(x,y,z, text)
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


RegisterNetEvent("drugdelivery:client")
AddEventHandler("drugdelivery:client", function()

	if tasking then
		return
	end

	rnd = math.random(1,#dropoffpoints)

	CreateBlip()

	local pedCreated = false

	tasking = true
	local timer = 120000
	while tasking and timer > 0 do
		timer = timer - 1
		Citizen.Wait(1)
		local plycoords = GetEntityCoords(PlayerPedId())
		local dstcheck = #(plycoords - vector3(dropoffpoints[rnd]["x"],dropoffpoints[rnd]["y"],dropoffpoints[rnd]["z"])) 
		if dstcheck < 40.0 and not pedCreated then
			pedCreated = true
			DeleteCreatedPed()
			CreateDrugPed()
			exports['mythic_notify']:SendAlert('inform', 'You are close to the drop off.')
		end

		if dstcheck < 2.0 and pedCreated then

			local crds = GetEntityCoords(deliveryPed)
			DrawText3Ds(crds["x"],crds["y"],crds["z"], "[E]")  

			if IsControlJustReleased(0,38) then
				TaskTurnPedToFaceEntity(deliveryPed, PlayerPedId(), 1.0)
				Citizen.Wait(1500)
				PlayAmbientSpeech1(deliveryPed, "Generic_Hi", "Speech_Params_Force")
				DoDropOff()
				tasking = false
			end

		end

	end
	
	tasking = false
	DeleteCreatedPed()
	DeleteBlip()

end)

local drugdealer = false
local salecount = 0


local areaLocs = {
	[1] =  { ['x'] = 228.36,['y'] = -1762.18,['z'] = 28.7,['h'] = 37.01, ['info'] = 1 },
	[2] =  { ['x'] = 449.71,['y'] = -1760.62,['z'] = 28.99,['h'] = 337.34, ['info'] = 2 },
	[3] =  { ['x'] = -719.0,['y'] = -897.81,['z'] = 20.43,['h'] = 270.27, ['info'] = 3 },
}



local HasProduct = {
	["mexican"] = true,
	["ballas"] = true,
	["weicheng"] = true,
}



function IsDroppable()
	playerped = PlayerPedId()
	coordA = GetEntityCoords(playerped, 1)
	coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
	veh = getVehicleInDirection(coordA, coordB)
	return veh
end

function getVehicleInDirection(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle
	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		offset = offset - 1
		if vehicle ~= 0 then break end
	end
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	if distance > 25 then vehicle = nil end
    return vehicle ~= nil and vehicle or 0
end

function CleanUpArea()
    local playerped = PlayerPedId()
    local plycoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstObject()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(plycoords - pos)
        if distance < 10.0 and ObjectFound ~= playerped then
        	if IsEntityAPed(ObjectFound) then
        		if IsPedAPlayer(ObjectFound) then
        		else
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

    SetEntityAsNoLongerNeeded(drugStorePed)
    DeleteEntity(drugStorePed)

    EndFindObject(handle)
end



local drugLocs = {
	[1] =  { ['x'] = 182.56,['y'] = -1319.25,['z'] = 29.32,['h'] = 236.06, ['info'] = ' Central', ["gang"] = "ballas", ["ent"] = 0 },
}

local firstdeal = false
Citizen.CreateThread(function()


    while true do

        if drugdealer then

	        Citizen.Wait(1000)

	        if firstdeal then
	        	Citizen.Wait(10000)
	        end

	        TriggerEvent("drugdelivery:client")  

		    salecount = salecount + 1
		    if salecount == 7 then
		    	Citizen.Wait(1200000)
		    	drugdealer = false
		    end

		    Citizen.Wait(150000)
		    firstdeal = false


	    else

	    	local close = false

	    	for i = 1, #drugLocs do

				local plycoords = GetEntityCoords(PlayerPedId())

				local dstcheck = #(plycoords - vector3(drugLocs[i]["x"],drugLocs[i]["y"],drugLocs[i]["z"])) 
				

				if dstcheck < 5.0 then

					close = true

					local job = exports["isPed"]:isPed("job")

					if job ~= "police" then

						local price = 100
						

			    		DrawText3Ds(drugLocs[i]["x"],drugLocs[i]["y"],drugLocs[i]["z"], "[E] $" .. price .. " offer to sell stolen goods (P).") 
						for i = 84, 97 do
							if IsControlJustReleased(0,38) then

					    				TriggerServerEvent("drugdelivery:server", price)
										Citizen.Wait(1500)

								end
							end

			    	else

			    		Citizen.Wait(60000)

			    	end

			    	Citizen.Wait(1)

			    end

			end

			if not close then
				Citizen.Wait(2000)
			end

	    end

    end

end)





RegisterNetEvent("drugdelivery:nope")
AddEventHandler("drugdelivery:nope", function()
	local NearNPC = exports["isPed"]:GetClosestNPC()
	exports['mythic_notify']:SendAlert('inform', 'We aint needing no help right now - come back later.')
	PlayAmbientSpeech1(NearNPC, "Chat_Resp", "SPEECH_PARAMS_FORCE", 1)
end)


RegisterNetEvent("drugdelivery:startDealing")
AddEventHandler("drugdelivery:startDealing", function()
	local NearNPC = exports["isPed"]:GetClosestNPC()
	PlayAmbientSpeech1(NearNPC, "Chat_Resp", "SPEECH_PARAMS_FORCE", 1)
	--exports['mythic_notify']:SendAlert('inform', 'Your pager will be updated with the location soon.')
	salecount = 0
	drugdealer = true
	firstdeal = true
end)


function GetVecDist(v1,v2)
  if not v1 or not v2 or not v1.x or not v2.x then return 0; end
  return math.sqrt(  ( (v1.x or 0) - (v2.x or 0) )*(  (v1.x or 0) - (v2.x or 0) )+( (v1.y or 0) - (v2.y or 0) )*( (v1.y or 0) - (v2.y or 0) )+( (v1.z or 0) - (v2.z or 0) )*( (v1.z or 0) - (v2.z or 0) )  )
end

