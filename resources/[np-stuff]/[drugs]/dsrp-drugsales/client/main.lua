ESX = nil
local selling = false
local secondsRemaining
local sold = false
local playerHasDrugs = false
local pedIsTryingToSellDrugs = false
local PlayerData		= {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

local enoughCops
RegisterNetEvent("returncopsamount")
AddEventHandler("returncopsamount", function(cops)
	--// Cocaines
	local gcocaineqty = exports['dsrp-inventory']:getQuantity('1gcocaine')
	local gcrackqty = exports['dsrp-inventory']:getQuantity('1gcrack')

	local weedqty = exports['dsrp-inventory']:getQuantity('weedq')
	--// lsd
	local lsdtabqty = exports['dsrp-inventory']:getQuantity('lsdtab')
	local badlsdtabqty = exports['dsrp-inventory']:getQuantity('badlsdtab')

		if gcocaineqty > 0 then
				TriggerEvent('playerhasdrugs')
				return
		end

		if gcrackqty > 0 then
				TriggerEvent('playerhasdrugs')
				return
		end

		if weedqty > 0 then
			TriggerEvent('playerhasdrugs')
			return
		end

		if lsdtabqty > 0 then
			TriggerEvent('playerhasdrugs')
			return
		end

		if badlsdtabqty > 0 then
			TriggerEvent('playerhasdrugs')
			return
		end

		
		if oxyqty > 0 then
			TriggerEvent('playerhasdrugs')
			return
		end

		TriggerEvent('nomoredrugs')

end)

function sellDrugs()
	--// Cocaines
	local gcocaineqty = exports['dsrp-inventory']:getQuantity('1gcocaine')
	local gcrackqty = exports['dsrp-inventory']:getQuantity('1gcrack')
	--// Oxycodeien
	local oxyqty = exports['dsrp-inventory']:getQuantity('oxy')
	--// Weedies
	local weedqty = exports['dsrp-inventory']:getQuantity('weedq')
	--// lsd
	local lsdtabqty = exports['dsrp-inventory']:getQuantity('lsdtab')
	local badlsdtabqty = exports['dsrp-inventory']:getQuantity('badlsdtab')

	local x = 0
	local blackMoney = 0
	local drugType = nil
	
	if true then
		--//Cocaine
		if gcocaineqty > 0 then
			if gcocaineqty > 0 then
			drugType = '1gcocaine'
			end
			if gcocaineqty == 1 then
				x = 1
			elseif gcocaineqty == 2 then
				x = math.random(1,2)
			elseif gcocaineqty == 3 then
				x = math.random(1,3)
			elseif gcocaineqty == 4 then
				x = math.random(1,4)
			elseif gcocaineqty >= 5 then
				x = math.random(1,5)
			end
		elseif gcrackqty > 0 then
			if gcrackqty > 0 then
				drugType = '1gcrack'
			end
			if gcrackqty == 1 then
				x = 1
			elseif gcrackqty == 2 then
				x = math.random(1,2)
			elseif gcrackqty == 3 then
				x = math.random(1,3)
			elseif gcrackqty == 4 then
				x = math.random(1,4)
			elseif gcrackqty >= 5 then
				x = math.random(1,5)
			end

		elseif oxyqty > 0 then
			if oxyqty > 0 then
				drugType = 'oxy'
			end
			if oxyqty == 1 then
				x = 1
			elseif oxyqty == 2 then
				x = math.random(1,2)
			elseif oxyqty == 3 then
				x = math.random(1,3)
			elseif oxyqty == 4 then
				x = math.random(1,4)
			elseif oxyqty >= 5 then
				x = math.random(1,5)
			end
		
		

			--//Weed
		
		elseif weedqty > 0 then
			if weedqty > 0 then
				drugType = 'weedq'
			end
			if weedqty == 1 then
				x = 1
			elseif weedqty == 2 then
				x = math.random(1,2)
			elseif weedqty == 3 then
				x = math.random(1,3)
			elseif weedqty == 4 then
				x = math.random(1,4)
			elseif weedqty >= 5 then
				x = math.random(1,5)
			end
			--//LSD
		elseif lsdtabqty > 0 then
			if lsdtabqty > 0 then
				drugType = 'lsdtab'
			end
			if lsdtabqty == 1 then
				x = 1
			elseif lsdtabqty == 2 then
				x = math.random(1,2)
			elseif lsdtabqty == 3 then
				x = math.random(1,3)
			elseif lsdtabqty == 4 then
				x = math.random(1,4)
			elseif lsdtabqty >= 5 then
				x = math.random(1,5)
			end
		elseif badlsdtabqty > 0 then
			if badlsdtabqty > 0 then
				drugType = 'badlsdtab'
			end
			if badlsdtabqty == 1 then
				x = 1
			elseif badlsdtabqty == 2 then
				x = math.random(1,2)
			elseif badlsdtabqty == 3 then
				x = math.random(1,3)
			elseif badlsdtabqty == 4 then
				x = math.random(1,4)
			elseif badlsdtabqty >= 5 then
				x = math.random(1,5)
			end
	else
		TriggerEvent('nomoredrugs')
		return
	end
	--// Price per drug
	if drugType=='1gcocaine' then
		blackMoney = 105 * x
	elseif drugType=='1gcrack' then
		blackMoney = 50 * x
	elseif drugType=='weedq' then
		blackMoney = 85 * x
	elseif drugType=='lsdtab' then
		blackMoney = 90 * x
	elseif drugType=='badlsdtab' then
		blackMoney = 125 * x
	elseif drugType=='oxy' then
		blackMoney = 120 * x
	end

	if drugType ~= nil then
		TriggerEvent('inventory:removeItem', drugType, x)
		--xPlayer.removeInventoryItem(drugType, x)
		TriggerServerEvent('sellDrugs', blackMoney)
		TriggerEvent('esx_status:add','stress',(45000))
		exports['mythic_notify']:SendAlert('error', 'Stress Gained!')
	end
end
end

--TIME TO SELL
Citizen.CreateThread(function()
	while true do
		if selling then
			if secondsRemaining > 0 then
				secondsRemaining = secondsRemaining - 1
				ESX.ShowNotification(_U('remained') .. secondsRemaining .. 's')
			end
			Citizen.Wait(1000)
		end
		Citizen.Wait(100)
	end
end)

RegisterKeyMapping('drug:sell', '[Drug] Sell To NPC', 'keyboard', 'H')

RegisterCommand('drug:sell', function()
	SellDopeCMD()
end, false)


currentped = nil

function SellDopeCMD()
	local player = GetPlayerPed(-1)
	local pid = PlayerPedId()
	  local playerloc = GetEntityCoords(player, 0)
	local handle, ped = FindFirstPed()
	local success
	repeat
		success, ped = FindNextPed(handle)
		   local pos = GetEntityCoords(ped)
		 local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
		if IsPedInAnyVehicle(GetPlayerPed(-1)) == false then
			if DoesEntityExist(ped)then
				if IsPedDeadOrDying(ped) == false then
					if IsPedInAnyVehicle(ped) == false then
						local pedType = GetPedType(ped)
						if pedType ~= 28 and IsPedAPlayer(ped) == false then
							currentped = pos
							if distance <= 3 and ped  ~= GetPlayerPed(-1) and ped ~= oldped  then
								TriggerServerEvent('check')
									if playerHasDrugs and sold == false and selling == false then 
										--PED REJECT OFFER
										local random = math.random(1, Config.PedRejectPercent)
										if random == Config.PedRejectPercent then
											TriggerEvent('notification', 'Na cuh im good on that.', 1)
											oldped = ped
											end
											TriggerEvent("sold")
										--PED ACCEPT OFFER
										else
											SetEntityAsMissionEntity(ped)
											ClearPedTasks(ped)
											FreezeEntityPosition(ped,true)
											oldped = ped
											TaskStandStill(ped, 9)
											pos1 = GetEntityCoords(ped)
											TriggerEvent("sellingdrugs")
										end
									end
								end
							end
						end
					end
				end

					
	until not success

	EndFindPed(handle)
end


function hasdope()
		--// Cocaines
		local gcocaineqty = exports['dsrp-inventory']:getQuantity('1gcocaine')
		local gcrackqty = exports['dsrp-inventory']:getQuantity('1gcrack')
		--// Oxycodeien
		local oxyqty = exports['dsrp-inventory']:getQuantity('oxy')
		--// Weedies
		local weedqty = exports['dsrp-inventory']:getQuantity('weedq')
		--// lsd
		local lsdtabqty = exports['dsrp-inventory']:getQuantity('lsdtab')
		local badlsdtabqty = exports['dsrp-inventory']:getQuantity('badlsdtab')

		if gcocaineqty or gcrackqty or oxyqty or weedqty or lsdtabqty or badlsdtabqty then
			return true
		else
			return false
		end
end

local showing = false

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if hasdope() == true then
            local foundped = false
            local player = GetPlayerPed(-1)
            local pid = PlayerPedId()
            local playerloc = GetEntityCoords(player, 0)
            local handle, ped = FindFirstPed()
            local success
            repeat
                success, ped = FindNextPed(handle)
                local pos = GetEntityCoords(ped)
                local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
                if IsPedInAnyVehicle(GetPlayerPed(-1)) == false then
                    if DoesEntityExist(ped)then
                        if IsPedDeadOrDying(ped) == false then
                            if IsPedInAnyVehicle(ped) == false then
                                local pedType = GetPedType(ped)
                                if pedType ~= 28 and IsPedAPlayer(ped) == false then
                                    currentped = pos
                                    if (distance <= 3) and (ped  ~= GetPlayerPed(-1)) and (ped ~= oldped) then 
                                        if (showing == false) then
                                            TriggerEvent('cd_drawtextui:ShowUI', 'show', '[H] - Sell Drugs')
                                            showing = true
                                        end
                                        foundped = true
                                    end
                                end
                            end
                        end
                    end
                end


            until not success

            EndFindPed(handle)

            if (foundped == false) and (showing == true) then 
                TriggerEvent('cd_drawtextui:HideUI')
				showing = false
            end
        else

            Wait(1000)
        end
    end
end)


Citizen.CreateThread(function()
	while true do
		Wait(100)
		if selling then
			local player = GetPlayerPed(-1)
  			local playerloc = GetEntityCoords(player, 0)
			local distance = GetDistanceBetweenCoords(pos1.x, pos1.y, pos1.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
			local pid = PlayerPedId()
			--TOO FAR
			if distance > 5 then
				ESX.ShowNotification(_U('too_far_away'))
				selling = false
				SetEntityAsMissionEntity(oldped)
				SetPedAsNoLongerNeeded(oldped)
				FreezeEntityPosition(oldped,false)
			end
			--SUCCESS
			if secondsRemaining <= 1 then
				selling = false
				SetEntityAsMissionEntity(oldped)
				SetPedAsNoLongerNeeded(oldped)
				FreezeEntityPosition(oldped,false)
				StopAnimTask(pid, "mp_safehouselost@","package_dropoff", 1.0)
				playerHasDrugs = false
				sold = false
				sellDrugs()
				--TriggerServerEvent('sellDrugs')
			end	
			
			if secondsRemaining == 5  then
				Citizen.Wait(1100) 
				RequestAnimDict("mp_safehouselost@")
				while (not HasAnimDictLoaded("mp_safehouselost@")) do 
					Citizen.Wait(0) 
				end
				TaskPlayAnim(pid,"mp_safehouselost@","package_dropoff",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			end
		end	
	end
end)	

		
RegisterNetEvent('sellingdrugs')
AddEventHandler('sellingdrugs', function()
	secondsRemaining = Config.TimeToSell + 1
	selling = true
end)

RegisterNetEvent('sold')
AddEventHandler('sold', function()
	sold = false
	selling = false
	secondsRemaining = 0
	--TriggerEvent("server-inventory-open", "1", "Close just updating inventory")
end)

--Info that you dont have drugs
RegisterNetEvent('nomoredrugs')
AddEventHandler('nomoredrugs', function()
	ESX.ShowNotification('You have no more drugs')
	playerHasDrugs = false
	sold = false
	selling = false
	secondsRemaining = 0
end)

--Show help notification ("PRESS E...")
RegisterNetEvent('playerhasdrugs')
AddEventHandler('playerhasdrugs', function()
	ESX.ShowHelpNotification('Press H to offer drugs')
	playerHasDrugs = true
end)



RegisterNetEvent('drugsEnable')
AddEventHandler('drugsEnable', function()
	pedIsTryingToSellDrugs = true
end)
--DISPATCH END
