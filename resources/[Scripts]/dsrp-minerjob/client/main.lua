local PlayerData                = {}
ESX                             = nil

local blip1 = {}
local blips = false
local blipActive = false
local mineActive = false
local washingActive = false
local remeltingActive = false
local firstspawn = false
local impacts = 0
local timer = 0


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
    while ESX == nil or ESX.PlayerData == nil or ESX.PlayerData.job == nil do
        Citizen.Wait(1)
    end
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent("esx-minerjob:washing")
AddEventHandler("esx-minerjob:washing", function()
    Washing()
end)

RegisterNetEvent("esx-minerjob:remelting")
AddEventHandler("esx-minerjob:remelting", function()
    Remelting()
end)




Citizen.CreateThread(function()
    blip1 = AddBlipForCoord(-597.01, 2091.42, 131.41)
    blip2 = AddBlipForCoord(Config.WashingX, Config.WashingY, Config.WashingZ)
    blip3 = AddBlipForCoord(Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ)
    blip4 = AddBlipForCoord(Config.SellX, Config.SellY, Config.SellZ)
    SetBlipSprite(blip1, 17)
    SetBlipColour(blip1, 4)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mine Start")
    EndTextCommandSetBlipName(blip1)   
    SetBlipSprite(blip2, 18)
    SetBlipColour(blip2, 4)
    SetBlipAsShortRange(blip2, true)
    SetBlipScale(blip1, 0.6)
    SetBlipScale(blip2, 0.6)
    SetBlipScale(blip3, 0.6)
    SetBlipScale(blip4, 0.6)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mine Wash")
    EndTextCommandSetBlipName(blip2)   
    SetBlipSprite(blip3, 19)
    SetBlipColour(blip3, 4)
    SetBlipAsShortRange(blip3, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mine Remelting")
    EndTextCommandSetBlipName(blip3)
    SetBlipSprite(blip4, 20)
    SetBlipColour(blip4, 4)
    SetBlipAsShortRange(blip4, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mine Sell")
    EndTextCommandSetBlipName(blip4)    
    blipActive = true
end)



local breakrocksmine = PolyZone:Create({
    vector2(2997.2348632813, 2777.8859863281),
    vector2(3008.3747558594, 2776.3703613281),
    vector2(2997.3225097656, 2746.4733886719),
    vector2(2991.3862304688, 2754.8369140625)
  }, {
    name="minerarea",
    minZ = 40.141780853271,
    maxZ = 45.144645690918,
    debugGrid = false
  })
  
  local nearbreakrocks = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        nearbreakrocks = breakrocksmine:isPointInside(coord)
        if nearbreakrocks and ESX.PlayerData.job.name == 'miner' then
            DrawText3Ds(3004.58, 2773.00, 43.03, '~g~E~w~ - to mine')
            DrawText3Ds(2999.02, 2759.00, 42.98, '~g~E~w~ - to mine')
            DrawText3Ds(2996.87, 2750.25, 44.40, '~g~E~w~ - to mine')
                    if IsControlJustReleased(1, 51) then
                        Animation()
                        mineActive = true
                    end
        else 
            Citizen.Wait(1700)
            end
        end
    end)  
  


local washmine = PolyZone:Create({
    vector2(1953.9586181641, 547.71368408203),
    vector2(1968.5452880859, 545.41491699219),
    vector2(1970.5190429688, 555.66668701172),
    vector2(1957.7930908203, 557.37878417969)
  }, {
    name="Mine Wash",
    minZ = 160.68266296387,
    maxZ = 164.15942382813,
    dub
  })

  local nearwash = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        nearwash = washmine:isPointInside(coord)
        if nearwash and ESX.PlayerData.job.name == 'miner' then
            DrawText3Ds(Config.WashingX, Config.WashingY, Config.WashingZ, '~g~E~w~ - wash stones')
                local itemquantitty = exports['dsrp-inventory']:getQuantity('stone')
                if IsControlJustReleased(0, 38) and itemquantitty > 9 then
                    TriggerServerEvent("esx-minerjob:washing")
                    exports["sway_taskbar"]:taskBar(15000, 'Washing Stone')
                    TriggerEvent('inventory:removeItem', 'stone', 10)
                    Citizen.Wait(1000)
                    TriggerEvent('player:receiveItem', 'washedstone', 5)
                elseif IsControlJustReleased(0, 38) and itemquantitty < 9 then
                    TriggerEvent('notification', 'Not enough stone', 1)
            end
        else 
            Citizen.Wait(1700)
            end
        end
    end)  



    local SmeltArea = PolyZone:Create({
            vector2(1088.4437255859, -1999.1335449219),
            vector2(1085.8848876953, -1996.1147460938),
            vector2(1079.7946777344, -2003.9085693359),
            vector2(1083.0799560547, -2007.2567138672)
          }, {
            name="Smelting Area",
            minZ = 29.874446868896,
            maxZ = 32.00901222229,
            debugGrid = false
          })
          
      
    local nearsmeltarea = false
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(4)
            local plyPed = PlayerPedId()
            local coord = GetEntityCoords(plyPed)
            nearsmeltarea = SmeltArea:isPointInside(coord)
            if nearsmeltarea and ESX.PlayerData.job.name == 'miner' then
                DrawText3Ds(1084.66, -2002.37, 31.40, '~g~E~w~ - to smelt stone')
                local itemquant = exports['dsrp-inventory']:getQuantity('washedstone')

                if IsControlJustReleased(1, 51) and itemquant > 9 then
                    TriggerServerEvent("esx-minerjob:remelting")
                    TriggerEvent('inventory:removeItem', 'washedstone', 10)
                    exports["sway_taskbar"]:taskBar(15000, 'Resmelting Stone')
                    TriggerEvent('player:receiveItem', 'iron', math.random(1,3))
                    TriggerEvent('player:receiveItem', 'goldbar', 2)
                elseif IsControlJustReleased(1, 51) and itemquant < 9 then
                    TriggerEvent('notification', 'Not enough Washed Stone!', 1)
                end
            else
                Wait(1000)
            end
        end
    end)
  

    local sellarea = PolyZone:Create({
        vector2(-173.27104187012, -1025.1276855469),
        vector2(-175.34953308105, -1031.0393066406),
        vector2(-167.47038269043, -1035.3245849609),
        vector2(-162.99293518066, -1028.5767822266)
      }, {
        name="SellStones",
        minZ = 26.273553848267,
        maxZ = 29.315759658813,
        debugGrid = false
      })

      local nearsellarea = false
      Citizen.CreateThread(function()
          while true do
              Citizen.Wait(4)
              local plyPed = PlayerPedId()
              local coord = GetEntityCoords(plyPed)
              nearsellarea = sellarea:isPointInside(coord)
              if nearsellarea then
                  DrawText3Ds(-169.42, -1027.36, 27.27, '~g~E~w~ - to sell materials')
                  if IsControlJustReleased(1, 51) then
                    local itemquant = exports['dsrp-inventory']:getQuantity('goldbar')
                    local itemhasenough = exports['dsrp-inventory']:hasEnoughOfItem('goldbar', 1)
                    local itemhasenough2 = exports['dsrp-inventory']:hasEnoughOfItem('iron', 1)
                    local itemquant2 = exports['dsrp-inventory']:getQuantity('iron')
                    if itemquant >= 1 and itemhasenough then
                        print(itemquant) 
                        print(itemhasenough) 
                        TriggerServerEvent('removedgoods', itemquant, itemhasenough)
                        TriggerEvent("inventory:removeItem","goldbar", itemquant)
                    end
                    if itemquant2 >= 1 and itemhasenough then
                        TriggerServerEvent('removedgoods2', itemquant2)
                        TriggerEvent("inventory:removeItem","iron", itemquant2, itemhasenough2)
                    end
                end
              else
                  Wait(1000)
              end
          end
      end)


function Animation()
    Citizen.CreateThread(function()
        while impacts < 5 do
            Citizen.Wait(1)
		local ped = PlayerPedId()	
                RequestAnimDict("melee@large_wpn@streamed_core")
                Citizen.Wait(100)
                TaskPlayAnim((ped), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 8.0, 8.0, -1, 80, 0, 0, 0, 0)
                SetEntityHeading(ped, 270.0)
                TriggerServerEvent('InteractSound_SV:PlayOnSource', 'pickaxe', 0.5)
                if impacts == 0 then
                    pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true) 
                    AttachEntityToEntity(pickaxe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.18, -0.02, -0.02, 350.0, 100.00, 140.0, true, true, false, true, 1, true)
                end  
                Citizen.Wait(2500)
                ClearPedTasks(ped)
                impacts = impacts+1
                if impacts == 5 then
                    DetachEntity(pickaxe, 1, true)
                    DeleteEntity(pickaxe)
                    DeleteObject(pickaxe)
                    mineActive = false
                    impacts = 0
                    TriggerEvent('player:receiveItem', 'stone', 5)
                    TriggerEvent('notification', 'You received 5 stone.', 1)
                    break
                end        
        end
    end)
end

function Washing()
    local ped = PlayerPedId()
    RequestAnimDict("amb@prop_human_bum_bin@idle_a")
    washingActive = true
    Citizen.Wait(100)
    FreezeEntityPosition(ped, true)
    TaskPlayAnim((ped), 'amb@prop_human_bum_bin@idle_a', 'idle_a', 8.0, 8.0, -1, 81, 0, 0, 0, 0)
    -- TriggerEvent("esx-minerjob:timer")
    Citizen.Wait(15900)
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
    washingActive = false
end

function Remelting()
    local ped = PlayerPedId()
    RequestAnimDict("amb@prop_human_bum_bin@idle_a")
    remeltingActive = true
    Citizen.Wait(100)
    FreezeEntityPosition(ped, true)
    TaskPlayAnim((ped), 'amb@prop_human_bum_bin@idle_a', 'idle_a', 8.0, 8.0, -1, 81, 0, 0, 0, 0)
    Citizen.Wait(15900)
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
    remeltingActive = false
end

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
