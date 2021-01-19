-- current selling value depending on amount of people selling.

local value = 0.4



-- amount of weed4g's needed to start.

local weedcost = 10



-- are we already running a looperino?

local ActiveRun = false



-- Current step of procedure, 0 nothing, 1 moving to location

local CurrentStep = 0



-- 1 in X chance of getting rep, higher = less obviously.

local repChance = 5





-- counter +0.1 chance per drop off, 1 in X

local CounterIncreaseChance = 22





-- chance for call in on sale

local PoliceCallChance = 5



-- run length

local DropOffCount = 0



-- our current drop point

local DropOffLocation =  { ['x'] = -10.81,['y'] = -1828.68,['z'] = 25.4,['h'] = 301.59, ['info'] = ' Grove shop' }



-- loop waiting period, changes to 1 for draw text options.

local waittime = 1000





local WeedVehicle = 0



-- drop marker

local CurrentMarker = 0



-- How many active deliveries we have, if this is 2 we dont require cooking

local DeliveryCounter = 0



-- What item is required to be cooked

local CurrentCookItem = 1



-- milliseconds to swap from cook to delivery

local GracePeriod = 60



local DropOffMax = 12



local lastDelivery = GetGameTimer() - GracePeriod



local lastCook = GetGameTimer() - GracePeriod



local SaleReputation = 0



local bandprice = 4000

local rollcashprice = 300



local inkedmoneybagprice = 50000

local markedbillsprice = 350



local rollcount = 10

local bandcount = 10





local FoodTable = {

    [1] = { ["id"] = "coffee", ["name"] = "Coffee" },

    [2] = { ["id"] = "icecream", ["name"] = "Icecream" },

    [3] = { ["id"] = "donut", ["name"] = "Donut" },

    [4] = { ["id"] = "sandwich", ["name"] = "Sandwich" },

    [5] = { ["id"] = "water", ["name"] = "Water" },

    [6] = { ["id"] = "taco", ["name"] = "Taco" },

    [7] = { ["id"] = "fishtaco", ["name"] = "Fish Taco" },

    [8] = { ["id"] = "churro", ["name"] = "Churro" },

    [9] = { ["id"] = "hamburger", ["name"] = "Hamburger" },

    [10] = { ["id"] = "eggsbacon", ["name"] = "Bacon and Eggs" },

    [11] = { ["id"] = "hotdog", ["name"] = "Hotdog" },

    [12] = { ["id"] = "mshake", ["name"] = "Milk Shake" },

    [13] = { ["id"] = "burrito", ["name"] = "Burrito" },

    [14] = { ["id"] = "greencow", ["name"] = "Green Cow" },

}



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




Citizen.CreateThread(function()

    while true do

        Citizen.Wait(1)

        local plyCoords = GetEntityCoords(PlayerPedId())

        local dist = Vdist(19.68, -1602.41, 29.38, plyCoords)

        if dist > 120.0 then

            Wait(1000)

        else

            local dist2 = Vdist(11.32, -1605.93, 29.4, plyCoords) 

            local dist3 = Vdist(7.61, -1599.54, 29.3,plyCoords)

            local dist4 = Vdist(15.47, -1598.78, 29.38,plyCoords)

            local dist5 = Vdist(9.24,-1604.11, 29.38,plyCoords)





            if dist < 1.5 and not ActiveRun then

                DrawText3Ds(19.68, -1602.41, 29.38, "Press E to deliver Green Tacos @ " .. value .. "%")

                if IsControlJustReleased(1,38) then

                    local lPed = PlayerPedId()

                    RequestAnimDict("mini@repair")

                    Wait(1000)

                    if not IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then

                        ClearPedSecondaryTask(lPed)

                        TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)

                    end


                    local finished = exports["sway_taskbar"]:taskBar(5000,"Packaging Tacos")               

                      CheckWeedRun()

                      ClearPedTasks(lPed)

                    

                end

            elseif dist2 < 1.5 and not ActiveRun then

                if DeliveryCounter > 0 then

                    DrawText3Ds(11.32, -1605.93, 29.4, "Press E to deliver food.")

                    if IsControlJustReleased(1,38) then



                        if lastCook+GracePeriod < GetGameTimer() then

                            lastDelivery = GetGameTimer()

                            TriggerServerEvent("TacoShop:reputations")

                            TriggerEvent("taco:successStart")

                            TriggerServerEvent("delivery:status",-1)

                            Wait(1000)

                        else

                            TriggerEvent("notification","You must wait to swap to deliveries! (" .. (lastCook+GracePeriod-GetGameTimer())/1000 .." seconds)")

                        end



                    end

                else

                    DrawText3Ds(11.32, -1605.93, 29.4, "No food required for delivery")

                end

            elseif dist3 < 1.5 then

                DrawText3Ds(7.61, -1599.54, 29.3, "Press E to cancel deliveries")

                if IsControlJustReleased(1,38) then

                    TriggerEvent("notification","Runs reset.")

                    EndRuns()

                    Wait(1000)

                end

            -- elseif dist4 < 1.5 and not ActiveRun then

            --     DrawText3Ds(15.800518989563,-1598.4792480469,29.377986907959, "[E] - Cook Food")

            --     if IsControlJustReleased(1,38) then

            --         if DeliveryCounter == 0 then

            --             local lPed = PlayerPedId()

            --             RequestAnimDict("mini@repair")

            --             Wait(1000)

            --             if not IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then

            --                 ClearPedSecondaryTask(lPed)

            --                 TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)

            --             end

            --             local finished = exports["sway_taskbarskill"]:taskBar(4000,math.random(6,10))

            --             if finished ~= 100 then

            --                 ClearPedTasks(PlayerPedId())

            --             end

            --             if finished == 100 then

            --                 local finished2 = exports["sway_taskbarskill"]:taskBar(2000,math.random(4,8))

            --                 if finished2 ~= 100 then

            --                     ClearPedTasks(PlayerPedId())

            --                 end

            --                 if finished2 == 100 then

            --                     TriggerServerEvent('player:receiveItem', FoodTable[CurrentCookItem]["id"], 1)

            --                     TriggerEvent('notification', 'Success!')

            --                     ClearPedTasks(PlayerPedId())

            --                 end

            --             end

            --         else

            --             TriggerEvent('notification', 'No food available to cook.', 2)

            --         end

            --     end

            elseif dist5 < 1.5 and not ActiveRun then

                if DeliveryCounter == 2 then

                    DrawText3Ds(9.24,-1604.11, 29.38, "We require food to be delivered")

                else

                    DrawText3Ds(9.24,-1604.11, 29.38, "[E] We require a " .. FoodTable[CurrentCookItem]["name"] .. " to be delivered.")

                    if IsControlJustReleased(1,38) then

                        if lastDelivery+GracePeriod < GetGameTimer() then

                            lastCook = GetGameTimer()

                            SetDelivery(FoodTable[CurrentCookItem]["id"])

                            Wait(1000)

                        else

                            TriggerEvent("notification","You must wait to start prepping food (" .. (lastDelivery+GracePeriod-GetGameTimer())/1000 .." seconds)")

                        end                        

                    end

                end  

            end

        end

    end

end)



function SetDelivery(foodReq)

    if DeliveryCounter ~= 2 then

        if exports["dsrp-inventory"]:hasEnoughOfItem(foodReq,1) then

            TriggerEvent("inventory:removeItem",foodReq, 1)

            TriggerServerEvent('tacomission:completAVACed', math.random(10,90))

            TriggerServerEvent("delivery:status",1)

        else

            TriggerEvent("notification","You dont have the required food for the delivery!", 2)

        end

    end

    Wait(1000)

end



function CheckWeedRun()
    if exports["dsrp-inventory"]:hasEnoughOfItem("weedq",weedcost,false) then
        TriggerServerEvent("weed:checkmoney")
        print('Coming Here')
       TriggerEvent("weed:successStart") 
    else
        TriggerEvent('notification', 'You dont have enough weed broke boi')
    end
end





RegisterNetEvent("TacoShop:reputation")

AddEventHandler("TacoShop:reputation", function(rep)

    SaleReputation = rep

end)





RegisterNetEvent("delivery:deliverables")

AddEventHandler("delivery:deliverables", function(newCounter,nextItem)

    DeliveryCounter = newCounter

    CurrentCookItem = nextItem

end)







RegisterNetEvent("taco:successStart")

AddEventHandler("taco:successStart", function()

    EndRuns()

    ActiveRun = true

    local toolong = 0



    TriggerEvent("player:receiveItem","weedtaco", 1)

    while ActiveRun do

        Wait(1)

        if CurrentStep == 0 then

            DropOffLocation = DropOffsClose[math.random(#DropOffsClose)]

            BlipCreation()

            CurrentStep = 1

        end

        local plyCoords = GetEntityCoords(PlayerPedId())

        local inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)

        local distance = Vdist(DropOffLocation["x"],DropOffLocation["y"],DropOffLocation["z"],plyCoords)

        if distance < 45.0 and not inVehicle then

            waittime = 1

            DrawText3Ds(DropOffLocation["x"],DropOffLocation["y"],DropOffLocation["z"],"Press E to drop off package.")

            if IsControlJustReleased(1,38) and ActiveRun and distance < 1.5 then

                AttemptDropOffTaco()

                EndRuns()

            end

        end

        toolong = toolong + 1

        if toolong > 180000 then

            TriggerEvent("notification","Taco Run timed out!")

            EndRuns()

        end

    end



end)


function AttemptDropOffTaco()

    if exports["dsrp-inventory"]:hasEnoughOfItem("weedtaco",1,false) then
        TriggerEvent("inventory:removeItem","weedtaco", 1)
        TriggerEvent("player:receiveItem","weedq", math.random(1,5))
        print("you have gay")
        TriggerEvent("attachItemDrugs","cashcase01")

        if math.random(CounterIncreaseChance) == CounterIncreaseChance then

            TriggerServerEvent("TacoShop:IncreaseCounter")

        end

        local payment = math.random(10,50)

        if exports["dsrp-inventory"]:hasEnoughOfItem("band",bandcount,false) then     
            TriggerEvent("inventory:removeItem","band", bandcount)   
            TriggerServerEvent('pay:bandmoney', bandcount)       

                TriggerEvent("notification","Thanks for the extra sauce!")

    
        else


            
        if exports["dsrp-inventory"]:hasEnoughOfItem("rollcash",rollcount,false) then     
            TriggerEvent("inventory:removeItem","rollcash", rollcount)   
            TriggerServerEvent('pay:rollcashmoney', rollcount)       

                TriggerEvent("notification","Thanks for the extra sauce!")



        else 

            TriggerEvent("notification","Thanks, no extra sauce though?!")

        end
        TriggerEvent('phone:addnotification', 'EMAIL',  "Dude! That shit fire you gotta get me some more when you can! ")
        TriggerServerEvent('tacomission:completAVACed', payment)

    end

end
end


RegisterNetEvent("weed:values")

AddEventHandler("weed:values", function(newValue)

    value = newValue

end)



function CreateWeedVehicle()



    if DoesEntityExist(WeedVehicle) then



        SetVehicleHasBeenOwnedByPlayer(WeedVehicle,false)

        SetEntityAsNoLongerNeeded(WeedVehicle)

        DeleteEntity(WeedVehicle)

    end



    local car = GetHashKey(carpick[math.random(#carpick)])

    RequestModel(car)

    while not HasModelLoaded(car) do

        Citizen.Wait(0)

    end



    local spawnpoint = 1

    for i = 1, #carspawns do

        local caisseo = GetClosestVehicle(carspawns[i]["x"], carspawns[i]["y"], carspawns[i]["z"], 3.500, 0, 70)

        if not DoesEntityExist(caisseo) then

            spawnpoint = i

        end

    end



    WeedVehicle = CreateVehicle(car, carspawns[spawnpoint]["x"], carspawns[spawnpoint]["y"], carspawns[spawnpoint]["z"], carspawns[spawnpoint]["h"], true, false)

    local plt = GetVehicleNumberPlateText(WeedVehicle)

    SetVehicleHasBeenOwnedByPlayer(WeedVehicle,true)

    SetModelAsNoLongerNeeded(car)
	TriggerEvent("keys:addNew",  GetVehicleNumberPlateText(plt))


    while true do

        Citizen.Wait(1)

         DrawText3Ds(carspawns[spawnpoint]["x"], carspawns[spawnpoint]["y"], carspawns[spawnpoint]["z"], "Your Delivery Car (Stolen).")

         if #(GetEntityCoords(PlayerPedId()) - vector3(carspawns[spawnpoint]["x"], carspawns[spawnpoint]["y"], carspawns[spawnpoint]["z"])) < 8.0 then

            return

         end

    end



end



RegisterNetEvent("weed:successStart")

AddEventHandler("weed:successStart", function()



    if not exports["dsrp-inventory"]:hasEnoughOfItem("weedq",weedcost,false) then

        TriggerEvent("notification", "You dont have enough weed.")
        return
    end



    StartWeedRun()

    CreateWeedVehicle()

    local toolong = 0

    while ActiveRun do

        Wait(waittime)

        if CurrentStep == 0 then



            if DropOffCount == DropOffMax or not DoesEntityExist(WeedVehicle) then

                EndRuns()

            end



            local veh = GetVehiclePedIsIn(PlayerPedId(),false)

            if WeedVehicle == veh then

                CurrentStep = 1

                waittime = 1000

                if math.random(50) < 25 then

                    DropOffLocation = DropOffs[math.random(#DropOffs)]

                else

                    DropOffLocation = DropOffsClose[math.random(#DropOffsClose)]

                end                

                BlipCreation()


                
            end



        elseif CurrentStep == 1 then

            local plyCoords = GetEntityCoords(PlayerPedId())

            local inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)

            local distance = Vdist(DropOffLocation["x"],DropOffLocation["y"],DropOffLocation["z"],plyCoords)

            if distance < 30.0 and not inVehicle then

                waittime = 1

                DrawText3Ds(DropOffLocation["x"],DropOffLocation["y"],DropOffLocation["z"],"Press E to drop off package.")

                if IsControlJustReleased(1,38) and ActiveRun and distance < 1.5 then

                    AttemptDropOff()

                end

            else

                waittime = 1000

            end

        else

            waittime = 1000

        end



        toolong = toolong + 1

        if toolong > 360000 then

            WeedTacoTooLong()

        end



    end



end)



function ClearBlips()

    RemoveBlip(CurrentMarker)

    CurrentMarker = 0

end



function BlipCreation()

    ClearBlips()

    CurrentMarker = AddBlipForCoord(DropOffLocation["x"],DropOffLocation["y"],DropOffLocation["z"])

    SetBlipSprite(CurrentMarker, 514)

    SetBlipScale(CurrentMarker, 1.0)

    SetBlipAsShortRange(CurrentMarker, false)

    BeginTextCommandSetBlipName("STRING")

    AddTextComponentString("Drop Off")

    EndTextCommandSetBlipName(CurrentMarker)

end



function StartWeedRun()

    TriggerEvent("inventory:removeItem","weedq", weedcost)
    TriggerEvent("player:receiveItem","weed12oz",1)

    ActiveRun = true

end



function EndRuns()

    ClearBlips()

    SetVehicleHasBeenOwnedByPlayer(WeedVehicle,false)

    SetEntityAsNoLongerNeeded(WeedVehicle)



    ActiveRun = false

    waittime = 1000

    CurrentStep = 0

    DropOffCount = 0

    DropOffLocation =  { ['x'] = -10.81,['y'] = -1828.68,['z'] = 25.4,['h'] = 301.59, ['info'] = ' Grove shop' }

    Wait(1000)

    ClearBlips()

end



function WeedTacoTooLong()

    if exports["dsrp-inventory"]:hasEnoughOfItem("weed12oz",1,false) then
        ClearBlips()
        Wait(180000)

        TriggerEvent("notification","You took too long!", 2)

        DropOffCount = DropOffCount + 1

        CurrentStep = 0        

    else

        TriggerEvent("notification","Run ended as your box is gone!")

        EndRuns()

    end

end



function AttemptDropOff()

    if exports["dsrp-inventory"]:hasEnoughOfItem("weed12oz",1,false) then
        if math.random(PoliceCallChance) == PoliceCallChance then
            TriggerEvent("civilian:alertPolice",15.0,"Suspicious",0)
        end

        TriggerEvent("inventory:removeItem",weed12oz, 1)
        TriggerEvent("notification","Drop off success!")

        TriggerEvent("player:receiveItem","band", 4)
        TriggerEvent("inventory:removeItem","weed12oz",1)
          ClearBlips()

        TriggerEvent("attachItemDrugs","drugpackage01")

        Wait(10000)

        -- new run

        DropOffCount = DropOffCount + 1

        CurrentStep = 0        

    else

        TriggerEvent("notification","Run ended as your box is gone!")

        EndRuns()

    end

end