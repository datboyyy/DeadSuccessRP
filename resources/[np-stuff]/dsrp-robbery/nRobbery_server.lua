ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
-----Power Tracking---

local City_Power_State = true
local Prison_Power_State = true
local Paleto_Power_State = true

------------------------

local VaultDoor = false

-----Prison Break Tracking-------
local Prison_Electric_State = false
local Prison_Physical_State = false
---------------------------------

----------Alarm Tracking---------

local alarms = {["CPower"] = false, ["PPower"] = false, ["prison"] = false, ["bank"] = false, ["PApaleto"] = false, ["paleto"] = false}

-----------------------------------

---------Reset Tracking------------

local areaReset = {["bank"] = false, ["Prision"] = false, ["PPower"] = false, ["CPower"] = false, ["PApaleto"] = false, ["paleto"] = false }

-----------------------------------

Area_Prision = "prisionArea"
Area_PowerCity = "cityArea"
Area_PowerPrision = "powPrisonArea"
Area_Bank = "mainBankArea"
Area_Paleto = "paletBank"
Area_Jewl = "jewlArea"

local markers = {}


-------------------------------------
local flags = {}
local CURRENT_CARD_PALETO = 1
local CURRENT_CARD_CITY = 1

function generateFlags()
    for k,v in pairs(markers) do
        flags[k] = {}
        flags[k].isFinished = true
        flags[k].toolUsed = 0
        flags[k].inUse = false
        flags[k].time = os.time()

    end
    CURRENT_CARD_PALETO = math.random(1,5)
    CURRENT_CARD_CITY = math.random(1,5)
end
generateFlags()

RegisterNetEvent('robbery:spawnaids')
AddEventHandler('robbery:spawnaids', function()
    TriggerClientEvent('robbery:aids', -1)
end)

RegisterNetEvent('robbery:triggerItemsUsedServer')
AddEventHandler('robbery:triggerItemsUsedServer', function()
    --local activePolice = ??
    local src = source
    TriggerClientEvent('robbery:triggerItemsUsed',src,itemid,activePolice)
end)

RegisterNetEvent('robbery:inUse')
AddEventHandler('robbery:inUse', function(locationID, state)
    flags[locationID].inUse = state
    TriggerClientEvent('robbery:sendFlags', -1, flags)
end)

RegisterNetEvent('inv:playerSpawnedTest')
AddEventHandler('inv:playerSpawnedTest', function()
    local src = source
    TriggerClientEvent('robbery:sendMarkers', src, markers, particlePos,markerDifficult)
    TriggerClientEvent('robbery:sendFlags', src, flags)
end)

RegisterNetEvent('robbery:robberyFailed')
AddEventHandler('robbery:robberyFailed', function(locationID, itemid)

    flags[locationID].toolUsed = itemsid
    flags[locationID].inUse = false
    flags[locationID].isFinished = false

    TriggerClientEvent('robbery:sendFlags', -1, flags)
end)

RegisterNetEvent("robbery:robberyFinished")
AddEventHandler("robbery:robberyFinished", function(locationID, ToolType, itemid)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local user = xPlayer.identifier

    marker = markers[locationID]

    flags[locationID].toolUsed = itemid
    flags[locationID].inUse = false
    flags[locationID].isFinished = true
    flags[locationID].time = os.time()
    if marker.connected ~= nil and marker.connected ~= 0 then
        flags[marker.connected].inUse = false
        flags[marker.connected].isFinished = true
        flags[marker.connected].time = os.time()
    end
    TriggerClientEvent('robbery:sendFlags',-1,flags)

    ----checking over end state function

    if marker.attachedDoor ~= nil and marker.attachedDoor ~= 0 and marker.attachedDoor ~= -22 then TriggerEvent('qb-doorlock:client:setDoors', marker.attachedDoor, src) end
    if marker.attachedDoor ~= nil and marker.attachedDoor == -22 then updateVaultDoor() end
    if locationID > 36 and locationID < 40 then
        TriggerClientEvent("player:receiveItem",src,"markedbills",math.random(10,50))
        if math.random(100) > 70 then
            TriggerClientEvent("player:receiveItem",src,"Gruppe6Card22", 1)
        end
        return
    end
    if marker.dropChance ~= 0 or marker.dropChance ~= 0 then
        if math.random(2) == 2 then
            TriggerClientEvent("player:receiveItem",src,"markedbills", math.random(10,50))
        else
            TriggerClientEvent("player:receiveItem",src,"inkedmoneybag", math.random(1,2))
        end

        if marker.group == PRISON_POWER or marker.group == CITY_POWER or marker.group == PALETO_POWER then updatePower() end
        if marker.group == PRISON_PHYSICAL or marker.group == PRISON_ELECTRICITY then updatePrisonBreak() end
        if locationID == 36 then TriggerEvent("ai:startPrisonBreak", src) end
    end
end)

function updatePrisonBreak()
    local isElectric = true
    local isPhysical = true
    
    for k,v in pairs(markers) do
        if v.group == PRISON_ELECTRIC then
            if not flags[k].isFinished then isElectric = false end
        end

        if v.group == PRISON_PHYSICAL then
            if not flags[k].isFinished then isPhysical = false end
        end

        if k >= 27 and k <= 36 then
            if flags[k].isFinished then
                lockdown()
            end
        end
    end

    Prison_Electric_State = isElectric
    Prison_Physical_State = isPhysical
    TriggerClientEvent("robbery:sendServerFlags",-1,Prison_Electric_State,Prison_Physical_State,City_Power_State,Prison_Power_State,door,Paleto_Power_State,CityCard,PaletoCard)
end

function updatePower()
    local isPrisonValid = true
    local isCityValid = true
    local isPaletoValid = true
    
    for k,v in pairs(markers) do
        if v.group == PRISON_POWER then
            if not flags[k].isFinished then isPrisonValid = false end
        end

        if v.group == CITY_POWER then
            if not flags[k].isFinished then isCityValid = false end
        end

        if v.group == PALETO_POWER then
            if not flags[k].isFinished then isPaletoValid = false end
        end
    end
end

function electricDisable(GroupType)
    for k,v in pairs(markers) do
        if v.group == GroupType and v.ToolType == ELECTRICAL_LOCK then
            flags[k].isFinished = true
            flags[k].toolUsed = 0
            flags[k].inUse = false
            if v.attachedDoor ~= nil and v.attachedDoor ~= -22 and v.attachedDoor ~= 0 then
                TriggerClientEvent("qb-doorlock:client:setDoors",v.attachedDoor,0)
            end
        end
    end
end

function lockdown()
    TriggerClientEvent("jail:lockdown", -1, true)
    TriggerEvent("qb-doorlock:client:setDoors",211,1)
    TriggerEvent("qb-doorlock:client:setDoors",212,1)
    TriggerEvent("qb-doorlock:client:setDoors",213,1)
    TriggerEvent("qb-doorlock:client:setDoors",214,1)
end

function endLockdown()
    TriggerClientEvent("jail:lockdown", -1, false)
    TriggerEvent("qb-doorlock:client:setDoors",211,0)
    TriggerEvent("qb-doorlock:client:setDoors",212,0)
    TriggerEvent("qb-doorlock:client:setDoors",213,0)
    TriggerEvent("qb-doorlock:client:setDoors",214,0)
end

function CheckLargeBanks()
    for k,v in pairs(markers) do
        if v.attachedDoor ~= nil and v.attachedDoor ~= -22 and v.attachedDoor ~= 0 then
            if not flags[k].isFinished and not exports["doorlock"]:isDoorLocked(v.attachedDoor) then
                TriggerEvent("qb-doorlock:client:setDoors", v.attachedDoor,1)
            end
        end
        if flags[k].time ~= 0 and (os.time() - flags[k].time) > 5400 then
            resetArea(k)
        end
    end

    TriggerClientEvent('robbery:sendFlags', -1, flags)
    TriggerClientEvent('robbery:sendServerFlags',-1,Prison_Electric_State,Prison_Physical_State,City_Power_State,Prison_Power_State,door,Paleto_Power_State,CityCard,PaletoCard)
    areaReset = {["bank"] = false, ["Prision"] = false, ["PPower"] = false, ["CPower"] = false, ["PApaleto"] = false, ["paleto"] = false }
    SetTimeout(1200000, CheckLargeBanks)
end
  
SetTimeout(18000, CheckLargeBanks)

function resetArea(locationID)
    local marker = markers[locationID]

    local resetArea = ""
    local resetLockdown = false

    if marker.group == MAIN_BANK and not areaReset["bank"] then
        resetArea = "bank"
        CURRENT_CARD_PALETO = math.random(1,5)
    elseif marker.group == CITY_POWER and not areaReset["CPower"] then
        resetArea = "CPower"
    elseif marker.group == PALETO_POWER and not areaReset["PApaleto"] then
        resetArea = "PApaleto"
    elseif marker.group == PALETO_BANK and not areaReset["paleto"] then
        resetArea = "paleto"
        CURRENT_CARD_CITY = math.random(1,5)
    elseif marker.group == PRISON_POWER and not areaReset["PPower"] then
        resetArea = "PPower"
    elseif (marker.group == PRISON_GATES or marker.group == PRISON_ELECTRIC or marker.group == PRISON_PHYSICAL or marker.group == PRISON_FINAL) and not areaReset["Prision"] then
        resetArea = "Prision"
    else
        return
    end

    for k,v in pairs(markers) do
        local resetFlags = false
        if resetArea == "bank" and v.group == MAIN_BANK then resetFlags = true VaultDoor = false end
        if resetArea == "CPower" and v.group == CITY_POWER then resetFlags = true City_Power_State = true end
        if resetArea == "PPower" and v.group == PRISON_POWER then resetFlags = true Prison_Power_State = true end
        if resetArea == "PApaleto" and v.group == PALETO_POWER then resetFlags = true Paleto_Power_State = true end

        if resetFlags == "paleto" and v.group == PALETO_BANK then resetFlags = true end

        if resetArea == "Prision" and (v.group == PRISON_GATES or v.group == PRISON_ELECTRIC or v.group == PRISON_PHYSICAL or v.group == PRISON_FINAL) then
            resetFlags = true
            Prison_Electric_State = false
            Prison_Physical_State = false
            if not resetLockdown then
            endLockDown()
            reseLockdown = true
            end
        end

        if resetFlags then
            flags[k].isFinished = false
            flags[k].toolUsed = 0
            flags[k].inUse = false
            flags[k].time = os.time()

        end
    end

    resetLockdown = false
    areaReset[resetArea] = true
end