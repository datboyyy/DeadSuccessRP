

-----------------------------------------------------
--PLAYERSTUFF
local cmd = {}
cmd = {
    title = "Spawn Car",
    command = "scar",
    concmd = "scar",
    category = "Player",
    usage = "scar <model>",
    description = "spawn's you a car",
    ranks = {"spec"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.message then return end
    local src = caller:getVar("source")
    TriggerClientEvent("np-admin:runSpawnCommand", src, args.message)
    NPX.Admin:Log(log, caller)
end

function cmd.DrawCommand()
    cmd.vars.message = cmd.vars.message ~= nil and cmd.vars.message or nil
    
    if WarMenu.Button("Enter a model", "Model: " .. (cmd.vars.message and cmd.vars.message or "No model")) then
        NPX.Admin.Menu:ShowTextEntry("Enter a model", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end
            
            cmd.vars.message = result
        end)
    end
    if WarMenu.Button("Seat into Vehicle") then TriggerEvent("np-admin:SeatIntoLast") end
    if cmd.vars.message then if WarMenu.Button("Spawn model: " .. cmd.vars.message) then TriggerEvent('np-admin:runSpawnCommand', cmd.vars.message) end end
end

NPX.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Ban",
    command = "ban",
    concmd = "ban",
    category = "User Management",
    usage = "ban <source> <time>",
    description = "Bans selected target",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    if not args.reason then args.reason = "No Reason Given" end
    if not args.time then return end
    
    local temp, timeSum, addedTime = NPX.Admin:GetBanTimeFromString(args.time)
    
    if temp and temp ~= 0 and timeSum <= 0 then NPX.Admin:Log(string.format("%s [%s] attempted to ban %s [%s]; Invalid ban length", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))) return end
    
    local log = string.format("%s [%s] Banned player: %s [%s] | Reason: %s | Time: %s", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"), args.reason, args.time)
    NPX.Admin:Log(log, caller)
    
    NPX.Admin:BanPlayer(args.target, caller, args.time, args.reason)
    DropPlayer(args.target:getVar("source"), string.format("You were banned | Reason: %s | Length: %s", args.reason, args.time == "0" and "permanent" or args.time))
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil
    cmd.vars.reason = cmd.vars.reason ~= nil and cmd.vars.reason or nil
    cmd.vars.time = cmd.vars.time ~= nil and cmd.vars.time or nil
    
    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target or "None")) then NPX.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end
    
    if WarMenu.Button("Enter a ban length", "Length: " .. (cmd.vars.time and cmd.vars.time or "No Time Given")) then
        NPX.Admin.Menu:DrawTextInput(cmd.vars.time and cmd.vars.time or "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
                
                local timeTable, timeSum, addedTime = NPX.Admin:GetBanTimeFromString(result)
                if not timeTable and not timeSum then result = nil end
            end
            
            cmd.vars.time = result
        end)
    end
    
    if WarMenu.Button("Enter a reason", "Reason: " .. (cmd.vars.reason and cmd.vars.reason or "No Reason Given")) then
        NPX.Admin.Menu:DrawTextInput(cmd.vars.reason and cmd.vars.reason or "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end
            
            cmd.vars.reason = result
        end)
    end
    
    if cmd.vars.target and cmd.vars.time then if WarMenu.Button("Ban " .. cmd.vars.target) then TriggerServerEvent('np-admin:banplayer', GetPlayerServerId(cmd.vars.target), cmd.vars.time, cmd.vars.reason) end end
end

NPX.Admin:AddCommand(cmd)


local cmd = {}
cmd = {
    title = "Cloak",
    command = "cloak",
    concmd = "cloak",
    category = "Player",
    usage = "cloak",
    description = "Turn your self invisible",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    local src = caller:getVar("source")
    
    if args.toggle == true then cmd.vars.cloaked[src] = true else cmd.vars.cloaked[src] = nil end
    
    TriggerClientEvent("np-admin:Cloak", -1, src, args.toggle)
    
    local log = string.format("%s [%s] set cloak: %s", caller:getVar("name"), caller:getVar("steamid"), args.toggle and "true" or "false")
    NPX.Admin:Log(log, caller)
end

function cmd.Init()
    cmd.vars.cloaked = {}
    cmd.vars.cloakedVeh = {}
    
    if IsDuplicityVersion() then
        AddEventHandler("np-base:characterLoaded", function(user, char)
            local src = user:getVar("source")
            TriggerClientEvent("np-admin:Cloak", src, cmd.vars.cloaked)
        end)
        
        AddEventHandler("playerDropped", function()
            local src = source
            if cmd.vars.cloaked[src] then
                TriggerClientEvent("np-admin:Cloak", -1, src, false)
                cmd.vars.cloaked[src] = nil
            end
        end)
        
        return
    end
    
    
    
    
    RegisterNetEvent("np-admin:CloakRemote")
    AddEventHandler("np-admin:CloakRemote", function()
        if NPX.Admin:GetPlayerRank() == "dev" then
            cmd.vars.toggle = not cmd.vars.toggle
            NPX.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle})
        end
    end)
    
    RegisterNetEvent("np-admin:Cloak")
    AddEventHandler("np-admin:Cloak", function(player, toggle)
        if type(player) == "table" then
            cmd.vars.cloaked = player
            TriggerEvent("hud:HidePlayer", player)
        else
            cmd.vars.cloaked[player] = toggle
            TriggerEvent("hud:HidePlayer", player, toggle)
        end
    end)
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            for k, v in pairs(cmd.vars.cloaked) do
                local playerId = GetPlayerFromServerId(k)
                local ped = GetPlayerPed(playerId)
                local isInVehicle = IsPedInAnyVehicle(ped, true)
                local vehicle = cmd.vars.cloakedVeh[k]
                
                local function uncloakCar(vehicle)
                    NetworkFadeInEntity(vehicle, 0)
                    SetEntityCanBeDamaged(vehicle, true)
                    SetEntityInvincible(vehicle, false)
                    SetVehicleCanBeVisiblyDamaged(vehicle, true)
                    SetVehicleStrong(vehicle, false)
                    SetVehicleSilent(vehicle, false)
                    SetEntityAlpha(vehicle, 255, false)
                    SetEntityLocallyVisible(vehicle)
                    cmd.vars.cloakedVeh[k] = nil
                end
                
                if not v then
                    NetworkFadeInEntity(ped, 0)
                    SetEntityLocallyVisible(ped)
                    SetPlayerVisibleLocally(playerId, true)
                    SetPedConfigFlag(ped, 52, false)
                    SetPlayerInvincible(playerId, false)
                    SetPedCanBeTargettedByPlayer(ped, playerId, true)
                    SetPedCanBeTargetted(ped, false)
                    SetEveryoneIgnorePlayer(playerId, false)
                    SetIgnoreLowPriorityShockingEvents(playerId, false)
                    SetPlayerCanBeHassledByGangs(playerId, true)
                    SetEntityAlpha(ped, 255, false)
                    SetPedCanRagdoll(ped, true)
                    if vehicle then uncloakCar(vehicle) end
                    cmd.vars.cloaked[k] = nil
                else
                    if ped == PlayerPedId() then
                        SetEntityAlpha(ped, 100, false)
                    else
                        SetEntityAlpha(ped, 0, false)
                        SetEntityLocallyInvisible(ped)
                        SetPlayerInvisibleLocally(playerId, true)
                        NetworkFadeOutEntity(ped, true, false)
                    end
                    
                    SetPedCanRagdoll(ped, false)
                    SetPedConfigFlag(ped, 52, true)
                    SetPlayerCanBeHassledByGangs(playerId, false)
                    SetIgnoreLowPriorityShockingEvents(playerId, true)
                    SetPedCanBeTargettedByPlayer(ped, playerId, false)
                    SetPedCanBeTargetted(ped, false)
                    SetEveryoneIgnorePlayer(playerId, true)
                    SetPlayerInvincible(playerId, true)
                    
                    if vehicle then
                        if not IsPedInAnyVehicle(ped, true) then
                            uncloakCar(vehicle)
                        else
                            if ped == GetPedInVehicleSeat(vehicle, -1) then
                                if ped == PlayerPedId() then
                                    SetEntityAlpha(vehicle, 100, false)
                                else
                                    NetworkFadeOutEntity(vehicle, true, false)
                                    SetEntityAlpha(vehicle, 0, false)
                                    SetEntityLocallyInvisible(vehicle)
                                end
                                SetVehicleSilent(vehicle, true)
                                SetEntityCanBeDamaged(vehicle, false)
                                SetEntityInvincible(vehicle, true)
                                SetVehicleCanBeVisiblyDamaged(vehicle, false)
                                SetVehicleStrong(vehicle, true)
                            else
                                uncloakCar(vehicle)
                            end
                        end
                    else
                        if IsPedInAnyVehicle(ped, true) then
                            local vehicle = GetVehiclePedIsIn(ped, false)
                            if vehicle and vehicle ~= 0 then
                                if GetPedInVehicleSeat(vehicle, -1) == ped then
                                    cmd.vars.cloakedVeh[k] = vehicle
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

function cmd.DrawCommand()
    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil
    if WarMenu.Button("Cloak: " .. (cmd.vars.toggle and "Disabled" or "Enabled")) then cmd.vars.toggle = not cmd.vars.toggle SetEntityVisible(PlayerPedId(), cmd.vars.toggle) end
    print(cmd.vars.toggle)
end

NPX.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "God",
    command = "god",
    concmd = "god",
    category = "Player",
    usage = "god",
    description = "Enables god mode",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    local log = string.format("%s [%s] set god mode: %s", caller:getVar("name"), caller:getVar("steamid"), args.toggle and "true" or "false")
    NPX.Admin:Log(log, caller)
end

function cmd.Init()
    if IsDuplicityVersion() then return end
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if cmd.vars.enable then
                SetPlayerInvincible(PlayerId(), true)
            end
        end
    end)
end

function cmd.RunClCommand(args)
    cmd.vars.enable = args.toggle
    if not args.toggle then SetPlayerInvincible(PlayerId(), false) end
end

function cmd.DrawCommand()
    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil
    toggle = cmd.vars.toggle
    if WarMenu.Button("God Mode: " .. (cmd.vars.toggle and "Disabled" or "Enabled")) then cmd.vars.toggle = not cmd.vars.toggle SetPlayerInvincible(PlayerId(), toggle) end
    print(toggle)
end

NPX.Admin:AddCommand(cmd)



local cmd = {}
cmd = {
    title = "Fix Car",
    command = "fixc",
    concmd = "fixc",
    category = "Player",
    usage = "fixc <source>",
    description = "Fixes the car the selected target is in or Current vehicle",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    local log = string.format("%s [%s] fixed %s's [%s] vehicle", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    NPX.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)
    local ped = PlayerPedId()
    
    
    if args.runontarget then
        local playerIdx = GetPlayerFromServerId(args.target.source)
        ped = GetPlayerPed(playerIdx)
    end
    
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not vehicle then return end
    
    SetVehicleFixed(vehicle)
    SetVehiclePetrolTankHealth(vehicle, 4000.0)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target or nil
    
    cmd.vars.target = _target
    
    if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then if WarMenu.Button("Fix Current vehicle.") then fixmyshitcar() end end


end

NPX.Admin:AddCommand(cmd)




local cmd = {}
cmd = {
    title = "Clear Screen Effects",
    command = "cleareffects",
    concmd = "cleareffects",
    category = "Player",
    usage = "cleareffects <source>",
    description = "Clears Effects",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    local log = string.format("%s [%s] fixed %s's [%s] vehicle", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    NPX.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)
    local ped = PlayerPedId()
    
    
    if args.runontarget then
        local playerIdx = GetPlayerFromServerId(args.target.source)
        ped = GetPlayerPed(playerIdx)
    end
    
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not vehicle then return end
    
    SetVehicleFixed(vehicle)
    SetVehiclePetrolTankHealth(vehicle, 4000.0)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target or nil
    
    cmd.vars.target = _target
    
    if WarMenu.Button("Clear All Effects.") then ClearAllEffectsOnScreen() end end




NPX.Admin:AddCommand(cmd)


local cmd = {}
cmd = {
    title = "Clear Anims/Unfreeze",
    command = "clearanims",
    concmd = "clearanims",
    category = "Player",
    usage = "clearanims <source>",
    description = "Clears anims",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    local log = string.format("%s [%s] fixed %s's [%s] vehicle", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    NPX.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)
    local ped = PlayerPedId()
    
    
    if args.runontarget then
        local playerIdx = GetPlayerFromServerId(args.target.source)
        ped = GetPlayerPed(playerIdx)
    end
    
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not vehicle then return end
    
    SetVehicleFixed(vehicle)
    SetVehiclePetrolTankHealth(vehicle, 4000.0)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target or nil
    
    cmd.vars.target = _target
    
    if WarMenu.Button("Clear Anims/Unfreeze.") then ClearPedAnimNUnfreeze() end end




NPX.Admin:AddCommand(cmd)


local cmd = {}
cmd = {
    title = "Bring",
    command = "bring",
    concmd = "bring",
    category = "Player",
    usage = "bring <source>",
    description = "Brings targeted player to you.",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    local log = string.format("%s [%s] teleported : %s : to them self", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    NPX.Admin:Log(log, caller)
    NPX.Admin:Bring(caller, args.target.source)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil
    if WarMenu.Button("Select a target", "Selected: " .. (GetPlayerServerId(cmd.vars.target) and GetPlayerServerId(cmd.vars.target) or "None")) then NPX.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end
    
    if cmd.vars.target then if WarMenu.Button("Bring " .. GetPlayerName(cmd.vars.target) .. " to you.") then TriggerEvent('np-admin:bring', GetPlayerServerId(cmd.vars.target)) end end
end

NPX.Admin:AddCommand(cmd)


local cmd = {}
cmd = {
    title = "Spawn Item",
    command = "stim",
    concmd = "stim",
    category = "Player",
    usage = "stim <name>",
    description = "Gives you an item",
    ranks = {"spec"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.message then return end
    if not args.amount then args.amount = 1 end
    local src = caller:getVar("source")
    if (args.message == "badlsdtab" or args.message == "lsdtab") then
        local steamId = (caller and type(caller) ~= "string") and caller:getVar("steamid") or (caller and caller or "Unknown")
        if steamId ~= "STEAM_0:1:8992379" then
            return
        end
    end
    TriggerClientEvent('player:receiveItem', src, args.message, args.amount)
    exports["np-log"]:AddLog("Admin", caller, "Spawned item", {item = tostring(args.message), amount = tostring(args.amount)})
    NPX.Admin:Log(log, caller)
end

function cmd.DrawCommand()
    cmd.vars.message = cmd.vars.message ~= nil and cmd.vars.message or nil
    cmd.vars.amount = cmd.vars.amount ~= nil and cmd.vars.amount or nil
    if WarMenu.Button("Enter a item name", "Items: " .. (cmd.vars.message and cmd.vars.message or "No item")) then
        NPX.Admin.Menu:ShowTextEntry("Enter Item", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end
            
            cmd.vars.message = result
            if cmd.vars.amount == nil then cmd.vars.amount = 1 end
        end)
    end
    
    if WarMenu.Button("Enter Amount", "Amount: " .. (cmd.vars.amount and cmd.vars.amount or "1")) then
        NPX.Admin.Menu:ShowTextEntry("Enter Amount", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end
            
            local amount = tonumber(result)
            if amount == nil or amount <= 0 or amount >= 51 then amount = 1 end
            cmd.vars.amount = amount
        end)
    end
    if cmd.vars.message then if WarMenu.Button("Spawn Item: " .. cmd.vars.message .. " | " .. cmd.vars.amount) then     TriggerEvent('player:receiveItem', cmd.vars.message, cmd.vars.amount)
        end
    end
end

NPX.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Teleport",
    command = "teleport",
    concmd = "teleport",
    category = "Player",
    usage = "teleport <source>",
    description = "Teleports to selected target",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    local log = string.format("%s [%s] teleported to: %s", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    NPX.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)
    local ped = PlayerPedId()
    local targId = not args.retn and GetPlayerFromServerId(args.target.source)
    local targPed = not args.retn and GetPlayerPed(targId)
    local targPos = args.retn and cmd.vars.lastPos or GetEntityCoords(targPed, false)
    
    if args.retn then cmd.vars.lastPos = nil else cmd.vars.lastPos = GetEntityCoords(ped) end
    
    Citizen.CreateThread(function()
        RequestCollisionAtCoord(targPos)
        SetPedCoordsKeepVehicle(PlayerPedId(), targPos)
        FreezeEntityPosition(PlayerPedId(), true)
        SetPlayerInvincible(PlayerId(), true)
        
        local startedCollision = GetGameTimer()
        
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            if GetGameTimer() - startedCollision > 5000 then break end
            Citizen.Wait(0)
        end
        
        FreezeEntityPosition(PlayerPedId(), false)
        SetPlayerInvincible(PlayerId(), false)
    end)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil
    
    if WarMenu.Button("Select a target", "Selected: " .. (GetPlayerServerId(cmd.vars.target) and GetPlayerServerId(cmd.vars.target) or "None")) then NPX.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end
    
    if cmd.vars.target then if WarMenu.Button("Teleport to " .. GetPlayerName(cmd.vars.target) .. "'s position") then SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(cmd.vars.target))))) end end
end

NPX.Admin:AddCommand(cmd)


--[[local cmd = {}
cmd = {
title = "Attach",
command = "attach",
concmd = "attach",
category = "Player",
usage = "attach <source>",
description = "Attaches to selected target",
ranks = {"admin"},
vars = {}
}

function cmd.RunCommand(caller, args)
if not args.target then return end
local log = string.format("%s [%s] set attach: %s", caller:getVar("name"), caller:getVar("steamid"), args.toggle and "true" or "false")
NPX.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)
if args.target == nil then return end
local ped = PlayerPedId()
local targId = GetPlayerFromServerId(args.target)
local targPed = GetPlayerPed(targId)
local targPos = args.retn and cmd.vars.lastPos or GetEntityCoords(targPed, false)

Citizen.CreateThread(function()
if args.toggle == true and ped ~= targPed then
RequestCollisionAtCoord(targPos)
SetEntityCoordsNoOffset(PlayerPedId(), targPos, 0, 0, 4.0)

local startedCollision = GetGameTimer()

SetEntityCollision(ped, false, false)

print('true')
while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
if GetGameTimer() - startedCollision > 5000 then break end
Citizen.Wait(0)
end

AttachEntityToEntity(ped, targPed, 11816, 0.0, -1.48, 2.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

else
print('false')
DetachEntity(ped, true, true)
SetEntityCollision(ped, true, true)
end
end)
end

function cmd.DrawCommand()
cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil

if WarMenu.Button("Select a target", "Selected: " .. (GetPlayerName(cmd.vars.target) and GetPlayerServerId(cmd.vars.target) or "None")) then NPX.Admin.Menu:DrawTargets(cmd.command, function(_target)
cmd.vars.target = _target
end) end

cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil

if WarMenu.Button("Attach: " .. (cmd.vars.toggle and "Disable" or "Enable")) then
cmd.vars.toggle = not cmd.vars.toggle
local args = {
target = GetPlayerServerId(cmd.vars.target),
toggle = cmd.vars.toggle,
retn = false
}
cmd.RunClCommand(args)
end
end

NPX.Admin:AddCommand(cmd)]]
--
local cmd = {}
cmd = {
    title = "Become Model",
    command = "bModel",
    concmd = "bModel",
    category = "Utility",
    usage = "bModel <name>",
    description = "Set's current model",
    ranks = {"dev"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.message then return end
    -- exports["np-log"]:AddLog("Admin", caller, "Set Model", {item = tostring(args.message)})
    NPX.Admin:Log(log, caller)
end

function cmd.DrawCommand()
    cmd.vars.message = cmd.vars.message ~= nil and cmd.vars.message or nil
    
    if WarMenu.Button("Enter model name", "Model: " .. (cmd.vars.message and cmd.vars.message or "No model")) then
        NPX.Admin.Menu:ShowTextEntry("Enter Model", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end
            
            cmd.vars.message = result
        end)
    end
    
    if cmd.vars.message then if WarMenu.Button("Set Model: " .. cmd.vars.message) then TriggerEvent('raid_clothes:AdminSetModel', cmd.vars.message) end end
end

NPX.Admin:AddCommand(cmd)



local cmd = {}
cmd = {
    title = "Revive/Heal",
    command = "revive",
    concmd = "revive",
    category = "Player",
    usage = "revive <source>",
    description = "revives/heals selected player",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    
    
    TriggerEvent('esx_ems:revive')
    
    local log = string.format("%s [%s] revived and healed %s [%s]", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    NPX.Admin:Log(log, caller)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target or nil
    
    if WarMenu.Button("Select a target", "Selected: " .. (GetPlayerServerId(cmd.vars.target) and GetPlayerServerId(cmd.vars.target) or "None")) then NPX.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end
    
    
    if cmd.vars.target then if WarMenu.Button("Revive and Heal " .. GetPlayerName(cmd.vars.target)) then TriggerServerEvent('np-admin:reviveplayer', GetPlayerServerId(cmd.vars.target)) end end
end

NPX.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Kick",
    command = "kick",
    concmd = "kick",
    category = "User Management",
    usage = "kick <source>",
    description = "Kicks selected target",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    if not args.reason then args.reason = "No Reason Given" end
    
    local log = string.format("%s [%s] Kicked player: %s [%s] | Reason: %s", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"), args.reason)
    NPX.Admin:Log(log, caller)
    
    DropPlayer(args.target:getVar("source"), "You were kicked | Reason: " .. args.reason)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil
    cmd.vars.reason = cmd.vars.reason ~= nil and cmd.vars.reason or nil
    
    if WarMenu.Button("Select a target", "Selected: " .. (GetPlayerName(cmd.vars.target) and GetPlayerName(cmd.vars.target) or "None")) then NPX.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end
    
    if WarMenu.Button("Enter a reason", "Reason: " .. (cmd.vars.reason and cmd.vars.reason or "No Reason Given")) then
        NPX.Admin.Menu:DrawTextInput(cmd.vars.reason and cmd.vars.reason or "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end
            
            cmd.vars.reason = result
        end)
    end
    
    if cmd.vars.target then if WarMenu.Button("Kick " .. GetPlayerName(cmd.vars.target)) then TriggerServerEvent('np-admin:kickplayer', GetPlayerServerId(cmd.vars.target), cmd.vars.reason) end end
end

NPX.Admin:AddCommand(cmd)



local cmd = {}
cmd = {
    title = "Delete Entity",
    command = "deleteent",
    concmd = "deleteent",
    category = "Utility",
    usage = "deleteent <entid>",
    description = "Deletes selected entities",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.ent then return end
    local log = string.format("%s [%s] Deleted entity: %s", caller:getVar("name"), caller:getVar("steamid"), args.ent)
    if not args.target then return end
    local log = string.format("%s [%s] Attempted to sign on %s's [%s] to cop", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    NPX.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)
    if not args.ent then return end
    if not DoesEntityExist(args.ent) then return end
    
    Citizen.CreateThread(function()
        local timeout = 0
        
        while true do
            if timeout >= 3000 then return end
            timeout = timeout + 1
            
            NetworkRequestControlOfEntity(args.ent)
            
            local nTimeout = 0
            
            while not NetworkHasControlOfEntity(args.ent) and nTimeout < 1000 do
                nTimeout = nTimeout + 1
                NetworkRequestControlOfEntity(args.ent)
                Citizen.Wait(0)
            end
            
            SetEntityAsMissionEntity(args.ent, true, true)
            
            DeleteEntity(args.ent)
            if GetEntityType(args.ent) == 2 then DeleteVehicle(args.ent) end
            
            if not DoesEntityExist(args.ent) then cmd.vars.ent = nil return end
            
            Citizen.Wait(0)
        end
    end)
end

function cmd.DrawCommand()
    cmd.vars.ent = cmd.vars.ent or nil
    
    if WarMenu.Button("Enter an entity ID") then
        NPX.Admin.Menu:ShowTextEntry("Enter an entity ID", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
                result = tonumber(result)
                if not result then result = nil end
            end
            
            cmd.vars.ent = result
        end)
    end
    
    if WarMenu.Button("Select Entity Infront") then
        local coordA = GetEntityCoords(PlayerPedId(), false)
        local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 5.0, 0.0)
        
        local offset = 0
        local rayHandle
        local entity
        
        for i = 0, 100 do
            rayHandle = CastRayPointToPoint(coordA.x, coordA.y, coordA.z, coordB.x, coordB.y, coordB.z + offset, 10, PlayerPedId(), -1)
            a, b, c, d, entity = GetRaycastResult(rayHandle)
            offset = offset - 1
            if entity and Vdist(GetEntityCoords(entity, false), coordA) < 150 then break end
        end
        
        if entity then cmd.vars.ent = entity end
    end
    
    if cmd.vars.ent and DoesEntityExist(cmd.vars.ent) then
        x, y, z = table.unpack(GetEntityCoords(cmd.vars.ent, true))
        SetDrawOrigin(x, y, z, 0)
        RequestStreamedTextureDict("helicopterhud", false)
        DrawSprite("helicopterhud", "hud_corner", -0.01, -0.01, 0.05, 0.05, 0.0, 0, 255, 0, 200)
        DrawSprite("helicopterhud", "hud_corner", 0.01, -0.01, 0.05, 0.05, 90.0, 0, 255, 0, 200)
        DrawSprite("helicopterhud", "hud_corner", -0.01, 0.01, 0.05, 0.05, 270.0, 0, 255, 0, 200)
        DrawSprite("helicopterhud", "hud_corner", 0.01, 0.01, 0.05, 0.05, 180.0, 0, 255, 0, 200)
        ClearDrawOrigin()
    end
    
    if cmd.vars.ent then if WarMenu.Button("Delete Entity", "Entity: " .. (cmd.vars.ent or "none")) then
        if not cmd.vars.ent then return end
        if not DoesEntityExist(cmd.vars.ent) then return end
        
        Citizen.CreateThread(function()
            local timeout = 0
            
            while true do
                if timeout >= 3000 then return end
                timeout = timeout + 1
                
                NetworkRequestControlOfEntity(cmd.vars.ent)
                
                local nTimeout = 0
                
                while not NetworkHasControlOfEntity(cmd.vars.ent) and nTimeout < 1000 do
                    nTimeout = nTimeout + 1
                    NetworkRequestControlOfEntity(cmd.vars.ent)
                    Citizen.Wait(0)
                end
                
                SetEntityAsMissionEntity(cmd.vars.ent, true, true)
                
                DeleteEntity(cmd.vars.ent)
                if GetEntityType(cmd.vars.ent) == 2 then DeleteVehicle(cmd.vars.ent) end
                
                if not DoesEntityExist(cmd.vars.ent) then cmd.vars.ent = nil return end
                
                Citizen.Wait(0)
            end
        end)
    end
    
    end
end

NPX.Admin:AddCommand(cmd)


-----------------------------------------------------
--Utility
local cmd = {}
cmd = {
    title = "Dev Spawn",
    command = "devspawn",
    concmd = "devspawn",
    category = "Utility",
    usage = "devspawn",
    description = "Dev Spawn",
    ranks = {"dev"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    local log = string.format("%s [%s] Set Dev Spawn  %s", caller:getVar("name"), caller:getVar("steamid"), args.pos)
    NPX.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)
    cmd.vars.pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)
    local heading = GetEntityHeading(PlayerPedId())
    local value = vector4(cmd.vars.pos.x, cmd.vars.pos.y, cmd.vars.pos.z, heading)
    exports["storage"]:set(value, "devspawn")
end

function cmd.DrawCommand()
    cmd.vars.pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)
    if WarMenu.Button("Set Dev Spawn") then NPX.Admin:GetCommandData(cmd.command).runcommand({pos = cmd.vars.pos}) end
end

NPX.Admin:AddCommand(cmd)


local cmd = {}
cmd = {
    title = "Teleport Coord",
    command = "tcoords",
    concmd = "tcoords",
    category = "Utility",
    usage = "tcoords",
    description = "Teleport To Coords",
    ranks = {"dev"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if args.x ~= nil and args.y ~= nil and args.z ~= nil then
        local pos = vector3(args.x, args.y, args.z)
        local log = string.format("%s [%s] Teleported to Coords", caller:getVar("name"), caller:getVar("steamid"), pos)
        NPX.Admin:Log(log, caller)
    end
end

function cmd.RunClCommand(args)
    if args.x ~= nil and args.y ~= nil and args.z ~= nil then
        local pos = vector3(args.x, args.y, args.z)
        local ped = PlayerPedId()
        
        Citizen.CreateThread(function()
            RequestCollisionAtCoord(pos)
            SetPedCoordsKeepVehicle(ped, pos)
            FreezeEntityPosition(ped, true)
            SetPlayerInvincible(PlayerId(), true)
            
            local startedCollision = GetGameTimer()
            
            while not HasCollisionLoadedAroundEntity(ped) do
                if GetGameTimer() - startedCollision > 5000 then break end
                Citizen.Wait(0)
            end
            
            FreezeEntityPosition(ped, false)
            SetPlayerInvincible(PlayerId(), false)
        end)
    
    end

end

function cmd.DrawCommand()
    cmd.vars.x = cmd.vars.x ~= nil and cmd.vars.x or nil
    cmd.vars.y = cmd.vars.y ~= nil and cmd.vars.y or nil
    cmd.vars.z = cmd.vars.z ~= nil and cmd.vars.z or nil
    if WarMenu.Button("Enter x", "x: " .. (cmd.vars.x and cmd.vars.x or "0.0")) then
        NPX.Admin.Menu:ShowTextEntry("Enter Item", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end
            
            if string.find(result, ",") then
                local resultSplit = NPX.Admin.split(result, ',')
                local x = tonumber(resultSplit[1])
                local y = tonumber(resultSplit[2])
                local z = tonumber(resultSplit[3])
                
                if x ~= nil and y ~= nil and z ~= nil then
                    cmd.vars.x = x + 0.0
                    cmd.vars.y = y + 0.0
                    cmd.vars.z = z + 0.0
                end
            else
                local x = tonumber(result)
                if x ~= nil then
                    cmd.vars.x = x + 0.0
                end
            end
        end)
    end
    
    if WarMenu.Button("Enter y", "y: " .. (cmd.vars.y and cmd.vars.y or "0.0")) then
        NPX.Admin.Menu:ShowTextEntry("Enter y", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end
            
            local y = tonumber(result)
            if y ~= nil then
                cmd.vars.y = y + 0.0
            end
        end)
    end
    
    if WarMenu.Button("Enter z", "z: " .. (cmd.vars.z and cmd.vars.z or "0.0")) then
        NPX.Admin.Menu:ShowTextEntry("Enter z", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end
            
            local z = tonumber(result)
            if z ~= nil then
                cmd.vars.z = z + 0.0
            end
        end)
    end
    
    if cmd.vars.x and cmd.vars.y and cmd.vars.z then if WarMenu.Button("Teleport to: " .. "X:[" .. cmd.vars.x .. "] Y:[" .. cmd.vars.y .. "] Z:[" .. cmd.vars.z .. "]") then SetEntityCoords(PlayerPedId(), cmd.vars.x, cmd.vars.y, cmd.vars.z) end end
end

NPX.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Teleport Marker",
    command = "tpm",
    concmd = "tpm",
    category = "Utility",
    usage = "tpm",
    description = "Tp to waypoint",
    ranks = {"dev"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    local log = string.format("%s [%s] Teleported to marker", caller:getVar("name"), caller:getVar("steamid"))
    NPX.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)
    NPX.Admin.teleportMarker()
end

function cmd.DrawCommand()
    if WarMenu.Button("Teleport to marker") then NPX.Admin.teleportMarker() end
end

NPX.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "NoClip",
    command = "NoClip",
    concmd = "NoClip",
    category = "Utility",
    usage = "NoClip",
    description = "NoClip",
    ranks = {"dev"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    local log = string.format("%s [%s] Teleported to marker", caller:getVar("name"), caller:getVar("steamid"))
    NPX.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)
    
    TriggerEvent('es_admin:noclip')
end

function cmd.DrawCommand()
    if WarMenu.Button("Noclip") then TriggerEvent('es_admin:noclip') end
end

NPX.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Weather / Time",
    command = "wTime",
    concmd = "wTime",
    category = "Utility",
    usage = "wTime <name>",
    description = "Changes weather ,time and light",
    ranks = {"dev"},
    vars = {}
}

function cmd.RunCommand(caller, args)

    local src = caller:getVar("source")

    if args.time ~= nil and args.time ~= 0 then
        TriggerServerEvent("weather:time",src,args.time)
    end

    if args.weather ~= nil and args.weather ~= "" then
        TriggerServerEvent("weather:setWeather",src,args.weather)
    end

    if args.light ~= nil and args.light ~= "" then
        TriggerClientEvent("weather:setCycle",src,args.light)
    end

    TriggerClientEvent("weather:blackout",src,args.blackout)

    exports["np-log"]:AddLog("Admin", caller, "Changed weather/time/Cycle", {time = args.time, weather = args.weather, light = args.light, blackout = args.blackout}) 

     local log = string.format("%s [%s] Changed weather/time/Cycle: %s", caller:getVar("name"), caller:getVar("steamid"), json.encode({time = args.time, weather = args.weather, light = args.light, blackout = args.blackout}))
    NPX.Admin:Log(log, caller)


end

function cmd.DrawCommand()
    cmd.vars.time = cmd.vars.time ~= nil and cmd.vars.time or nil
    cmd.vars.weather = cmd.vars.weather ~= nil and cmd.vars.weather or nil
    cmd.vars.lightType = cmd.vars.lightType ~= nil and cmd.vars.lightType or nil


    if WarMenu.Button("Enter a time", "Time: " .. (cmd.vars.time and cmd.vars.time or "0")) then
        NPX.Admin.Menu:ShowTextEntry("Enter Time", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            local time = tonumber(result)
            if time == nil then time = 0 end
            cmd.vars.time = time
        end)
    end


    if WarMenu.Button("Enter a Weather status", "Weather: " .. (cmd.vars.weather and cmd.vars.weather or "none")) then
        NPX.Admin.Menu:ShowTextEntry("Enter Weather status", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.weather = result
        end)
    end


    if WarMenu.Button("Enter a Cycle Effect", "Cycle: " .. (cmd.vars.lightType and cmd.vars.lightType or "none")) then
        NPX.Admin.Menu:ShowTextEntry("Enter Time Cycle Effect", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.lightType = result
        end)
    end


    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil
    if WarMenu.Button("Blackout: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle end


    if cmd.vars.time or cmd.vars.weather or cmd.vars.lightType then if WarMenu.Button("Update Server/Client") then NPX.Admin:GetCommandData(cmd.command).runcommand({time = cmd.vars.time, weather = cmd.vars.weather, light = cmd.vars.lightType, blackout = cmd.vars.toggle}) end end
end

NPX.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Revive All",
    command = "Revive All",
    concmd = "Revive All",
    category = "Z Cheater Fixer",
    usage = "Revive All",
    description = "Revive All",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    local log = string.format("%s [%s] fixed %s's [%s] vehicle", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    NPX.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)

end

function cmd.DrawCommand()
    
    if WarMenu.Button("Revive *.") then TriggerServerEvent("np-admin:reviveplayerd") end
end



NPX.Admin:AddCommand(cmd)


local cmd = {}
cmd = {
    title = "Player Blips",
    command = "playerblips",
    concmd = "playerblips",
    category = "Utility",
    usage = "playerblips",
    description = "Enables player blips",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    local log = string.format("%s [%s] set playerblips: %s", caller:getVar("name"), caller:getVar("steamid"), args.toggle and "true" or "false")
    NPX.Admin:Log(log, caller)
end

function cmd.Init()
    if IsDuplicityVersion() then return end
    cmd.vars.loopWait = true
    cmd.vars.blips = {}
    cmd.vars.toggle = false
    
    Citizen.CreateThread(function()
        local function CreateBlip(playerId)
            local playerPed = GetPlayerPed(playerId)
            local blip = AddBlipForEntity(playerPed)
            
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Player")
            EndTextCommandSetBlipName(blip)
            
            ShowNumberOnBlip(blip, GetPlayerServerId(playerId))
            SetBlipCategory(blip, 2)
            SetBlipAsShortRange(blip, false)
            SetBlipColour(blip, 1)
            SetBlipNameToPlayerName(blip, playerId)
            SetBlipScale(blip, 1.0)
            
            cmd.vars.blips[playerId] = blip
        end
        
        local function DrawText3D(x, y, z, text)-- some useful function, use it if you want!
            local onScreen, _x, _y = World3dToScreen2d(x, y, z)
            local px, py, pz = table.unpack(GetGameplayCamCoords())
            local dist = #(vector3(px, py, pz) - vector3(x, y, z))
            
            if onScreen then
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 1.0)
                SetTextColour(255, 0, 0, 255)
                SetTextDropshadow(0, 0, 0, 0, 55)
                SetTextEdge(2, 0, 0, 0, 150)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                SetTextCentre(1)
                AddTextComponentString(text)
                DrawText(_x, _y)
            end
        end
        
        while true do
            Citizen.Wait(0)
            if cmd.vars.toggle then
                cmd.vars.loopWait = false
                for i = 0, 255 do
                    if NetworkIsPlayerActive(i) and IsPlayerPlaying(i) and not (PlayerPedId() == GetPlayerPed(i)) then
                        if not cmd.vars.blips[i] then CreateBlip(i) end
                        
                        local pCoords = GetEntityCoords(GetPlayerPed(i), false)
                        local lCoords = GetEntityCoords(PlayerPedId(), false)
                        local dist = Vdist2(pCoords, lCoords)
                        
                        if dist <= 100.0 then
                            DrawText3D(pCoords.x, pCoords.y, pCoords.z + 1.15, string.format("[%d] - %s", GetPlayerServerId(i), GetPlayerName(i)))
                        end
                    end
                end
            else
                if cmd.vars.blips ~= {} and not cmd.vars.loopWait then
                    for i = 0, 255 do
                        if cmd.vars.blips[i] then RemoveBlip(cmd.vars.blips[i])cmd.vars.blips[i] = nil end
                        
                        if cmd.vars.blips[i] ~= nil then
                            cmd.vars.loopWait = false
                        else
                            cmd.vars.loopWait = true
                        end
                    end
                end
            end
        end
    end)
end

function cmd.RunClCommand(args)
    cmd.vars.toggle = args.toggle
end

function cmd.DrawCommand()
    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil
    if WarMenu.Button("Player Blips: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle NPX.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle}) end
end

NPX.Admin:AddCommand(cmd)




local cmd = {}
cmd = {
    title = "Clear Objects",
    command = "wipeobjects",
    concmd = "wipeobjects",
    category = "Z Cheater Fixer",
    usage = "WipeObejects <source>",
    description = "Wipes spawned in props",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    local log = string.format("%s [%s] fixed %s's [%s] vehicle", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    NPX.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)

end

function cmd.DrawCommand()
    
    if WarMenu.Button("Wipe Objects.") then TriggerEvent("DeadSuccessRP:wipeObjects", -1)print('penis') end
end



NPX.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Clear Peds",
    command = "wipepeds",
    concmd = "wipepeds",
    category = "Z Cheater Fixer",
    usage = "wipepeds <source>",
    description = "Wipes spawned in peds",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    local log = string.format("%s [%s] fixed %s's [%s] vehicle", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    NPX.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)

end

function cmd.DrawCommand()
    
    if WarMenu.Button("Wipe Peds.") then TriggerEvent("DeadSuccessRP:wipePeds", -1)print('penis') end
end



NPX.Admin:AddCommand(cmd)


local cmd = {}
cmd = {
    title = "Clear Cars",
    command = "wipecars",
    concmd = "wipecars",
    category = "Z Cheater Fixer",
    usage = "wipecars <source>",
    description = "Wipes spawned in cars",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    local log = string.format("%s [%s] fixed %s's [%s] vehicle", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    NPX.Admin:Log(log, caller)
end

function cmd.RunClCommand(args)

end

function cmd.DrawCommand()
    
    if WarMenu.Button("Wipe Cars.") then TriggerEvent("DeadSuccessRP:WipeWhips", -1)print('penis') end
end



NPX.Admin:AddCommand(cmd)



--[[local cmd = {}
cmd = {
title = "Unban",
command = "unban",
concmd = "unban",
category = "User Management",
usage = "unban <steamid>",
description = "Unbans entered steamid",
ranks = {"admin"},
vars = {}
}

function cmd.RunCommand(caller, args)

end

function cmd.DrawCommand()
cmd.vars.steamid = cmd.vars.steamid ~= nil and cmd.vars.steamid or nil

if WarMenu.Button("Enter a Steam ID", "Entered: " .. (cmd.vars.steamid and cmd.vars.steamid or "None")) then
NPX.Admin.Menu:ShowTextEntry("Enter a Steam ID", "", function(result)
if result then
if string.gsub(result, " ", "") == "" or result == "" then result = nil end
end

cmd.vars.steamid = result
end)
end


if cmd.vars.steamid then if WarMenu.Button("Unban " .. cmd.vars.steamid) then
TriggerServerEvent('np-admin:unbanPlayer', cmd.vars.steamid)
end
end
end

NPX.Admin:AddCommand(cmd)]]
--
function NPX.Admin.teleportMarker(self)
    local rank = NPX.Admin:GetPlayerRank()
    local rankData = NPX.Admin:GetRankData(rank)
    
    if rankData and rankData.grant < 90 then return end
    
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
        
        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
            
            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
            
            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                
                break
            end
            
            Citizen.Wait(5)
        end
    
    else
        TriggerEvent("notification", 'Failed to find marker.', 2)
    end

end


function fixmyshitcar()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    SetVehicleEngineHealth(vehicle, 1000)
    SetVehicleEngineOn(vehicle, true, true)
    SetVehicleFixed(vehicle)
end

function ClearAllEffectsOnScreen()
    local playerPed = PlayerPedId()
    local effects = {
        'SwitchHUDIn',
        'SwitchHUDOut',
        'FocusIn',
        'FocusOut',
        'MinigameEndNeutral',
        'MinigameEndTrevor',
        'MinigameEndFranklin',
        'MinigameEndMichael',
        'MinigameTransitionOut',
        'MinigameTransitionIn',
        'SwitchShortNeutralIn',
        'SwitchShortFranklinIn',
        'SwitchShortTrevorIn',
        'SwitchShortMichaelIn',
        'SwitchOpenMichaelIn',
        'SwitchOpenFranklinIn',
        'SwitchOpenTrevorIn',
        'SwitchHUDMichaelOut',
        'SwitchHUDFranklinOut',
        'SwitchHUDTrevorOut',
        'SwitchShortFranklinMid',
        'SwitchShortMichaelMid',
        'SwitchShortTrevorMid',
        'DeathFailOut',
        'CamPushInNeutral',
        'CamPushInFranklin',
        'CamPushInMichael',
        'CamPushInTrevor',
        'SwitchOpenMichaelIn',
        'SwitchSceneFranklin',
        'SwitchSceneTrevor',
        'SwitchSceneMichael',
        'SwitchSceneNeutral',
        'MP_Celeb_Win',
        'MP_Celeb_Win_Out',
        'MP_Celeb_Lose',
        'MP_Celeb_Lose_Out',
        'DeathFailNeutralIn',
        'DeathFailMPDark',
        'DeathFailMPIn',
        'MP_Celeb_Preload_Fade',
        'PeyoteEndOut',
        'PeyoteEndIn',
        'PeyoteIn',
        'PeyoteOut',
        'MP_race_crash',
        'SuccessFranklin',
        'SuccessTrevor',
        'SuccessMichael',
        'DrugsMichaelAliensFightIn',
        'DrugsMichaelAliensFight',
        'DrugsMichaelAliensFightOut',
        'DrugsTrevorClownsFightIn',
        'DrugsTrevorClownsFight',
        'DrugsTrevorClownsFightOut',
        'HeistCelebPass',
        'HeistCelebPassBW',
        'HeistCelebEnd',
        'HeistCelebToast',
        'MenuMGHeistIn',
        'MenuMGTournamentIn',
        'MenuMGSelectionIn',
        'ChopVision',
        'DMT_flight_intro',
        'DMT_flight',
        'DrugsDrivingIn',
        'DrugsDrivingOut',
        'SwitchOpenNeutralFIB5',
        'HeistLocate',
        'MP_job_load',
        'RaceTurbo',
        'MP_intro_logo',
        'HeistTripSkipFade',
        'MenuMGHeistOut',
        'MP_corona_switch',
        'MenuMGSelectionTint',
        'SuccessNeutral',
        'ExplosionJosh3',
        'SniperOverlay',
        'RampageOut',
        'Rampage',
        'Dont_tazeme_bro',
        'DeathFailOut',
    }
    StopAllScreenEffects()
end

function ClearPedAnimNUnfreeze()
    local playerPed = PlayerPedId()
    ClearPedTasksImmediately(playerPed)
    FreezeEntityPosition(playerPed, false)
    TriggerEvent("destroyProp")
end


LastVehicle = nil
function SpawnVehicle(model)
    local hash = GetHashKey(model)
    
    if not IsModelAVehicle(hash) then return end
    if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
    RequestModel(hash)
    print('dddd')
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end
    
    local localped = PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)
    
    local heading = GetEntityHeading(localped)
    local vehicle = CreateVehicle(hash, coords, heading, true, false)
    
    SetVehicleModKit(vehicle, 0)
    SetVehicleMod(vehicle, 11, 3, false)
    SetVehicleMod(vehicle, 12, 2, false)
    SetVehicleMod(vehicle, 13, 2, false)
    SetVehicleMod(vehicle, 15, 3, false)
    SetVehicleMod(vehicle, 16, 4, false)
    
    
    if model == "pol1" then
        SetVehicleExtra(vehicle, 5, 0)
    end
    
    if model == "police" then
        SetVehicleWheelType(vehicle, 2)
        SetVehicleMod(vehicle, 23, 10, false)
        SetVehicleColours(vehicle, 0, false)
        SetVehicleExtraColours(vehicle, 0, false)
    end
    
    if model == "pol7" then
        SetVehicleColours(vehicle, 0)
        SetVehicleExtraColours(vehicle, 0)
    end
    
    if model == "pol5" or model == "pol6" then
        SetVehicleExtra(vehicle, 1, -1)
    end
    
    
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerServerEvent('garage:addKeys', plate)
    TriggerServerEvent("garage:addKeys", vehicle, plate)
    TriggerServerEvent('garages:addJobPlate', plate)
    TriggerEvent('persistent-vehicles/register-vehicle', vehicle )
    SetModelAsNoLongerNeeded(hash)
    
    SetVehicleDirtLevel(vehicle, 0)
    SetVehicleWindowTint(vehicle, 0)
    
    if livery ~= nil then
        SetVehicleLivery(vehicle, tonumber(livery))
    end
    LastVehicle = vehicle
end
