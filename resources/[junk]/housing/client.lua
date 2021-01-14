local OwnedHouse = nil
local AvailableHouses = {}
local blips = {}
local Knockings = {}
local state = 1
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end) Wait(0) end
    while ESX.GetPlayerData().job == nil do Wait(0) end
    TriggerServerEvent('loaf_housing:getOwned')
    while OwnedHouse == nil do Wait(0) end

    if Config.IKEABlip['Enabled'] then
        local blip = AddBlipForCoord(Config.Furnituring['enter'])
        SetBlipSprite(blip, Config.IKEABlip['Sprite'])
        SetBlipColour(blip, Config.IKEABlip['Colour'])
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, Config.IKEABlip['Scale'])
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Strings['ikea'])
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)
    end
    sleep = 500
    while true do
        Wait(sleep)
        for k, v in pairs(Config.Houses) do
            if Vdist2(GetEntityCoords(PlayerPedId()), v['door']) <= 2.5 then
                local text = 'error'
                while Vdist2(GetEntityCoords(PlayerPedId()), v['door']) <= 2.5 do
                    if OwnedHouse.houseId == k then
                        text = (Strings['Press_E']):format(Strings['Manage_House'])
                    else
                        if not AvailableHouses[k] then
                            if OwnedHouse.houseId ~= 0 then
                                text = Strings['Must_Sell']
                            else
                                text = (Strings['Press_E']):format((Strings['Buy_House']):format(k))
                            end
                        else
                            if Config.PoliceRaid['Enabled'] then
                                if Config.PoliceRaid['Jobs'][ESX.GetPlayerData().job.name] then
                                    text = (Strings['Press_E']):format(Strings['Knock_House']) .. Strings['Raid_House']
                                else
                                    text = (Strings['Press_E']):format(Strings['Knock_House'])
                                end
                            else
                                text = (Strings['Press_E']):format(Strings['Knock_House'])
                            end
                        end
                    end
                    HelpText(text, v['door'])

                    if IsControlJustReleased(0, 47) then
                        if Config.PoliceRaid['Enabled'] then
                            if Config.PoliceRaid['Jobs'][ESX.GetPlayerData().job.name] then
                                TriggerServerEvent('loaf_housing:policeRaid', k)
                            end
                        end
                    end

                    if IsControlJustReleased(0, 38) then
                        if OwnedHouse.houseId == k then
                            ESX.UI.Menu.CloseAll()
                            elements = {
                                {label = Strings['Enter_House'], value = 'enter'},
                                {label = (Strings['Sell_House']):format(math.floor(Config.Houses[OwnedHouse.houseId]['price']*(Config.SellPercentage/100))), value = 'sell'},
                            }
                            if Config.EnableGarage then
                                table.insert(elements, {label = Strings['Garage'], value = 'garage'})
                            end
                            ESX.UI.Menu.Open(
                                    'default', GetCurrentResourceName(), 'manage_house',
                                {
                                    title = Strings['Manage_House'],
                                    align = 'bottom-right',
                                    elements = elements
                                },
                                function(data, menu)
                                    if data.current.value == 'enter' then
                                        TriggerEvent('InteractSound_CL:PlayOnOne', 'doorenter', 0.8)
                                        TriggerEvent('settonight',source, true)
                                        TriggerEvent('dooranim')
                                        menu.close()
                                        Wait(1500)
                                        TriggerEvent('denoms')
                                        TriggerServerEvent('loaf_housing:enterHouse', k)
                                        menu.close()
                                    elseif data.current.value == 'garage' then
                                        local coordss = Config.Houses[OwnedHouse.houseId]['door']
                                        local found, coords, heading
                                        if not Config.Houses[OwnedHouse.houseId]['garage'] then
                                            found, coords, heading = GetClosestVehicleNodeWithHeading(coordss.x, coordss.y, coordss.z, 3.0, 100.0, 2.5)
                                        else
                                            found, coords, heading = true, Config.Houses[OwnedHouse.houseId]['garage'].xyz, Config.Houses[OwnedHouse.houseId]['garage'].w
                                        end
                                        if found then
                                            ESX.UI.Menu.CloseAll()
                                            TriggerServerEvent('esx_garage:viewVehicles', coords, heading, 'housing')
                                            return
                                        else
                                            ESX.ShowNotification(Strings['No_Spawn'])
                                        end
                                    elseif data.current.value == 'sell' then
                                        ESX.UI.Menu.Open(
                                            'default', GetCurrentResourceName(), 'sell',
                                        {
                                            title = (Strings['Sell_Confirm']):format(math.floor(Config.Houses[OwnedHouse.houseId]['price']*(Config.SellPercentage/100))),
                                            align = 'bottom-right',
                                            elements = {
                                                {label = Strings['yes'], value = 'yes'},
                                                {label = Strings['no'], value = 'no'}
                                            },
                                        },
                                        function(data2, menu2)
                                            if data2.current.value == 'yes' then
                                                TriggerServerEvent('loaf_housing:sellHouse')
                                                ESX.UI.Menu.CloseAll()
                                                Wait(5000)
                                            else
                                                menu2.close()
                                            end
                                        end,
                                            function(data2, menu2)
                                            menu2.close()
                                        end)
                                    end
                                end,
                            function(data, menu)
                                menu.close()
                            end)
                        else
                            if not AvailableHouses[k] and OwnedHouse.houseId == 0 then
                                ESX.UI.Menu.CloseAll()
                                local elements = {
                                    {label = Strings['yes'], value = 'yes'},
                                    {label = Strings['no'], value = 'no'},
                                }
                                if Config.VisitHouse then
                                    table.insert(elements, {label = Strings['Visit'], value = 'visit'})
                                end
                                ESX.UI.Menu.Open(
                                    'default', GetCurrentResourceName(), 'buy',
                                {
                                    title = (Strings['Buy_House_Confirm']):format(k, v['price']),
                                    align = 'bottom-right',
                                    elements = elements
                                },
                                function(data, menu)
                                    if data.current.value == 'yes' then
                                        TriggerServerEvent('loaf_housing:buyHouse', k)
                                        ESX.UI.Menu.CloseAll()
                                        Wait(5000)
                                    else
                                        if data.current.value == 'visit' then
                                            TriggerServerEvent('loaf_housing:visit', k)
                                            TriggerEvent('settonight',source, true)
                                        end
                                        menu.close()
                                    end
                                end,
                                    function(data, menu)
                                    menu.close()
                                end)
                            else
                                if AvailableHouses[k] then
                                    TriggerServerEvent('loaf_housing:knockDoor', k)
                                    while Vdist2(GetEntityCoords(PlayerPedId()), v['door']) <= 4.5 do Wait(0) HelpText(Strings['Waiting_Owner'], v['door']) end
                                    TriggerServerEvent('loaf_housing:unKnockDoor', k)
                                end
                            end
                        end
                        Wait(5000)
                    end
                    Wait(0)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while OwnedHouse == nil do Wait(0) end
    while true do
        Wait(0)
        local dist = Vdist2(GetEntityCoords(PlayerPedId()), Config.Furnituring['enter'])
        if dist <= 50.0 then
            DrawMarker(27, Config.Furnituring['enter'], vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)
            if dist <= 1.5 then
                HelpText((Strings['Press_E']):format(Strings['Buy_Furniture']), Config.Furnituring['enter'])
                if IsControlJustReleased(0, 38) then
                    FreezeEntityPosition(PlayerPedId(), true)
                    local currentcategory = 1
                    local category = Config.Furniture['Categories'][currentcategory]

                    local current = 1
                    local cooldown = GetGameTimer()

                    local model = GetHashKey(Config.Furniture[category[1]][current][2])

                    if IsModelValid(model) then
                        local startedLoading = GetGameTimer()
                        while not HasModelLoaded(model) do
                            RequestModel(model) Wait(0)
                            if GetGameTimer() - startedLoading >= 1500 then
                                ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                break
                            end
                        end
                        furniture = CreateObject(model, Config.Furnituring['teleport'])
                        SetEntityHeading(furniture, 0.0)
                    else
                        ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                    end

                    local cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
                    SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(furniture, 0.0, -5.0, 4.0))
                    PointCamAtCoord(cam, GetEntityCoords(furniture))
                    RenderScriptCams(1, 0, 0, 1, 1)
                    SetCamActive(cam, true)
                    FreezeEntityPosition(PlayerPedId(), true)
                    while true do
                        Wait(0)
                        HelpText((Strings['Buying_Furniture']):format(category[2], Config.Furniture[category[1]][current][1], Config.Furniture[category[1]][current][3]))

                        DrawText3D(GetEntityCoords(furniture), ('%s ($%s)'):format(Config.Furniture[category[1]][current][1], Config.Furniture[category[1]][current][3]), 0.5)

                        DisableControlAction(0, 24)
                        DisableControlAction(0, 25)
                        DisableControlAction(0, 14)
                        DisableControlAction(0, 15)
                        DisableControlAction(0, 16)
                        DisableControlAction(0, 17)

                        SetTimeAndWeather()

                        if IsControlJustReleased(0, 194) then
                            break
                        elseif IsControlJustReleased(0, 172) then
                            if Config.Furniture['Categories'][currentcategory + 1] then
                                category = Config.Furniture['Categories'][currentcategory + 1]
                                currentcategory = currentcategory + 1
                                current = 1
                            else
                                category = Config.Furniture['Categories'][1]
                                currentcategory = 1
                                current = 1
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do
                                    RequestModel(model) Wait(0)
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObject(model, Config.Furnituring['teleport'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                            end
                        elseif IsControlPressed(0, 34) then
                            SetEntityHeading(furniture, GetEntityHeading(furniture) + 0.25)
                        elseif IsControlPressed(0, 35) then
                            SetEntityHeading(furniture, GetEntityHeading(furniture) - 0.25)
                        elseif IsDisabledControlPressed(0, 96) then
                            local currentCoord = GetCamCoord(cam)
                            if currentCoord.z + 0.1 <= GetOffsetFromEntityInWorldCoords(furniture, 0.0, -5.0, 4.5).z then
                                currentCoord = vector3(currentCoord.x, currentCoord.y, currentCoord.z + 0.1)
                                SetCamCoord(cam, currentCoord)
                            end
                        elseif IsDisabledControlPressed(0, 97) then
                            local currentCoord = GetCamCoord(cam)
                            if currentCoord.z - 0.1 >= GetOffsetFromEntityInWorldCoords(furniture, 0.0, -5.0, 0.1).z then
                                currentCoord = vector3(currentCoord.x, currentCoord.y, currentCoord.z - 0.1)
                                SetCamCoord(cam, currentCoord)
                            end
                        elseif IsControlPressed(0, 33) then
                            local fov = GetCamFov(cam)
                            if fov + 0.1 >= 129.9 then fov = 129.9 else fov = fov + 0.1 end
                            SetCamFov(cam, fov)
                        elseif IsControlPressed(0, 32) then
                            local fov = GetCamFov(cam)
                            if fov - 0.1 <= 1.1 then fov = 1.1 else fov = fov - 0.1 end
                            SetCamFov(cam, fov)
                        elseif IsControlJustReleased(0, 173) then
                            if Config.Furniture['Categories'][currentcategory - 1] then
                                category = Config.Furniture['Categories'][currentcategory - 1]
                                currentcategory = currentcategory - 1
                                current = 1
                            else
                                category = Config.Furniture['Categories'][#Config.Furniture['Categories']]
                                currentcategory = #Config.Furniture['Categories']
                                current = 1
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do
                                    RequestModel(model) Wait(0)
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObject(model, Config.Furnituring['teleport'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                            end
                        elseif IsControlJustReleased(0, 191) then
                            local answered = false
                            ESX.UI.Menu.CloseAll()
                            ESX.UI.Menu.Open(
                                'default', GetCurrentResourceName(), 'buy_furniture',
                            {
                                title = (Strings['Confirm_Purchase']):format(Config.Furniture[category[1]][current][1], Config.Furniture[category[1]][current][3]),
                                align = 'center',
                                elements = {
                                    {label = Strings['yes'], value = 'yes'},
                                    {label = Strings['no'], value = 'no'}
                                },
                            },
                            function(data, menu)
                                menu.close()
                                if data.current.value == 'yes' then
                                    TriggerServerEvent('loaf_housing:buy_furniture', currentcategory, current)
                                    DoScreenFadeOut(250)
                                    Wait(1500)
                                    DoScreenFadeIn(500)
                                end
                                answered = true
                            end,
                                function(data, menu)
                                    answered = true
                                    menu.close()
                                end
                            )
                            while not answered do Wait(0) end
                        elseif IsControlPressed(0, 190) and cooldown < GetGameTimer() then
                            if Config.Furniture[category[1]][current + 1] then
                                current = current + 1
                            else
                                current = 1
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do
                                    RequestModel(model) Wait(0)
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObject(model, Config.Furnituring['teleport'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                            end
                            cooldown = GetGameTimer() + 250
                        elseif IsControlPressed(0, 189) and cooldown < GetGameTimer() then
                            if Config.Furniture[category[1]][current - 1] then
                                current = current - 1
                            else
                                current = #Config.Furniture[category[1]]
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do
                                    RequestModel(model) Wait(0)
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObject(model, Config.Furnituring['teleport'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                            end
                            cooldown = GetGameTimer() + 250
                        end
                    end
                    FreezeEntityPosition(PlayerPedId(), false)
                    DeleteObject(furniture)
                    RenderScriptCams(false, false, 0, true, false)
                    DestroyCam(cam)
                end
            end
        end
    end
end)

RegisterNetEvent('loaf_housing:visitHouse')
AddEventHandler('loaf_housing:visitHouse', function(coords, prop, door, housespawn)
    local house = EnterHouse(Config.Props[prop], coords)
    SetEntityHeading(house, 0.0)
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    local exit = GetOffsetFromEntityInWorldCoords(house, Config.Offsets[prop]['door'])
    for i = 1, 25 do
        SetEntityCoords(PlayerPedId(), exit)
        Wait(50)
    end
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        SetEntityCoords(PlayerPedId(), exit)
        Wait(50)
    end
    DoScreenFadeIn(1500)
    while true do
        Wait(0)

        local dist = #(GetEntityCoords(PlayerPedId()) - exit)

        SetTimeAndWeather()
        TriggerEvent('settonight',source, true)
        exit = GetOffsetFromEntityInWorldCoords(house, Config.Offsets[prop]['door'])

        if GetEntityCoords(house).z ~= coords.z then
            SetEntityCoords(house, coords)
        end

        local height = GetEntityCoords(PlayerPedId()).z - GetEntityCoords(house).z

        if height > 10.0 or height < -10.0 then
            SetEntityCoords(PlayerPedId(), exit)
        end

        if dist <= 25.0 then

            DrawMarker(27, exit, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)

            if dist <= 1.5 then

                HelpText('~INPUT_CONTEXT~ ' .. Strings['Exit'], exit)

                if IsControlJustReleased(0, 51) then

                    TriggerServerEvent('loaf_housing:leaveVisit', housespawn)
                    TriggerEvent('settonight',source, false)
                    DoScreenFadeOut(0)

                    for i = 1, 25 do
                        SetEntityCoords(PlayerPedId(), door)
                        Wait(50)
                    end

                    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                        SetEntityCoords(PlayerPedId(), door)
                        Wait(50)
                    end

                    DoScreenFadeIn(1500)

                    SetEntityCoords(house, vector3(0.0, 0.0, 0.0))
                    CreateThread(function()
                        while DoesEntityExist(house) do
                            DeleteObject(house)
                            SetEntityAsMissionEntity(house, true, true)
                            Wait(50)
                        end
                    end)

                    return

                end

            end

        end

    end
end)

function OpenCupboard(room)
    TriggerEvent("server-inventory-open", "1", "Cupboard"..room.."-")
end

RegisterNetEvent('loaf_housing:spawnHouse')
AddEventHandler('loaf_housing:spawnHouse', function(coords, furniture)
    local prop = Config.Houses[OwnedHouse.houseId]['prop']
    local house = EnterHouse(Config.Props[prop], coords)
    local placed_furniture, furniture_table = {}, {}
	local hasInvOpen = false
    for k, v in pairs(OwnedHouse['furniture']) do
        local model = GetHashKey(v['object'])
        while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
        local object = CreateObject(model, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])), false, false, false)
        SetEntityHeading(object, v['heading'])
        FreezeEntityPosition(object, true)
        SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])))
        table.insert(placed_furniture, object)
        table.insert(furniture_table, {['Object'] = object, ['Offset'] = vector3(v['offset'][1], v['offset'][2], v['offset'][3])})
    end
    SetEntityHeading(house, 0.0)
    local exit = GetOffsetFromEntityInWorldCoords(house, Config.Offsets[prop]['door'])
    local storage = GetOffsetFromEntityInWorldCoords(house, Config.Offsets[prop]['storage'])
    TriggerServerEvent('loaf_housing:setInstanceCoords', Config.Offsets[prop]['door'], coords, prop, OwnedHouse['furniture'])
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    for i = 1, 25 do
        SetEntityCoords(PlayerPedId(), exit)
        Wait(50)
    end
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        SetEntityCoords(PlayerPedId(), exit)
        Wait(50)
    end
    DoScreenFadeIn(1500)
    local in_house = true
    ClearPedWetness(PlayerPedId())
    while in_house do
        SetTimeAndWeather()

        exit = GetOffsetFromEntityInWorldCoords(house, Config.Offsets[prop]['door'])
        storage = GetOffsetFromEntityInWorldCoords(house, Config.Offsets[prop]['storage'])

        for k, v in pairs(furniture_table) do
            local offset = GetOffsetFromEntityInWorldCoords(house, v['Offset'])
            if GetEntityCoords(v['Object']) ~= offset then
                SetEntityCoords(v['Object'], offset)
            end
        end

        local height = GetEntityCoords(PlayerPedId()).z - GetEntityCoords(house).z

        if height > 10.0 or height < -10.0 then
            SetEntityCoords(PlayerPedId(), exit)
        end

        if GetEntityCoords(house).z ~= coords.z then
            SetEntityCoords(house, coords)
        end

        DrawMarker(27, exit, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)
        DrawMarker(27, storage, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)
        if Vdist2(GetEntityCoords(PlayerPedId()), storage) <= 2.0 then
            HelpText((Strings['Press_E']):format(Strings['Storage']), storage)
            if IsControlJustReleased(0, 38) and Vdist2(GetEntityCoords(PlayerPedId()), storage) <= 2.0 then
                ESX.UI.Menu.CloseAll()

                ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'storage',
                {
                    title = Strings['Storage_Title'],
                    align = 'bottom-right',
                    elements = {
                        {label = Strings['Items'], value = 'i'},
                       -- {label = Strings['Weapons'], value = 'w'},
                        --{label =  Strings['Wardrobe'], value = 'ward'}
                    },
                },
                function(data, menu)
                    if data.current.value == 'i' then
                        --itemStorage(OwnedHouse.houseId)
			if not hasInvOpen then
				hasInvOpen = true
                OpenCupboard(OwnedHouse.houseId .. '_prop_room_items')
                TriggerEvent('InteractSound_CL:PlayOnOne', 'zip', 0.6)
				menu.close()
				hasInvOpen = false
			else
				
			end
			--OpenCupboard(OwnedHouse.houseId)
                    elseif data.current.value == 'w' then
                        weaponStorage(OwnedHouse.houseId)
                    elseif data.current.value == 'ward' then
                        wardrobeMenu()
                    end
                end,
                    function(data, menu)
                    menu.close()
                end)

            end
        end
        if Vdist2(GetEntityCoords(PlayerPedId()), exit) <= 1.5 then
            HelpText((Strings['Press_E']):format(Strings['Manage_Door']), exit)
            if IsControlJustReleased(0, 38) then
                ESX.UI.Menu.CloseAll()

                local elements = {
                    {label = Strings['Accept'], value = 'accept'},
                    {label = Strings['Furnish'], value = 'furnish'},
                    {label = Strings['Re_Furnish'], value = 'refurnish'},
                    {label = Strings['Exit'], value = 'exit'},
                }

                ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'manage_door',
                {
                    title = Strings['Manage_Door'],
                    align = 'bottom-right',
                    elements = elements,
                },
                function(data, menu)
                    if data.current.value == 'exit' then
                        ESX.TriggerServerCallback('loaf_housing:hasGuests', function(has)
                            if not has then
                                ESX.UI.Menu.CloseAll()
                                TriggerServerEvent('loaf_housing:deleteInstance')
                                DoScreenFadeOut(0)
                                TriggerEvent('dooranim')
                                TriggerEvent('settonight',source, false)
                                TriggerEvent('InteractSound_CL:PlayOnOne', 'doorexit', 0.8)
                                in_house = false
                                return
                            else
                                ESX.ShowNotification(Strings['Guests'])
                            end
                        end)
                    elseif data.current.value == 'refurnish' then
                        ESX.TriggerServerCallback('loaf_housing:hasGuests', function(has)
                            if not has then
                                local elements = {}
                                for k, v in pairs(OwnedHouse['furniture']) do
                                    table.insert(elements, {label = (Strings['Remove']):format(v['name'], k), value = k})
                                end
                                local editing = true
                                ESX.UI.Menu.Open(
                                    'default', GetCurrentResourceName(), 'edit_furniture',
                                {
                                    title = Strings['Re_Furnish'],
                                    align = 'bottom-right',
                                    elements = elements,
                                },
                                function(data2, menu2)
                                    DeleteObject(placed_furniture[data2.current.value])
                                    if furniture[OwnedHouse['furniture'][data2.current.value]['object']] then
                                        furniture[OwnedHouse['furniture'][data2.current.value]['object']]['amount'] = furniture[OwnedHouse['furniture'][data2.current.value]['object']]['amount'] + 1
                                    else
                                        furniture[OwnedHouse['furniture'][data2.current.value]['object']] = {amount = 1, name = OwnedHouse['furniture'][data2.current.value]['name']}
                                    end
                                    table.remove(OwnedHouse['furniture'], data2.current.value)
                                    for k, v in pairs(placed_furniture) do
                                        DeleteObject(v)
                                    end
                                    placed_furniture = {}
                                    for k, v in pairs(OwnedHouse['furniture']) do
                                        local model = GetHashKey(v['object'])
                                        while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
                                        local object = CreateObject(model, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])), true, false, true)
                                        SetEntityHeading(object, v['heading'])
                                        FreezeEntityPosition(object, true)
                                        SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])))
                                        table.insert(placed_furniture, object)
                                    end
                                    TriggerServerEvent('loaf_housing:furnish', OwnedHouse, furniture)
                                    menu2.close()
                                    editing = false
                                end,
                                    function(data2, menu2)
                                        editing = false
                                    menu2.close()
                                end)
                                while editing do
                                    Wait(0)
                                    for k, v in pairs(placed_furniture) do
                                        DrawText3D(GetEntityCoords(v), ('%s (#%s)'):format(OwnedHouse['furniture'][k]['name'], k), 0.3)
                                    end
                                end
                            else
                                ESX.ShowNotification(Strings['Guests'])
                            end
                        end)
                    elseif data.current.value == 'furnish' then
                        ESX.TriggerServerCallback('loaf_housing:hasGuests', function(has)
                            if not has then
                                local elements = {}
                                for k, v in pairs(furniture) do
                                    table.insert(elements, {label = ('x%s %s'):format(v['amount'], v['name']), value = k, name = v['name']})
                                end
                                ESX.UI.Menu.Open(
                                    'default', GetCurrentResourceName(), 'furnish',
                                {
                                    title = Strings['Furnish'],
                                    align = 'bottom-right',
                                    elements = elements,
                                },
                                function(data2, menu2)
                                    ESX.UI.Menu.CloseAll()
                                    local model = GetHashKey(data2.current.value)
                                    while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
                                    local object = CreateObject(model, GetOffsetFromEntityInWorldCoords(house, Config.Offsets[prop]['spawn_furniture']), true, false, true)
                                    SetEntityCollision(object, false, false)
                                    SetEntityHasGravity(object, false)
                                    Wait(250)
                                    while true do
                                        Wait(0)
                                        HelpText(Strings['Furnishing'])
                                        ESX.UI.Menu.CloseAll() -- test
                                        TriggerEvent('settonight',source, true)
                                        DisableControlAction(0, 24)
                                        DisableControlAction(0, 25)
                                        DisableControlAction(0, 14)
                                        DisableControlAction(0, 15)
                                        DisableControlAction(0, 16)
                                        DisableControlAction(0, 17)
                                        -- DrawEdge(object) -- w.i.p
                                        DrawText3D(GetEntityCoords(object), ('%s, %s: %s'):format(data2.current.name, Strings['Rotation'], string.format("%.2f", GetEntityHeading(object))), 0.3)
                                        if IsControlPressed(0, 172) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.0, 0.01, 0.0))
                                        elseif IsControlPressed(0, 173) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.0, -0.01, 0.0))
                                        elseif IsControlPressed(0, 96) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.0, 0.0, 0.01))
                                        elseif IsControlPressed(0, 97) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.0, 0.0, -0.01))
                                        elseif IsControlPressed(0, 174) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, -0.01, 0.0, 0.0))
                                        elseif IsControlPressed(0, 175) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.01, 0.0, 0.0))
                                        elseif IsDisabledControlPressed(0, 24) then
                                            SetEntityHeading(object, GetEntityHeading(object)+0.5)
                                        elseif IsDisabledControlPressed(0, 25) then
                                            SetEntityHeading(object, GetEntityHeading(object)-0.5)
                                        elseif IsControlJustReleased(0, 47) then
                                            local objCoords, houseCoords = GetEntityCoords(object), GetEntityCoords(house)
                                            local houseHeight = GetEntityHeight(house, GetEntityCoords(house), true, false)
                                            SetEntityCoords(object, objCoords.x, objCoords.y, (objCoords.z-(objCoords.z-houseCoords.z))+houseHeight)
                                        elseif IsControlPressed(0, 215) then
                                            local objCoords, houseCoords = GetEntityCoords(object), GetEntityCoords(house)
                                            local furn_offs = objCoords - houseCoords
                                            local furnished = {['offset'] = {furn_offs.x, furn_offs.y, furn_offs.z}, ['object'] = data2.current.value, ['name'] = data2.current.name, ['heading'] = GetEntityHeading(object)}
                                            table.insert(OwnedHouse['furniture'], furnished)
                                            if furniture[data2.current.value]['amount'] > 1 then
                                                furniture[data2.current.value]['amount'] = furniture[data2.current.value]['amount'] - 1
                                            else -- ugly code, idk how to improve ┬»\_(πâä)_/┬» couldn't get table.remove to work on this shit
                                                local oldFurniture = furniture
                                                furniture = {}
                                                for k, v in pairs(oldFurniture) do
                                                    if k ~= data2.current.value then
                                                        furniture[k] = v
                                                    end
                                                end
                                            end
                                            DeleteObject(object)

                                            for k, v in pairs(placed_furniture) do
                                                DeleteObject(v)
                                            end
                                            placed_furniture = {}
                                            for k, v in pairs(OwnedHouse['furniture']) do
                                                local model = GetHashKey(v['object'])
                                                while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
                                                local object = CreateObject(model, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])), true, false, true)
                                                SetEntityHeading(object, v['heading'])
                                                FreezeEntityPosition(object, true)
                                                SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])))
                                                table.insert(placed_furniture, object)
                                            end

                                            TriggerServerEvent('loaf_housing:furnish', OwnedHouse, furniture)
                                            break
                                        elseif IsControlPressed(0, 202) then
                                            DeleteObject(object)
                                            break
                                        end
                                    end
                                end,
                                    function(data2, menu2)
                                    menu2.close()
                                end)
                            else
                                ESX.ShowNotification(Strings['Guests'])
                            end
                        end)
                    elseif data.current.value == 'accept' then
                        local elements = {}
                        for k, v in pairs(Knockings) do
                            table.insert(elements, v)
                        end
                        ESX.UI.Menu.Open(
                            'default', GetCurrentResourceName(), 'let_in',
                        {
                            title = Strings['Let_In'],
                            align = 'bottom-right',
                            elements = elements,
                        },
                        function(data2, menu2)
                            if Knockings[data2.current.value] then
                                TriggerServerEvent('loaf_housing:letIn', data2.current.value, Config.Offsets[prop]['storage'])
                            end
                            menu2.close()
                        end,
                            function(data2, menu2)
                            menu2.close()
                        end)
                    end
                end,
                    function(data, menu)
                    menu.close()
                end)
            end
        end
        Wait(0)
    end
    SetEntityCoords(house, vector3(0.0, 0.0, 0.0))
    CreateThread(function()
        while DoesEntityExist(house) do
            DeleteObject(house)
            SetEntityAsMissionEntity(house, true, true)
            Wait(50)
        end
    end)
    for k, v in pairs(placed_furniture) do
        SetEntityCoords(v, vector3(0.0, 0.0, 0.0))
        CreateThread(function()
            while DoesEntityExist(v) do
                DeleteObject(v)
                SetEntityAsMissionEntity(v, true, true)
                Wait(50)
            end
        end)
    end
end)

RegisterNetEvent('loaf_housing:leaveHouse')
AddEventHandler('loaf_housing:leaveHouse', function(house)
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
    for i = 1, 25 do
        SetEntityCoords(PlayerPedId(),  Config.Houses[house]['door'])
        Wait(50)
    end
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
        Wait(50)
    end
    DoScreenFadeIn(1500)
end)

RegisterNetEvent('loaf_housing:knockAccept')
AddEventHandler('loaf_housing:knockAccept', function(coords, house, storageOffset, spawnpos, furniture, host)
    local prop = Config.Houses[house]['prop']
    local offsets = Config.Offsets[Config.Houses[house]['prop']]
    prop = EnterHouse(Config.Props[prop], spawnpos)
    local exit = GetOffsetFromEntityInWorldCoords(prop, offsets['door'])
    local placed_furniture, furniture_table = {}, {}
    for k, v in pairs(furniture) do
        local model = GetHashKey(v['object'])
        while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
        local object = CreateObject(model, GetOffsetFromEntityInWorldCoords(prop, vector3(v['offset'][1], v['offset'][2], v['offset'][3])), false, false, false)
        SetEntityHeading(object, v['heading'])
        FreezeEntityPosition(object, true)
        table.insert(placed_furniture, object)
        table.insert(furniture_table, {['Object'] = object, ['Offset'] = vector3(v['offset'][1], v['offset'][2], v['offset'][3])})
    end
    SetEntityHeading(prop, 0.0)

    while not DoesEntityExist(prop) do Wait(0) end

    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    SetEntityCoords(PlayerPedId(), exit)
    for i = 1, 25 do
        SetEntityCoords(PlayerPedId(), exit)
        Wait(50)
    end
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        SetEntityCoords(PlayerPedId(), exit)
        Wait(50)
    end
    DoScreenFadeIn(1500)
    local timer = GetGameTimer() + 500
    local delete = false
    local hasInvOpen = false
    while true do
        Wait(0)
        if timer <= GetGameTimer() then
            timer = GetGameTimer() + 500
            ESX.TriggerServerCallback('loaf_housing:hostOnline', function(online)
                if not online then
                    delete = true
                end
            end, host)
        end
        SetTimeAndWeather()

        exit = GetOffsetFromEntityInWorldCoords(prop, offsets['door'])
        storage = GetOffsetFromEntityInWorldCoords(prop, offsets['storage'])

        for k, v in pairs(furniture_table) do
            local offset = GetOffsetFromEntityInWorldCoords(prop, v['Offset'])
            if GetEntityCoords(v['Object']) ~= offset then
                SetEntityCoords(v['Object'], offset)
            end
        end

        if GetEntityCoords(prop).z ~= spawnpos.z then
            SetEntityCoords(prop, spawnpos)
        end

        local height = GetEntityCoords(PlayerPedId()).z - GetEntityCoords(prop).z

        if height > 10.0 or height < -10.0 then
            SetEntityCoords(PlayerPedId(), exit)
        end

        if delete then
            ESX.UI.Menu.CloseAll()
            DoScreenFadeOut(750)
            for k, v in pairs(placed_furniture) do
                DeleteObject(v)
            end
            while not IsScreenFadedOut() do Wait(0) end
            SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
            for i = 1, 25 do
                SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
                Wait(50)
            end
            while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
                Wait(50)
            end
            DeleteObject(prop)
            DoScreenFadeIn(1500)
            ESX.ShowNotification(Strings['Host_Left'])
            return
        end
        DrawMarker(27, exit, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)
        DrawMarker(27, storage, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)
        if Vdist2(GetEntityCoords(PlayerPedId()), exit) <= 1.5 then
            HelpText((Strings['Press_E']):format(Strings['Exit']), exit)
            if IsControlJustReleased(0, 38) then
                ESX.UI.Menu.CloseAll()
                DoScreenFadeOut(750)
                for k, v in pairs(placed_furniture) do
                    DeleteObject(v)
                end
                while not IsScreenFadedOut() do Wait(0) end
                SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
                for i = 1, 25 do
                    SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
                    Wait(50)
                end
                while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                    SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
                    Wait(50)
                end
                DeleteObject(prop)
                DoScreenFadeIn(1500)
                TriggerServerEvent('loaf_housing:leaveHouse', house)
                return
            end
        end
        if Vdist2(GetEntityCoords(PlayerPedId()), storage) <= 2.0 then
            HelpText((Strings['Press_E']):format(Strings['Storage']), storage)
            if IsControlJustReleased(0, 38) and Vdist2(GetEntityCoords(PlayerPedId()), storage) <= 2.0 then
                ESX.UI.Menu.CloseAll()

                ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'storage',
                {
                    title = Strings['Storage_Title'],
                    align = 'bottom-right',
                    elements = {
                        {label = Strings['Items'], value = 'i'},
                        {label = Strings['Weapons'], value = 'w'}
                    },
                },
                function(data, menu)
                    if data.current.value == 'i' then
                        --itemStorage(house)
			exports['mythic_notify']:SendAlert('error', house)
			if not hasInvOpen then
				hasInvOpen = true
				OpenCupboard(house .. '_prop_room_items')
				menu.close()
				hasInvOpen = false
			else
				
			end
                    elseif data.current.value == 'w' then
                        weaponStorage(house)
                    end
                end,
                    function(data, menu)
                    menu.close()
		    hasInvOpen = false
                end)

            end
        end
    end

    SetEntityCoords(prop, vector3(0.0, 0.0, 0.0))
    CreateThread(function()
        while DoesEntityExist(prop) do
            DeleteObject(prop)
            SetEntityAsMissionEntity(prop, true, true)
            Wait(50)
        end
    end)
    for k, v in pairs(placed_furniture) do
        SetEntityCoords(v, vector3(0.0, 0.0, 0.0))
        CreateThread(function()
            while DoesEntityExist(v) do
                DeleteObject(v)
                SetEntityAsMissionEntity(v, true, true)
                Wait(50)
            end
        end)
    end
end)





RegisterNetEvent('dooranim')
AddEventHandler('dooranim', function()
 ClearPedSecondaryTask(GetPlayerPed(-1))
 loadAnimDict("anim@heists@keycard@")
 TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
 Citizen.Wait(850)
 ClearPedTasks(GetPlayerPed(-1))
end)


function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end


RegisterNetEvent('loaf_housing:reloadHouses')
AddEventHandler('loaf_housing:reloadHouses', function()
    while ESX == nil do TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end) Wait(0) end
    while ESX.GetPlayerData().job == nil do Wait(0) end
    TriggerServerEvent('loaf_housing:getOwned')
end)

RegisterNetEvent('loaf_housing:knockedDoor')
AddEventHandler('loaf_housing:knockedDoor', function(src)
    ESX.ShowNotification(Strings['Someone_Knocked'])
    if not Knockings[src] then
        Knockings[src] = {label = (Strings['Accept_Player']):format(GetPlayerName(GetPlayerFromServerId(src))), value = src}
    end
end)

RegisterNetEvent('loaf_housing:removeDoorKnock')
AddEventHandler('loaf_housing:removeDoorKnock', function(src)
    local newTable = {}
    for k, v in pairs(Knockings) do
        if v.value ~= src then
            table.remove(newTable, v)
        end
    end
    Knockings = newTable
end)

RegisterNetEvent('loaf_housing:setHouse')
AddEventHandler('loaf_housing:setHouse', function(house, purchasedHouses)
    OwnedHouse = house

    AvailableHouses = {}

    for k, v in pairs(blips) do
        RemoveBlip(v)
    end

    for k, v in pairs(purchasedHouses) do
        if v.houseid ~= OwnedHouse.houseId then
            AvailableHouses[v.houseid] = v.houseid
        end
    end

    for k, v in pairs(Config.Houses) do
        if OwnedHouse.houseId == k then
            CreateBlip(v['door'], 40, 3, 0.75, Strings['Your_House'])
        else
            if not AvailableHouses[k] then
                if Config.AddHouseBlips then
                    CreateBlip(v['door'], 374, 0, 0.45, '')
                end
            else
                if Config.AddBoughtHouses then
                    CreateBlip(v['door'], 374, 2, 0.45, Strings['Player_House'])
                end
            end
        end
    end
end)

EnterHouse = function(prop, coords)
    local obj = CreateObject(prop, coords, false)
    FreezeEntityPosition(obj, true)
    return obj
end

HelpText = function(msg, coords)
    if not coords or not Config.Use3DText then
        AddTextEntry(GetCurrentResourceName(), msg)
        DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
    else
        DrawText3D(coords, string.gsub(msg, "~INPUT_CONTEXT~", "[E]"), 0.35)
    end
end

CreateBlip = function(coords, sprite, colour, scale, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    table.insert(blips, blip)
end

rgb = function(speed)
    local result = {}
    local n = GetGameTimer() / 200
    result.r = math.floor(math.sin(n * speed + 0) * 127 + 128)
    result.g = math.floor(math.sin(n * speed + 2) * 127 + 128)
    result.b = math.floor(math.sin(n * speed + 4) * 127 + 128)
    return result
end

DrawEdge = function(entity)
    local left, right = GetModelDimensions(GetEntityModel(entity))
    local leftoffset, rightoffset = GetOffsetFromEntityInWorldCoords(entity, left.x, left.y, left.z), GetOffsetFromEntityInWorldCoords(entity, right.x, right.y, right.z)
    local coords = GetEntityCoords(entity)

    local color = rgb(0.5)

    -- DrawBox(GetOffsetFromEntityInWorldCoords(entity, left.x, left.y, left.z), GetOffsetFromEntityInWorldCoords(entity, right.x, right.y, right.z), 255, 255, 255, 50)
    --DrawBox(coords+left, coords+right, 255, 255, 255, 50)

    DrawLine(rightoffset, rightoffset.x, rightoffset.y, leftoffset.z, color.r, color.g, color.b, 255)
    DrawLine(leftoffset, leftoffset.x, leftoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(leftoffset.x, rightoffset.y, leftoffset.z, leftoffset.x, rightoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, leftoffset.y, leftoffset.z, rightoffset.x, leftoffset.y, rightoffset.z, color.r, color.g, color.b, 255)

    DrawLine(rightoffset.x, leftoffset.y, leftoffset.z, leftoffset, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, rightoffset.y, leftoffset.z, leftoffset.x, rightoffset.y, leftoffset.z, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, rightoffset.y, rightoffset.z, leftoffset.x, rightoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(leftoffset.x, leftoffset.y, rightoffset.z, rightoffset.x, leftoffset.y, rightoffset.z, color.r, color.g, color.b, 255)

    DrawLine(leftoffset.x, leftoffset.y, rightoffset.z, leftoffset.x, rightoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, rightoffset.y, rightoffset.z, rightoffset.x, leftoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(leftoffset.x, leftoffset.y, leftoffset.z, leftoffset.x, rightoffset.y, leftoffset.z, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, rightoffset.y, leftoffset.z, rightoffset.x, leftoffset.y, leftoffset.z, color.r, color.g, color.b, 255)

    --[[DrawLine(coords+left, (coords+left).x, (coords+left).y, (coords+right).z, color.r, color.g, color.b, 255)
    DrawLine(coords+right, (coords+right).x, (coords+right).y, (coords+left).z, color.r, color.g, color.b, 255)
    DrawLine(coords.x+left.x, coords.y+right.y, coords.z+left.z, coords.x+left.x, coords.y+right.y, coords.z+right.z, color.r, color.g, color.b, 255)
    DrawLine(coords.x+right.x, coords.y+left.y, coords.z+left.z, coords.x+right.x, coords.y+left.y, coords.z+right.z, color.r, color.g, color.b, 255)

    DrawLine(coords.x+right.x, coords.y+left.y, coords.z+left.z, coords+left, color.r, color.g, color.b, 255)
    DrawLine(coords.x+right.x, coords.y+right.y, coords.z+left.z, coords.x+left.x, coords.y+right.y, coords.z+left.z, color.r, color.g, color.b, 255)
    DrawLine(coords.x+right.x, coords.y+right.y, coords.z+right.z, coords.x+left.x, coords.y+right.y, coords.z+right.z, color.r, color.g, color.b, 255)
    DrawLine(coords.x+left.x, coords.y+left.y, coords.z+right.z, coords.x+right.x, coords.y+left.y, coords.z+right.z, color.r, color.g, color.b, 255)

    DrawLine(coords.x+left.x, coords.y+left.y, coords.z+right.z, coords.x+left.x, coords.y+right.y, coords.z+right.z, color.r, color.g, color.b, 255)
    DrawLine(coords.x+right.x, coords.y+right.y, coords.z+right.z, coords.x+right.x, coords.y+left.y, coords.z+right.z, color.r, color.g, color.b, 255)
    DrawLine(coords.x+left.x, coords.y+left.y, coords.z+left.z, coords.x+left.x, coords.y+right.y, coords.z+left.z, color.r, color.g, color.b, 255)
    DrawLine(coords.x+right.x, coords.y+right.y, coords.z+left.z, coords.x+right.x, coords.y+left.y, coords.z+left.z, color.r, color.g, color.b, 255)]]
end
