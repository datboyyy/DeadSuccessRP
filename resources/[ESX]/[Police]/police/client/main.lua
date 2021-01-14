local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, isHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
local isPolice = false
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)


function cleanPlayer(playerPed)
    SetPedArmour(playerPed, 0)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
    ResetPedMovementClipset(playerPed, 0)
end


function isOppositeDir(a, b)
    local result = 0
    if a < 90 then
        a = 360 + a
    end
    if b < 90 then
        b = 360 + b
    end
    if a > b then
        result = a - b
    else
        result = b - a
    end
    if result > 110 then
        return true
    else
        return false
    end
end





function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        
        for index, value in ipairs(players) do
            local target = GetPlayerPed(value)
            if (target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if (closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        
        return closestPlayer, closestDistance, closestPed
    
    else
        TriggerEvent("DoShortHudText", "Inside Vehicle.", 2)
    end

end




RegisterNetEvent('police:remmaskAccepted')
AddEventHandler('police:remmaskAccepted', function()
    TriggerEvent("facewear:adjust", 1, true)
    TriggerEvent("facewear:adjust", 3, true)
    TriggerEvent("facewear:adjust", 4, true)
    TriggerEvent("facewear:adjust", 2, true)
end)

RegisterNetEvent('police:remmask')
AddEventHandler('police:remmask', function(t)
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 5) then
        if isOppositeDir(GetEntityHeading(t), GetEntityHeading(PlayerPedId())) and not IsPedInVehicle(t, GetVehiclePedIsIn(t, false), false) then
            TriggerServerEvent("police:remmaskGranted", GetPlayerServerId(t))
            AnimSet = "mp_missheist_ornatebank"
            AnimationOn = "stand_cash_in_bag_intro"
            AnimationOff = "stand_cash_in_bag_intro"
            loadAnimDict(AnimSet)
            TaskPlayAnim(PlayerPedId(), AnimSet, AnimationOn, 8.0, -8, -1, 49, 0, 0, 0, 0)
            Citizen.Wait(500)
            ClearPedTasks(PlayerPedId())
        end
    else
        TriggerEvent("notification", "No player near you (maybe get closer)!", 2)
    end
end)



------- Garage Shit ----
--[[function OpenVehicleSpawnerMenu(type, station, part, partNum)
local playerCoords = GetEntityCoords(PlayerPedId())
PlayerData = ESX.GetPlayerData()
local elements = {
{label = _U('garage_storeditem'), action = 'garage'},
{label = _U('garage_storeitem'), action = 'store_garage'},
{label = _U('garage_buyitem'), action = 'buy_vehicle'}
}

ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle', {
title    = _U('garage_title'),
align    = 'bottom-right',
elements = elements
}, function(data, menu)
if data.current.action == 'buy_vehicle' then
local shopElements, shopCoords = {}

if type == 'car' then
shopCoords = Config.PoliceStations[station].Vehicles[partNum].InsideShop
local authorizedVehicles = Config.AuthorizedVehicles[PlayerData.job.grade_name]

if #Config.AuthorizedVehicles.Shared > 0 then
for k,vehicle in ipairs(Config.AuthorizedVehicles.Shared) do
table.insert(shopElements, {
label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, _U('shop_item', ESX.Math.GroupDigits(vehicle.price))),
name  = vehicle.label,
model = vehicle.model,
price = vehicle.price,
type  = 'car'
})
end
end

if #authorizedVehicles > 0 then
for k,vehicle in ipairs(authorizedVehicles) do
table.insert(shopElements, {
label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, _U('shop_item', ESX.Math.GroupDigits(vehicle.price))),
name  = vehicle.label,
model = vehicle.model,
price = vehicle.price,
type  = 'car'
})
end
else
if #Config.AuthorizedVehicles.Shared == 0 then
return
end
end
elseif type == 'helicopter' then
shopCoords = Config.PoliceStations[station].Helicopters[partNum].InsideShop
local authorizedHelicopters = Config.AuthorizedHelicopters[PlayerData.job.grade_name]

if #authorizedHelicopters > 0 then
for k,vehicle in ipairs(authorizedHelicopters) do
table.insert(shopElements, {
label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, _U('shop_item', ESX.Math.GroupDigits(vehicle.price))),
name  = vehicle.label,
model = vehicle.model,
price = vehicle.price,
livery = vehicle.livery or nil,
type  = 'helicopter'
})
end
else
ESX.ShowNotification(_U('helicopter_notauthorized'))
return
end
end

OpenShopMenu(shopElements, playerCoords, shopCoords)
elseif data.current.action == 'garage' then
local garage = {}

ESX.TriggerServerCallback('esx_vehicleshop:retrieveJobVehicles', function(jobVehicles)
if #jobVehicles > 0 then
for k,v in ipairs(jobVehicles) do
local props = json.decode(v.vehicle)
local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
local label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(vehicleName, props.plate)

if v.stored then
label = label .. ('<span style="color:green;">%s</span>'):format(_U('garage_stored'))
else
label = label .. ('<span style="color:darkred;">%s</span>'):format(_U('garage_notstored'))
end

table.insert(garage, {
label = label,
stored = v.stored,
model = props.model,
vehicleProps = props
})
end

ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_garage', {
title    = _U('garage_title'),
align    = 'bottom-right',
elements = garage
}, function(data2, menu2)
if data2.current.stored then
local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(station, part, partNum)

if foundSpawn then
menu2.close()

ESX.Game.SpawnVehicle(data2.current.model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
ESX.Game.SetVehicleProperties(vehicle, data2.current.vehicleProps)
--SetVehicleMod(vehicle, 12, 2)
--SetVehicleMod(vehicle, 13, 3)
--SetVehicleMod(vehicle, 17, 4)
SetVehicleExtra(vehicle, 1, 0)
SetVehicleExtra(vehicle, 2, 0)
SetVehicleExtra(vehicle, 3, 0)
SetVehicleExtra(vehicle, 4, 0)
SetVehicleExtra(vehicle, 5, 0)
SetVehicleExtra(vehicle, 6, 0)
SetVehicleExtra(vehicle, 7, 0)
SetVehicleExtra(vehicle, 8, 0)
SetVehicleExtra(vehicle, 9, 0)
SetVehicleExtra(vehicle, 10, 0)
SetVehicleExtra(vehicle, 11, 0)
SetVehicleExtra(vehicle, 12, 0)
SetVehicleExtra(vehicle, 13, 0)
SetVehicleExtra(vehicle, 14, 0)
SetVehicleDirtLevel(vehicle, 0.1)
TriggerServerEvent('esx_vehicleshop:setJobVehicleState', data2.current.vehicleProps.plate, true)

local plate = GetVehicleNumberPlateText(vehicle)
TriggerServerEvent('garage:addKeys', plate)
isPolice = true

ESX.ShowNotification(_U('garage_released'))
end)
end
else
ESX.ShowNotification(_U('garage_notavailable'))
end
end, function(data2, menu2)
menu2.close()
end)
else
ESX.ShowNotification(_U('garage_empty'))
end
end, type)
elseif data.current.action == 'store_garage' then
StoreNearbyVehicle(playerCoords)
end
end, function(data, menu)
menu.close()
end)
end

function StoreNearbyVehicle(playerCoords)
local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 30.0), {}

if #vehicles > 0 then
for k,v in ipairs(vehicles) do

-- Make sure the vehicle we're saving is empty, or else it wont be deleted
if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then
table.insert(vehiclePlates, {
vehicle = v,
plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))
})
end
end
else
ESX.ShowNotification(_U('garage_store_nearby'))
return
end

ESX.TriggerServerCallback('esx_policejob:storeNearbyVehicle', function(storeSuccess, foundNum)
if storeSuccess then
local vehicleId = vehiclePlates[foundNum]
local attempts = 0
ESX.Game.DeleteVehicle(vehicleId.vehicle)
IsBusy = true

Citizen.CreateThread(function()
BeginTextCommandBusyString('STRING')
AddTextComponentSubstringPlayerName(_U('garage_storing'))
EndTextCommandBusyString(4)

while IsBusy do
Citizen.Wait(100)
end

RemoveLoadingPrompt()
end)

-- Workaround for vehicle not deleting when other players are near it.
while DoesEntityExist(vehicleId.vehicle) do
Citizen.Wait(500)
attempts = attempts + 1

-- Give up
if attempts > 30 then
break
end

vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)
if #vehicles > 0 then
for k,v in ipairs(vehicles) do
if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehicleId.plate then
ESX.Game.DeleteVehicle(v)
break
end
end
end
end

IsBusy = false
ESX.ShowNotification(_U('garage_has_stored'))
else
ESX.ShowNotification(_U('garage_has_notstored'))
end
end, vehiclePlates)
end

function GetAvailableVehicleSpawnPoint(station, part, partNum)
local spawnPoints = Config.PoliceStations[station][part][partNum].SpawnPoints
local found, foundSpawnPoint = false, nil

for i=1, #spawnPoints, 1 do
if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
found, foundSpawnPoint = true, spawnPoints[i]
break
end
end

if found then
return true, foundSpawnPoint
else
ESX.ShowNotification(_U('vehicle_blocked'))
return false
end
end

function OpenShopMenu(elements, restoreCoords, shopCoords)
local playerPed = PlayerPedId()
isInShopMenu = true

ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
title    = _U('vehicleshop_title'),
align    = 'bottom-right',
elements = elements
}, function(data, menu)
ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {
title    = _U('vehicleshop_confirm', data.current.name, data.current.price),
align    = 'bottom-right',
elements = {
{label = _U('confirm_no'), value = 'no'},
{label = _U('confirm_yes'), value = 'yes'}
}}, function(data2, menu2)
if data2.current.value == 'yes' then
local newPlate = exports['esx_vehicleshop']:GeneratePlate()
local vehicle  = GetVehiclePedIsIn(playerPed, false)
local props    = ESX.Game.GetVehicleProperties(vehicle)
props.plate    = newPlate

ESX.TriggerServerCallback('esx_policejob:buyJobVehicle', function (bought)
if bought then
ESX.ShowNotification(_U('vehicleshop_bought', data.current.name, ESX.Math.GroupDigits(data.current.price)))

isInShopMenu = false
ESX.UI.Menu.CloseAll()
DeleteSpawnedVehicles()
FreezeEntityPosition(playerPed, false)
SetEntityVisible(playerPed, true)

ESX.Game.Teleport(playerPed, restoreCoords)
else
ESX.ShowNotification(_U('vehicleshop_money'))
menu2.close()
end
end, props, data.current.type)
else
menu2.close()
end
end, function(data2, menu2)
menu2.close()
end)
end, function(data, menu)
isInShopMenu = false
ESX.UI.Menu.CloseAll()

DeleteSpawnedVehicles()
FreezeEntityPosition(playerPed, false)
SetEntityVisible(playerPed, true)

ESX.Game.Teleport(playerPed, restoreCoords)
end, function(data, menu)
DeleteSpawnedVehicles()
WaitForVehicleToLoad(data.current.model)

ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
table.insert(spawnedVehicles, vehicle)
TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
FreezeEntityPosition(vehicle, true)
SetModelAsNoLongerNeeded(data.current.model)

if data.current.livery then
SetVehicleModKit(vehicle, 0)
SetVehicleLivery(vehicle, data.current.livery)
end
end)
end)

WaitForVehicleToLoad(elements[1].model)
ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
table.insert(spawnedVehicles, vehicle)
TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
FreezeEntityPosition(vehicle, true)
SetModelAsNoLongerNeeded(elements[1].model)

if elements[1].livery then
SetVehicleModKit(vehicle, 0)
SetVehicleLivery(vehicle, elements[1].livery)
end
end)
end

Citizen.CreateThread(function()
while true do
Citizen.Wait(0)

if isInShopMenu then
DisableControlAction(0, 75, true)  -- Disable exit vehicle
DisableControlAction(27, 75, true) -- Disable exit vehicle
else
Citizen.Wait(500)
end
end
end)

function DeleteSpawnedVehicles()
while #spawnedVehicles > 0 do
local vehicle = spawnedVehicles[1]
ESX.Game.DeleteVehicle(vehicle)
table.remove(spawnedVehicles, 1)
end
end

function WaitForVehicleToLoad(modelHash)
modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

if not HasModelLoaded(modelHash) then
RequestModel(modelHash)

BeginTextCommandBusyString('STRING')
AddTextComponentSubstringPlayerName(_U('vehicleshop_awaiting_model'))
EndTextCommandBusyString(4)

while not HasModelLoaded(modelHash) do
Citizen.Wait(0)
DisableAllControlActions(0)
end

RemoveLoadingPrompt()
end
end
]]
--
--[[function OpenPoliceActionsMenu()
    ESX.UI.Menu.CloseAll()
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions', {
        title = 'Police',
        align = 'bottom-right',
        elements = {
            --{label = "MDT System", value = 'mdt'},
            {label = _U('citizen_interaction'), value = 'citizen_interaction'},
            {label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
            {label = _U('object_spawner'), value = 'object_spawner'},
            {label = "Jail Menu", value = 'jail_menu'},
            {label = "Police K9", value = 'police_k9'},
            {label = "Deploy spikes", value = 'spikes'}
        
        
        }}, function(data, menu)
        if data.current.value == 'jail_menu' then
            TriggerEvent("esx-qalle-jail:openJailMenu")
        end
        if data.current.value == 'spikes' then
            TriggerEvent('c_setSpike', source)
        end
        if data.current.value == 'police_k9' then
            TriggerEvent('esx_policedog:openMenu')
        end
        
        
        if data.current.value == 'citizen_interaction' then
            local elements = {
                {label = _U('id_card'), value = 'identity_card'},
                {label = "Revive Player", value = 'pd_revive'},
                {label = "GSR Test", value = 'gsr_test'},
                {label = _U('search'), value = 'body_search'},
                {label = _U('handcuff'), value = 'handcuff'},
                {label = "Soft Cuff", value = 'softcuff'},
                {label = _U('drag'), value = 'drag'},
                {label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
                {label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
                {label = _U('fine'), value = 'fine'},
                {label = _U('unpaid_bills'), value = 'unpaid_bills'},
            --{label = "Give licence", value = 'give_licence'}
            }
            
            
            if Config.EnableLicenses then
                table.insert(elements, {label = _U('license_check'), value = 'license'})
            end
            
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
                title = _U('citizen_interaction'),
                align = 'bottom-right',
                elements = elements
            }, function(data2, menu2)
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    local action = data2.current.value
                    
                    if action == 'identity_card' then
                        OpenIdentityCardMenu(closestPlayer)
                    elseif action == 'pd_revive' then
                        TriggerServerEvent('tp_ambulancejob:revivePD', GetPlayerServerId(closestPlayer))
                    elseif action == 'body_search' then
                        TriggerServerEvent('esx_policejob:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
                        TriggerServerEvent("people-search", GetPlayerServerId(closestPlayer))
                    --OpenBodySearchMenu(closestPlayer)
                    elseif action == 'handcuff' then
                        TriggerServerEvent('tp_policejob:handcuff', GetPlayerServerId(closestPlayer))
                    elseif action == 'softcuff' then
                        TriggerServerEvent('tp_policejob:handcuffsoft', GetPlayerServerId(closestPlayer))
                    elseif action == 'drag' then
                        TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
                    elseif action == 'put_in_vehicle' then
                        local playerPed = PlayerPedId()
                        local coords = GetEntityCoords(playerPed)
                        
                        
                        local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
                        
                        local lockStatus = GetVehicleDoorLockStatus(vehicle)
                        if lockStatus == 2 then
                            exports['mythic_notify']:SendAlert('inform', 'Your vehicle is locked!', 12000)
                        else
                            TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
                        end
                    elseif action == 'out_the_vehicle' then
                        TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
                    elseif action == 'fine' then
                        OpenFineMenu(closestPlayer)
                    elseif action == 'license' then
                        ShowPlayerLicense(closestPlayer)
                    elseif action == 'give_licence' then
                        GivePlayerWeaponLicense(closestPlayer)
                    elseif action == 'unpaid_bills' then
                        OpenUnpaidBillsMenu(closestPlayer)
                    elseif action == 'gsr_test' then
                        TriggerServerEvent('GSR:Status2', GetPlayerServerId(closestPlayer))
                    end
                else
                    ESX.ShowNotification(_U('no_players_nearby'))
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 'vehicle_interaction' then
            local elements = {}
            local playerPed = PlayerPedId()
            local vehicle = ESX.Game.GetVehicleInDirection()
            
            if DoesEntityExist(vehicle) then
                table.insert(elements, {label = _U('vehicle_info'), value = 'vehicle_infos'})
                table.insert(elements, {label = _U('pick_lock'), value = 'hijack_vehicle'})
                table.insert(elements, {label = _U('impound'), value = 'impound'})
            end
            
            table.insert(elements, {label = _U('search_database'), value = 'search_database'})
            
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
                title = _U('vehicle_interaction'),
                align = 'bottom-right',
                elements = elements
            }, function(data2, menu2)
                local coords = GetEntityCoords(playerPed)
                vehicle = ESX.Game.GetVehicleInDirection()
                action = data2.current.value
                
                if action == 'search_database' then
                    LookupVehicle()
                elseif DoesEntityExist(vehicle) then
                    if action == 'vehicle_infos' then
                        local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
                        OpenVehicleInfosMenu(vehicleData)
                    elseif action == 'hijack_vehicle' then
                        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
                            TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
                            Citizen.Wait(10000)
                            ClearPedTasksImmediately(playerPed)
                            
                            SetVehicleDoorsLocked(vehicle, 1)
                            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                            ESX.ShowNotification(_U('vehicle_unlocked'))
                        end
                    elseif action == 'impound' then
                        TriggerEvent('tp_impound:impounded', source)
                    --TriggerEvent('esx_impound:impound_nearest_vehicle', source)
                    end
                end
            
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 'object_spawner' then
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
                title = _U('traffic_interaction'),
                align = 'bottom-right',
                elements = {
                    {label = _U('cone'), model = 'prop_roadcone02a'},
                    {label = _U('barrier'), model = 'prop_barrier_work05'},
                --{label = _U('spikestrips'), model = 'p_ld_stinger_s'},
                --{label = _U('box'), model = 'prop_boxpile_07d'},
                --{label = _U('cash'), model = 'hei_prop_cash_crate_half_full'}
                }}, function(data2, menu2)
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local forward = GetEntityForwardVector(playerPed)
                local x, y, z = table.unpack(coords + forward * 1.0)
                
                if data2.current.model == 'prop_roadcone02a' then
                    z = z - 1.0
                end
                
                ESX.Game.SpawnObject(data2.current.model, {x = x, y = y, z = z}, function(obj)
                    SetEntityHeading(obj, GetEntityHeading(playerPed))
                    PlaceObjectOnGroundProperly(obj)
                end)
                end, function(data2, menu2)
                    menu2.close()
                end)
        end
        end, function(data, menu)
            menu.close()
        end)
end

function OpenIdentityCardMenu(player)
    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
        local elements = {}
        local nameLabel = _U('name', data.name)
        local jobLabel, sexLabel, dobLabel, heightLabel, idLabel
        
        if data.job.grade_label and data.job.grade_label ~= '' then
            jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
        else
            jobLabel = _U('job', data.job.label)
        end
        
        if Config.EnableESXIdentity then
            nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)
            
            if data.sex then
                if string.lower(data.sex) == 'm' then
                    sexLabel = _U('sex', _U('male'))
                else
                    sexLabel = _U('sex', _U('female'))
                end
            else
                sexLabel = _U('sex', _U('unknown'))
            end
            
            if data.dob then
                dobLabel = _U('dob', data.dob)
            else
                dobLabel = _U('dob', _U('unknown'))
            end
            
            if data.height then
                heightLabel = _U('height', data.height)
            else
                heightLabel = _U('height', _U('unknown'))
            end
            
            if data.name then
                idLabel = _U('id', data.name)
            else
                idLabel = _U('id', _U('unknown'))
            end
        end
        
        local elements = {
            {label = nameLabel},
            {label = jobLabel}
        }
        
        if Config.EnableESXIdentity then
            table.insert(elements, {label = sexLabel})
            table.insert(elements, {label = dobLabel})
            table.insert(elements, {label = heightLabel})
            table.insert(elements, {label = idLabel})
        end
        
        if data.drunk then
            table.insert(elements, {label = _U('bac', data.drunk)})
        end
        
        if data.licenses then
            table.insert(elements, {label = _U('license_label')})
            
            for i = 1, #data.licenses, 1 do
                table.insert(elements, {label = data.licenses[i].label})
            end
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
            title = _U('citizen_interaction'),
            align = 'bottom-right',
            elements = elements
        }, nil, function(data, menu)
            menu.close()
        end)
    end, GetPlayerServerId(player))
end

function OpenBodySearchMenu(player)
    TriggerEvent("esx_inventoryhud:openPlayerInventory", GetPlayerServerId(player), GetPlayerName(player))
end]]--


--[[function OpenFineMenu(player)
ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine', {
title    = _U('fine'),
align    = 'bottom-right',
elements = {
{label = _U('traffic_offense'), value = 0},
{label = _U('minor_offense'),   value = 1},
{label = _U('average_offense'), value = 2},
{label = _U('major_offense'),   value = 3}
}}, function(data, menu)
OpenFineCategoryMenu(player, data.current.value)
end, function(data, menu)
menu.close()
end)
end

function OpenFineCategoryMenu(player, category)
ESX.TriggerServerCallback('esx_policejob:getFineList', function(fines)
local elements = {}

for k,fine in ipairs(fines) do
table.insert(elements, {
label     = ('%s <span style="color:green;">%s</span>'):format(fine.label, _U('armory_item', ESX.Math.GroupDigits(fine.amount))),
value     = fine.id,
amount    = fine.amount,
fineLabel = fine.label
})
end

ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category', {
title    = _U('fine'),
align    = 'bottom-right',
elements = elements
}, function(data, menu)
menu.close()

if Config.EnablePlayerManagement then
TriggerServerEvent('tp_billing:sendBill', GetPlayerServerId(player), 'society_police', _U('fine_total', data.current.fineLabel), data.current.amount)
else
TriggerServerEvent('tp_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total', data.current.fineLabel), data.current.amount)
end

ESX.SetTimeout(300, function()
OpenFineCategoryMenu(player, category)
end)
end, function(data, menu)
menu.close()
end)
end, category)
end]]
--
--[[function LookupVehicle()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle',
        {
            title = _U('search_database_title'),
        }, function(data, menu)
            local length = string.len(data.value)
            if data.value == nil or length < 2 or length > 13 then
                ESX.ShowNotification(_U('search_database_error_invalid'))
            else
                ESX.TriggerServerCallback('esx_policejob:getVehicleFromPlate', function(owner, found)
                    if found then
                        ESX.ShowNotification(_U('search_database_found', owner))
                    else
                        ESX.ShowNotification(_U('search_database_error_not_found'))
                    end
                end, data.value)
                menu.close()
            end
        end, function(data, menu)
            menu.close()
        end)
end


function OpenUnpaidBillsMenu(player)
    local elements = {}
    
    ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
        for k, bill in ipairs(bills) do
            table.insert(elements, {
                label = ('%s - <span style="color:red;">%s</span>'):format(bill.label, _U('armory_item', ESX.Math.GroupDigits(bill.amount))),
                billId = bill.id
            })
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing', {
            title = _U('unpaid_bills'),
            align = 'bottom-right',
            elements = elements
        }, nil, function(data, menu)
            menu.close()
        end)
    end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)
    ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)
        local elements = {{label = _U('plate', retrivedInfo.plate)}}
        
        if retrivedInfo.owner == nil then
            table.insert(elements, {label = _U('owner_unknown')})
        else
            table.insert(elements, {label = _U('owner', retrivedInfo.owner)})
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
            title = _U('vehicle_info'),
            align = 'bottom-right',
            elements = elements
        }, nil, function(data, menu)
            menu.close()
        end)
    end, vehicleData.plate)
end]]--

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    
    Citizen.Wait(5000)
    TriggerServerEvent('esx_policejob:forceBlip')
end)



--[[AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)
if part == 'Cloakroom' then
CurrentAction     = 'menu_cloakroom'
CurrentActionMsg  = _U('open_cloackroom')
CurrentActionData = {}
--elseif part == 'Armory' then
--	CurrentAction     = 'menu_armory'
--	CurrentActionMsg  = _U('open_armory')
--	CurrentActionData = {station = station}
elseif part == 'Vehicles' then
CurrentAction     = 'menu_vehicle_spawner'
CurrentActionMsg  = _U('garage_prompt')
CurrentActionData = {station = station, part = part, partNum = partNum}
elseif part == 'Helicopters' then
CurrentAction     = 'Helicopters'
CurrentActionMsg  = _U('helicopter_prompt')
CurrentActionData = {station = station, part = part, partNum = partNum}
elseif part == 'BossActions' then
CurrentAction     = 'menu_boss_actions'
CurrentActionMsg  = _U('open_bossmenu')
CurrentActionData = {}
end
end)]]
--
AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
    if not isInShopMenu then
        ESX.UI.Menu.CloseAll()
    end
    
    CurrentAction = nil
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)
    local playerPed = PlayerPedId()
    
    if PlayerData.job and PlayerData.job.name == 'police' and IsPedOnFoot(playerPed) then
        CurrentAction = 'remove_entity'
        CurrentActionMsg = _U('remove_prop')
        CurrentActionData = {entity = entity}
    end
    
    if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed)
            
            for i = 0, 7, 1 do
                SetVehicleTyreBurst(vehicle, i, true, 250)
            end
        end
    end
end)

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)
    if CurrentAction == 'remove_entity' then
        CurrentAction = nil
    end
end)

RegisterNetEvent('tp_policejob:handcuff')
AddEventHandler('tp_policejob:handcuff', function()
    local finished = exports["sway_skillbar"]:taskBar(1200, 7)
    if finished ~= 100 then
        TriggerEvent('notification', 'Failed to resist...', 2)
        isHandcuffed = not isHandcuffed
    else
        TriggerEvent('notification', 'You have resisted, NOW RUN')
    end
    --isHandcuffed = not isHandcuffed
    local playerPed = PlayerPedId()
    
    Citizen.CreateThread(function()
        if isHandcuffed then
            
            RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
                Citizen.Wait(100)
            end
            
            TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            
            SetEnableHandcuffs(playerPed, true)
            DisablePlayerFiring(playerPed, true)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)-- unarm player
            SetPedCanPlayGestureAnims(playerPed, false)
            FreezeEntityPosition(playerPed, true)
            DisplayRadar(false)
            
            if Config.EnableHandcuffTimer then
                if handcuffTimer.active then
                    ESX.ClearTimeout(handcuffTimer.task)
                end
                
                StartHandcuffTimer()
            end
        else
            Wait(1000)
        end
    end)
end)

RegisterNetEvent('police:cuffTransition')
AddEventHandler('police:cuffTransition', function()
    loadAnimDict("mp_arrest_paired")
    Citizen.Wait(100)
    TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "cop_p2_back_right", 8.0, -8, -1, 48, 0, 0, 0, 0)
    Citizen.Wait(3500)
    ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNetEvent('tp_policejob:uncuff')
AddEventHandler('tp_policejob:uncuff', function()
    isHandcuffed = not isHandcuffed
    local playerPed = PlayerPedId()
    
    Citizen.CreateThread(function()
        if Config.EnableHandcuffTimer and handcuffTimer.active then
            ESX.ClearTimeout(handcuffTimer.task)
        end
        
        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        DisablePlayerFiring(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed, true)
        FreezeEntityPosition(playerPed, false)
        DisplayRadar(true)
    end)
end)

RegisterNetEvent('tp_policejob:softcuff')
AddEventHandler('tp_policejob:softcuff', function()
    local finished = exports["sway_skillbar"]:taskBar(1000, math.random(5, 15))
    if finished ~= 100 then
        TriggerEvent('notification', 'failed to resist...', 2)
        isHandcuffed = not isHandcuffed
    else
        TriggerEvent('notification', 'you have resisted, NOW RUN')
    
    end
    --isHandcuffed = not isHandcuffed
    local playerPed = PlayerPedId()
    
    Citizen.CreateThread(function()
        if isHandcuffed then
            
            RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
                Citizen.Wait(100)
            end
            
            TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            
            SetEnableHandcuffs(playerPed, true)
            DisablePlayerFiring(playerPed, true)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)-- unarm player
            SetPedCanPlayGestureAnims(playerPed, false)
            --FreezeEntityPosition(playerPed, true)
            DisplayRadar(false)
            
            if Config.EnableHandcuffTimer then
                if handcuffTimer.active then
                    ESX.ClearTimeout(handcuffTimer.task)
                end
                
                StartHandcuffTimer()
            end
        else
            Wait(1000)
        end
    end)
end)

RegisterNetEvent('esx_policejob:unrestrain')
AddEventHandler('esx_policejob:unrestrain', function()
    if isHandcuffed then
        local playerPed = PlayerPedId()
        isHandcuffed = false
        
        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        DisablePlayerFiring(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed, true)
        FreezeEntityPosition(playerPed, false)
        DisplayRadar(true)
        
        -- end timer
        if Config.EnableHandcuffTimer and handcuffTimer.active then
            ESX.ClearTimeout(handcuffTimer.task)
        end
    end
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(copId)
    if not isHandcuffed then
        return
    end
    
    dragStatus.isDragged = not dragStatus.isDragged
    dragStatus.CopId = copId
end)

Citizen.CreateThread(function()
    local playerPed
    local targetPed
    
    while true do
        Citizen.Wait(1)
        
        if isHandcuffed then
            playerPed = PlayerPedId()
            
            if dragStatus.isDragged then
                targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))
                
                -- undrag if target is in an vehicle
                if not IsPedSittingInAnyVehicle(targetPed) then
                    AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                else
                    dragStatus.isDragged = false
                    DetachEntity(playerPed, true, false)
                end
                
                if IsPedDeadOrDying(targetPed, true) then
                    dragStatus.isDragged = false
                    DetachEntity(playerPed, true, false)
                end
            
            else
                DetachEntity(playerPed, true, false)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    if not isHandcuffed then
        return
    end
    
    if IsAnyVehicleNearPoint(coords, 5.0) then
        local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
        
        if DoesEntityExist(vehicle) then
            local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
            
            for i = maxSeats - 1, 0, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    freeSeat = i
                    break
                end
            end
            
            if freeSeat then
                TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
                dragStatus.isDragged = false
            end
        end
    end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function()
    local playerPed = PlayerPedId()
    
    if not IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    TaskLeaveVehicle(playerPed, vehicle, 16)
end)

-- Handcuff
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        
        if isHandcuffed then
            --DisableControlAction(0, 1, true) -- Disable pan
            --DisableControlAction(0, 2, true) -- Disable tilt
            DisableControlAction(0, 24, true)-- Attack
            DisableControlAction(0, 257, true)-- Attack 2
            DisableControlAction(0, 25, true)-- Aim
            DisableControlAction(0, 263, true)-- Melee Attack 1
            --DisableControlAction(0, 32, true) -- W
            DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
            DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
            --DisableControlAction(0, 34, true) -- A
            --DisableControlAction(0, 31, true) -- S
            --DisableControlAction(0, 30, true) -- D
            DisableControlAction(0, 45, true)-- Reload
            DisableControlAction(0, 22, true)-- Jump
            DisableControlAction(0, 44, true)-- Cover
            DisableControlAction(0, 37, true)-- Select Weapon
            DisableControlAction(0, 23, true)-- Also 'enter'?
            
            DisableControlAction(0, 288, true)-- Disable phone
            DisableControlAction(0, 289, true)-- Inventory
            DisableControlAction(0, 170, true)-- Animations
            DisableControlAction(0, 167, true)-- Job
            
            --DisableControlAction(0, 0, true) -- Disable changing view
            --DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true)-- Disable clearing animation
            DisableControlAction(2, 199, true)-- Disable pause screen
            
            DisableControlAction(0, 59, true)-- Disable steering in vehicle
            DisableControlAction(0, 71, true)-- Disable driving forward in vehicle
            DisableControlAction(0, 72, true)-- Disable reversing in vehicle
            
            DisableControlAction(2, 36, true)-- Disable going stealth
            
            DisableControlAction(0, 47, true)-- Disable weapon
            DisableControlAction(0, 264, true)-- Disable melee
            DisableControlAction(0, 257, true)-- Disable melee
            DisableControlAction(0, 140, true)-- Disable melee
            DisableControlAction(0, 141, true)-- Disable melee
            DisableControlAction(0, 142, true)-- Disable melee
            DisableControlAction(0, 143, true)-- Disable melee
            DisableControlAction(0, 75, true)-- Disable exit vehicle
            DisableControlAction(27, 75, true)-- Disable exit vehicle
            
            DisableControlAction(0, 15, true)-- ALT
            DisableControlAction(0, 246, true)-- Y
            
            if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
                ESX.Streaming.RequestAnimDict('mp_arresting', function()
                    TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
                end)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- Handcuff
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        
        if isSoftcuffed then
            --DisableControlAction(0, 1, true) -- Disable pan
            --DisableControlAction(0, 2, true) -- Disable tilt
            DisableControlAction(0, 24, true)-- Attack
            DisableControlAction(0, 257, true)-- Attack 2
            DisableControlAction(0, 25, true)-- Aim
            DisableControlAction(0, 263, true)-- Melee Attack 1
            DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
            DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
            --DisableControlAction(0, 32, true) -- W
            --DisableControlAction(0, 34, true) -- A
            --DisableControlAction(0, 31, true) -- S
            --DisableControlAction(0, 30, true) -- D
            DisableControlAction(0, 45, true)-- Reload
            DisableControlAction(0, 22, true)-- Jump
            DisableControlAction(0, 44, true)-- Cover
            DisableControlAction(0, 37, true)-- Select Weapon
            DisableControlAction(0, 23, true)-- Also 'enter'?
            
            DisableControlAction(0, 288, true)-- Disable phone
            DisableControlAction(0, 289, true)-- Inventory
            DisableControlAction(0, 170, true)-- Animations
            DisableControlAction(0, 167, true)-- Job
            
            --DisableControlAction(0, 0, true) -- Disable changing view
            --DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true)-- Disable clearing animation
            DisableControlAction(2, 199, true)-- Disable pause screen
            
            DisableControlAction(0, 59, true)-- Disable steering in vehicle
            DisableControlAction(0, 71, true)-- Disable driving forward in vehicle
            DisableControlAction(0, 72, true)-- Disable reversing in vehicle
            
            DisableControlAction(2, 36, true)-- Disable going stealth
            
            DisableControlAction(0, 47, true)-- Disable weapon
            DisableControlAction(0, 264, true)-- Disable melee
            DisableControlAction(0, 257, true)-- Disable melee
            DisableControlAction(0, 140, true)-- Disable melee
            DisableControlAction(0, 141, true)-- Disable melee
            DisableControlAction(0, 142, true)-- Disable melee
            DisableControlAction(0, 143, true)-- Disable melee
            --DisableControlAction(0, 75, true)  -- Disable exit vehicle
            --DisableControlAction(27, 75, true) -- Disable exit vehicle
            DisableControlAction(0, 15, true)-- ALT
            DisableControlAction(0, 246, true)-- Y
            
            if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
                ESX.Streaming.RequestAnimDict('mp_arresting', function()
                    TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
                end)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- Display markers
--[[Citizen.CreateThread(function()
while true do
Citizen.Wait(0)

if PlayerData.job and PlayerData.job.name == 'police' then

local playerPed = PlayerPedId()
local coords    = GetEntityCoords(playerPed)
local isInMarker, hasExited, letSleep = false, false, true
local currentStation, currentPart, currentPartNum

for k,v in pairs(Config.PoliceStations) do


for i=1, #v.Vehicles, 1 do
local distance = GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner, true)

if distance < Config.DrawDistance then
DrawMarker(27, v.Vehicles[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, false, 2, false, false, false, false)
letSleep = false
end

if distance < 2.2 then
isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
end
end

for i=1, #v.Helicopters, 1 do
local distance =  GetDistanceBetweenCoords(coords, v.Helicopters[i].Spawner, true)

if distance < Config.DrawDistance then
DrawMarker(27, v.Helicopters[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, false, 2, false, false, false, false)
letSleep = false
end

if distance < 2.2 then
isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Helicopters', i
end
end

if Config.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
for i=1, #v.BossActions, 1 do
local distance = GetDistanceBetweenCoords(coords, v.BossActions[i], true)

if distance < Config.DrawDistance then
DrawMarker(22, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, false, 2, true, false, false, false)
letSleep = false
end

if distance < 2.2 then
isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
end
end
end
end

if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
if
(LastStation and LastPart and LastPartNum) and
(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
then
TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
hasExited = true
end

HasAlreadyEnteredMarker = true
LastStation             = currentStation
LastPart                = currentPart
LastPartNum             = currentPartNum

TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
end

if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
HasAlreadyEnteredMarker = false
TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
end

if letSleep then
Citizen.Wait(500)
end

else
Citizen.Wait(500)
end
end
end)]]
--
-- Enter / Exit entity zone events
--[[Citizen.CreateThread(function()
    local trackedEntities = {
        'prop_roadcone02a',
        'prop_barrier_work05',
        'p_ld_stinger_s',
        'prop_boxpile_07d',
        'hei_prop_cash_crate_half_full'
    }
    
    while true do
        Citizen.Wait(500)
        
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        local closestDistance = -1
        local closestEntity = nil
        
        for i = 1, #trackedEntities, 1 do
            local object = GetClosestObjectOfType(coords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)
            
            if DoesEntityExist(object) then
                local objCoords = GetEntityCoords(object)
                local distance = GetDistanceBetweenCoords(coords, objCoords, true)
                
                if closestDistance == -1 or closestDistance > distance then
                    closestDistance = distance
                    closestEntity = object
                end
            end
        end
        
        if closestDistance ~= -1 and closestDistance <= 3.0 then
            if LastEntity ~= closestEntity then
                TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
                LastEntity = closestEntity
            end
        else
            if LastEntity then
                TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
                LastEntity = nil
            end
        end
    end
end)]]--

-- Key Controls
--[[Citizen.CreateThread(function()
while true do
Citizen.Wait(0)

if CurrentAction then
ESX.ShowHelpNotification(CurrentActionMsg)

if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'police' then

if CurrentAction == 'menu_cloakroom' then
OpenCloakroomMenu()
elseif CurrentAction == 'menu_armory' then
if Config.MaxInService == -1 then
OpenArmoryMenu(CurrentActionData.station)
elseif playerInService then
OpenArmoryMenu(CurrentActionData.station)
else
ESX.ShowNotification(_U('service_not'))
end
elseif CurrentAction == 'menu_vehicle_spawner' then
if Config.MaxInService == -1 then
OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
elseif playerInService then
OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
else
ESX.ShowNotification(_U('service_not'))
end
elseif CurrentAction == 'Helicopters' then
if Config.MaxInService == -1 then
OpenVehicleSpawnerMenu('helicopter', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
elseif playerInService then
OpenVehicleSpawnerMenu('helicopter', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
else
ESX.ShowNotification(_U('service_not'))
end
elseif CurrentAction == 'delete_vehicle' then
ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
elseif CurrentAction == 'menu_boss_actions' then
ESX.UI.Menu.CloseAll()
TriggerEvent('society:openBossMenu', 'police', function(data, menu)
menu.close()

CurrentAction     = 'menu_boss_actions'
CurrentActionMsg  = _U('open_bossmenu')
CurrentActionData = {}
end, { wash = true }) -- disable washing money
elseif CurrentAction == 'remove_entity' then
DeleteEntity(CurrentActionData.entity)
end

CurrentAction = nil
end
end -- CurrentAction end

if IsControlJustReleased(0, 167) and not IsDead and PlayerData.job and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') then
if Config.MaxInService == -1 then
OpenPoliceActionsMenu()
elseif playerInService then
OpenPoliceActionsMenu()
else
ESX.ShowNotification(_U('service_not'))
end
end

if IsControlJustReleased(0, 38) and currentTask.busy then
ESX.ShowNotification(_U('impound_canceled'))
ESX.ClearTimeout(currentTask.task)
ClearPedTasks(PlayerPedId())

currentTask.busy = false
end
end
end)]]
--
AddEventHandler('playerSpawned', function(spawn)
    isDead = false
    TriggerEvent('esx_policejob:unrestrain')
    
    if not hasAlreadyJoined then
        TriggerServerEvent('sway_policejob:spawned')
    end
    hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        TriggerEvent('esx_policejob:unrestrain')
        
        
        if Config.EnableHandcuffTimer and handcuffTimer.active then
            ESX.ClearTimeout(handcuffTimer.task)
        end
    end
end)

-- handcuff timer, unrestrain the player after an certain amount of time
function StartHandcuffTimer()
    if Config.EnableHandcuffTimer and handcuffTimer.active then
        ESX.ClearTimeout(handcuffTimer.task)
    end
    
    handcuffTimer.active = true
    
    handcuffTimer.task = ESX.SetTimeout(Config.HandcuffTimer, function()
        ESX.ShowNotification(_U('unrestrained_timer'))
        TriggerEvent('esx_policejob:unrestrain')
        handcuffTimer.active = false
    end)
end

-- TODO
--   - return to garage if owned
--   - message owner that his vehicle has been impounded
function ImpoundVehicle(vehicle)
    --local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    ESX.Game.DeleteVehicle(vehicle)
    ESX.ShowNotification(_U('impound_successful'))
    currentTask.busy = false
end




RegisterNetEvent('c_setSpike')
AddEventHandler('c_setSpike', function()
    SetSpikesOnGround()
end)

local usingSpikes = false

function SetSpikesOnGround()
    x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    
    spike = GetHashKey("P_ld_stinger_s")
    
    RequestModel(spike)
    while not HasModelLoaded(spike) do
        Citizen.Wait(1)
    end
    
    exports['mythic_notify']:SendAlert('inform', 'Deploying spikes', 10000)
    doAnimation()
    Citizen.Wait(1700)
    ClearPedTasksImmediately(GetPlayerPed(-1))
    usingSpikes = true
    --FreezeEntityPosition(GetPlayerPed(-1), false)
    Citizen.Wait(250)
    local playerheading = GetEntityHeading(GetPlayerPed(-1))
    coords1 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 3, 10, -0.7)
    coords2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -5, -0.5)
    
    obj1 = CreateObject(spike, coords1['x'], coords1['y'], coords1['z'], true, true, true)
    obj2 = CreateObject(spike, coords2['x'], coords2['y'], coords2['z'], true, true, true)
    obj3 = CreateObject(spike, coords2['x'], coords2['y'], coords2['z'], true, true, true)
    SetEntityHeading(obj1, playerheading)
    SetEntityHeading(obj2, playerheading)
    SetEntityHeading(obj3, playerheading)
    
    
    AttachEntityToEntity(obj1, GetPlayerPed(-1), 1, 0.0, 4.0, 0.0, 0.0, -90.0, 0.0, true, true, false, false, 2, true)
    AttachEntityToEntity(obj2, GetPlayerPed(-1), 1, 0.0, 8.0, 0.0, 0.0, -90.0, 0.0, true, true, false, false, 2, true)
    AttachEntityToEntity(obj3, GetPlayerPed(-1), 1, 0.0, 12.0, 0.0, 0.0, -90.0, 0.0, true, true, false, false, 2, true)
    
    DetachEntity(obj1, true, true)
    DetachEntity(obj2, true, true)
    DetachEntity(obj3, true, true)
    
    PlaceObjectOnGroundProperly(obj1)
    PlaceObjectOnGroundProperly(obj2)
    PlaceObjectOnGroundProperly(obj3)
    
    local blip = AddBlipForEntity(obj2)
    SetBlipAsFriendly(blip, true)
    SetBlipSprite(blip, 238)
    BeginTextCommandSetBlipName("STRING");
    AddTextComponentString(tostring("SPIKES"))
    EndTextCommandSetBlipName(blip)

end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped, false)
        local vehCoord = GetEntityCoords(veh)
        if IsPedInAnyVehicle(ped, false) then
            if DoesObjectOfTypeExistAtCoords(vehCoord["x"], vehCoord["y"], vehCoord["z"], 0.9, -874338148, true) then
                TriggerEvent("spike:die", veh)
                RemoveSpike()
            end
        else
            Wait(1000)
        end
    end
end)

function RemoveSpike()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    local vehCoord = GetEntityCoords(veh)
    if DoesObjectOfTypeExistAtCoords(vehCoord["x"], vehCoord["y"], vehCoord["z"], 0.9, GetHashKey("P_ld_stinger_s"), true) then
        spike = GetClosestObjectOfType(vehCoord["x"], vehCoord["y"], vehCoord["z"], 0.9, GetHashKey("P_ld_stinger_s"), false, false, false)
        SetEntityAsMissionEntity(spike, true, true)
        DeleteObject(spike)
        RemoveBlip(blip)
    end
end

RegisterNetEvent("spike:die")
AddEventHandler("spike:die", function(veh)
    SetVehicleTyreBurst(veh, 0, false, 0.001)
    SetVehicleTyreBurst(veh, 45, false, 0.001)
    Citizen.Wait(40000)
    SetVehicleTyreBurst(veh, 1, false, 0.001)
    SetVehicleTyreBurst(veh, 47, false, 0.001)
    Citizen.Wait(40000)
    SetVehicleTyreBurst(veh, 2, false, 0.001)
    Citizen.Wait(40000)
    SetVehicleTyreBurst(veh, 3, false, 0.001)
    Citizen.Wait(40000)
    SetVehicleTyreBurst(veh, 4, false, 0.001)
    Citizen.Wait(40000)
    SetVehicleTyreBurst(veh, 5, false, 0.001)
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function doAnimation()
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    
    --FreezeEntityPosition(ped, true)
    loadAnimDict("pickup_object")
    TaskPlayAnim(ped, "pickup_object", "pickup_low", 1.0, 1, -1, 33, 0, 0, 0, 0)
end

function GetPlayers()
    local Players = {}
    
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(Players, i)
        end
    end
    
    return Players
end

function GetTouchedPlayers()
    local TouchedPlayer = {}
    for Key, Value in ipairs(GetPlayers()) do
        if IsEntityTouchingEntity(PlayerPedId(), GetPlayerPed(Value)) then
            table.insert(TouchedPlayer, Value)
        end
    end
    return TouchedPlayer
end

RegisterNetEvent("tp:checkGSR")
AddEventHandler("tp:checkGSR", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('GSR:Status2', GetPlayerServerId(closestPlayer))
    else
        TriggerServerEvent("tp:addChatSystem", "No players nearby")
    end
end)

RegisterNetEvent("tp:openmdt")
AddEventHandler("tp:openmdt", function()
    TriggerServerEvent("mdt:hotKeyOpen")
end)

RegisterNetEvent("tp:escort")
AddEventHandler("tp:escort", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
    else
        ESX.ShowNotification(_U('no_players_nearby'))
    --TriggerServerEvent("tp:addChatSystem", "No players nearby")
    end
end)

RegisterNetEvent("tp:pdrevive")
AddEventHandler("tp:pdrevive", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        loadAnimDict( "amb@medic@standing@tendtodead@enter" )
        loadAnimDict( "amb@medic@standing@timeofdeath@enter" )
        loadAnimDict( "amb@medic@standing@tendtodead@idle_a" )
        loadAnimDict( "random@crash_rescue@help_victim_up" )
        local player = GetPlayerPed( -1 )
        TaskPlayAnim( player, "amb@medic@standing@tendtodead@enter", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
        Wait (1000)
        TaskPlayAnim( player, "amb@medic@standing@tendtodead@idle_a", "idle_b", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
        Wait (3000)
        TaskPlayAnim( player, "amb@medic@standing@tendtodead@exit", "exit_flee", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
        Wait (1000)
        TaskPlayAnim( player, "amb@medic@standing@timeofdeath@enter", "enter", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )  
        Wait (500)
        TaskPlayAnim( player, "amb@medic@standing@timeofdeath@enter", "helping_victim_to_feet_player", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )  
        TriggerServerEvent('tp_ambulancejob:revivePD', GetPlayerServerId(closestPlayer))
    else
        ESX.ShowNotification(_U('no_players_nearby'))
    --TriggerServerEvent("tp:addChatSystem", "No players nearby")
    end
end)

RegisterNetEvent("tp:putinvehicle")
AddEventHandler("tp:putinvehicle", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        
        local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
        
        local lockStatus = GetVehicleDoorLockStatus(vehicle)
        if lockStatus == 2 then
            exports['mythic_notify']:SendAlert('inform', 'Your vehicle is locked!', 12000)
        else
            TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
        end
    else
        --ESX.ShowNotification(_U('no_players_nearby'))
        TriggerServerEvent("tp:addChatSystem", "No players nearby")
    end
end)

RegisterNetEvent("tp:takeoutvehicle")
AddEventHandler("tp:takeoutvehicle", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
    else
        --ESX.ShowNotification(_U('no_players_nearby'))
        TriggerServerEvent("tp:addChatSystem", "No players nearby")
    end
end)

RegisterNetEvent("tp:search")
AddEventHandler("tp:search", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent("tp:addChatSystem", "You are searching a player")
        TriggerEvent('disc-inventoryhud:search', source)
    else
        --ESX.ShowNotification(_U('no_players_nearby'))
        TriggerServerEvent("tp:addChatSystem", "No players nearby")
    end
end)

RegisterNetEvent("tp:handcuff")
AddEventHandler("tp:handcuff", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 2.0 then
        TriggerEvent('police:cuffTransition')
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'handcuff', 0.4)
        TriggerServerEvent('tp_policejob:handcuff', GetPlayerServerId(closestPlayer))
    else
        --ESX.ShowNotification(_U('no_players_nearby'))
        TriggerServerEvent("tp:addChatSystem", "No players nearby")
    end
end)

RegisterNetEvent("tp:softcuff")
AddEventHandler("tp:softcuff", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 2.0 then
        TriggerEvent('police:cuffTransition')
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'handcuff', 0.4)
        TriggerServerEvent('tp_policejob:handcuffsoft', GetPlayerServerId(closestPlayer))
    else
        --ESX.ShowNotification(_U('no_players_nearby'))
        TriggerServerEvent("tp:addChatSystem", "No players nearby")
    end
end)

--Cuff hotkey thread
isdead = exports["ambulancejob"]:GetDeath()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if PlayerData.job and PlayerData.job.name == 'police' and not isdead then
            if not IsPedInAnyVehicle(PlayerPedId()) and not IsPedRunning(PlayerPedId()) then
                --shift and e == cuff
                if IsControlPressed(0, 38) and IsControlPressed(0, 209) then
                    TriggerEvent("tp:handcuff")
                    Citizen.Wait(1000)
                end
                -- shift and h = uncuff
                if IsControlPressed(0, 209) and IsControlPressed(0, 74) then
                    TriggerEvent("tp:uncuff")
                    Citizen.Wait(1000)
                end
                --sgift + k == escort
                if IsControlPressed(0, 209) and IsControlPressed(0, 311) then
                    TriggerEvent('tp:escort')
                    Citizen.Wait(1000)
                -- up arrow = Seat in nearest car
                else
                    if IsControlJustReleased(2, 172) then
                        TriggerEvent('tp:putinvehicle')
                        Citizen.Wait(1000)
                    else
                        -- down arrow = UnSeat in nearest car
                        if IsControlJustReleased(2, 173) then
                            TriggerEvent('tp:takeoutvehicle')
                            Citizen.Wait(1000)
                        end
                    end
                end
            end
        else
            Wait(1500)
        end
    end
end)

RegisterNetEvent("tp:uncuff")
AddEventHandler("tp:uncuff", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('tp_policejob:uncuff', GetPlayerServerId(closestPlayer))
    else
        --ESX.ShowNotification(_U('no_players_nearby'))
        TriggerServerEvent("tp:addChatSystem", "No players nearby")
    end
end)

RegisterNetEvent("tp:getid")
AddEventHandler("tp:getid", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        OpenIdentityCardMenu(closestPlayer)
    else
        --ESX.ShowNotification(_U('no_players_nearby'))
        TriggerServerEvent("tp:addChatSystem", "No players nearby")
    end
end)

RegisterNetEvent("tp:menuimpound")
AddEventHandler("tp:menuimpound", function()
    local coords = GetEntityCoords(playerPed)
    vehicle = ESX.Game.GetVehicleInDirection()
    
    
    if DoesEntityExist(vehicle) then
        
        TriggerEvent('tp_impound:impounded', source)
    else
        TriggerServerEvent("tp:addChatSystem", "No vehicle nearby")
    end
end)



function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 


RegisterCommand('checkbal', function()
	t, distance, closestPed = GetClosestPlayer()
    if(distance ~= -1 and distance < 7) then
        if ESX.PlayerData.job.name == 'police' then
		TriggerServerEvent("cash-checksv", GetPlayerServerId(t))
	else
		TriggerEvent("DoLongHudText", "No player near you!",2)
        end
    end
end)

RegisterNetEvent('police:checkPhone')
AddEventHandler('police:checkPhone', function()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 5) then
		TriggerServerEvent("phone:getSMSOther",GetPlayerServerId(t))
	else

		TriggerEvent("DoLongHudText", "No player near you!",2)

	end
end)

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayers(targetVector,dist)
	local players = GetPlayers()
	local ply = PlayerPedId()
	local plyCoords = targetVector
	local closestplayers = {}
	local closestdistance = {}
	local closestcoords = {}

	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
			if(distance < dist) then
				valueID = GetPlayerServerId(value)
				closestplayers[#closestplayers+1]= valueID
				closestdistance[#closestdistance+1]= distance
				closestcoords[#closestcoords+1]= {targetCoords["x"], targetCoords["y"], targetCoords["z"]}
				
			end
		end
	end
	return closestplayers, closestdistance, closestcoords
end